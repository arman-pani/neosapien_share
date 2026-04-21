// =============================================================================
// MEMORY STRATEGY — transfer_repository.dart
// =============================================================================
//
// This file must never load an entire file into RAM. Files up to 500 MB are
// supported. The following rules are enforced:
//
//  UPLOAD PATH
//  ─────────────────────────────────────────────────────────────────────────
//  1. SHA-256 pre-computation:
//       file.openRead() produces a Stream<List<int>> of OS-page-sized chunks
//       (~64 KB each). These are fed one-by-one into sha256.startChunkedConversion(),
//       which accumulates the hash state internally and never holds more than
//       one chunk in memory at a time.
//
//  2. Firebase Storage upload:
//       storageRef.putFile(File) is used — the Firebase SDK reads the file
//       itself in chunks and sends them over HTTP. We never call
//       readAsBytes() or putData(Uint8List). Peak RAM contribution from the
//       upload itself is bounded by the SDK's internal buffer (~1–4 MB).
//
//  DOWNLOAD PATH (ReceiveRepository)
//  ─────────────────────────────────────────────────────────────────────────
//  3. Dio is configured with ResponseType.stream, which returns a
//       ResponseBody whose .stream emits Uint8List chunks. Each chunk is
//       written directly to a RandomAccessFile sink; the chunk reference is
//       then released. Peak RAM per chunk ≈ 64–256 KB.
//
//  4. Post-download SHA-256 verification is done in a separate Isolate
//       (via compute()) using the same streaming chunked-conversion pattern.
//       No full-file buffer is allocated in the main isolate.
//
//  GENERAL
//  ─────────────────────────────────────────────────────────────────────────
//  • No BytesBuilder accumulation across chunks.
//  • No typed-data copies unless explicitly bounded (e.g., a single 64 KB page).
//  • Peak heap for a 500 MB file transfer is expected to stay below 20 MB
//    (1 chunk in → 1 chunk out, all other bytes on disk or in the network
//    buffer).
//
// =============================================================================

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/transfer_record.dart';
import '../../domain/interfaces/transfer_repository.dart';
import '../remote_data_sources/firebase_service.dart';
import '../remote_data_sources/transfer_remote_data_source.dart';

class FirebaseTransferRepository implements TransferRepository {
  FirebaseTransferRepository({
    required FirebaseService firebaseService,
    required TransferRemoteDataSource remoteDataSource,
    required SharedPreferences prefs,
    required Dio dio,
  }) : _firebaseService = firebaseService,
       _remoteDataSource = remoteDataSource,
       _prefs = prefs,
       _dio = dio;

  final FirebaseService _firebaseService;
  final TransferRemoteDataSource _remoteDataSource;
  final SharedPreferences _prefs;
  final Dio _dio;

  static const _sessionPrefix = 'resumable_session_';

  // Active tasks keyed by transferId → fileId → dynamic (UploadTask or CancelToken).
  final _activeTasks = <String, Map<String, dynamic>>{};

  // Cancellation flags: transferId → true when cancelled.
  final _cancelled = <String, bool>{};

  // ---------------------------------------------------------------------------
  // fetchIncomingTransfers (legacy)
  // ---------------------------------------------------------------------------

  @override
  Future<List<TransferRecord>> fetchIncomingTransfers() async {
    final remoteTransfers = await _remoteDataSource.fetchIncomingTransfers();
    return remoteTransfers.map((transfer) => transfer.toDomain()).toList();
  }

  // ---------------------------------------------------------------------------
  // uploadTransfer
  // ---------------------------------------------------------------------------

  @override
  TransferUploadOperation uploadTransfer({
    required String transferId,
    required String senderId,
    required String recipientCode,
    required List<TransferUploadFile> files,
  }) {
    return _startTransfer(
      transferId: transferId,
      senderId: senderId,
      recipientCode: recipientCode,
      files: files,
    );
  }

  // ---------------------------------------------------------------------------
  // retryFailedFiles
  // ---------------------------------------------------------------------------

  @override
  TransferUploadOperation retryFailedFiles({
    required String transferId,
    required String senderId,
    required String recipientCode,
    required List<TransferUploadFile> failedFiles,
  }) {
    // Clear the previous cancellation flag if present.
    _cancelled.remove(transferId);
    return _startTransfer(
      transferId: transferId,
      senderId: senderId,
      recipientCode: recipientCode,
      files: failedFiles,
      isRetry: true,
    );
  }

  // ---------------------------------------------------------------------------
  // cancelTransfer
  // ---------------------------------------------------------------------------

  @override
  Future<void> cancelTransfer(String transferId) async {
    _cancelled[transferId] = true;

    // Cancel in-flight tasks (could be UploadTask or CancelToken).
    final taskMap = _activeTasks[transferId];
    if (taskMap != null) {
      for (final task in taskMap.values) {
        if (task is UploadTask) {
          try {
            await task.cancel();
          } catch (_) {}
        } else if (task is CancelToken) {
          task.cancel('Transfer cancelled by user');
        }
      }
    }
    _activeTasks.remove(transferId);

    final transferRef = _firebaseService.firestore
        .collection('transfers')
        .doc(transferId);

    // Mark Firestore transfer as cancelled.
    try {
      await transferRef.update({'status': 'cancelled'});
    } catch (_) {}

    // Delete any partial Storage objects for this transfer.
    try {
      final storageRef = _firebaseService.storage.ref().child(
        'transfers/$transferId',
      );
      await _deleteStoragePrefix(storageRef);
    } catch (_) {}
  }

  /// Recursively deletes all objects under [ref] (best-effort).
  Future<void> _deleteStoragePrefix(Reference ref) async {
    try {
      final list = await ref.listAll();
      for (final item in list.items) {
        try {
          await item.delete();
        } catch (_) {}
      }
      for (final prefix in list.prefixes) {
        await _deleteStoragePrefix(prefix);
      }
    } catch (_) {}
  }

  // ---------------------------------------------------------------------------
  // Internal: start a transfer, returning a live-progress operation handle
  // ---------------------------------------------------------------------------

  TransferUploadOperation _startTransfer({
    required String transferId,
    required String senderId,
    required String recipientCode,
    required List<TransferUploadFile> files,
    bool isRetry = false,
  }) {
    final progressController =
        StreamController<TransferUploadProgress>.broadcast();

    // Initialise per-file progress.
    final perFileProgress = <String, FileUploadProgress>{
      for (final f in files)
        f.fileId: FileUploadProgress(
          fileId: f.fileId,
          bytesTransferred: 0,
          totalBytes: f.sizeInBytes,
          status: FileUploadStatus.pending,
        ),
    };

    final totalBytes = files.fold<int>(0, (s, f) => s + f.sizeInBytes);

    void emitProgress() {
      if (progressController.isClosed) return;

      final weightedBytes = perFileProgress.values.fold<double>(
        0,
        (acc, fp) => acc + fp.bytesTransferred,
      );

      progressController.add(
        TransferUploadProgress(
          fileProgress: Map.unmodifiable(perFileProgress),
          aggregateProgress: totalBytes == 0
              ? 1.0
              : (weightedBytes / totalBytes).clamp(0.0, 1.0),
        ),
      );
    }

    emitProgress();

    final completion =
        _runUpload(
          transferId: transferId,
          senderId: senderId,
          recipientCode: recipientCode,
          files: files,
          perFileProgress: perFileProgress,
          emitProgress: emitProgress,
          isRetry: isRetry,
        ).whenComplete(() async {
          emitProgress();
          await progressController.close();
        });

    return TransferUploadOperation(
      transferId: transferId,
      progressStream: progressController.stream,
      completion: completion,
    );
  }

  Future<void> _runUpload({
    required String transferId,
    required String senderId,
    required String recipientCode,
    required List<TransferUploadFile> files,
    required Map<String, FileUploadProgress> perFileProgress,
    required VoidCallback emitProgress,
    required bool isRetry,
  }) async {
    final transferRef = _firebaseService.firestore
        .collection('transfers')
        .doc(transferId);
    final expiresAt = DateTime.now().add(const Duration(hours: 72));

    try {
      if (!isRetry) {
        await transferRef.set({
          'status': 'uploading',
          'senderId': senderId,
          'recipientCode': recipientCode,
          'createdAt': DateTime.now().toUtc(),
          'expiresAt': expiresAt,
        });

        for (final file in files) {
          await transferRef.collection('files').doc(file.fileId).set({
            'name': file.name,
            'size': file.sizeInBytes,
            'mimeType': file.mimeType,
            'progress': 0.0,
            'status': 'uploading',
          });
        }
      } else {
        // Reset only the retried files back to "uploading".
        await transferRef.update({'status': 'uploading'});
        for (final file in files) {
          await transferRef.collection('files').doc(file.fileId).update({
            'progress': 0.0,
            'status': 'uploading',
          });
        }
      }
    } catch (e) {
      rethrow;
    }

    for (final file in files) {
      if (_cancelled[transferId] == true) return;

      await _uploadFile(
        transferId: transferId,
        transferRef: transferRef,
        file: file,
        perFileProgress: perFileProgress,
        emitProgress: emitProgress,
      );
    }

    if (_cancelled[transferId] == true) return;

    // Only mark ready if ALL files are done (none failed).
    final hasFailure = perFileProgress.values.any(
      (p) => p.status == FileUploadStatus.failed,
    );
    if (!hasFailure) {
      await transferRef.update({'status': 'ready'});
    }
  }

  Future<void> _uploadFile({
    required String transferId,
    required DocumentReference<Map<String, dynamic>> transferRef,
    required TransferUploadFile file,
    required Map<String, FileUploadProgress> perFileProgress,
    required VoidCallback emitProgress,
  }) async {
    final fileDocRef = transferRef.collection('files').doc(file.fileId);
    final sessionKey = '$_sessionPrefix${transferId}_${file.fileId}';

    void updateFile(FileUploadProgress fp) {
      perFileProgress[file.fileId] = fp;
      emitProgress();
    }

    try {
      final sha256Hash = await compute(_computeFileSha256, file.path);

      if (_cancelled[transferId] == true) return;

      // 1. Get or create resumable session URI
      String? sessionUri = _prefs.getString(sessionKey);
      int offset = 0;

      if (sessionUri != null) {
        // Query current upload status to see how many bytes were already uploaded
        offset = await _querySessionOffset(sessionUri);
      } else {
        sessionUri = await _initiateResumableUpload(
          transferId: transferId,
          fileId: file.fileId,
          fileName: file.name,
          mimeType: file.mimeType,
        );
        await _prefs.setString(sessionKey, sessionUri);
      }

      if (_cancelled[transferId] == true) return;

      // 2. Perform the upload from the offset
      final cancelToken = CancelToken();
      _activeTasks.putIfAbsent(transferId, () => {})[file.fileId] = cancelToken;

      await _uploadToSession(
        sessionUri: sessionUri,
        file: File(file.path),
        offset: offset,
        cancelToken: cancelToken,
        onProgress: (sent, total) {
          updateFile(
            FileUploadProgress(
              fileId: file.fileId,
              bytesTransferred: sent,
              totalBytes: total,
              status: FileUploadStatus.uploading,
            ),
          );
          fileDocRef.update({'progress': sent / total}).catchError((_) {});
        },
      );

      if (_cancelled[transferId] == true) return;

      // 3. Mark as done and clean up session
      await _prefs.remove(sessionKey);
      _activeTasks[transferId]?.remove(file.fileId);

      // Handle the case where the file is zero-byte and was never actually
      // uploaded to Storage (Resumable upload skips 0-byte finalize).
      // We skip fetching a download URL if the file is empty.
      String? storageUrl;
      if (file.sizeInBytes > 0) {
        final storagePath = 'transfers/$transferId/${file.fileId}/${file.name}';
        final storageRef = _firebaseService.storage.ref().child(storagePath);
        storageUrl = await storageRef.getDownloadURL();
      }

      updateFile(
        FileUploadProgress(
          fileId: file.fileId,
          bytesTransferred: file.sizeInBytes,
          totalBytes: file.sizeInBytes,
          status: FileUploadStatus.done,
        ),
      );

      final updateData = <String, dynamic>{
        'sha256': sha256Hash,
        'progress': 1.0,
        'status': 'uploaded',
      };
      if (storageUrl != null) {
        updateData['storageUrl'] = storageUrl;
      }

      await fileDocRef.update(updateData);
    } catch (e) {
      _activeTasks[transferId]?.remove(file.fileId);

      if (_cancelled[transferId] == true) {
        updateFile(
          FileUploadProgress(
            fileId: file.fileId,
            bytesTransferred: 0,
            totalBytes: file.sizeInBytes,
            status: FileUploadStatus.cancelled,
          ),
        );
        return;
      }

      updateFile(
        FileUploadProgress(
          fileId: file.fileId,
          bytesTransferred: 0,
          totalBytes: file.sizeInBytes,
          status: FileUploadStatus.failed,
        ),
      );
      await fileDocRef.update({'status': 'failed'}).catchError((_) {});
    }
  }

  Future<String> _initiateResumableUpload({
    required String transferId,
    required String fileId,
    required String fileName,
    required String mimeType,
  }) async {
    final bucket = _firebaseService.storage.app.options.storageBucket;
    final path = Uri.encodeComponent('transfers/$transferId/$fileId/$fileName');
    final url =
        'https://firebasestorage.googleapis.com/v0/b/$bucket/o?uploadType=resumable&name=$path';

    final response = await _dio.post(
      url,
      options: Options(
        headers: {
          'X-Goog-Upload-Protocol': 'resumable',
          'X-Goog-Upload-Command': 'start',
          'Content-Type': mimeType,
        },
      ),
    );

    // Firebase Storage usually returns the session URI in 'x-goog-upload-url'
    // instead of the standard GCS 'location' header.
    final sessionUri =
        response.headers.value('location') ??
        response.headers.value('x-goog-upload-url');

    if (sessionUri == null) {
      throw Exception('Failed to get resumable upload session URI');
    }
    return sessionUri;
  }

  Future<int> _querySessionOffset(String sessionUri) async {
    try {
      final response = await _dio.put(
        sessionUri,
        options: Options(
          headers: {'X-Goog-Upload-Command': 'query'},
          validateStatus: (status) => status == 200 || status == 308,
        ),
      );
      final sizeStr = response.headers.value('X-Goog-Upload-Size');
      return int.tryParse(sizeStr ?? '0') ?? 0;
    } catch (_) {
      return 0; // Fallback to start if query fails
    }
  }

  Future<void> _uploadToSession({
    required String sessionUri,
    required File file,
    required int offset,
    required CancelToken cancelToken,
    required void Function(int sent, int total) onProgress,
  }) async {
    final totalSize = await file.length();
    if (offset >= totalSize) return;

    // We open a stream from the file at the given offset.
    // Dio supports piping a Stream as the request body.
    final stream = file.openRead(offset);

    await _dio.put(
      sessionUri,
      data: stream,
      cancelToken: cancelToken,
      options: Options(
        headers: {
          'X-Goog-Upload-Command': 'upload, finalize',
          'X-Goog-Upload-Offset': offset,
          'Content-Length': totalSize - offset,
        },
      ),
      onSendProgress: (sent, total) {
        // 'sent' here is relative to the current PUT request, so we add the offset.
        onProgress(sent + offset, totalSize);
      },
    );
  }

  // ---------------------------------------------------------------------------
  // SHA-256: pure streaming — no BytesBuilder, no full-file load
  // ---------------------------------------------------------------------------

  /// Computes the SHA-256 of the file at [path] in a separate Isolate.
  static Future<String> _computeFileSha256(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      throw FileSystemException('File does not exist', path);
    }

    final digestSink = _DigestCollector();
    final hashSink = sha256.startChunkedConversion(digestSink);

    await for (final chunk in file.openRead()) {
      hashSink.add(chunk);
    }

    hashSink.close();
    return digestSink.value.toString();
  }

  // ---------------------------------------------------------------------------
  // watchTransferDelivery — real-time sender-side status listener
  // ---------------------------------------------------------------------------

  /// Listens to `transfers/{transferId}` in Firestore and maps the `status`
  /// field to [TransferDeliveryStatus].
  ///
  /// The Firestore status string values are:
  ///   "uploading"  → [TransferDeliveryStatus.uploading]
  ///   "queued"     → [TransferDeliveryStatus.queued]   (recipient offline)
  ///   "ready"      → [TransferDeliveryStatus.ready]    (FCM sent)
  ///   "delivered"  → [TransferDeliveryStatus.delivered]
  ///   "expired"    → [TransferDeliveryStatus.expired]
  ///   "cancelled"  → [TransferDeliveryStatus.cancelled]
  ///   anything else → [TransferDeliveryStatus.unknown]
  @override
  Stream<TransferDeliveryStatus> watchTransferDelivery(String transferId) {
    return _firebaseService.firestore
        .collection('transfers')
        .doc(transferId)
        .snapshots()
        .map((snap) {
          if (!snap.exists) return TransferDeliveryStatus.unknown;
          final status = snap.data()?['status'] as String? ?? '';
          return switch (status) {
            'uploading' => TransferDeliveryStatus.uploading,
            'queued' => TransferDeliveryStatus.queued,
            'ready' => TransferDeliveryStatus.ready,
            'delivered' => TransferDeliveryStatus.delivered,
            'expired' => TransferDeliveryStatus.expired,
            'cancelled' => TransferDeliveryStatus.cancelled,
            _ => TransferDeliveryStatus.unknown,
          };
        });
  }

  @override
  Future<List<PendingResumption>> getPendingResumableTransfers() async {
    final keys = _prefs.getKeys();
    final resumptions = <String, List<String>>{};

    for (final key in keys) {
      if (key.startsWith(_sessionPrefix)) {
        // Key format: resumable_session_<transferId>_<fileId>
        final parts = key.split('_');
        if (parts.length >= 4) {
          final transferId = parts[2];
          final fileId = parts[3];
          resumptions.putIfAbsent(transferId, () => []).add(fileId);
        }
      }
    }

    return resumptions.entries
        .map((e) => PendingResumption(transferId: e.key, fileIds: e.value))
        .toList();
  }
}

// ---------------------------------------------------------------------------
// SHA-256 sink helper
// ---------------------------------------------------------------------------

/// Collects the single [Digest] emitted by [sha256.startChunkedConversion].
class _DigestCollector implements Sink<Digest> {
  Digest? _value;

  Digest get value {
    final v = _value;
    if (v == null) {
      throw StateError('Digest not available — close() the conversion first.');
    }
    return v;
  }

  @override
  void add(Digest data) => _value = data;

  @override
  void close() {}
}

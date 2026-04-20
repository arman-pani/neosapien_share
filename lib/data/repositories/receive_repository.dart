import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/incoming_transfer.dart';
import '../remote_data_sources/incoming_transfer_remote_data_source.dart';

// =============================================================================
// MEMORY STRATEGY — receive_repository.dart
// =============================================================================
//
// Downloads are always streamed; no file is ever fully buffered in RAM.
//
//  DOWNLOAD PATH
//  ─────────────────────────────────────────────────────────────────────────
//  • Dio is used with ResponseType.stream. The response body is a
//    Stream<Uint8List> of network-sized chunks (typically 64–256 KB).
//  • Each chunk is written immediately to a RandomAccessFile opened on the
//    destination path. The chunk reference is released after the write, so
//    only one chunk is in RAM at a time regardless of total file size.
//  • Peak heap contribution from a download: ≈ one network chunk (≤256 KB).
//
//  SHA-256 VERIFICATION
//  ─────────────────────────────────────────────────────────────────────────
//  • After the file is saved to disk, integrity is verified in a separate
//    Isolate (via compute()). The isolate uses computeFileSha256() which
//    itself opens the file with File.openRead() and feeds chunks into
//    sha256.startChunkedConversion() — never loading the full file.
//  • The main isolate holds zero bytes of the file during this phase.
//
//  STORAGE FALLBACK
//  ─────────────────────────────────────────────────────────────────────────
//  • On Android, external storage is preferred when permissions are granted.
//  • If denied, the app falls back to internal app-scoped storage.
//    Either way, files land on disk immediately — no in-memory accumulation.
//
// =============================================================================

/// High-level repository for the receive flow.
class ReceiveRepository {
  ReceiveRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  // -------------------------------------------------------------------------
  // downloadFile
  // -------------------------------------------------------------------------

  /// Streams [FileDownloadProgress] events while downloading [file].
  ///
  /// The download writes directly to disk in streaming chunks (never buffering
  /// the full content). After completion, SHA-256 is verified in a background
  /// isolate using the same streaming approach.
  Stream<FileDownloadProgress> downloadFile({
    required TransferFile file,
    required String transferId,
  }) {
    final controller = StreamController<FileDownloadProgress>.broadcast();

    _doDownload(
      file: file,
      transferId: transferId,
      controller: controller,
    ).whenComplete(controller.close);

    return controller.stream;
  }

  Future<void> _doDownload({
    required TransferFile file,
    required String transferId,
    required StreamController<FileDownloadProgress> controller,
  }) async {
    void emit(FileDownloadProgress p) {
      if (!controller.isClosed) controller.add(p);
    }

    emit(FileDownloadProgress(
      fileId: file.fileId,
      bytesReceived: 0,
      totalBytes: file.size,
      status: FileDownloadStatus.downloading,
    ));

    try {
      final dir = await resolveDownloadDir(transferId);
      final destFile = File('${dir.path}/${file.name}');

      // Note: Firebase Storage signed URLs do not support range requests easily
      // via the standard SDK/signed URL mechanism. Resumable downloads are 
      // therefore currently implemented as "restart from byte 0" on network drops.
      // We ensure the destFile is fresh or explicitly overwritten.

      // Open a RandomAccessFile sink — chunks land on disk immediately.
      final raf = await destFile.open(mode: FileMode.write);

      try {
        final response = await _dio.get<ResponseBody>(
          file.storageUrl,
          options: Options(responseType: ResponseType.stream),
        );

        final body = response.data;
        if (body == null) throw Exception('Empty response body');

        int received = 0;

        // Each iteration holds exactly one network chunk in RAM.
        await for (final chunk in body.stream) {
          await raf.writeFrom(chunk);
          received += chunk.length;
          emit(FileDownloadProgress(
            fileId: file.fileId,
            bytesReceived: received,
            totalBytes: file.size,
            status: FileDownloadStatus.downloading,
          ));
        }
      } catch (e) {
        // If download fails mid-stream, delete partial file to prevent corruption
        // and ensure the next attempt starts clean.
        await raf.close();
        if (await destFile.exists()) {
          await destFile.delete();
        }
        rethrow;
      } finally {
        await raf.close();
      }

      // ── SHA-256 integrity verification ────────────────────────────────────
      // Run in an isolate so the UI is not blocked. The isolate streams the
      // saved file from disk using computeFileSha256() — no full-file buffer.
      emit(FileDownloadProgress(
        fileId: file.fileId,
        bytesReceived: file.size,
        totalBytes: file.size,
        status: FileDownloadStatus.verifying,
      ));

      final actualHash = await compute(
        _computeHashIsolate,
        destFile.path,
      );

      if (actualHash != file.sha256) {
        emit(FileDownloadProgress(
          fileId: file.fileId,
          bytesReceived: file.size,
          totalBytes: file.size,
          status: FileDownloadStatus.corrupt,
        ));
        return;
      }

      emit(FileDownloadProgress(
        fileId: file.fileId,
        bytesReceived: file.size,
        totalBytes: file.size,
        status: FileDownloadStatus.done,
        savedPath: destFile.path,
      ));
    } catch (e) {
      emit(FileDownloadProgress(
        fileId: file.fileId,
        bytesReceived: 0,
        totalBytes: file.size,
        status: FileDownloadStatus.failed,
      ));
    }
  }

  // -------------------------------------------------------------------------
  // resolveDownloadDir
  // -------------------------------------------------------------------------

  /// Returns (creating if needed) the directory where files for [transferId]
  /// are stored. Public so providers can resolve the final path.
  Future<Directory> resolveDownloadDir(String transferId) async {
    Directory? base;

    // Try public/external storage if permission granted (Android)
    if (Platform.isAndroid) {
      final hasPhotoPerm = await Permission.photos.isGranted;
      final hasExternalPerm = await Permission.storage.isGranted;

      if (hasPhotoPerm || hasExternalPerm) {
        base = await getExternalStorageDirectory();
        if (base != null) {
          debugPrint('ReceiveRepository: using external storage: ${base.path}');
        }
      } else {
        debugPrint(
          'ReceiveRepository: media/storage permissions denied — '
          'falling back to internal app storage.',
        );
      }
    }

    // Fallback to app-scoped directory (internal storage / iOS sandbox)
    if (base == null) {
      base = await getApplicationDocumentsDirectory();
      debugPrint('ReceiveRepository: using internal app storage: ${base.path}');
    }

    final dir = Directory('${base.path}/neosapienShare/downloads/$transferId');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }
}

// ---------------------------------------------------------------------------
// Isolate entry point for SHA-256 verification
// ---------------------------------------------------------------------------

/// Top-level function required by [compute]. Runs in a separate isolate so the
/// UI thread is never blocked during hash verification of large files.
///
/// Streams the file from disk in chunks — peak RAM is one chunk (≈64 KB).
Future<String> _computeHashIsolate(String filePath) =>
    computeFileSha256(File(filePath));

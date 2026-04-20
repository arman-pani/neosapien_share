import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

import '../../domain/entities/incoming_transfer.dart';

/// Streams incoming "ready" transfers addressed to [myCode].
///
/// The query mirrors the Firestore schema:
///   transfers/{id}: { recipientCode, status, expiresAt, senderId, ... }
///   transfers/{id}/files/{fileId}: { name, size, mimeType, storageUrl, sha256 }
class IncomingTransferRemoteDataSource {
  const IncomingTransferRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  /// Returns a stream that emits whenever the set of ready or queued transfers
  /// changes for [myCode].
  ///
  /// Filters:
  ///   • status is "ready" or "queued"   — "queued" means the push was not
  ///     deliverable (recipient was offline); the transfer is still available.
  ///   • expiresAt > now                 — client-side guard; the cleanup
  ///     Cloud Function will have already set expired docs to status="expired".
  ///
  /// Each emission re-fetches all matching documents' file sub-collections.
  Stream<List<IncomingTransfer>> watchIncomingTransfers(String myCode) {
    // Firestore does not support OR queries on the same field in a single query
    // without using whereIn or a composite index.  whereIn on status keeps the
    // query simple and allows the expiresAt filter to be enforced.
    final query = _firestore
        .collection('transfers')
        .where('recipientCode', isEqualTo: myCode)
        .where('status', whereIn: ['ready', 'queued'])
        .where('expiresAt', isGreaterThan: Timestamp.now());

    return query.snapshots().asyncMap((snapshot) async {
      final now = DateTime.now();
      final transfers = <IncomingTransfer>[];

      for (final doc in snapshot.docs) {
        final data  = doc.data();
        // Additional client-side expiry guard (Timestamp.now() used in the
        // query is captured at subscription time; real-time clock may drift).
        final expiresAt = (data['expiresAt'] as Timestamp?)?.toDate();
        if (expiresAt != null && expiresAt.isBefore(now)) continue;

        final filesSnapshot = await doc.reference.collection('files').get();
        final files = filesSnapshot.docs
            .map((f) => TransferFile.fromFirestore(f.id, f.data()))
            .toList();

        transfers.add(
          IncomingTransfer.fromFirestore(doc.id, data, files),
        );
      }

      return transfers;
    });
  }
}

// ---------------------------------------------------------------------------
// Download progress model
// ---------------------------------------------------------------------------

enum FileDownloadStatus { idle, downloading, verifying, done, corrupt, failed }

class FileDownloadProgress {
  const FileDownloadProgress({
    required this.fileId,
    required this.bytesReceived,
    required this.totalBytes,
    required this.status,
    this.savedPath,
  });

  final String fileId;
  final int bytesReceived;
  final int totalBytes;
  final FileDownloadStatus status;
  final String? savedPath;

  double get fraction =>
      totalBytes == 0 ? 0 : (bytesReceived / totalBytes).clamp(0.0, 1.0);
}

// ---------------------------------------------------------------------------
// SHA-256 helper (chunked, no full-file RAM load)
// ---------------------------------------------------------------------------

Future<String> computeFileSha256(File file) async {
  final digestSink = _SingleDigestSink();
  final chunkedDigest = sha256.startChunkedConversion(digestSink);

  await for (final chunk in file.openRead()) {
    chunkedDigest.add(chunk);
  }

  chunkedDigest.close();
  return digestSink.value.toString();
}

class _SingleDigestSink implements Sink<Digest> {
  Digest? _value;

  Digest get value {
    final v = _value;
    if (v == null) throw StateError('Digest not yet available.');
    return v;
  }

  @override
  void add(Digest data) => _value = data;

  @override
  void close() {}
}

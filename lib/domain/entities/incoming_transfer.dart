import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_transfer.freezed.dart';

// ---------------------------------------------------------------------------
// TransferFile — one file inside a transfer
// ---------------------------------------------------------------------------

@freezed
abstract class TransferFile with _$TransferFile {
  const factory TransferFile({
    required String fileId,
    required String name,
    required int size,
    required String mimeType,
    required String storageUrl,
    required String sha256,
  }) = _TransferFile;

  factory TransferFile.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return TransferFile(
      fileId: id,
      name: data['name'] as String? ?? '',
      size: (data['size'] as num?)?.toInt() ?? 0,
      mimeType: data['mimeType'] as String? ?? 'application/octet-stream',
      storageUrl: data['storageUrl'] as String? ?? '',
      sha256: data['sha256'] as String? ?? '',
    );
  }
}

// ---------------------------------------------------------------------------
// IncomingTransfer — a full transfer record with its files
// ---------------------------------------------------------------------------

@freezed
abstract class IncomingTransfer with _$IncomingTransfer {
  const factory IncomingTransfer({
    required String transferId,
    required String senderCode,
    required String recipientCode,
    required String status,
    required DateTime createdAt,
    required DateTime expiresAt,
    required List<TransferFile> files,
  }) = _IncomingTransfer;

  factory IncomingTransfer.fromFirestore(
    String id,
    Map<String, dynamic> data,
    List<TransferFile> files,
  ) {
    DateTime parseTimestamp(dynamic raw) {
      if (raw is Timestamp) return raw.toDate();
      if (raw is DateTime) return raw;
      return DateTime.now();
    }

    return IncomingTransfer(
      transferId: id,
      senderCode: data['senderId'] as String? ?? '',
      recipientCode: data['recipientCode'] as String? ?? '',
      status: data['status'] as String? ?? '',
      createdAt: parseTimestamp(data['createdAt']),
      expiresAt: parseTimestamp(data['expiresAt']),
      files: files,
    );
  }
}

extension IncomingTransferX on IncomingTransfer {
  int get totalBytes => files.fold(0, (s, f) => s + f.size);
}

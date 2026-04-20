import '../entities/transfer_record.dart';

// ---------------------------------------------------------------------------
// Delivery status — observed by  the sender after upload completes
// ---------------------------------------------------------------------------

/// The real-time delivery state of a transfer as seen by the sender.
///
/// Transitions (set by Cloud Function or cleanup job):
///   uploading → queued     recipient offline (no FCM token); transfer is still
///                          available until it expires.
///   uploading → ready      FCM push sent; recipient will be notified.
///   ready     → delivered  Recipient acknowledged the first download chunk.
///   *         → expired    72-hour TTL passed; Cloud Function cleaned up files.
///   *         → cancelled  Sender cancelled mid-upload.
enum TransferDeliveryStatus {
  uploading,
  queued,   // was 'ready' in Firestore before re-labelling; push not delivered
  ready,    // FCM sent — waiting for recipient to open
  delivered,
  expired,
  cancelled,
  unknown,
}

// ---------------------------------------------------------------------------
// Per-file status enum
// ---------------------------------------------------------------------------

enum FileUploadStatus { pending, uploading, done, failed, cancelled }

// ---------------------------------------------------------------------------
// Upload file descriptor
// ---------------------------------------------------------------------------

class TransferUploadFile {
  const TransferUploadFile({
    required this.fileId,
    required this.name,
    required this.path,
    required this.sizeInBytes,
    required this.mimeType,
  });

  final String fileId;
  final String name;
  final String path;
  final int sizeInBytes;
  final String mimeType;
}

// ---------------------------------------------------------------------------
// Resumption descriptor
// ---------------------------------------------------------------------------

class PendingResumption {
  const PendingResumption({
    required this.transferId,
    required this.fileIds,
  });

  final String transferId;
  final List<String> fileIds;
}

// ---------------------------------------------------------------------------
// Progress snapshots
// ---------------------------------------------------------------------------

class FileUploadProgress {
  const FileUploadProgress({
    required this.fileId,
    required this.bytesTransferred,
    required this.totalBytes,
    required this.status,
  });

  final String fileId;
  final int bytesTransferred;
  final int totalBytes;
  final FileUploadStatus status;

  double get fraction =>
      totalBytes == 0 ? 0 : (bytesTransferred / totalBytes).clamp(0.0, 1.0);
}

class TransferUploadProgress {
  const TransferUploadProgress({
    required this.fileProgress,
    required this.aggregateProgress,
  });

  final Map<String, FileUploadProgress> fileProgress;
  final double aggregateProgress;
}

// ---------------------------------------------------------------------------
// Operation handle returned by uploadTransfer
// ---------------------------------------------------------------------------

class TransferUploadOperation {
  const TransferUploadOperation({
    required this.transferId,
    required this.progressStream,
    required this.completion,
  });

  final String transferId;
  final Stream<TransferUploadProgress> progressStream;
  final Future<void> completion;
}

// ---------------------------------------------------------------------------
// Abstract repository
// ---------------------------------------------------------------------------

abstract class TransferRepository {
  Future<List<TransferRecord>> fetchIncomingTransfers();

  TransferUploadOperation uploadTransfer({
    required String senderId,
    required String recipientCode,
    required List<TransferUploadFile> files,
  });

  /// Cancels an in-flight transfer:
  ///  • Cancels active Firebase Storage upload tasks.
  ///  • Sets the Firestore transfer status to "cancelled".
  ///  • Deletes any partial Storage objects already uploaded.
  Future<void> cancelTransfer(String transferId);

  /// Retries only the files whose status is [FileUploadStatus.failed].
  TransferUploadOperation retryFailedFiles({
    required String transferId,
    required String senderId,
    required String recipientCode,
    required List<TransferUploadFile> failedFiles,
  });

  /// The stream completes naturally when the document is deleted.
  Stream<TransferDeliveryStatus> watchTransferDelivery(String transferId);

  /// Scans local storage for any incomplete upload sessions that can be resumed.
  Future<List<PendingResumption>> getPendingResumableTransfers();
}

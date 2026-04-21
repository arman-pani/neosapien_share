import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/interfaces/transfer_repository.dart';
import '../../../core/di/providers.dart';
import '../../../core/services/connectivity_service.dart';

part 'send_upload_provider.freezed.dart';
part 'send_upload_provider.g.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum SendPhase { idle, uploading, success, partialFailure, cancelled }

@freezed
class SendUploadState with _$SendUploadState {
  const factory SendUploadState({
    @Default(SendPhase.idle) SendPhase phase,
    @Default('') String transferId,
    @Default('') String recipientCode,
    @Default('') String senderId,
    @Default([]) List<TransferUploadFile> files,
    @Default({}) Map<String, FileUploadProgress> fileProgress,
    @Default(0) double aggregateProgress,
    @Default(false) bool isCancelling,
    @Default(TransferDeliveryStatus.unknown) TransferDeliveryStatus deliveryStatus,
  }) = _SendUploadState;

  const SendUploadState._();

  bool get isInProgress => phase == SendPhase.uploading && !isCancelling;

  List<TransferUploadFile> get failedFiles => files
      .where((f) => fileProgress[f.fileId]?.status == FileUploadStatus.failed)
      .toList();
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
class SendUpload extends _$SendUpload {
  StreamSubscription<TransferUploadProgress>? _progressSub;
  StreamSubscription<TransferDeliveryStatus>? _deliverySub;
  StreamSubscription<AppConnectivityStatus>? _connectivitySub;

  @override
  FutureOr<SendUploadState> build(String transferId) {
    _connectivitySub?.cancel();
    _connectivitySub = ref.watch(connectivityServiceProvider).statusStream.listen((status) {
      if (status == AppConnectivityStatus.online) {
        final currentState = state.valueOrNull;
        if (currentState != null) {
          if (currentState.phase == SendPhase.partialFailure ||
              (currentState.phase == SendPhase.uploading && !currentState.isCancelling)) {
            // Auto-resume on network restore if we were mid-upload or failed.
            retryFailed();
          }
        }
      }
    });

    ref.onDispose(() {
      _progressSub?.cancel();
      _deliverySub?.cancel();
      _connectivitySub?.cancel();
    });

    return SendUploadState(transferId: transferId);
  }

  // -------------------------------------------------------------------------
  // Start
  // -------------------------------------------------------------------------

  void startUpload({
    required String senderId,
    required String recipientCode,
    required List<TransferUploadFile> files,
  }) {
    final currentState = state.requireValue;
    if (currentState.phase == SendPhase.uploading) {
      return;
    }

    state = AsyncValue.data(currentState.copyWith(
      phase: SendPhase.uploading,
      recipientCode: recipientCode,
      senderId: senderId,
      files: files,
      aggregateProgress: 0,
      fileProgress: {
        for (final f in files)
          f.fileId: FileUploadProgress(
            fileId: f.fileId,
            bytesTransferred: 0,
            totalBytes: f.sizeInBytes,
            status: FileUploadStatus.pending,
          ),
      },
    ));

    final operation = ref.read(transferRepositoryProvider).uploadTransfer(
      transferId: currentState.transferId,
      senderId: senderId,
      recipientCode: recipientCode,
      files: files,
    );

    _listenToOperation(operation);
  }

  // -------------------------------------------------------------------------
  // Retry failed files
  // -------------------------------------------------------------------------

  void retryFailed() {
    final currentState = state.requireValue;
    final failed = currentState.failedFiles;
    if (failed.isEmpty) return;

    // Reset failed files to pending in local state immediately.
    final newProgress = Map<String, FileUploadProgress>.from(
      currentState.fileProgress,
    );
    for (final f in failed) {
      newProgress[f.fileId] = FileUploadProgress(
        fileId: f.fileId,
        bytesTransferred: 0,
        totalBytes: f.sizeInBytes,
        status: FileUploadStatus.pending,
      );
    }

    state = AsyncValue.data(currentState.copyWith(
      phase: SendPhase.uploading,
      fileProgress: newProgress,
    ));

    final operation = ref.read(transferRepositoryProvider).retryFailedFiles(
      transferId: currentState.transferId,
      senderId: currentState.senderId,
      recipientCode: currentState.recipientCode,
      failedFiles: failed,
    );

    _listenToOperation(operation);
  }

  // -------------------------------------------------------------------------
  // Cancel
  // -------------------------------------------------------------------------

  Future<void> cancel() async {
    final currentState = state.requireValue;
    if (currentState.phase != SendPhase.uploading) return;

    state = AsyncValue.data(currentState.copyWith(isCancelling: true));

    await _progressSub?.cancel();
    _progressSub = null;

    await ref.read(transferRepositoryProvider).cancelTransfer(currentState.transferId);

    state = AsyncValue.data(currentState.copyWith(phase: SendPhase.cancelled, isCancelling: false));
  }

  // -------------------------------------------------------------------------
  // Internal: subscribe to a progress stream and drive state
  // -------------------------------------------------------------------------

  void _listenToOperation(TransferUploadOperation operation) {
    _progressSub?.cancel();
    _progressSub = operation.progressStream.listen(
      (progress) {
        state = AsyncValue.data(state.requireValue.copyWith(
          fileProgress: Map.unmodifiable(progress.fileProgress),
          aggregateProgress: progress.aggregateProgress,
        ));
      },
      onDone: _onStreamDone,
      onError: (Object _) => _onStreamDone(),
    );
  }

  void _onStreamDone() {
    final currentState = state.requireValue;
    if (currentState.phase == SendPhase.cancelled) return;
    if (currentState.isCancelling) return;

    final hasFailure = currentState.fileProgress.values.any(
      (p) => p.status == FileUploadStatus.failed,
    );

    state = AsyncValue.data(currentState.copyWith(
      phase: hasFailure ? SendPhase.partialFailure : SendPhase.success,
      aggregateProgress: hasFailure ? currentState.aggregateProgress : 1.0,
    ));

    // Once upload finishes successfully, start watching delivery status so
    // the sender can see "Queued — recipient offline", "Delivered", or
    // "Expired" in real-time.
    if (!hasFailure) {
      _watchDelivery(currentState.transferId);
    }
  }

  void _watchDelivery(String transferId) {
    _deliverySub?.cancel();
    _deliverySub = ref.read(transferRepositoryProvider).watchTransferDelivery(transferId).listen((
      status,
    ) {
      state = AsyncValue.data(state.requireValue.copyWith(deliveryStatus: status));
    });
  }
}

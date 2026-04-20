import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/interfaces/transfer_repository.dart';
import '../../core/di/providers.dart';
import '../../core/services/connectivity_service.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum SendPhase { idle, uploading, success, partialFailure, cancelled }

class SendUploadState {
  const SendUploadState({
    this.phase = SendPhase.idle,
    this.transferId = '',
    this.recipientCode = '',
    this.senderId = '',
    this.files = const [],
    this.fileProgress = const {},
    this.aggregateProgress = 0,
    this.isCancelling = false,
    this.deliveryStatus = TransferDeliveryStatus.unknown,
  });

  final SendPhase phase;
  final String transferId;
  final String recipientCode;
  final String senderId;

  /// Original file descriptors — needed for retry.
  final List<TransferUploadFile> files;

  /// fileId → FileUploadProgress
  final Map<String, FileUploadProgress> fileProgress;

  /// Weighted aggregate 0.0–1.0
  final double aggregateProgress;

  /// True while cancel request is in flight.
  final bool isCancelling;

  /// Real-time delivery status visible to the sender after upload completes.
  /// Updates in real-time via a Firestore listener.
  final TransferDeliveryStatus deliveryStatus;

  bool get isInProgress =>
      phase == SendPhase.uploading && !isCancelling;

  List<TransferUploadFile> get failedFiles => files
      .where(
        (f) =>
            fileProgress[f.fileId]?.status == FileUploadStatus.failed,
      )
      .toList();

  SendUploadState copyWith({
    SendPhase? phase,
    String? transferId,
    String? recipientCode,
    String? senderId,
    List<TransferUploadFile>? files,
    Map<String, FileUploadProgress>? fileProgress,
    double? aggregateProgress,
    bool? isCancelling,
    TransferDeliveryStatus? deliveryStatus,
  }) {
    return SendUploadState(
      phase: phase ?? this.phase,
      transferId: transferId ?? this.transferId,
      recipientCode: recipientCode ?? this.recipientCode,
      senderId: senderId ?? this.senderId,
      files: files ?? this.files,
      fileProgress: fileProgress ?? this.fileProgress,
      aggregateProgress: aggregateProgress ?? this.aggregateProgress,
      isCancelling: isCancelling ?? this.isCancelling,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
    );
  }
}

// ---------------------------------------------------------------------------
// Provider — family keyed by transferId so each upload session is isolated.
// Use .autoDispose so state is released when the screen is popped after
// success/cancel, but not during rotation (the widget re-subscribes).
// ---------------------------------------------------------------------------

final sendUploadProvider = StateNotifierProvider.autoDispose
    .family<SendUploadNotifier, SendUploadState, String>(
  (ref, transferId) => SendUploadNotifier(
    ref.watch(transferRepositoryProvider),
    ref.watch(connectivityServiceProvider),
    transferId,
  ),
);

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class SendUploadNotifier extends StateNotifier<SendUploadState> {
  SendUploadNotifier(
    this._repository,
    this._connectivity,
    String transferId,
  ) : super(SendUploadState(transferId: transferId)) {
    _connectivitySub = _connectivity.statusStream.listen((status) {
      if (status == AppConnectivityStatus.online) {
        if (state.phase == SendPhase.partialFailure ||
            (state.phase == SendPhase.uploading && !state.isCancelling)) {
          // Auto-resume on network restore if we were mid-upload or failed.
          retryFailed();
        }
      }
    });
  }

  final TransferRepository _repository;
  final ConnectivityService _connectivity;
  StreamSubscription<TransferUploadProgress>? _progressSub;
  StreamSubscription<TransferDeliveryStatus>? _deliverySub;
  late StreamSubscription<AppConnectivityStatus> _connectivitySub;

  // -------------------------------------------------------------------------
  // Start
  // -------------------------------------------------------------------------

  void startUpload({
    required String senderId,
    required String recipientCode,
    required List<TransferUploadFile> files,
  }) {
    if (state.phase == SendPhase.uploading) return; // already running

    state = state.copyWith(
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
    );

    final operation = _repository.uploadTransfer(
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
    final failed = state.failedFiles;
    if (failed.isEmpty) return;

    // Reset failed files to pending in local state immediately.
    final newProgress = Map<String, FileUploadProgress>.from(state.fileProgress);
    for (final f in failed) {
      newProgress[f.fileId] = FileUploadProgress(
        fileId: f.fileId,
        bytesTransferred: 0,
        totalBytes: f.sizeInBytes,
        status: FileUploadStatus.pending,
      );
    }

    state = state.copyWith(
      phase: SendPhase.uploading,
      fileProgress: newProgress,
    );

    final operation = _repository.retryFailedFiles(
      transferId: state.transferId,
      senderId: state.senderId,
      recipientCode: state.recipientCode,
      failedFiles: failed,
    );

    _listenToOperation(operation);
  }

  // -------------------------------------------------------------------------
  // Cancel
  // -------------------------------------------------------------------------

  Future<void> cancel() async {
    if (state.phase != SendPhase.uploading) return;

    state = state.copyWith(isCancelling: true);

    await _progressSub?.cancel();
    _progressSub = null;

    await _repository.cancelTransfer(state.transferId);

    state = state.copyWith(
      phase: SendPhase.cancelled,
      isCancelling: false,
    );
  }

  // -------------------------------------------------------------------------
  // Internal: subscribe to a progress stream and drive state
  // -------------------------------------------------------------------------

  void _listenToOperation(TransferUploadOperation operation) {
    _progressSub?.cancel();
    _progressSub = operation.progressStream.listen(
      (progress) {
        if (!mounted) return;
        state = state.copyWith(
          fileProgress: Map.unmodifiable(progress.fileProgress),
          aggregateProgress: progress.aggregateProgress,
        );
      },
      onDone: _onStreamDone,
      onError: (Object _) => _onStreamDone(),
    );
  }

  void _onStreamDone() {
    if (!mounted) return;
    if (state.phase == SendPhase.cancelled) return;
    if (state.isCancelling) return;

    final hasFailure = state.fileProgress.values
        .any((p) => p.status == FileUploadStatus.failed);

    state = state.copyWith(
      phase: hasFailure ? SendPhase.partialFailure : SendPhase.success,
      aggregateProgress: hasFailure ? state.aggregateProgress : 1.0,
    );

    // Once upload finishes successfully, start watching delivery status so
    // the sender can see "Queued — recipient offline", "Delivered", or
    // "Expired" in real-time.
    if (!hasFailure) {
      _watchDelivery(state.transferId);
    }
  }

  void _watchDelivery(String transferId) {
    _deliverySub?.cancel();
    _deliverySub = _repository
        .watchTransferDelivery(transferId)
        .listen((status) {
      if (!mounted) return;
      state = state.copyWith(deliveryStatus: status);
    });
  }

  @override
  void dispose() {
    _progressSub?.cancel();
    _deliverySub?.cancel();
    _connectivitySub.cancel();
    super.dispose();
  }
}

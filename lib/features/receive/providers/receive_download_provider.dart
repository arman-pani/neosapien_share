import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:neosapien_share/data/remote_data_sources/incoming_transfer_remote_data_source.dart';
import 'package:neosapien_share/domain/entities/incoming_transfer.dart';
import 'package:neosapien_share/core/di/providers.dart';
import 'active_transfer_provider.dart';

part 'receive_download_provider.freezed.dart';
part 'receive_download_provider.g.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum ReceiveDownloadStatus { idle, downloading, done }

@freezed
class ReceiveDownloadState with _$ReceiveDownloadState {
  const factory ReceiveDownloadState({
    @Default(ReceiveDownloadStatus.idle) ReceiveDownloadStatus status,
    IncomingTransfer? transfer,
    @Default({}) Map<String, double> perFileProgress,
    @Default({}) Map<String, FileDownloadStatus> perFileStatus,
    @Default(0) double aggregateProgress,
    @Default([]) List<String> corruptFiles,
    @Default({}) Map<String, String> filePaths,
  }) = _ReceiveDownloadState;

  const ReceiveDownloadState._();

  bool get hasCorruption => corruptFiles.isNotEmpty;

  bool get isExpired {
    if (transfer == null) return false;
    return transfer!.expiresAt.isBefore(DateTime.now());
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
class ReceiveDownload extends _$ReceiveDownload {
  @override
  FutureOr<ReceiveDownloadState> build(String transferId) async {
    final transfer = await ref.watch(activeTransferProvider(transferId).future);
    return ReceiveDownloadState(transfer: transfer);
  }

  /// Guards against downloading the same transfer twice in a session.
  bool _downloadStarted = false;

  Future<void> downloadAll(IncomingTransfer transfer) async {
    if (_downloadStarted) return;
    _downloadStarted = true;

    final files = transfer.files;
    final repository = ref.read(receiveRepositoryProvider);

    // Initialise progress tracking
    final perFileProgress = {for (final f in files) f.fileId: 0.0};
    final perFileStatus = {
      for (final f in files) f.fileId: FileDownloadStatus.downloading,
    };
    final fileSizes = {for (final f in files) f.fileId: f.size};
    final totalBytes = transfer.totalBytes.toDouble().clamp(1, double.infinity);

    final corruptFiles = <String>[];

    state = AsyncValue.data(state.requireValue.copyWith(
      status: ReceiveDownloadStatus.downloading,
      perFileProgress: Map.of(perFileProgress),
      perFileStatus: Map.of(perFileStatus),
      aggregateProgress: 0,
    ));

    for (final file in files) {
      final stream = repository.downloadFile(
        file: file,
        transferId: transferId,
      );

      await for (final progress in stream) {
        perFileProgress[file.fileId] = progress.fraction;
        perFileStatus[file.fileId] = progress.status;

        // Weighted aggregate
        final weighted = perFileProgress.entries.fold<double>(
          0,
          (sum, e) => sum + ((fileSizes[e.key] ?? 0) * e.value),
        );

        state = AsyncValue.data(state.requireValue.copyWith(
          perFileProgress: Map.of(perFileProgress),
          perFileStatus: Map.of(perFileStatus),
          aggregateProgress: (weighted / totalBytes).clamp(0.0, 1.0),
        ));
      }

      // Record outcome
      final finalStatus = perFileStatus[file.fileId];
      if (finalStatus == FileDownloadStatus.done) {
        final dir = await ref
            .read(receiveRepositoryProvider)
            .resolveDownloadDir(transferId);
        final path = '${dir.path}/${file.name}';
        state = AsyncValue.data(state.requireValue.copyWith(
          filePaths: {...state.requireValue.filePaths, file.fileId: path},
        ));
      } else if (finalStatus == FileDownloadStatus.corrupt) {
        corruptFiles.add(file.name);
      }
    }

    state = AsyncValue.data(state.requireValue.copyWith(
      status: ReceiveDownloadStatus.done,
      perFileProgress: Map.of(perFileProgress),
      perFileStatus: Map.of(perFileStatus),
      aggregateProgress: 1.0,
      corruptFiles: corruptFiles,
    ));
  }

  /// Sets the transfer status to "delivered" in Firestore.
  Future<void> markAsDelivered() async {
    await ref.read(receiveRepositoryProvider).markAsDelivered(transferId);
  }
}

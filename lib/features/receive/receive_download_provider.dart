import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/incoming_transfer.dart';
import '../../core/di/providers.dart';
import '../../data/remote_data_sources/incoming_transfer_remote_data_source.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

enum ReceiveDownloadStatus { idle, downloading, done }

class ReceiveDownloadState {
  const ReceiveDownloadState({
    this.status = ReceiveDownloadStatus.idle,
    this.perFileProgress = const {},
    this.perFileStatus = const {},
    this.aggregateProgress = 0,
    this.corruptFiles = const [],
    this.savedPaths = const [],
  });

  final ReceiveDownloadStatus status;

  /// fileId → fraction 0.0–1.0
  final Map<String, double> perFileProgress;

  /// fileId → FileDownloadStatus
  final Map<String, FileDownloadStatus> perFileStatus;

  /// Weighted aggregate across all files (0.0–1.0)
  final double aggregateProgress;

  /// Names of files that failed SHA-256 verification
  final List<String> corruptFiles;

  /// Paths of successfully saved files
  final List<String> savedPaths;

  bool get hasCorruption => corruptFiles.isNotEmpty;

  ReceiveDownloadState copyWith({
    ReceiveDownloadStatus? status,
    Map<String, double>? perFileProgress,
    Map<String, FileDownloadStatus>? perFileStatus,
    double? aggregateProgress,
    List<String>? corruptFiles,
    List<String>? savedPaths,
  }) {
    return ReceiveDownloadState(
      status: status ?? this.status,
      perFileProgress: perFileProgress ?? this.perFileProgress,
      perFileStatus: perFileStatus ?? this.perFileStatus,
      aggregateProgress: aggregateProgress ?? this.aggregateProgress,
      corruptFiles: corruptFiles ?? this.corruptFiles,
      savedPaths: savedPaths ?? this.savedPaths,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

final receiveDownloadProvider = StateNotifierProvider.family<
    ReceiveDownloadNotifier, ReceiveDownloadState, String>(
  (ref, transferId) => ReceiveDownloadNotifier(ref, transferId),
);

class ReceiveDownloadNotifier
    extends StateNotifier<ReceiveDownloadState> {
  ReceiveDownloadNotifier(this._ref, this._transferId)
      : super(const ReceiveDownloadState());

  final Ref _ref;
  final String _transferId;

  /// Guards against downloading the same transfer twice in a session.
  bool _downloadStarted = false;

  Future<void> downloadAll(IncomingTransfer transfer) async {
    if (_downloadStarted) return;
    _downloadStarted = true;

    final files = transfer.files;
    final repository = _ref.read(receiveRepositoryProvider);

    // Initialise progress tracking
    final perFileProgress = {for (final f in files) f.fileId: 0.0};
    final perFileStatus = {
      for (final f in files) f.fileId: FileDownloadStatus.downloading,
    };
    final fileSizes = {for (final f in files) f.fileId: f.size};
    final totalBytes = transfer.totalBytes.toDouble().clamp(1, double.infinity);

    final savedPaths = <String>[];
    final corruptFiles = <String>[];

    state = state.copyWith(
      status: ReceiveDownloadStatus.downloading,
      perFileProgress: Map.of(perFileProgress),
      perFileStatus: Map.of(perFileStatus),
      aggregateProgress: 0,
    );

    for (final file in files) {
      final stream = repository.downloadFile(
        file: file,
        transferId: _transferId,
      );

      await for (final progress in stream) {
        perFileProgress[file.fileId] = progress.fraction;
        perFileStatus[file.fileId] = progress.status;

        // Weighted aggregate
        final weighted = perFileProgress.entries.fold<double>(
          0,
          (sum, e) => sum + ((fileSizes[e.key] ?? 0) * e.value),
        );

        state = state.copyWith(
          perFileProgress: Map.of(perFileProgress),
          perFileStatus: Map.of(perFileStatus),
          aggregateProgress: (weighted / totalBytes).clamp(0.0, 1.0),
        );
      }

      // Record outcome
      final finalStatus = perFileStatus[file.fileId];
      if (finalStatus == FileDownloadStatus.done) {
        // savedPath was emitted as the last event's savedPath; we read it from
        // the last emitted event indirectly via state, so we re-check here.
        // The actual path emitted lives only in the event stream; re-derive:
        final dir = await _ref.read(receiveRepositoryProvider).resolveDownloadDir(
          _transferId,
        );
        savedPaths.add('${dir.path}/${file.name}');
      } else if (finalStatus == FileDownloadStatus.corrupt) {
        corruptFiles.add(file.name);
      }
    }

    state = state.copyWith(
      status: ReceiveDownloadStatus.done,
      perFileProgress: Map.of(perFileProgress),
      perFileStatus: Map.of(perFileStatus),
      aggregateProgress: 1.0,
      corruptFiles: corruptFiles,
      savedPaths: savedPaths,
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/interfaces/transfer_repository.dart';
import 'send_upload_provider.dart';

// ---------------------------------------------------------------------------
// SendProgressScreen
// ---------------------------------------------------------------------------

class SendProgressScreen extends ConsumerWidget {
  const SendProgressScreen({
    super.key,
    required this.transferId,
    required this.recipientCode,
  });

  final String transferId;
  final String recipientCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadState =
        ref.watch(sendUploadProvider(transferId));

    // Navigate away when cancelled — pop back to file selector.
    ref.listen(sendUploadProvider(transferId), (prev, next) {
      if (next.phase == SendPhase.cancelled && context.canPop()) {
        context.pop();
      }
    });

    return PopScope(
      // Intercept back-button while an upload is in progress.
      canPop: uploadState.phase != SendPhase.uploading,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        _showCancelDialog(context, ref);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D14),
        appBar: _buildAppBar(context, ref, uploadState),
        body: SafeArea(
          child: Column(
            children: [
              // Aggregate progress bar — always visible at top.
              _AggregateProgressHeader(
                state: uploadState,
                recipientCode: recipientCode,
              ),
              // File list.
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  children: [
                    ...uploadState.files.map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _FileProgressCard(
                          file: f,
                          progress: uploadState.fileProgress[f.fileId],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom action bar.
              _BottomActionBar(
                state: uploadState,
                onCancel: () => _showCancelDialog(context, ref),
                onRetry: () =>
                    ref.read(sendUploadProvider(transferId).notifier).retryFailed(),
                onDone: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    SendUploadState state,
  ) {
    late final String title;
    if (state.phase == SendPhase.success) {
      title = 'Transfer complete';
    } else if (state.phase == SendPhase.partialFailure) {
      title = 'Partially failed';
    } else if (state.phase == SendPhase.cancelled) {
      title = 'Transfer cancelled';
    } else {
      title = 'Sending files…';
    }

    return AppBar(
      backgroundColor: const Color(0xFF12121C),
      foregroundColor: Colors.white,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      automaticallyImplyLeading: state.phase != SendPhase.uploading,
      leading: state.phase == SendPhase.uploading
          ? null
          : BackButton(onPressed: () => context.go('/home')),
    );
  }

  Future<void> _showCancelDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Cancel transfer?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Cancelling will stop all uploads and delete any partial data from the server.',
          style: TextStyle(color: Color(0xFFCCCCCC)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Keep uploading',
              style: TextStyle(color: Color(0xFF7B6FE8)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Yes, cancel',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(sendUploadProvider(transferId).notifier).cancel();
    }
  }
}

// ---------------------------------------------------------------------------
// Aggregate progress header
// ---------------------------------------------------------------------------

class _AggregateProgressHeader extends StatelessWidget {
  const _AggregateProgressHeader({
    required this.state,
    required this.recipientCode,
  });

  final SendUploadState state;
  final String recipientCode;

  @override
  Widget build(BuildContext context) {
    final phase = state.phase;

    final Color barColor;
    final String label;

    switch (phase) {
      case SendPhase.success:
        barColor = const Color(0xFF4CAF50);
        label = 'Files sent to $recipientCode';
      case SendPhase.partialFailure:
        barColor = const Color(0xFFFF6B6B);
        label = 'Some files failed — tap "Retry" to try again';
      case SendPhase.cancelled:
        barColor = const Color(0xFF888888);
        label = 'Transfer cancelled';
      case SendPhase.uploading:
        barColor = const Color(0xFF7B6FE8);
        final pct = (state.aggregateProgress * 100).toStringAsFixed(0);
        label = 'Uploading… $pct%';
      case SendPhase.idle:
        barColor = const Color(0xFF7B6FE8);
        label = 'Preparing…';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF12121C),
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A3E))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status icon + label row.
          Row(
            children: [
              _PhaseIcon(phase: phase),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: phase == SendPhase.success
                        ? const Color(0xFF4CAF50)
                        : phase == SendPhase.partialFailure
                            ? const Color(0xFFFF6B6B)
                            : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar.
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: state.aggregateProgress),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) => LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: const Color(0xFF2A2A3E),
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Byte counts.
          _ByteCountRow(state: state),
          // Delivery status banner — shown after a successful upload.
          if (phase == SendPhase.success)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _DeliveryStatusBanner(
                status: state.deliveryStatus,
              ),
            ),
        ],
      ),
    );
  }
}

class _ByteCountRow extends StatelessWidget {
  const _ByteCountRow({required this.state});

  final SendUploadState state;

  @override
  Widget build(BuildContext context) {
    final totalBytes =
        state.files.fold<int>(0, (s, f) => s + f.sizeInBytes);
    final transferredBytes = state.fileProgress.values
        .fold<int>(0, (s, fp) => s + fp.bytesTransferred);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${_formatBytes(transferredBytes)} / ${_formatBytes(totalBytes)}',
          style: const TextStyle(color: Color(0xFF888888), fontSize: 12),
        ),
        Text(
          '${state.fileProgress.values.where((p) => p.status == FileUploadStatus.done).length}'
          ' / ${state.files.length} files',
          style: const TextStyle(color: Color(0xFF888888), fontSize: 12),
        ),
      ],
    );
  }
}

class _PhaseIcon extends StatelessWidget {
  const _PhaseIcon({required this.phase});

  final SendPhase phase;

  @override
  Widget build(BuildContext context) {
    switch (phase) {
      case SendPhase.success:
        return const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF4CAF50),
          size: 26,
        );
      case SendPhase.partialFailure:
        return const Icon(
          Icons.warning_rounded,
          color: Color(0xFFFFB74D),
          size: 26,
        );
      case SendPhase.cancelled:
        return const Icon(
          Icons.cancel_rounded,
          color: Color(0xFF888888),
          size: 26,
        );
      case SendPhase.uploading:
        return const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Color(0xFF7B6FE8),
          ),
        );
      case SendPhase.idle:
        return const SizedBox(width: 22, height: 22);
    }
  }
}

// ---------------------------------------------------------------------------
// Per-file card
// ---------------------------------------------------------------------------

class _FileProgressCard extends StatelessWidget {
  const _FileProgressCard({required this.file, required this.progress});

  final TransferUploadFile file;
  final FileUploadProgress? progress;

  @override
  Widget build(BuildContext context) {
    final fp = progress;
    final status =
        fp?.status ?? FileUploadStatus.pending;
    final fraction = fp?.fraction ?? 0.0;
    final transferred = fp?.bytesTransferred ?? 0;
    final total = file.sizeInBytes;

    final Color borderColor;
    switch (status) {
      case FileUploadStatus.done:
        borderColor = const Color(0xFF4CAF50).withValues(alpha: 0.5);
      case FileUploadStatus.failed:
        borderColor = const Color(0xFFFF6B6B).withValues(alpha: 0.5);
      case FileUploadStatus.cancelled:
        borderColor = const Color(0xFF888888).withValues(alpha: 0.5);
      default:
        borderColor = const Color(0xFF2A2A3E);
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF12121C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File name + status icon row.
          Row(
            children: [
              Icon(
                _mimeIcon(file.mimeType),
                color: const Color(0xFF7B6FE8),
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _StatusIcon(status: status),
            ],
          ),
          const SizedBox(height: 6),
          // Size line.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                status == FileUploadStatus.uploading
                    ? '${_formatBytes(transferred)} / ${_formatBytes(total)}'
                    : _formatBytes(total),
                style: const TextStyle(
                  color: Color(0xFF666680),
                  fontSize: 12,
                ),
              ),
              if (status == FileUploadStatus.uploading)
                Text(
                  '${(fraction * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Color(0xFF7B6FE8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          // Progress bar — only while uploading.
          if (status == FileUploadStatus.uploading ||
              status == FileUploadStatus.pending) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: fraction),
                duration: const Duration(milliseconds: 200),
                builder: (context, value, child) => LinearProgressIndicator(
                  value: status == FileUploadStatus.pending ? null : value,
                  minHeight: 5,
                  backgroundColor: const Color(0xFF2A2A3E),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF7B6FE8),
                  ),
                ),
              ),
            ),
          ],
          // Failure message.
          if (status == FileUploadStatus.failed)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Upload failed — will be retried.',
                style: TextStyle(
                  color: Color(0xFFFF6B6B),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  final FileUploadStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case FileUploadStatus.done:
        return const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF4CAF50),
          size: 18,
        );
      case FileUploadStatus.failed:
        return const Icon(
          Icons.error_rounded,
          color: Color(0xFFFF6B6B),
          size: 18,
        );
      case FileUploadStatus.cancelled:
        return const Icon(
          Icons.cancel_rounded,
          color: Color(0xFF888888),
          size: 18,
        );
      case FileUploadStatus.uploading:
        return const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF7B6FE8),
          ),
        );
      case FileUploadStatus.pending:
        return const Icon(
          Icons.radio_button_unchecked_rounded,
          color: Color(0xFF444466),
          size: 18,
        );
    }
  }
}

// ---------------------------------------------------------------------------
// Bottom action bar
// ---------------------------------------------------------------------------

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.state,
    required this.onCancel,
    required this.onRetry,
    required this.onDone,
  });

  final SendUploadState state;
  final VoidCallback onCancel;
  final VoidCallback onRetry;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF12121C),
        border: Border(top: BorderSide(color: Color(0xFF2A2A3E))),
      ),
      child: switch (state.phase) {
        // In-progress: Cancel button (disabled while cancelling).
        SendPhase.uploading => SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: state.isCancelling
                      ? const Color(0xFF444444)
                      : const Color(0xFFFF6B6B),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: state.isCancelling ? null : onCancel,
              icon: state.isCancelling
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF888888),
                      ),
                    )
                  : const Icon(
                      Icons.cancel_outlined,
                      color: Color(0xFFFF6B6B),
                    ),
              label: Text(
                state.isCancelling ? 'Cancelling…' : 'Cancel transfer',
                style: TextStyle(
                  color: state.isCancelling
                      ? const Color(0xFF888888)
                      : const Color(0xFFFF6B6B),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        // Success: Done button.
        SendPhase.success => SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1A3A1A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onDone,
              icon: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF4CAF50),
              ),
              label: const Text(
                'Done',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        // Partial failure: Retry + Done row.
        SendPhase.partialFailure => Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFFB74D)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: onRetry,
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: Color(0xFFFFB74D),
                    ),
                    label: const Text(
                      'Retry failed files',
                      style: TextStyle(
                        color: Color(0xFFFFB74D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF444466)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: onDone,
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Color(0xFF888888)),
                  ),
                ),
              ),
            ],
          ),

        // Cancelled.
        SendPhase.cancelled => SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2A2A3E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onDone,
              child: const Text(
                'Back to home',
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        // Idle — should not normally be visible, but guard anyway.
        SendPhase.idle => const SizedBox.shrink(),
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Delivery status banner (shown on the sender side after upload succeeds)
// ---------------------------------------------------------------------------

class _DeliveryStatusBanner extends StatelessWidget {
  const _DeliveryStatusBanner({required this.status});

  final TransferDeliveryStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, label, bg, fg) = switch (status) {
      TransferDeliveryStatus.queued => (
        Icons.schedule_rounded,
        'Queued — recipient offline. Will be delivered when they come online.',
        const Color(0xFF2A2215),
        const Color(0xFFFFA851),
      ),
      TransferDeliveryStatus.ready => (
        Icons.notifications_active_rounded,
        'Notified — waiting for recipient to open.',
        const Color(0xFF1A1E2E),
        const Color(0xFF7B6FE8),
      ),
      TransferDeliveryStatus.delivered => (
        Icons.check_circle_rounded,
        'Delivered 🎉 — recipient has opened the transfer.',
        const Color(0xFF1A2E1A),
        const Color(0xFF4CAF50),
      ),
      TransferDeliveryStatus.expired => (
        Icons.timer_off_rounded,
        'Transfer expired — not downloaded within 72 hours.',
        const Color(0xFF2E1A1A),
        const Color(0xFFFF6B6B),
      ),
      _ => (
        Icons.hourglass_top_rounded,
        'Waiting for delivery confirmation…',
        const Color(0xFF1A1A2E),
        const Color(0xFF888888),
      ),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: Container(
        key: ValueKey(status),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: fg.withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: fg, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

IconData _mimeIcon(String mime) {
  if (mime.startsWith('image/')) return Icons.image_rounded;
  if (mime.startsWith('video/')) return Icons.movie_rounded;
  if (mime.startsWith('audio/')) return Icons.music_note_rounded;
  if (mime == 'application/pdf') return Icons.picture_as_pdf_rounded;
  if (mime.contains('zip') || mime.contains('compressed')) {
    return Icons.folder_zip_rounded;
  }
  if (mime.startsWith('text/')) return Icons.description_rounded;
  return Icons.insert_drive_file_rounded;
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  const units = ['KB', 'MB', 'GB', 'TB'];
  var value = bytes.toDouble();
  var unitIndex = -1;
  while (value >= 1024 && unitIndex < units.length - 1) {
    value /= 1024;
    unitIndex++;
  }
  final decimals = max(0, value >= 100 ? 0 : 1);
  return '${value.toStringAsFixed(decimals)} ${units[unitIndex]}';
}

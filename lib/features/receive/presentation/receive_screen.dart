import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../domain/entities/incoming_transfer.dart';
import '../../../data/remote_data_sources/incoming_transfer_remote_data_source.dart';
import '../incoming_transfers_provider.dart';
import '../receive_download_provider.dart';

class ReceiveScreen extends ConsumerStatefulWidget {
  const ReceiveScreen({super.key, required this.transferId});

  final String transferId;

  @override
  ConsumerState<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends ConsumerState<ReceiveScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final transfersAsync = ref.watch(incomingTransfersProvider);
    final dlState = ref.watch(receiveDownloadProvider(widget.transferId));
    final dlNotifier =
        ref.read(receiveDownloadProvider(widget.transferId).notifier);

    // React to corruption _after_ download finishes
    ref.listen(
      receiveDownloadProvider(widget.transferId),
      (prev, next) {
        if (next.status == ReceiveDownloadStatus.done &&
            next.hasCorruption &&
            mounted) {
          _showCorruptionDialog(next.corruptFiles);
        }
      },
    );

    return transfersAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (transfers) {
        final transfer = transfers.cast<IncomingTransfer?>().firstWhere(
              (t) => t?.transferId == widget.transferId,
              orElse: () => null,
            );

        // Transfer not found — check Firestore directly to distinguish
        // "expired" from "not found". The real-time listener already excludes
        // expired docs, so if transferId is missing from the list it is either
        // loading, expired, or invalid.  We show the expired screen
        // immediately because the Cloud Function sets status = "expired" and
        // the listener removes it from the stream.
        if (transfer == null) {
          return _ExpiredTransferScreen(transferId: widget.transferId);
        }

        return Scaffold(
          backgroundColor: const Color(0xFF0D0D14),
          appBar: AppBar(
            backgroundColor: const Color(0xFF12121C),
            foregroundColor: Colors.white,
            title: const Text(
              'Incoming Transfer',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            leading: BackButton(
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _TransferHeader(transfer: transfer),
                      const SizedBox(height: 24),
                      if (dlState.status != ReceiveDownloadStatus.idle) ...[
                        _AggregateProgressBar(progress: dlState.aggregateProgress),
                        const SizedBox(height: 20),
                      ],
                      _FilesList(
                        transfer: transfer,
                        dlState: dlState,
                      ),
                    ],
                  ),
                ),
                _BottomBar(
                  transfer: transfer,
                  dlState: dlState,
                  onDownloadAll: () {
                    // Mark the transfer as delivered in Firestore so the
                    // sender's real-time listener transitions to "delivered".
                    _markDelivered(widget.transferId);
                    dlNotifier.downloadAll(transfer);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Sets status = "delivered" so the sender's [watchTransferDelivery] stream
  /// transitions from "ready" / "queued" to "delivered".
  /// Best-effort — we do not block the download on this call.
  void _markDelivered(String transferId) {
    final firestore = ref.read(firebaseServiceProvider).firestore;
    firestore
        .collection('transfers')
        .doc(transferId)
        .update({'status': 'delivered'})
        .catchError((_) {});
  }

  void _showCorruptionDialog(List<String> corruptFiles) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFFF6B6B)),
            SizedBox(width: 10),
            Text(
              'Integrity Check Failed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'File corrupted — transfer integrity check failed.',
              style: TextStyle(color: Color(0xFFCCCCCC)),
            ),
            const SizedBox(height: 12),
            ...corruptFiles.map(
              (name) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  '• $name',
                  style: const TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK', style: TextStyle(color: Color(0xFF7B6FE8))),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _TransferHeader extends StatelessWidget {
  const _TransferHeader({required this.transfer});

  final IncomingTransfer transfer;

  @override
  Widget build(BuildContext context) {
    final remaining = transfer.expiresAt.difference(DateTime.now());
    final hoursLeft = remaining.inHours;
    final minutesLeft = remaining.inMinutes % 60;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF1A1A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF7B6FE8).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B6FE8).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.download_rounded,
                  color: Color(0xFF7B6FE8),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'From',
                      style: TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      transfer.senderCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _InfoChip(
                icon: Icons.folder_rounded,
                label:
                    '${transfer.files.length} file${transfer.files.length == 1 ? '' : 's'}',
              ),
              const SizedBox(width: 8),
              _InfoChip(
                icon: Icons.data_usage_rounded,
                label: _formatBytes(transfer.totalBytes),
              ),
              const SizedBox(width: 8),
              _InfoChip(
                icon: Icons.timer_outlined,
                label: remaining.isNegative
                    ? 'Expired'
                    : '${hoursLeft}h ${minutesLeft}m left',
                color: remaining.isNegative
                    ? const Color(0xFFFF6B6B)
                    : remaining.inHours < 4
                        ? const Color(0xFFFFA851)
                        : const Color(0xFF4CAF50),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    this.color = const Color(0xFF7B6FE8),
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AggregateProgressBar extends StatelessWidget {
  const _AggregateProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).toStringAsFixed(0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Overall progress',
              style: TextStyle(
                color: Color(0xFFCCCCCC),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$pct%',
              style: const TextStyle(
                color: Color(0xFF7B6FE8),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: progress),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) => LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: const Color(0xFF2A2A3E),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF7B6FE8)),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilesList extends StatelessWidget {
  const _FilesList({required this.transfer, required this.dlState});

  final IncomingTransfer transfer;
  final ReceiveDownloadState dlState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Files',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...transfer.files.map(
          (f) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _FileProgressCard(
              file: f,
              progress: dlState.perFileProgress[f.fileId] ?? 0,
              fileStatus:
                  dlState.perFileStatus[f.fileId] ?? FileDownloadStatus.idle,
            ),
          ),
        ),
      ],
    );
  }
}

class _FileProgressCard extends StatelessWidget {
  const _FileProgressCard({
    required this.file,
    required this.progress,
    required this.fileStatus,
  });

  final TransferFile file;
  final double progress;
  final FileDownloadStatus fileStatus;

  @override
  Widget build(BuildContext context) {
    final statusColor = _colorForStatus(fileStatus);
    final statusIcon = _iconForStatus(fileStatus);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF12121C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: fileStatus == FileDownloadStatus.corrupt
              ? const Color(0xFFFF6B6B).withValues(alpha: 0.5)
              : const Color(0xFF2A2A3E),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_mimeIcon(file.mimeType), color: const Color(0xFF7B6FE8), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  file.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(statusIcon, color: statusColor, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${_formatBytes(file.size)} • ${file.mimeType}',
            style: const TextStyle(color: Color(0xFF666680), fontSize: 12),
          ),
          if (fileStatus == FileDownloadStatus.downloading ||
              fileStatus == FileDownloadStatus.verifying) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(end: progress),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, v, child) => LinearProgressIndicator(
                        value: v,
                        minHeight: 5,
                        backgroundColor: const Color(0xFF2A2A3E),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          fileStatus == FileDownloadStatus.verifying
                              ? const Color(0xFFFFA851)
                              : const Color(0xFF7B6FE8),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  fileStatus == FileDownloadStatus.verifying
                      ? 'Verifying…'
                      : '${(progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Color(0xFFCCCCCC),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          if (fileStatus == FileDownloadStatus.corrupt)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'File corrupted — transfer integrity check failed.',
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

  Color _colorForStatus(FileDownloadStatus s) => switch (s) {
        FileDownloadStatus.done => const Color(0xFF4CAF50),
        FileDownloadStatus.corrupt => const Color(0xFFFF6B6B),
        FileDownloadStatus.failed => const Color(0xFFFF6B6B),
        FileDownloadStatus.verifying => const Color(0xFFFFA851),
        FileDownloadStatus.downloading => const Color(0xFF7B6FE8),
        FileDownloadStatus.idle => const Color(0xFF444466),
      };

  IconData _iconForStatus(FileDownloadStatus s) => switch (s) {
        FileDownloadStatus.done => Icons.check_circle_rounded,
        FileDownloadStatus.corrupt => Icons.error_rounded,
        FileDownloadStatus.failed => Icons.cancel_rounded,
        FileDownloadStatus.verifying => Icons.verified_rounded,
        FileDownloadStatus.downloading => Icons.downloading_rounded,
        FileDownloadStatus.idle => Icons.radio_button_unchecked_rounded,
      };

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
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.transfer,
    required this.dlState,
    required this.onDownloadAll,
  });

  final IncomingTransfer transfer;
  final ReceiveDownloadState dlState;
  final VoidCallback onDownloadAll;

  @override
  Widget build(BuildContext context) {
    final isIdle = dlState.status == ReceiveDownloadStatus.idle;
    final isDone = dlState.status == ReceiveDownloadStatus.done;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF12121C),
        border: Border(top: BorderSide(color: Color(0xFF2A2A3E))),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: isDone
                ? const Color(0xFF2A4A2A)
                : const Color(0xFF7B6FE8),
            disabledBackgroundColor: const Color(0xFF3A3A4E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: isIdle ? onDownloadAll : null,
          icon: isDone
              ? const Icon(Icons.check_circle_rounded, color: Color(0xFF4CAF50))
              : isIdle
                  ? const Icon(Icons.download_for_offline_rounded)
                  : const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
          label: Text(
            isDone ? 'Download complete' : isIdle ? 'Download all' : 'Downloading…',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDone ? const Color(0xFF4CAF50) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Expired Screen
// ---------------------------------------------------------------------------

class _ExpiredTransferScreen extends StatelessWidget {
  const _ExpiredTransferScreen({required this.transferId});

  final String transferId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12121C),
        foregroundColor: Colors.white,
        title: const Text('Transfer Expired'),
        leading: BackButton(onPressed: () => context.go('/home')),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.timer_off_rounded,
                  color: Color(0xFFFF6B6B),
                  size: 64,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'This transfer has expired',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'For security and storage efficiency, all files are automatically deleted 72 hours after they are uploaded.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A2E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFF2A2A3E)),
                    ),
                  ),
                  onPressed: () => context.go('/home'),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

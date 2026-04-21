import 'package:flutter/material.dart';
import 'package:neosapien_share/domain/interfaces/transfer_repository.dart';
import 'package:neosapien_share/features/send/providers/send_upload_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/aggregate_progress_bar.dart';
import '../../../../shared/utils/file_util.dart';
import 'delivery_status_banner.dart';

class AggregateProgressHeader extends StatelessWidget {
  const AggregateProgressHeader({
    super.key,
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
        barColor = AppColors.success;
        label = 'Files sent to $recipientCode';
      case SendPhase.partialFailure:
        barColor = AppColors.danger;
        label = 'Some files failed — tap "Retry" to try again';
      case SendPhase.cancelled:
        barColor = AppColors.textMuted;
        label = 'Transfer cancelled';
      case SendPhase.uploading:
        barColor = AppColors.primary;
        final pct = (state.aggregateProgress * 100).toStringAsFixed(0);
        label = 'Uploading… $pct%';
      case SendPhase.idle:
        barColor = AppColors.primary;
        label = 'Preparing…';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _PhaseIcon(phase: phase),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: phase == SendPhase.success
                        ? AppColors.success
                        : phase == SendPhase.partialFailure
                        ? AppColors.danger
                        : AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AggregateProgressBar(
            progress: state.aggregateProgress,
            barColor: barColor,
            showPercentage: false,
            height: 10,
          ),
          const SizedBox(height: 8),
          _ByteCountRow(state: state),
          if (phase == SendPhase.success)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: DeliveryStatusBanner(status: state.deliveryStatus),
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
    final totalBytes = state.files.fold<int>(0, (s, f) => s + f.sizeInBytes);
    final transferredBytes = state.fileProgress.values.fold<int>(
      0,
      (s, fp) => s + fp.bytesTransferred,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${formatBytes(transferredBytes)} / ${formatBytes(totalBytes)}',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
        Text(
          '${state.fileProgress.values.where((p) => p.status == FileUploadStatus.done).length}'
          ' / ${state.files.length} files',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
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
          color: AppColors.success,
          size: 26,
        );
      case SendPhase.partialFailure:
        return const Icon(
          Icons.warning_rounded,
          color: AppColors.warning,
          size: 26,
        );
      case SendPhase.cancelled:
        return const Icon(
          Icons.cancel_rounded,
          color: AppColors.textMuted,
          size: 26,
        );
      case SendPhase.uploading:
        return const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppColors.primary,
          ),
        );
      case SendPhase.idle:
        return const SizedBox(width: 22, height: 22);
    }
  }
}

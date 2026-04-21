import 'package:flutter/material.dart';
import 'package:neosapien_share/features/receive/providers/receive_download_provider.dart';
import 'package:neosapien_share/domain/entities/incoming_transfer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/utils/file_util.dart';
import '../../../../shared/widgets/info_chip.dart';

class ReceiveTransferHeader extends StatelessWidget {
  const ReceiveTransferHeader({
    super.key,
    required this.state,
    required this.senderName,
  });

  final ReceiveDownloadState state;
  final String senderName;

  @override
  Widget build(BuildContext context) {
    final transfer = state.transfer;
    if (transfer == null) return const SizedBox.shrink();

    final totalFiles = transfer.files.length;
    final totalBytes = transfer.totalBytes;
    final remainingTime = _calculateRemainingTime(transfer.expiresAt);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _SenderAvatar(name: senderName),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      senderName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'is sharing files with you',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              InfoChip(
                icon: Icons.filter_none_rounded,
                label: '$totalFiles File${totalFiles == 1 ? '' : 's'}',
              ),
              InfoChip(
                icon: Icons.data_usage_rounded,
                label: formatBytes(totalBytes),
                color: AppColors.secondary,
              ),
              InfoChip(
                icon: Icons.timer_outlined,
                label: 'Expires in $remainingTime',
                color: AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateRemainingTime(DateTime? expiresAt) {
    if (expiresAt == null) return 'unknown';
    final diff = expiresAt.difference(DateTime.now());
    if (diff.isNegative) return 'Expired';
    if (diff.inHours > 0) return '${diff.inHours}h';
    return '${diff.inMinutes}m';
  }
}

class _SenderAvatar extends StatelessWidget {
  const _SenderAvatar({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

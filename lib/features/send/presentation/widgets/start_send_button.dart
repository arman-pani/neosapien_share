import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/utils/file_util.dart';

class StartSendButton extends StatelessWidget {
  const StartSendButton({
    super.key,
    required this.onPressed,
    required this.totalBytes,
    required this.isEnabled,
    required this.isTooLarge,
  });

  final VoidCallback? onPressed;
  final int totalBytes;
  final bool isEnabled;
  final bool isTooLarge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Size',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              Text(
                formatBytes(totalBytes),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isTooLarge ? AppColors.danger : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: isTooLarge ? AppColors.danger : AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: isEnabled && !isTooLarge ? onPressed : null,
              icon: const Icon(Icons.send_rounded),
              label: Text(
                isTooLarge ? 'SIZE EXCEEDED' : 'START SEND',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

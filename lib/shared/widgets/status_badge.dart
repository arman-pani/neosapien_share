import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final (background, foreground) = switch (normalized) {
      'completed' => (
        AppColors.success.withValues(alpha: 0.15),
        AppColors.success,
      ),
      'failed' => (AppColors.danger.withValues(alpha: 0.15), AppColors.danger),
      'expired' => (
        AppColors.textMuted.withValues(alpha: 0.15),
        AppColors.textSecondary,
      ),
      _ => (AppColors.primary.withValues(alpha: 0.15), AppColors.primary),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: foreground.withValues(alpha: 0.3)),
      ),
      child: Text(
        normalized.toUpperCase(),
        style: TextStyle(
          color: foreground,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

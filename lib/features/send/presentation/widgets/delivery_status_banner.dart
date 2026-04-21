import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/interfaces/transfer_repository.dart';

class DeliveryStatusBanner extends StatelessWidget {
  const DeliveryStatusBanner({super.key, required this.status});

  final TransferDeliveryStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, label, bg, fg) = switch (status) {
      TransferDeliveryStatus.queued => (
        Icons.schedule_rounded,
        'Queued — recipient offline. Will be delivered when they come online.',
        const Color(0xFF2A2215),
        AppColors.warning,
      ),
      TransferDeliveryStatus.ready => (
        Icons.notifications_active_rounded,
        'Notified — waiting for recipient to open.',
        const Color(0xFF1A1E2E),
        AppColors.primary,
      ),
      TransferDeliveryStatus.delivered => (
        Icons.check_circle_rounded,
        'Delivered 🎉 — recipient has opened the transfer.',
        const Color(0xFF1A2E1A),
        AppColors.success,
      ),
      TransferDeliveryStatus.expired => (
        Icons.timer_off_rounded,
        'Transfer expired — not downloaded within 72 hours.',
        const Color(0xFF2E1A1A),
        AppColors.danger,
      ),
      _ => (
        Icons.hourglass_top_rounded,
        'Waiting for delivery confirmation…',
        AppColors.surface,
        AppColors.textMuted,
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

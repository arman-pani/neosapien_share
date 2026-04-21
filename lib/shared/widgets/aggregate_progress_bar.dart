import 'package:flutter/material.dart';
import 'package:neosapien_share/core/theme/app_colors.dart';

class AggregateProgressBar extends StatelessWidget {
  const AggregateProgressBar({
    super.key,
    required this.progress,
    this.label = 'Overall progress',
    this.showPercentage = true,
    this.height = 8.0,
    this.barColor = AppColors.primary,
  });

  final double progress;
  final String label;
  final bool showPercentage;
  final double height;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).toStringAsFixed(0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (showPercentage)
              Text(
                '$pct%',
                style: TextStyle(
                  color: barColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(height),
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: progress),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) => LinearProgressIndicator(
              value: value,
              minHeight: height,
              backgroundColor: AppColors.divider,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ),
      ],
    );
  }
}

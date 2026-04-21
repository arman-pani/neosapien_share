import 'package:flutter/material.dart';
import 'package:neosapien_share/core/theme/app_colors.dart';

enum AppInfoType {
  info,
  warning,
  error;

  Color get backgroundColor => switch (this) {
    AppInfoType.info => AppColors.primary.withValues(alpha: 0.1),
    AppInfoType.warning => AppColors.warning.withValues(alpha: 0.1),
    AppInfoType.error => AppColors.danger.withValues(alpha: 0.1),
  };

  Color get foregroundColor => switch (this) {
    AppInfoType.info => AppColors.primary,
    AppInfoType.warning => AppColors.warning,
    AppInfoType.error => AppColors.danger,
  };

  IconData get icon => switch (this) {
    AppInfoType.info => Icons.info_outline_rounded,
    AppInfoType.warning => Icons.warning_amber_rounded,
    AppInfoType.error => Icons.error_outline_rounded,
  };
}

class AppInfoBanner extends StatelessWidget {
  const AppInfoBanner({
    super.key,
    required this.message,
    this.type = AppInfoType.info,
    this.padding = const EdgeInsets.all(12),
  });

  final String message;
  final AppInfoType type;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: type.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: type.foregroundColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            type.icon,
            color: type.foregroundColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: type.foregroundColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:neosapien_share/core/theme/app_colors.dart';
import 'package:neosapien_share/shared/utils/file_util.dart';

enum TransferFileStatus {
  pending,
  active,
  verifying, // Only for downloads/uploads that need checksum
  done,
  failed,
  cancelled,
  corrupt; // Only for downloads
}

class TransferFileTile extends StatelessWidget {
  const TransferFileTile({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
    required this.progress,
    required this.status,
    this.statusMessage,
    this.onTap,
    this.isUpload = true,
  });

  final String fileName;
  final int fileSize;
  final String mimeType;
  final double progress;
  final TransferFileStatus status;
  final String? statusMessage;
  final VoidCallback? onTap;
  final bool isUpload;

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);
    
    // Border logic
    final Color borderColor;
    switch (status) {
      case TransferFileStatus.done:
        borderColor = AppColors.success.withValues(alpha: 0.5);
      case TransferFileStatus.failed:
      case TransferFileStatus.corrupt:
        borderColor = AppColors.danger.withValues(alpha: 0.5);
      case TransferFileStatus.cancelled:
        borderColor = AppColors.textMuted.withValues(alpha: 0.5);
      default:
        borderColor = AppColors.border;
    }

    final isProcessing = status == TransferFileStatus.active || 
                         status == TransferFileStatus.verifying || 
                         status == TransferFileStatus.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getMimeIcon(mimeType),
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(statusIcon, color: statusColor, size: 18),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    status == TransferFileStatus.active
                        ? '${formatBytes((progress * fileSize).toInt())} / ${formatBytes(fileSize)}'
                        : formatBytes(fileSize),
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  if (status == TransferFileStatus.active)
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              if (isProcessing) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: progress),
                    duration: const Duration(milliseconds: 200),
                    builder: (context, value, child) => LinearProgressIndicator(
                      value: status == TransferFileStatus.pending ? null : value,
                      minHeight: 5,
                      backgroundColor: AppColors.divider,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        status == TransferFileStatus.verifying
                            ? AppColors.warning
                            : AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
              if (statusMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    statusMessage!,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(TransferFileStatus status) => switch (status) {
    TransferFileStatus.done => AppColors.success,
    TransferFileStatus.corrupt || TransferFileStatus.failed => AppColors.danger,
    TransferFileStatus.verifying => AppColors.warning,
    TransferFileStatus.active => AppColors.primary,
    TransferFileStatus.cancelled => AppColors.textSecondary,
    TransferFileStatus.pending => AppColors.textMuted,
  };

  IconData _getStatusIcon(TransferFileStatus status) => switch (status) {
    TransferFileStatus.done => Icons.check_circle_rounded,
    TransferFileStatus.corrupt || TransferFileStatus.failed => Icons.error_rounded,
    TransferFileStatus.cancelled => Icons.cancel_rounded,
    TransferFileStatus.verifying => Icons.verified_rounded,
    TransferFileStatus.active => isUpload ? Icons.upload_file_rounded : Icons.downloading_rounded,
    TransferFileStatus.pending => Icons.radio_button_unchecked_rounded,
  };

  IconData _getMimeIcon(String mime) {
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

import 'package:flutter/material.dart';
import 'package:neosapien_share/features/receive/providers/receive_download_provider.dart';
import '../../../../core/theme/app_colors.dart';

class ReceiveBottomActionBar extends StatelessWidget {
  const ReceiveBottomActionBar({
    super.key,
    required this.state,
    required this.onStartDownload,
    required this.onDone,
  });

  final ReceiveDownloadState state;
  final VoidCallback onStartDownload;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final allDone = state.status == ReceiveDownloadStatus.done;
    final isDownloading = state.status == ReceiveDownloadStatus.downloading;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: allDone
            ? FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3A1A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: onDone,
                icon: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                ),
                label: const Text(
                  'DONE',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: isDownloading ? null : onStartDownload,
                icon: isDownloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.file_download_rounded),
                label: Text(
                  isDownloading ? 'DOWNLOADING…' : 'START DOWNLOAD',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}

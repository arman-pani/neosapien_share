import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/app_info_banner.dart';
import '../../providers/file_selection_notifier.dart';
import '../widgets/selection_header.dart';
import '../widgets/selected_files_list.dart';
import '../widgets/start_send_button.dart';

class FileSelectorScreen extends ConsumerWidget {
  const FileSelectorScreen({super.key, required this.recipientCode});

  final String recipientCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(fileSelectionProvider);
    final selectionNotifier = ref.read(fileSelectionProvider.notifier);

    final totalBytes = selectionNotifier.totalBytes;
    final totalBytesTooLarge = selectionNotifier.totalBytesTooLarge;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Send Files'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SelectionHeader(recipientCode: recipientCode),
            if (totalBytesTooLarge)
              const AppInfoBanner(
                message: 'Total size exceeds limit (1GB)',
                type: AppInfoType.error,
              ),
            SelectedFilesList(
              selectedFiles: selectionState.selectedFiles,
              onRemoveFile: (index) => selectionNotifier.removeFileAt(index),
            ),
            _AddMoreFilesButton(onPressed: () => selectionNotifier.pickFiles(context)),
            StartSendButton(
              onPressed: () => _startSend(context, ref),
              totalBytes: totalBytes,
              isEnabled: selectionState.selectedFiles.isNotEmpty,
              isTooLarge: totalBytesTooLarge,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startSend(BuildContext context, WidgetRef ref) async {
    await ref.read(fileSelectionProvider.notifier).startSend(context, recipientCode);
  }
}

class _AddMoreFilesButton extends StatelessWidget {
  const _AddMoreFilesButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: const Text(
          'ADD MORE FILES',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
      ),
    );
  }
}

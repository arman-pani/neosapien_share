import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neosapien_share/core/theme/app_colors.dart';
import 'package:neosapien_share/domain/interfaces/transfer_repository.dart';
import 'package:neosapien_share/features/send/providers/send_upload_provider.dart';
import 'package:neosapien_share/shared/widgets/transfer_file_tile.dart';
import 'package:neosapien_share/features/send/presentation/widgets/aggregate_progress_header.dart';
import 'package:neosapien_share/features/send/presentation/widgets/send_bottom_action_bar.dart';

class SendProgressScreen extends ConsumerWidget {
  const SendProgressScreen({
    super.key,
    required this.transferId,
    required this.recipientCode,
  });

  final String transferId;
  final String recipientCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploadStateAsync = ref.watch(sendUploadProvider(transferId));
    final uploadState =
        uploadStateAsync.valueOrNull ?? SendUploadState(transferId: transferId);

    // Navigate away when cancelled — pop back to file selector.
    ref.listen(sendUploadProvider(transferId), (prev, next) {
      final nextValue = next.valueOrNull;
      if (nextValue != null &&
          nextValue.phase == SendPhase.cancelled &&
          context.canPop()) {
        context.pop();
      }
    });

    return PopScope(
      canPop: uploadState.phase != SendPhase.uploading,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        _showCancelDialog(context, ref);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context, uploadState),
        body: SafeArea(
          child: Column(
            children: [
              AggregateProgressHeader(
                state: uploadState,
                recipientCode: recipientCode,
              ),
              Expanded(child: _FilesListView(state: uploadState)),
              SendBottomActionBar(
                state: uploadState,
                onCancel: () => _showCancelDialog(context, ref),
                onRetry: () => ref
                    .read(sendUploadProvider(transferId).notifier)
                    .retryFailed(),
                onDone: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    SendUploadState state,
  ) {
    final title = switch (state.phase) {
      SendPhase.success => 'Transfer complete',
      SendPhase.partialFailure => 'Partially failed',
      SendPhase.cancelled => 'Transfer cancelled',
      _ => 'Sending files…',
    };

    return AppBar(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      automaticallyImplyLeading: state.phase != SendPhase.uploading,
      leading: state.phase == SendPhase.uploading
          ? null
          : BackButton(onPressed: () => context.go('/home')),
    );
  }

  Future<void> _showCancelDialog(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Cancel transfer?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Cancelling will stop all uploads and delete any partial data from the server.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text(
              'Keep uploading',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(
              'Yes, cancel',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(sendUploadProvider(transferId).notifier).cancel();
    }
  }
}

class _FilesListView extends StatelessWidget {
  const _FilesListView({required this.state});
  final SendUploadState state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: state.files.length,
      itemBuilder: (context, index) {
        final f = state.files[index];
        final progress = state.fileProgress[f.fileId];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TransferFileTile(
            fileName: f.name,
            fileSize: f.sizeInBytes,
            mimeType: f.mimeType,
            progress: progress?.fraction ?? 0.0,
            status: _mapStatus(progress?.status ?? FileUploadStatus.pending),
            statusMessage: progress?.status == FileUploadStatus.failed
                ? 'Upload failed — will be retried.'
                : null,
            isUpload: true,
          ),
        );
      },
    );
  }

  TransferFileStatus _mapStatus(FileUploadStatus s) => switch (s) {
    FileUploadStatus.done => TransferFileStatus.done,
    FileUploadStatus.failed => TransferFileStatus.failed,
    FileUploadStatus.cancelled => TransferFileStatus.cancelled,
    FileUploadStatus.uploading => TransferFileStatus.active,
    FileUploadStatus.pending => TransferFileStatus.pending,
  };
}

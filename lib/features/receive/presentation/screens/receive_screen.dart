import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neosapien_share/core/theme/app_colors.dart';
import 'package:neosapien_share/features/receive/providers/receive_download_provider.dart';
import 'package:neosapien_share/features/receive/presentation/screens/expired_transfer_screen.dart';
import 'package:neosapien_share/features/receive/presentation/widgets/receive_transfer_header.dart';
import 'package:neosapien_share/features/receive/presentation/widgets/receive_files_list.dart';
import 'package:neosapien_share/features/receive/presentation/widgets/receive_bottom_action_bar.dart';

class ReceiveScreen extends ConsumerWidget {
  const ReceiveScreen({super.key, required this.transferId});

  final String transferId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadStateAsync = ref.watch(receiveDownloadProvider(transferId));

    return downloadStateAsync.when(
      data: (state) {
        if (state.isExpired) {
          return ExpiredTransferScreen(onBack: () => context.go('/home'));
        }

        final transfer = state.transfer;
        if (transfer == null) {
          // If transfer info isn't available yet (should be caught by builder when async completes)
          return const _LoadingScreen();
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(context, state),
          body: SafeArea(
            child: Column(
              children: [
                ReceiveTransferHeader(
                  state: state,
                  senderName: transfer.senderCode,
                ),
                Expanded(child: ReceiveFilesList(state: state)),
                ReceiveBottomActionBar(
                  state: state,
                  onStartDownload:
                      () => ref
                          .read(receiveDownloadProvider(transferId).notifier)
                          .downloadAll(transfer),
                  onDone: () => context.go('/home'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const _LoadingScreen(),
      error: (error, _) => _ErrorScreen(error: error, onBack: () => context.go('/home')),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ReceiveDownloadState state,
  ) {
    final title = switch (state.status) {
      ReceiveDownloadStatus.done => 'Download complete',
      ReceiveDownloadStatus.downloading => 'Downloading files…',
      _ => 'Incoming transfer',
    };

    return AppBar(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      leading: BackButton(onPressed: () => context.go('/home')),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.error, required this.onBack});
  final Object error;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(leading: BackButton(onPressed: onBack)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.danger,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Something went wrong: $error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

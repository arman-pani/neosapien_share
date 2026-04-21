import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:neosapien_share/core/di/providers.dart';
import 'package:neosapien_share/core/router/app_router.dart';
import 'package:neosapien_share/core/theme/app_colors.dart';
import 'package:neosapien_share/features/identity/providers/identity_provider.dart';
import 'package:neosapien_share/features/identity/providers/recent_transfers_provider.dart';
import 'package:neosapien_share/features/identity/models/received_transfer_summary.dart';
import 'package:neosapien_share/features/identity/presentation/widgets/pending_resumption_banner.dart';
import 'package:neosapien_share/shared/utils/file_util.dart';
import 'package:neosapien_share/shared/widgets/status_badge.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = ref.watch(identityProvider);

    // Request notification permissions once identity is resolved.
    ref.listen(identityProvider, (prev, next) {
      if (next.hasValue && prev?.hasValue != true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ref.read(notificationServiceProvider).requestPermission(context);
          }
        });
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: identity.when(
          data: (value) => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const PendingResumptionBanner(),
              const SizedBox(height: 24),
              _ShortCodeSection(shortCode: value.shortCode),
              const SizedBox(height: 32),
              _SendFilesButton(onPressed: () => context.go(AppRoutes.send)),
              const SizedBox(height: 32),
              const _RecentTransfersSection(),
            ],
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.danger, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShortCodeSection extends StatelessWidget {
  const _ShortCodeSection({required this.shortCode});
  final String shortCode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Your short code',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            shortCode,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontFamily: 'monospace',
              letterSpacing: 6,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          IconButton.outlined(
            style: IconButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
              foregroundColor: AppColors.primary,
            ),
            tooltip: 'Copy short code',
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: shortCode));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Short code copied')),
                );
              }
            },
            icon: const Icon(Icons.copy_rounded),
          ),
        ],
      ),
    );
  }
}

class _SendFilesButton extends StatelessWidget {
  const _SendFilesButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        icon: const Icon(Icons.send_rounded),
        label: const Text(
          'Send files',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _RecentTransfersSection extends ConsumerWidget {
  const _RecentTransfersSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentTransfers = ref.watch(recentReceivedTransfersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Transfers',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        recentTransfers.when(
          data: (items) {
            if (items.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'No transactions yet.',
                  style: TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return Column(
              children:
                  items
                      .map((item) => _RecentTransferTile(item: item))
                      .toList(growable: false),
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
          error: (error, _) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
            ),
            child: Text(
              'Unable to load received transfers: $error',
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentTransferTile extends StatelessWidget {
  const _RecentTransferTile({required this.item});
  final ReceivedTransferSummary item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          item.fileName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          formatBytes(item.sizeInBytes),
          style: const TextStyle(color: AppColors.textMuted),
        ),
        trailing: StatusBadge(status: item.status),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/providers.dart';
import '../../../core/router/app_router.dart';
import '../identity_provider.dart';

class ReceivedTransferSummary {
  const ReceivedTransferSummary({
    required this.id,
    required this.fileName,
    required this.sizeInBytes,
    required this.status,
  });

  final String id;
  final String fileName;
  final int sizeInBytes;
  final String status;
}

final recentReceivedTransfersProvider =
    StreamProvider.autoDispose<List<ReceivedTransferSummary>>((ref) {
      final identity = ref.watch(identityProvider);
      final shortCode = identity.valueOrNull?.shortCode;

      if (shortCode == null) {
        return const Stream<List<ReceivedTransferSummary>>.empty();
      }

      final firestore = ref.watch(firebaseServiceProvider).firestore;

      return firestore
          .collection('transfers')
          .where('recipientCode', isEqualTo: shortCode)
          .orderBy('createdAt', descending: true)
          .limit(5)
          .snapshots()
          .map(_mapTransferSnapshots);
    });

List<ReceivedTransferSummary> _mapTransferSnapshots(
  QuerySnapshot<Map<String, dynamic>> snapshot,
) {
  return snapshot.docs
      .map((doc) {
        final data = doc.data();
        final rawFiles = data['files'];
        final firstFile =
            rawFiles is List &&
                rawFiles.isNotEmpty &&
                rawFiles.first is Map<String, dynamic>
            ? rawFiles.first as Map<String, dynamic>
            : const <String, dynamic>{};

        return ReceivedTransferSummary(
          id: doc.id,
          fileName: (firstFile['name'] as String?) ?? 'Unnamed file',
          sizeInBytes: (firstFile['size'] as num?)?.toInt() ?? 0,
          status: (data['status'] as String?) ?? 'pending',
        );
      })
      .toList(growable: false);
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = ref.watch(identityProvider);
    final recentTransfers = ref.watch(recentReceivedTransfersProvider);

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
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: identity.when(
          data: (value) => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _PendingResumptionBanner(),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Your short code',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      value.shortCode,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            fontFamily: 'monospace',
                            letterSpacing: 6,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    IconButton.outlined(
                      tooltip: 'Copy short code',
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: value.shortCode),
                        );
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
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.go(AppRoutes.send),
                icon: const Icon(Icons.send_rounded),
                label: const Text('Send files'),
              ),
              const SizedBox(height: 32),
              Text('Receive', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              recentTransfers.when(
                data: (items) {
                  if (items.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No received transfers yet.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: items
                        .map(
                          (item) => Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              title: Text(item.fileName),
                              subtitle: Text(_formatFileSize(item.sizeInBytes)),
                              trailing: _StatusBadge(status: item.status),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Unable to load received transfers: $error',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '$error',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final (background, foreground) = switch (normalized) {
      'completed' => (const Color(0xFFD1FAE5), const Color(0xFF065F46)),
      'failed' => (const Color(0xFFFEE2E2), const Color(0xFF991B1B)),
      'expired' => (const Color(0xFFE5E7EB), const Color(0xFF374151)),
      _ => (const Color(0xFFDBEAFE), const Color(0xFF1D4ED8)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        normalized.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

String _formatFileSize(int bytes) {
  // ... (previous implementation)
  if (bytes < 1024) return '$bytes B';
  final kb = bytes / 1024;
  if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
  final mb = kb / 1024;
  if (mb < 1024) return '${mb.toStringAsFixed(1)} MB';
  final gb = mb / 1024;
  return '${gb.toStringAsFixed(1)} GB';
}

class _PendingResumptionBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumptions = ref.watch(pendingResumptionsProvider);

    return resumptions.when(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();

        final item = items.first; // Show the most recent/first found
        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF2A2A3E)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFACC15).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.replay_rounded,
                  color: const Color(0xFFFACC15),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Interrupted transfer found',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Resume your upload of ${item.fileIds.length} file(s).',
                      style: const TextStyle(
                        color: Color(0xFF888888),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  // Navigate to progress screen.
                  // Note: The TransferRecord might need to be fetched, but
                  // SendProgressScreen normally relies on SendUploadProvider
                  // which will now auto-resume if it finds the session.
                  context.go('/send/progress/${item.transferId}');
                },
                child: const Text(
                  'RESUME',
                  style: TextStyle(
                    color: Color(0xFFFACC15),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}

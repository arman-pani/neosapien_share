import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/incoming_transfer.dart';
import '../../core/di/providers.dart';
import '../../features/identity/identity_provider.dart';

/// Streams the live list of incoming "ready" transfers for the current user.
///
/// • Attaches a Firestore real-time listener on first build.
/// • Deduplicates across rebuilds: if a transferId has already been surfaced
///   this session, its notification is not re-fired.
/// • Automatically cancels the subscription when the provider is disposed.

final incomingTransfersProvider =
    StreamNotifierProvider<IncomingTransfersNotifier, List<IncomingTransfer>>(
  IncomingTransfersNotifier.new,
);

class IncomingTransfersNotifier
    extends StreamNotifier<List<IncomingTransfer>> {
  /// Tracks transfer IDs we have already notified about this session.
  final _seenIds = <String>{};

  @override
  Stream<List<IncomingTransfer>> build() {
    final identity = ref.watch(identityProvider);

    // While identity is loading/error, emit an empty list.
    final myCode = identity.valueOrNull?.shortCode;
    if (myCode == null) return Stream.value([]);

    final dataSource = ref.watch(incomingTransferDataSourceProvider);
    final notificationSvc = ref.watch(notificationServiceProvider);

    return dataSource.watchIncomingTransfers(myCode).map((transfers) {
      for (final t in transfers) {
        if (!_seenIds.contains(t.transferId)) {
          _seenIds.add(t.transferId);
          notificationSvc.showIncomingTransferNotification(t);
        }
      }
      return transfers;
    });
  }
}

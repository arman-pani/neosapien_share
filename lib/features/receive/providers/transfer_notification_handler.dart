import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neosapien_share/features/receive/providers/incoming_transfers_provider.dart';
import 'package:neosapien_share/core/di/providers.dart';

/// A logic-only component that observes the [incomingTransfersProvider]
/// and fires system notifications when new transfers arrive.
///
/// This is separated from the Notifier itself to keep the Firestore stream
/// pure and avoid side-effects during the build/map phase, which was causing
/// main-thread blocking on some devices.
class TransferNotificationHandler {
  TransferNotificationHandler(this.ref);

  final Ref ref;
  final _seenIds = <String>{};

  void listen() {
    // We listen to the stream of transfers.
    ref.listen(incomingTransfersProvider, (previous, next) {
      final transfers = next.valueOrNull;
      if (transfers == null) return;

      final notificationSvc = ref.read(notificationServiceProvider);

      for (final t in transfers) {
        if (!_seenIds.contains(t.transferId)) {
          _seenIds.add(t.transferId);
          
          // Only notify if this isn't the very first emission of a session
          // (optional, but prevents spamming notifications for old ready transfers
          // every time the app opens).
          // For now, we'll notify for all new IDs encountered this session.
          notificationSvc.showIncomingTransferNotification(t);
        }
      }
    });
  }
}

/// Provider for the [TransferNotificationHandler].
/// This should be watched at the root of the app to keep it active.
final transferNotificationHandlerProvider = Provider((ref) => TransferNotificationHandler(ref));

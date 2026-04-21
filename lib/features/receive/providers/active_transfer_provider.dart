import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:neosapien_share/domain/entities/incoming_transfer.dart';
import 'package:neosapien_share/features/receive/providers/incoming_transfers_provider.dart';
import 'package:neosapien_share/features/receive/providers/incoming_transfer_detail_provider.dart';

part 'active_transfer_provider.g.dart';

/// A combined provider that attempts to find a transfer in the active 
/// incoming transfers stream first, and falls back to a direct fetch 
/// if not found (e.g. following a deep link or FCM while sync is pending).
@riverpod
Future<IncomingTransfer?> activeTransfer(ActiveTransferRef ref, String transferId) async {
  final transfersAsync = ref.watch(incomingTransfersProvider);
  
  return transfersAsync.when(
    data: (transfers) async {
      final found = transfers.firstWhereOrNull((t) => t.transferId == transferId);
      if (found != null) return found;
      
      // Fallback to fetching specific detail
      return ref.watch(incomingTransferDetailProvider(transferId).future);
    },
    loading: () => null, // Wait for stream first
    error: (_, _) => ref.watch(incomingTransferDetailProvider(transferId).future),
  );
}

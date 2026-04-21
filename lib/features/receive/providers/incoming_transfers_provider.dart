import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:neosapien_share/domain/entities/incoming_transfer.dart';
import 'package:neosapien_share/core/di/providers.dart';
import 'package:neosapien_share/features/identity/providers/identity_provider.dart';

part 'incoming_transfers_provider.g.dart';

/// Streams the live list of incoming "ready" transfers for the current user.
///
/// • Attaches a Firestore real-time listener on first build.
/// • Deduplicates across rebuilds: if a transferId has already been surfaced
///   this session, its notification is not re-fired.
/// • Automatically cancels the subscription when the provider is disposed.

@Riverpod(keepAlive: true)
class IncomingTransfers extends _$IncomingTransfers {
  @override
  Stream<List<IncomingTransfer>> build() {
    final identity = ref.watch(identityProvider);

    // While identity is loading/error, emit an empty list.
    final myCode = identity.valueOrNull?.shortCode;
    if (myCode == null) return Stream.value([]);

    final dataSource = ref.watch(incomingTransferDataSourceProvider);

    return dataSource.watchIncomingTransfers(myCode);
  }
}

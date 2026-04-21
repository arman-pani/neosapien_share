import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../domain/entities/incoming_transfer.dart';

/// Fetches a specific transfer by ID.
/// This is used as a fallback by the ReceiveScreen if the real-time listener
/// hasn't yet pushed the document to the client.
final incomingTransferDetailProvider =
    FutureProvider.family<IncomingTransfer?, String>((ref, transferId) async {
  final dataSource = ref.watch(incomingTransferDataSourceProvider);
  return dataSource.getTransfer(transferId);
});

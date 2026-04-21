import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:neosapien_share/core/di/providers.dart';
import 'package:neosapien_share/domain/entities/incoming_transfer.dart';

part 'incoming_transfer_detail_provider.g.dart';

/// Fetches a specific transfer by ID.
/// This is used as a fallback by the ReceiveScreen if the real-time listener
/// hasn't yet pushed the document to the client.
@riverpod
class IncomingTransferDetail extends _$IncomingTransferDetail {
  @override
  Future<IncomingTransfer?> build(String transferId) async {
    final dataSource = ref.watch(incomingTransferDataSourceProvider);
    return dataSource.getTransfer(transferId);
  }
}

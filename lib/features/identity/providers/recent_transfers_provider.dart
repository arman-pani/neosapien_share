import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/providers.dart';
import '../models/received_transfer_summary.dart';
import 'identity_provider.dart';

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

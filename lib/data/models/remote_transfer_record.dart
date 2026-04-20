import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/transfer_record.dart';

part 'remote_transfer_record.freezed.dart';

@freezed
abstract class RemoteTransferRecord with _$RemoteTransferRecord {
  const RemoteTransferRecord._();

  const factory RemoteTransferRecord({
    required String id,
    required String shortCode,
    required String fileName,
    required int sizeInBytes,
    required DateTime createdAt,
  }) = _RemoteTransferRecord;

  TransferRecord toDomain() {
    return TransferRecord(
      id: id,
      shortCode: shortCode,
      fileName: fileName,
      sizeInBytes: sizeInBytes,
      createdAt: createdAt,
    );
  }
}

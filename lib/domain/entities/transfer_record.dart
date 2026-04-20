import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_record.freezed.dart';

@freezed
abstract class TransferRecord with _$TransferRecord {
  const factory TransferRecord({
    required String id,
    required String shortCode,
    required String fileName,
    required int sizeInBytes,
    required DateTime createdAt,
  }) = _TransferRecord;
}

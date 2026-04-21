import 'package:freezed_annotation/freezed_annotation.dart';

part 'identity_state.freezed.dart';

@freezed
class IdentityState with _$IdentityState {
  const factory IdentityState({
    required String shortCode,
    required String localUuid,
  }) = _IdentityState;
}

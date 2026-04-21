// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'identity_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$IdentityState {
  String get shortCode => throw _privateConstructorUsedError;
  String get localUuid => throw _privateConstructorUsedError;

  /// Create a copy of IdentityState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IdentityStateCopyWith<IdentityState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IdentityStateCopyWith<$Res> {
  factory $IdentityStateCopyWith(
    IdentityState value,
    $Res Function(IdentityState) then,
  ) = _$IdentityStateCopyWithImpl<$Res, IdentityState>;
  @useResult
  $Res call({String shortCode, String localUuid});
}

/// @nodoc
class _$IdentityStateCopyWithImpl<$Res, $Val extends IdentityState>
    implements $IdentityStateCopyWith<$Res> {
  _$IdentityStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IdentityState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? shortCode = null, Object? localUuid = null}) {
    return _then(
      _value.copyWith(
            shortCode: null == shortCode
                ? _value.shortCode
                : shortCode // ignore: cast_nullable_to_non_nullable
                      as String,
            localUuid: null == localUuid
                ? _value.localUuid
                : localUuid // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IdentityStateImplCopyWith<$Res>
    implements $IdentityStateCopyWith<$Res> {
  factory _$$IdentityStateImplCopyWith(
    _$IdentityStateImpl value,
    $Res Function(_$IdentityStateImpl) then,
  ) = __$$IdentityStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String shortCode, String localUuid});
}

/// @nodoc
class __$$IdentityStateImplCopyWithImpl<$Res>
    extends _$IdentityStateCopyWithImpl<$Res, _$IdentityStateImpl>
    implements _$$IdentityStateImplCopyWith<$Res> {
  __$$IdentityStateImplCopyWithImpl(
    _$IdentityStateImpl _value,
    $Res Function(_$IdentityStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IdentityState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? shortCode = null, Object? localUuid = null}) {
    return _then(
      _$IdentityStateImpl(
        shortCode: null == shortCode
            ? _value.shortCode
            : shortCode // ignore: cast_nullable_to_non_nullable
                  as String,
        localUuid: null == localUuid
            ? _value.localUuid
            : localUuid // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$IdentityStateImpl implements _IdentityState {
  const _$IdentityStateImpl({required this.shortCode, required this.localUuid});

  @override
  final String shortCode;
  @override
  final String localUuid;

  @override
  String toString() {
    return 'IdentityState(shortCode: $shortCode, localUuid: $localUuid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IdentityStateImpl &&
            (identical(other.shortCode, shortCode) ||
                other.shortCode == shortCode) &&
            (identical(other.localUuid, localUuid) ||
                other.localUuid == localUuid));
  }

  @override
  int get hashCode => Object.hash(runtimeType, shortCode, localUuid);

  /// Create a copy of IdentityState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IdentityStateImplCopyWith<_$IdentityStateImpl> get copyWith =>
      __$$IdentityStateImplCopyWithImpl<_$IdentityStateImpl>(this, _$identity);
}

abstract class _IdentityState implements IdentityState {
  const factory _IdentityState({
    required final String shortCode,
    required final String localUuid,
  }) = _$IdentityStateImpl;

  @override
  String get shortCode;
  @override
  String get localUuid;

  /// Create a copy of IdentityState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IdentityStateImplCopyWith<_$IdentityStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

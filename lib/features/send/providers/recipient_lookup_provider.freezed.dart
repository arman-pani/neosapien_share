// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipient_lookup_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RecipientLookupState {
  String get normalizedCode => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  String? get resolvedRecipientCode => throw _privateConstructorUsedError;

  /// Create a copy of RecipientLookupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipientLookupStateCopyWith<RecipientLookupState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipientLookupStateCopyWith<$Res> {
  factory $RecipientLookupStateCopyWith(
    RecipientLookupState value,
    $Res Function(RecipientLookupState) then,
  ) = _$RecipientLookupStateCopyWithImpl<$Res, RecipientLookupState>;
  @useResult
  $Res call({
    String normalizedCode,
    bool isLoading,
    String? errorMessage,
    String? resolvedRecipientCode,
  });
}

/// @nodoc
class _$RecipientLookupStateCopyWithImpl<
  $Res,
  $Val extends RecipientLookupState
>
    implements $RecipientLookupStateCopyWith<$Res> {
  _$RecipientLookupStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecipientLookupState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? normalizedCode = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? resolvedRecipientCode = freezed,
  }) {
    return _then(
      _value.copyWith(
            normalizedCode: null == normalizedCode
                ? _value.normalizedCode
                : normalizedCode // ignore: cast_nullable_to_non_nullable
                      as String,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            resolvedRecipientCode: freezed == resolvedRecipientCode
                ? _value.resolvedRecipientCode
                : resolvedRecipientCode // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RecipientLookupStateImplCopyWith<$Res>
    implements $RecipientLookupStateCopyWith<$Res> {
  factory _$$RecipientLookupStateImplCopyWith(
    _$RecipientLookupStateImpl value,
    $Res Function(_$RecipientLookupStateImpl) then,
  ) = __$$RecipientLookupStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String normalizedCode,
    bool isLoading,
    String? errorMessage,
    String? resolvedRecipientCode,
  });
}

/// @nodoc
class __$$RecipientLookupStateImplCopyWithImpl<$Res>
    extends _$RecipientLookupStateCopyWithImpl<$Res, _$RecipientLookupStateImpl>
    implements _$$RecipientLookupStateImplCopyWith<$Res> {
  __$$RecipientLookupStateImplCopyWithImpl(
    _$RecipientLookupStateImpl _value,
    $Res Function(_$RecipientLookupStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecipientLookupState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? normalizedCode = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? resolvedRecipientCode = freezed,
  }) {
    return _then(
      _$RecipientLookupStateImpl(
        normalizedCode: null == normalizedCode
            ? _value.normalizedCode
            : normalizedCode // ignore: cast_nullable_to_non_nullable
                  as String,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        resolvedRecipientCode: freezed == resolvedRecipientCode
            ? _value.resolvedRecipientCode
            : resolvedRecipientCode // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$RecipientLookupStateImpl implements _RecipientLookupState {
  const _$RecipientLookupStateImpl({
    required this.normalizedCode,
    required this.isLoading,
    this.errorMessage,
    this.resolvedRecipientCode,
  });

  @override
  final String normalizedCode;
  @override
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  final String? resolvedRecipientCode;

  @override
  String toString() {
    return 'RecipientLookupState(normalizedCode: $normalizedCode, isLoading: $isLoading, errorMessage: $errorMessage, resolvedRecipientCode: $resolvedRecipientCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipientLookupStateImpl &&
            (identical(other.normalizedCode, normalizedCode) ||
                other.normalizedCode == normalizedCode) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.resolvedRecipientCode, resolvedRecipientCode) ||
                other.resolvedRecipientCode == resolvedRecipientCode));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    normalizedCode,
    isLoading,
    errorMessage,
    resolvedRecipientCode,
  );

  /// Create a copy of RecipientLookupState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipientLookupStateImplCopyWith<_$RecipientLookupStateImpl>
  get copyWith =>
      __$$RecipientLookupStateImplCopyWithImpl<_$RecipientLookupStateImpl>(
        this,
        _$identity,
      );
}

abstract class _RecipientLookupState implements RecipientLookupState {
  const factory _RecipientLookupState({
    required final String normalizedCode,
    required final bool isLoading,
    final String? errorMessage,
    final String? resolvedRecipientCode,
  }) = _$RecipientLookupStateImpl;

  @override
  String get normalizedCode;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;
  @override
  String? get resolvedRecipientCode;

  /// Create a copy of RecipientLookupState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipientLookupStateImplCopyWith<_$RecipientLookupStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}

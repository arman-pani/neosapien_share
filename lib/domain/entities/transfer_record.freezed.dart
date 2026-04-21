// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TransferRecord {
  String get id => throw _privateConstructorUsedError;
  String get shortCode => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  int get sizeInBytes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of TransferRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferRecordCopyWith<TransferRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferRecordCopyWith<$Res> {
  factory $TransferRecordCopyWith(
    TransferRecord value,
    $Res Function(TransferRecord) then,
  ) = _$TransferRecordCopyWithImpl<$Res, TransferRecord>;
  @useResult
  $Res call({
    String id,
    String shortCode,
    String fileName,
    int sizeInBytes,
    DateTime createdAt,
  });
}

/// @nodoc
class _$TransferRecordCopyWithImpl<$Res, $Val extends TransferRecord>
    implements $TransferRecordCopyWith<$Res> {
  _$TransferRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shortCode = null,
    Object? fileName = null,
    Object? sizeInBytes = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            shortCode: null == shortCode
                ? _value.shortCode
                : shortCode // ignore: cast_nullable_to_non_nullable
                      as String,
            fileName: null == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                      as String,
            sizeInBytes: null == sizeInBytes
                ? _value.sizeInBytes
                : sizeInBytes // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransferRecordImplCopyWith<$Res>
    implements $TransferRecordCopyWith<$Res> {
  factory _$$TransferRecordImplCopyWith(
    _$TransferRecordImpl value,
    $Res Function(_$TransferRecordImpl) then,
  ) = __$$TransferRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String shortCode,
    String fileName,
    int sizeInBytes,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$TransferRecordImplCopyWithImpl<$Res>
    extends _$TransferRecordCopyWithImpl<$Res, _$TransferRecordImpl>
    implements _$$TransferRecordImplCopyWith<$Res> {
  __$$TransferRecordImplCopyWithImpl(
    _$TransferRecordImpl _value,
    $Res Function(_$TransferRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shortCode = null,
    Object? fileName = null,
    Object? sizeInBytes = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$TransferRecordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        shortCode: null == shortCode
            ? _value.shortCode
            : shortCode // ignore: cast_nullable_to_non_nullable
                  as String,
        fileName: null == fileName
            ? _value.fileName
            : fileName // ignore: cast_nullable_to_non_nullable
                  as String,
        sizeInBytes: null == sizeInBytes
            ? _value.sizeInBytes
            : sizeInBytes // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$TransferRecordImpl implements _TransferRecord {
  const _$TransferRecordImpl({
    required this.id,
    required this.shortCode,
    required this.fileName,
    required this.sizeInBytes,
    required this.createdAt,
  });

  @override
  final String id;
  @override
  final String shortCode;
  @override
  final String fileName;
  @override
  final int sizeInBytes;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TransferRecord(id: $id, shortCode: $shortCode, fileName: $fileName, sizeInBytes: $sizeInBytes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shortCode, shortCode) ||
                other.shortCode == shortCode) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.sizeInBytes, sizeInBytes) ||
                other.sizeInBytes == sizeInBytes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, shortCode, fileName, sizeInBytes, createdAt);

  /// Create a copy of TransferRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferRecordImplCopyWith<_$TransferRecordImpl> get copyWith =>
      __$$TransferRecordImplCopyWithImpl<_$TransferRecordImpl>(
        this,
        _$identity,
      );
}

abstract class _TransferRecord implements TransferRecord {
  const factory _TransferRecord({
    required final String id,
    required final String shortCode,
    required final String fileName,
    required final int sizeInBytes,
    required final DateTime createdAt,
  }) = _$TransferRecordImpl;

  @override
  String get id;
  @override
  String get shortCode;
  @override
  String get fileName;
  @override
  int get sizeInBytes;
  @override
  DateTime get createdAt;

  /// Create a copy of TransferRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferRecordImplCopyWith<_$TransferRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

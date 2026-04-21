// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_transfer_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RemoteTransferRecord {
  String get id => throw _privateConstructorUsedError;
  String get shortCode => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  int get sizeInBytes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of RemoteTransferRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RemoteTransferRecordCopyWith<RemoteTransferRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoteTransferRecordCopyWith<$Res> {
  factory $RemoteTransferRecordCopyWith(
    RemoteTransferRecord value,
    $Res Function(RemoteTransferRecord) then,
  ) = _$RemoteTransferRecordCopyWithImpl<$Res, RemoteTransferRecord>;
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
class _$RemoteTransferRecordCopyWithImpl<
  $Res,
  $Val extends RemoteTransferRecord
>
    implements $RemoteTransferRecordCopyWith<$Res> {
  _$RemoteTransferRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RemoteTransferRecord
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
abstract class _$$RemoteTransferRecordImplCopyWith<$Res>
    implements $RemoteTransferRecordCopyWith<$Res> {
  factory _$$RemoteTransferRecordImplCopyWith(
    _$RemoteTransferRecordImpl value,
    $Res Function(_$RemoteTransferRecordImpl) then,
  ) = __$$RemoteTransferRecordImplCopyWithImpl<$Res>;
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
class __$$RemoteTransferRecordImplCopyWithImpl<$Res>
    extends _$RemoteTransferRecordCopyWithImpl<$Res, _$RemoteTransferRecordImpl>
    implements _$$RemoteTransferRecordImplCopyWith<$Res> {
  __$$RemoteTransferRecordImplCopyWithImpl(
    _$RemoteTransferRecordImpl _value,
    $Res Function(_$RemoteTransferRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RemoteTransferRecord
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
      _$RemoteTransferRecordImpl(
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

class _$RemoteTransferRecordImpl extends _RemoteTransferRecord {
  const _$RemoteTransferRecordImpl({
    required this.id,
    required this.shortCode,
    required this.fileName,
    required this.sizeInBytes,
    required this.createdAt,
  }) : super._();

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
    return 'RemoteTransferRecord(id: $id, shortCode: $shortCode, fileName: $fileName, sizeInBytes: $sizeInBytes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoteTransferRecordImpl &&
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

  /// Create a copy of RemoteTransferRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoteTransferRecordImplCopyWith<_$RemoteTransferRecordImpl>
  get copyWith =>
      __$$RemoteTransferRecordImplCopyWithImpl<_$RemoteTransferRecordImpl>(
        this,
        _$identity,
      );
}

abstract class _RemoteTransferRecord extends RemoteTransferRecord {
  const factory _RemoteTransferRecord({
    required final String id,
    required final String shortCode,
    required final String fileName,
    required final int sizeInBytes,
    required final DateTime createdAt,
  }) = _$RemoteTransferRecordImpl;
  const _RemoteTransferRecord._() : super._();

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

  /// Create a copy of RemoteTransferRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemoteTransferRecordImplCopyWith<_$RemoteTransferRecordImpl>
  get copyWith => throw _privateConstructorUsedError;
}

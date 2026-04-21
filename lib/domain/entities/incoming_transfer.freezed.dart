// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incoming_transfer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TransferFile {
  String get fileId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  String get storageUrl => throw _privateConstructorUsedError;
  String get sha256 => throw _privateConstructorUsedError;

  /// Create a copy of TransferFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferFileCopyWith<TransferFile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferFileCopyWith<$Res> {
  factory $TransferFileCopyWith(
    TransferFile value,
    $Res Function(TransferFile) then,
  ) = _$TransferFileCopyWithImpl<$Res, TransferFile>;
  @useResult
  $Res call({
    String fileId,
    String name,
    int size,
    String mimeType,
    String storageUrl,
    String sha256,
  });
}

/// @nodoc
class _$TransferFileCopyWithImpl<$Res, $Val extends TransferFile>
    implements $TransferFileCopyWith<$Res> {
  _$TransferFileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileId = null,
    Object? name = null,
    Object? size = null,
    Object? mimeType = null,
    Object? storageUrl = null,
    Object? sha256 = null,
  }) {
    return _then(
      _value.copyWith(
            fileId: null == fileId
                ? _value.fileId
                : fileId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int,
            mimeType: null == mimeType
                ? _value.mimeType
                : mimeType // ignore: cast_nullable_to_non_nullable
                      as String,
            storageUrl: null == storageUrl
                ? _value.storageUrl
                : storageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            sha256: null == sha256
                ? _value.sha256
                : sha256 // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TransferFileImplCopyWith<$Res>
    implements $TransferFileCopyWith<$Res> {
  factory _$$TransferFileImplCopyWith(
    _$TransferFileImpl value,
    $Res Function(_$TransferFileImpl) then,
  ) = __$$TransferFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String fileId,
    String name,
    int size,
    String mimeType,
    String storageUrl,
    String sha256,
  });
}

/// @nodoc
class __$$TransferFileImplCopyWithImpl<$Res>
    extends _$TransferFileCopyWithImpl<$Res, _$TransferFileImpl>
    implements _$$TransferFileImplCopyWith<$Res> {
  __$$TransferFileImplCopyWithImpl(
    _$TransferFileImpl _value,
    $Res Function(_$TransferFileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TransferFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileId = null,
    Object? name = null,
    Object? size = null,
    Object? mimeType = null,
    Object? storageUrl = null,
    Object? sha256 = null,
  }) {
    return _then(
      _$TransferFileImpl(
        fileId: null == fileId
            ? _value.fileId
            : fileId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int,
        mimeType: null == mimeType
            ? _value.mimeType
            : mimeType // ignore: cast_nullable_to_non_nullable
                  as String,
        storageUrl: null == storageUrl
            ? _value.storageUrl
            : storageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        sha256: null == sha256
            ? _value.sha256
            : sha256 // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$TransferFileImpl implements _TransferFile {
  const _$TransferFileImpl({
    required this.fileId,
    required this.name,
    required this.size,
    required this.mimeType,
    required this.storageUrl,
    required this.sha256,
  });

  @override
  final String fileId;
  @override
  final String name;
  @override
  final int size;
  @override
  final String mimeType;
  @override
  final String storageUrl;
  @override
  final String sha256;

  @override
  String toString() {
    return 'TransferFile(fileId: $fileId, name: $name, size: $size, mimeType: $mimeType, storageUrl: $storageUrl, sha256: $sha256)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferFileImpl &&
            (identical(other.fileId, fileId) || other.fileId == fileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.storageUrl, storageUrl) ||
                other.storageUrl == storageUrl) &&
            (identical(other.sha256, sha256) || other.sha256 == sha256));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    fileId,
    name,
    size,
    mimeType,
    storageUrl,
    sha256,
  );

  /// Create a copy of TransferFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferFileImplCopyWith<_$TransferFileImpl> get copyWith =>
      __$$TransferFileImplCopyWithImpl<_$TransferFileImpl>(this, _$identity);
}

abstract class _TransferFile implements TransferFile {
  const factory _TransferFile({
    required final String fileId,
    required final String name,
    required final int size,
    required final String mimeType,
    required final String storageUrl,
    required final String sha256,
  }) = _$TransferFileImpl;

  @override
  String get fileId;
  @override
  String get name;
  @override
  int get size;
  @override
  String get mimeType;
  @override
  String get storageUrl;
  @override
  String get sha256;

  /// Create a copy of TransferFile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferFileImplCopyWith<_$TransferFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$IncomingTransfer {
  String get transferId => throw _privateConstructorUsedError;
  String get senderCode => throw _privateConstructorUsedError;
  String get recipientCode => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;
  List<TransferFile> get files => throw _privateConstructorUsedError;

  /// Create a copy of IncomingTransfer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IncomingTransferCopyWith<IncomingTransfer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomingTransferCopyWith<$Res> {
  factory $IncomingTransferCopyWith(
    IncomingTransfer value,
    $Res Function(IncomingTransfer) then,
  ) = _$IncomingTransferCopyWithImpl<$Res, IncomingTransfer>;
  @useResult
  $Res call({
    String transferId,
    String senderCode,
    String recipientCode,
    String status,
    DateTime createdAt,
    DateTime expiresAt,
    List<TransferFile> files,
  });
}

/// @nodoc
class _$IncomingTransferCopyWithImpl<$Res, $Val extends IncomingTransfer>
    implements $IncomingTransferCopyWith<$Res> {
  _$IncomingTransferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IncomingTransfer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferId = null,
    Object? senderCode = null,
    Object? recipientCode = null,
    Object? status = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? files = null,
  }) {
    return _then(
      _value.copyWith(
            transferId: null == transferId
                ? _value.transferId
                : transferId // ignore: cast_nullable_to_non_nullable
                      as String,
            senderCode: null == senderCode
                ? _value.senderCode
                : senderCode // ignore: cast_nullable_to_non_nullable
                      as String,
            recipientCode: null == recipientCode
                ? _value.recipientCode
                : recipientCode // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            expiresAt: null == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            files: null == files
                ? _value.files
                : files // ignore: cast_nullable_to_non_nullable
                      as List<TransferFile>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$IncomingTransferImplCopyWith<$Res>
    implements $IncomingTransferCopyWith<$Res> {
  factory _$$IncomingTransferImplCopyWith(
    _$IncomingTransferImpl value,
    $Res Function(_$IncomingTransferImpl) then,
  ) = __$$IncomingTransferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String transferId,
    String senderCode,
    String recipientCode,
    String status,
    DateTime createdAt,
    DateTime expiresAt,
    List<TransferFile> files,
  });
}

/// @nodoc
class __$$IncomingTransferImplCopyWithImpl<$Res>
    extends _$IncomingTransferCopyWithImpl<$Res, _$IncomingTransferImpl>
    implements _$$IncomingTransferImplCopyWith<$Res> {
  __$$IncomingTransferImplCopyWithImpl(
    _$IncomingTransferImpl _value,
    $Res Function(_$IncomingTransferImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of IncomingTransfer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferId = null,
    Object? senderCode = null,
    Object? recipientCode = null,
    Object? status = null,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? files = null,
  }) {
    return _then(
      _$IncomingTransferImpl(
        transferId: null == transferId
            ? _value.transferId
            : transferId // ignore: cast_nullable_to_non_nullable
                  as String,
        senderCode: null == senderCode
            ? _value.senderCode
            : senderCode // ignore: cast_nullable_to_non_nullable
                  as String,
        recipientCode: null == recipientCode
            ? _value.recipientCode
            : recipientCode // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expiresAt: null == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        files: null == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<TransferFile>,
      ),
    );
  }
}

/// @nodoc

class _$IncomingTransferImpl implements _IncomingTransfer {
  const _$IncomingTransferImpl({
    required this.transferId,
    required this.senderCode,
    required this.recipientCode,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    required final List<TransferFile> files,
  }) : _files = files;

  @override
  final String transferId;
  @override
  final String senderCode;
  @override
  final String recipientCode;
  @override
  final String status;
  @override
  final DateTime createdAt;
  @override
  final DateTime expiresAt;
  final List<TransferFile> _files;
  @override
  List<TransferFile> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  String toString() {
    return 'IncomingTransfer(transferId: $transferId, senderCode: $senderCode, recipientCode: $recipientCode, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, files: $files)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomingTransferImpl &&
            (identical(other.transferId, transferId) ||
                other.transferId == transferId) &&
            (identical(other.senderCode, senderCode) ||
                other.senderCode == senderCode) &&
            (identical(other.recipientCode, recipientCode) ||
                other.recipientCode == recipientCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality().equals(other._files, _files));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    transferId,
    senderCode,
    recipientCode,
    status,
    createdAt,
    expiresAt,
    const DeepCollectionEquality().hash(_files),
  );

  /// Create a copy of IncomingTransfer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IncomingTransferImplCopyWith<_$IncomingTransferImpl> get copyWith =>
      __$$IncomingTransferImplCopyWithImpl<_$IncomingTransferImpl>(
        this,
        _$identity,
      );
}

abstract class _IncomingTransfer implements IncomingTransfer {
  const factory _IncomingTransfer({
    required final String transferId,
    required final String senderCode,
    required final String recipientCode,
    required final String status,
    required final DateTime createdAt,
    required final DateTime expiresAt,
    required final List<TransferFile> files,
  }) = _$IncomingTransferImpl;

  @override
  String get transferId;
  @override
  String get senderCode;
  @override
  String get recipientCode;
  @override
  String get status;
  @override
  DateTime get createdAt;
  @override
  DateTime get expiresAt;
  @override
  List<TransferFile> get files;

  /// Create a copy of IncomingTransfer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IncomingTransferImplCopyWith<_$IncomingTransferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

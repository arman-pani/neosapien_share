// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_upload_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SendUploadState {
  SendPhase get phase => throw _privateConstructorUsedError;
  String get transferId => throw _privateConstructorUsedError;
  String get recipientCode => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  List<TransferUploadFile> get files => throw _privateConstructorUsedError;
  Map<String, FileUploadProgress> get fileProgress =>
      throw _privateConstructorUsedError;
  double get aggregateProgress => throw _privateConstructorUsedError;
  bool get isCancelling => throw _privateConstructorUsedError;
  TransferDeliveryStatus get deliveryStatus =>
      throw _privateConstructorUsedError;

  /// Create a copy of SendUploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SendUploadStateCopyWith<SendUploadState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SendUploadStateCopyWith<$Res> {
  factory $SendUploadStateCopyWith(
    SendUploadState value,
    $Res Function(SendUploadState) then,
  ) = _$SendUploadStateCopyWithImpl<$Res, SendUploadState>;
  @useResult
  $Res call({
    SendPhase phase,
    String transferId,
    String recipientCode,
    String senderId,
    List<TransferUploadFile> files,
    Map<String, FileUploadProgress> fileProgress,
    double aggregateProgress,
    bool isCancelling,
    TransferDeliveryStatus deliveryStatus,
  });
}

/// @nodoc
class _$SendUploadStateCopyWithImpl<$Res, $Val extends SendUploadState>
    implements $SendUploadStateCopyWith<$Res> {
  _$SendUploadStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SendUploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phase = null,
    Object? transferId = null,
    Object? recipientCode = null,
    Object? senderId = null,
    Object? files = null,
    Object? fileProgress = null,
    Object? aggregateProgress = null,
    Object? isCancelling = null,
    Object? deliveryStatus = null,
  }) {
    return _then(
      _value.copyWith(
            phase: null == phase
                ? _value.phase
                : phase // ignore: cast_nullable_to_non_nullable
                      as SendPhase,
            transferId: null == transferId
                ? _value.transferId
                : transferId // ignore: cast_nullable_to_non_nullable
                      as String,
            recipientCode: null == recipientCode
                ? _value.recipientCode
                : recipientCode // ignore: cast_nullable_to_non_nullable
                      as String,
            senderId: null == senderId
                ? _value.senderId
                : senderId // ignore: cast_nullable_to_non_nullable
                      as String,
            files: null == files
                ? _value.files
                : files // ignore: cast_nullable_to_non_nullable
                      as List<TransferUploadFile>,
            fileProgress: null == fileProgress
                ? _value.fileProgress
                : fileProgress // ignore: cast_nullable_to_non_nullable
                      as Map<String, FileUploadProgress>,
            aggregateProgress: null == aggregateProgress
                ? _value.aggregateProgress
                : aggregateProgress // ignore: cast_nullable_to_non_nullable
                      as double,
            isCancelling: null == isCancelling
                ? _value.isCancelling
                : isCancelling // ignore: cast_nullable_to_non_nullable
                      as bool,
            deliveryStatus: null == deliveryStatus
                ? _value.deliveryStatus
                : deliveryStatus // ignore: cast_nullable_to_non_nullable
                      as TransferDeliveryStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SendUploadStateImplCopyWith<$Res>
    implements $SendUploadStateCopyWith<$Res> {
  factory _$$SendUploadStateImplCopyWith(
    _$SendUploadStateImpl value,
    $Res Function(_$SendUploadStateImpl) then,
  ) = __$$SendUploadStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    SendPhase phase,
    String transferId,
    String recipientCode,
    String senderId,
    List<TransferUploadFile> files,
    Map<String, FileUploadProgress> fileProgress,
    double aggregateProgress,
    bool isCancelling,
    TransferDeliveryStatus deliveryStatus,
  });
}

/// @nodoc
class __$$SendUploadStateImplCopyWithImpl<$Res>
    extends _$SendUploadStateCopyWithImpl<$Res, _$SendUploadStateImpl>
    implements _$$SendUploadStateImplCopyWith<$Res> {
  __$$SendUploadStateImplCopyWithImpl(
    _$SendUploadStateImpl _value,
    $Res Function(_$SendUploadStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SendUploadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phase = null,
    Object? transferId = null,
    Object? recipientCode = null,
    Object? senderId = null,
    Object? files = null,
    Object? fileProgress = null,
    Object? aggregateProgress = null,
    Object? isCancelling = null,
    Object? deliveryStatus = null,
  }) {
    return _then(
      _$SendUploadStateImpl(
        phase: null == phase
            ? _value.phase
            : phase // ignore: cast_nullable_to_non_nullable
                  as SendPhase,
        transferId: null == transferId
            ? _value.transferId
            : transferId // ignore: cast_nullable_to_non_nullable
                  as String,
        recipientCode: null == recipientCode
            ? _value.recipientCode
            : recipientCode // ignore: cast_nullable_to_non_nullable
                  as String,
        senderId: null == senderId
            ? _value.senderId
            : senderId // ignore: cast_nullable_to_non_nullable
                  as String,
        files: null == files
            ? _value._files
            : files // ignore: cast_nullable_to_non_nullable
                  as List<TransferUploadFile>,
        fileProgress: null == fileProgress
            ? _value._fileProgress
            : fileProgress // ignore: cast_nullable_to_non_nullable
                  as Map<String, FileUploadProgress>,
        aggregateProgress: null == aggregateProgress
            ? _value.aggregateProgress
            : aggregateProgress // ignore: cast_nullable_to_non_nullable
                  as double,
        isCancelling: null == isCancelling
            ? _value.isCancelling
            : isCancelling // ignore: cast_nullable_to_non_nullable
                  as bool,
        deliveryStatus: null == deliveryStatus
            ? _value.deliveryStatus
            : deliveryStatus // ignore: cast_nullable_to_non_nullable
                  as TransferDeliveryStatus,
      ),
    );
  }
}

/// @nodoc

class _$SendUploadStateImpl extends _SendUploadState {
  const _$SendUploadStateImpl({
    this.phase = SendPhase.idle,
    this.transferId = '',
    this.recipientCode = '',
    this.senderId = '',
    final List<TransferUploadFile> files = const [],
    final Map<String, FileUploadProgress> fileProgress = const {},
    this.aggregateProgress = 0,
    this.isCancelling = false,
    this.deliveryStatus = TransferDeliveryStatus.unknown,
  }) : _files = files,
       _fileProgress = fileProgress,
       super._();

  @override
  @JsonKey()
  final SendPhase phase;
  @override
  @JsonKey()
  final String transferId;
  @override
  @JsonKey()
  final String recipientCode;
  @override
  @JsonKey()
  final String senderId;
  final List<TransferUploadFile> _files;
  @override
  @JsonKey()
  List<TransferUploadFile> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  final Map<String, FileUploadProgress> _fileProgress;
  @override
  @JsonKey()
  Map<String, FileUploadProgress> get fileProgress {
    if (_fileProgress is EqualUnmodifiableMapView) return _fileProgress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fileProgress);
  }

  @override
  @JsonKey()
  final double aggregateProgress;
  @override
  @JsonKey()
  final bool isCancelling;
  @override
  @JsonKey()
  final TransferDeliveryStatus deliveryStatus;

  @override
  String toString() {
    return 'SendUploadState(phase: $phase, transferId: $transferId, recipientCode: $recipientCode, senderId: $senderId, files: $files, fileProgress: $fileProgress, aggregateProgress: $aggregateProgress, isCancelling: $isCancelling, deliveryStatus: $deliveryStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SendUploadStateImpl &&
            (identical(other.phase, phase) || other.phase == phase) &&
            (identical(other.transferId, transferId) ||
                other.transferId == transferId) &&
            (identical(other.recipientCode, recipientCode) ||
                other.recipientCode == recipientCode) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            const DeepCollectionEquality().equals(other._files, _files) &&
            const DeepCollectionEquality().equals(
              other._fileProgress,
              _fileProgress,
            ) &&
            (identical(other.aggregateProgress, aggregateProgress) ||
                other.aggregateProgress == aggregateProgress) &&
            (identical(other.isCancelling, isCancelling) ||
                other.isCancelling == isCancelling) &&
            (identical(other.deliveryStatus, deliveryStatus) ||
                other.deliveryStatus == deliveryStatus));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    phase,
    transferId,
    recipientCode,
    senderId,
    const DeepCollectionEquality().hash(_files),
    const DeepCollectionEquality().hash(_fileProgress),
    aggregateProgress,
    isCancelling,
    deliveryStatus,
  );

  /// Create a copy of SendUploadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SendUploadStateImplCopyWith<_$SendUploadStateImpl> get copyWith =>
      __$$SendUploadStateImplCopyWithImpl<_$SendUploadStateImpl>(
        this,
        _$identity,
      );
}

abstract class _SendUploadState extends SendUploadState {
  const factory _SendUploadState({
    final SendPhase phase,
    final String transferId,
    final String recipientCode,
    final String senderId,
    final List<TransferUploadFile> files,
    final Map<String, FileUploadProgress> fileProgress,
    final double aggregateProgress,
    final bool isCancelling,
    final TransferDeliveryStatus deliveryStatus,
  }) = _$SendUploadStateImpl;
  const _SendUploadState._() : super._();

  @override
  SendPhase get phase;
  @override
  String get transferId;
  @override
  String get recipientCode;
  @override
  String get senderId;
  @override
  List<TransferUploadFile> get files;
  @override
  Map<String, FileUploadProgress> get fileProgress;
  @override
  double get aggregateProgress;
  @override
  bool get isCancelling;
  @override
  TransferDeliveryStatus get deliveryStatus;

  /// Create a copy of SendUploadState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SendUploadStateImplCopyWith<_$SendUploadStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receive_download_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ReceiveDownloadState {
  ReceiveDownloadStatus get status => throw _privateConstructorUsedError;
  IncomingTransfer? get transfer => throw _privateConstructorUsedError;
  Map<String, double> get perFileProgress => throw _privateConstructorUsedError;
  Map<String, FileDownloadStatus> get perFileStatus =>
      throw _privateConstructorUsedError;
  double get aggregateProgress => throw _privateConstructorUsedError;
  List<String> get corruptFiles => throw _privateConstructorUsedError;
  Map<String, String> get filePaths => throw _privateConstructorUsedError;

  /// Create a copy of ReceiveDownloadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceiveDownloadStateCopyWith<ReceiveDownloadState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiveDownloadStateCopyWith<$Res> {
  factory $ReceiveDownloadStateCopyWith(
    ReceiveDownloadState value,
    $Res Function(ReceiveDownloadState) then,
  ) = _$ReceiveDownloadStateCopyWithImpl<$Res, ReceiveDownloadState>;
  @useResult
  $Res call({
    ReceiveDownloadStatus status,
    IncomingTransfer? transfer,
    Map<String, double> perFileProgress,
    Map<String, FileDownloadStatus> perFileStatus,
    double aggregateProgress,
    List<String> corruptFiles,
    Map<String, String> filePaths,
  });

  $IncomingTransferCopyWith<$Res>? get transfer;
}

/// @nodoc
class _$ReceiveDownloadStateCopyWithImpl<
  $Res,
  $Val extends ReceiveDownloadState
>
    implements $ReceiveDownloadStateCopyWith<$Res> {
  _$ReceiveDownloadStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReceiveDownloadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? transfer = freezed,
    Object? perFileProgress = null,
    Object? perFileStatus = null,
    Object? aggregateProgress = null,
    Object? corruptFiles = null,
    Object? filePaths = null,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ReceiveDownloadStatus,
            transfer: freezed == transfer
                ? _value.transfer
                : transfer // ignore: cast_nullable_to_non_nullable
                      as IncomingTransfer?,
            perFileProgress: null == perFileProgress
                ? _value.perFileProgress
                : perFileProgress // ignore: cast_nullable_to_non_nullable
                      as Map<String, double>,
            perFileStatus: null == perFileStatus
                ? _value.perFileStatus
                : perFileStatus // ignore: cast_nullable_to_non_nullable
                      as Map<String, FileDownloadStatus>,
            aggregateProgress: null == aggregateProgress
                ? _value.aggregateProgress
                : aggregateProgress // ignore: cast_nullable_to_non_nullable
                      as double,
            corruptFiles: null == corruptFiles
                ? _value.corruptFiles
                : corruptFiles // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            filePaths: null == filePaths
                ? _value.filePaths
                : filePaths // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }

  /// Create a copy of ReceiveDownloadState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IncomingTransferCopyWith<$Res>? get transfer {
    if (_value.transfer == null) {
      return null;
    }

    return $IncomingTransferCopyWith<$Res>(_value.transfer!, (value) {
      return _then(_value.copyWith(transfer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReceiveDownloadStateImplCopyWith<$Res>
    implements $ReceiveDownloadStateCopyWith<$Res> {
  factory _$$ReceiveDownloadStateImplCopyWith(
    _$ReceiveDownloadStateImpl value,
    $Res Function(_$ReceiveDownloadStateImpl) then,
  ) = __$$ReceiveDownloadStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    ReceiveDownloadStatus status,
    IncomingTransfer? transfer,
    Map<String, double> perFileProgress,
    Map<String, FileDownloadStatus> perFileStatus,
    double aggregateProgress,
    List<String> corruptFiles,
    Map<String, String> filePaths,
  });

  @override
  $IncomingTransferCopyWith<$Res>? get transfer;
}

/// @nodoc
class __$$ReceiveDownloadStateImplCopyWithImpl<$Res>
    extends _$ReceiveDownloadStateCopyWithImpl<$Res, _$ReceiveDownloadStateImpl>
    implements _$$ReceiveDownloadStateImplCopyWith<$Res> {
  __$$ReceiveDownloadStateImplCopyWithImpl(
    _$ReceiveDownloadStateImpl _value,
    $Res Function(_$ReceiveDownloadStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReceiveDownloadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? transfer = freezed,
    Object? perFileProgress = null,
    Object? perFileStatus = null,
    Object? aggregateProgress = null,
    Object? corruptFiles = null,
    Object? filePaths = null,
  }) {
    return _then(
      _$ReceiveDownloadStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ReceiveDownloadStatus,
        transfer: freezed == transfer
            ? _value.transfer
            : transfer // ignore: cast_nullable_to_non_nullable
                  as IncomingTransfer?,
        perFileProgress: null == perFileProgress
            ? _value._perFileProgress
            : perFileProgress // ignore: cast_nullable_to_non_nullable
                  as Map<String, double>,
        perFileStatus: null == perFileStatus
            ? _value._perFileStatus
            : perFileStatus // ignore: cast_nullable_to_non_nullable
                  as Map<String, FileDownloadStatus>,
        aggregateProgress: null == aggregateProgress
            ? _value.aggregateProgress
            : aggregateProgress // ignore: cast_nullable_to_non_nullable
                  as double,
        corruptFiles: null == corruptFiles
            ? _value._corruptFiles
            : corruptFiles // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        filePaths: null == filePaths
            ? _value._filePaths
            : filePaths // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc

class _$ReceiveDownloadStateImpl extends _ReceiveDownloadState {
  const _$ReceiveDownloadStateImpl({
    this.status = ReceiveDownloadStatus.idle,
    this.transfer,
    final Map<String, double> perFileProgress = const {},
    final Map<String, FileDownloadStatus> perFileStatus = const {},
    this.aggregateProgress = 0,
    final List<String> corruptFiles = const [],
    final Map<String, String> filePaths = const {},
  }) : _perFileProgress = perFileProgress,
       _perFileStatus = perFileStatus,
       _corruptFiles = corruptFiles,
       _filePaths = filePaths,
       super._();

  @override
  @JsonKey()
  final ReceiveDownloadStatus status;
  @override
  final IncomingTransfer? transfer;
  final Map<String, double> _perFileProgress;
  @override
  @JsonKey()
  Map<String, double> get perFileProgress {
    if (_perFileProgress is EqualUnmodifiableMapView) return _perFileProgress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_perFileProgress);
  }

  final Map<String, FileDownloadStatus> _perFileStatus;
  @override
  @JsonKey()
  Map<String, FileDownloadStatus> get perFileStatus {
    if (_perFileStatus is EqualUnmodifiableMapView) return _perFileStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_perFileStatus);
  }

  @override
  @JsonKey()
  final double aggregateProgress;
  final List<String> _corruptFiles;
  @override
  @JsonKey()
  List<String> get corruptFiles {
    if (_corruptFiles is EqualUnmodifiableListView) return _corruptFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_corruptFiles);
  }

  final Map<String, String> _filePaths;
  @override
  @JsonKey()
  Map<String, String> get filePaths {
    if (_filePaths is EqualUnmodifiableMapView) return _filePaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_filePaths);
  }

  @override
  String toString() {
    return 'ReceiveDownloadState(status: $status, transfer: $transfer, perFileProgress: $perFileProgress, perFileStatus: $perFileStatus, aggregateProgress: $aggregateProgress, corruptFiles: $corruptFiles, filePaths: $filePaths)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiveDownloadStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.transfer, transfer) ||
                other.transfer == transfer) &&
            const DeepCollectionEquality().equals(
              other._perFileProgress,
              _perFileProgress,
            ) &&
            const DeepCollectionEquality().equals(
              other._perFileStatus,
              _perFileStatus,
            ) &&
            (identical(other.aggregateProgress, aggregateProgress) ||
                other.aggregateProgress == aggregateProgress) &&
            const DeepCollectionEquality().equals(
              other._corruptFiles,
              _corruptFiles,
            ) &&
            const DeepCollectionEquality().equals(
              other._filePaths,
              _filePaths,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    transfer,
    const DeepCollectionEquality().hash(_perFileProgress),
    const DeepCollectionEquality().hash(_perFileStatus),
    aggregateProgress,
    const DeepCollectionEquality().hash(_corruptFiles),
    const DeepCollectionEquality().hash(_filePaths),
  );

  /// Create a copy of ReceiveDownloadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiveDownloadStateImplCopyWith<_$ReceiveDownloadStateImpl>
  get copyWith =>
      __$$ReceiveDownloadStateImplCopyWithImpl<_$ReceiveDownloadStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ReceiveDownloadState extends ReceiveDownloadState {
  const factory _ReceiveDownloadState({
    final ReceiveDownloadStatus status,
    final IncomingTransfer? transfer,
    final Map<String, double> perFileProgress,
    final Map<String, FileDownloadStatus> perFileStatus,
    final double aggregateProgress,
    final List<String> corruptFiles,
    final Map<String, String> filePaths,
  }) = _$ReceiveDownloadStateImpl;
  const _ReceiveDownloadState._() : super._();

  @override
  ReceiveDownloadStatus get status;
  @override
  IncomingTransfer? get transfer;
  @override
  Map<String, double> get perFileProgress;
  @override
  Map<String, FileDownloadStatus> get perFileStatus;
  @override
  double get aggregateProgress;
  @override
  List<String> get corruptFiles;
  @override
  Map<String, String> get filePaths;

  /// Create a copy of ReceiveDownloadState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiveDownloadStateImplCopyWith<_$ReceiveDownloadStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}

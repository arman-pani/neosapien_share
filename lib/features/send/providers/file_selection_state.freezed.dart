// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_selection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SelectedSendFile {
  String get name => throw _privateConstructorUsedError;
  String? get path => throw _privateConstructorUsedError;
  int get sizeInBytes => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  bool get isZeroByte => throw _privateConstructorUsedError;

  /// Create a copy of SelectedSendFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectedSendFileCopyWith<SelectedSendFile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectedSendFileCopyWith<$Res> {
  factory $SelectedSendFileCopyWith(
    SelectedSendFile value,
    $Res Function(SelectedSendFile) then,
  ) = _$SelectedSendFileCopyWithImpl<$Res, SelectedSendFile>;
  @useResult
  $Res call({
    String name,
    String? path,
    int sizeInBytes,
    String mimeType,
    bool isZeroByte,
  });
}

/// @nodoc
class _$SelectedSendFileCopyWithImpl<$Res, $Val extends SelectedSendFile>
    implements $SelectedSendFileCopyWith<$Res> {
  _$SelectedSendFileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectedSendFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = freezed,
    Object? sizeInBytes = null,
    Object? mimeType = null,
    Object? isZeroByte = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            path: freezed == path
                ? _value.path
                : path // ignore: cast_nullable_to_non_nullable
                      as String?,
            sizeInBytes: null == sizeInBytes
                ? _value.sizeInBytes
                : sizeInBytes // ignore: cast_nullable_to_non_nullable
                      as int,
            mimeType: null == mimeType
                ? _value.mimeType
                : mimeType // ignore: cast_nullable_to_non_nullable
                      as String,
            isZeroByte: null == isZeroByte
                ? _value.isZeroByte
                : isZeroByte // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SelectedSendFileImplCopyWith<$Res>
    implements $SelectedSendFileCopyWith<$Res> {
  factory _$$SelectedSendFileImplCopyWith(
    _$SelectedSendFileImpl value,
    $Res Function(_$SelectedSendFileImpl) then,
  ) = __$$SelectedSendFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String? path,
    int sizeInBytes,
    String mimeType,
    bool isZeroByte,
  });
}

/// @nodoc
class __$$SelectedSendFileImplCopyWithImpl<$Res>
    extends _$SelectedSendFileCopyWithImpl<$Res, _$SelectedSendFileImpl>
    implements _$$SelectedSendFileImplCopyWith<$Res> {
  __$$SelectedSendFileImplCopyWithImpl(
    _$SelectedSendFileImpl _value,
    $Res Function(_$SelectedSendFileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SelectedSendFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? path = freezed,
    Object? sizeInBytes = null,
    Object? mimeType = null,
    Object? isZeroByte = null,
  }) {
    return _then(
      _$SelectedSendFileImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        path: freezed == path
            ? _value.path
            : path // ignore: cast_nullable_to_non_nullable
                  as String?,
        sizeInBytes: null == sizeInBytes
            ? _value.sizeInBytes
            : sizeInBytes // ignore: cast_nullable_to_non_nullable
                  as int,
        mimeType: null == mimeType
            ? _value.mimeType
            : mimeType // ignore: cast_nullable_to_non_nullable
                  as String,
        isZeroByte: null == isZeroByte
            ? _value.isZeroByte
            : isZeroByte // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SelectedSendFileImpl implements _SelectedSendFile {
  const _$SelectedSendFileImpl({
    required this.name,
    required this.path,
    required this.sizeInBytes,
    required this.mimeType,
    required this.isZeroByte,
  });

  @override
  final String name;
  @override
  final String? path;
  @override
  final int sizeInBytes;
  @override
  final String mimeType;
  @override
  final bool isZeroByte;

  @override
  String toString() {
    return 'SelectedSendFile(name: $name, path: $path, sizeInBytes: $sizeInBytes, mimeType: $mimeType, isZeroByte: $isZeroByte)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectedSendFileImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.sizeInBytes, sizeInBytes) ||
                other.sizeInBytes == sizeInBytes) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.isZeroByte, isZeroByte) ||
                other.isZeroByte == isZeroByte));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, name, path, sizeInBytes, mimeType, isZeroByte);

  /// Create a copy of SelectedSendFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectedSendFileImplCopyWith<_$SelectedSendFileImpl> get copyWith =>
      __$$SelectedSendFileImplCopyWithImpl<_$SelectedSendFileImpl>(
        this,
        _$identity,
      );
}

abstract class _SelectedSendFile implements SelectedSendFile {
  const factory _SelectedSendFile({
    required final String name,
    required final String? path,
    required final int sizeInBytes,
    required final String mimeType,
    required final bool isZeroByte,
  }) = _$SelectedSendFileImpl;

  @override
  String get name;
  @override
  String? get path;
  @override
  int get sizeInBytes;
  @override
  String get mimeType;
  @override
  bool get isZeroByte;

  /// Create a copy of SelectedSendFile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectedSendFileImplCopyWith<_$SelectedSendFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FileSelectionMessage {
  String get fileName => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  bool get isWarning => throw _privateConstructorUsedError;

  /// Create a copy of FileSelectionMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileSelectionMessageCopyWith<FileSelectionMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileSelectionMessageCopyWith<$Res> {
  factory $FileSelectionMessageCopyWith(
    FileSelectionMessage value,
    $Res Function(FileSelectionMessage) then,
  ) = _$FileSelectionMessageCopyWithImpl<$Res, FileSelectionMessage>;
  @useResult
  $Res call({String fileName, String message, bool isWarning});
}

/// @nodoc
class _$FileSelectionMessageCopyWithImpl<
  $Res,
  $Val extends FileSelectionMessage
>
    implements $FileSelectionMessageCopyWith<$Res> {
  _$FileSelectionMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileSelectionMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? message = null,
    Object? isWarning = null,
  }) {
    return _then(
      _value.copyWith(
            fileName: null == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            isWarning: null == isWarning
                ? _value.isWarning
                : isWarning // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FileSelectionMessageImplCopyWith<$Res>
    implements $FileSelectionMessageCopyWith<$Res> {
  factory _$$FileSelectionMessageImplCopyWith(
    _$FileSelectionMessageImpl value,
    $Res Function(_$FileSelectionMessageImpl) then,
  ) = __$$FileSelectionMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String fileName, String message, bool isWarning});
}

/// @nodoc
class __$$FileSelectionMessageImplCopyWithImpl<$Res>
    extends _$FileSelectionMessageCopyWithImpl<$Res, _$FileSelectionMessageImpl>
    implements _$$FileSelectionMessageImplCopyWith<$Res> {
  __$$FileSelectionMessageImplCopyWithImpl(
    _$FileSelectionMessageImpl _value,
    $Res Function(_$FileSelectionMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileSelectionMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileName = null,
    Object? message = null,
    Object? isWarning = null,
  }) {
    return _then(
      _$FileSelectionMessageImpl(
        fileName: null == fileName
            ? _value.fileName
            : fileName // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        isWarning: null == isWarning
            ? _value.isWarning
            : isWarning // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$FileSelectionMessageImpl implements _FileSelectionMessage {
  const _$FileSelectionMessageImpl({
    required this.fileName,
    required this.message,
    required this.isWarning,
  });

  @override
  final String fileName;
  @override
  final String message;
  @override
  final bool isWarning;

  @override
  String toString() {
    return 'FileSelectionMessage(fileName: $fileName, message: $message, isWarning: $isWarning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileSelectionMessageImpl &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isWarning, isWarning) ||
                other.isWarning == isWarning));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fileName, message, isWarning);

  /// Create a copy of FileSelectionMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileSelectionMessageImplCopyWith<_$FileSelectionMessageImpl>
  get copyWith =>
      __$$FileSelectionMessageImplCopyWithImpl<_$FileSelectionMessageImpl>(
        this,
        _$identity,
      );
}

abstract class _FileSelectionMessage implements FileSelectionMessage {
  const factory _FileSelectionMessage({
    required final String fileName,
    required final String message,
    required final bool isWarning,
  }) = _$FileSelectionMessageImpl;

  @override
  String get fileName;
  @override
  String get message;
  @override
  bool get isWarning;

  /// Create a copy of FileSelectionMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileSelectionMessageImplCopyWith<_$FileSelectionMessageImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FileSelectionState {
  List<SelectedSendFile> get selectedFiles =>
      throw _privateConstructorUsedError;
  List<FileSelectionMessage> get messages => throw _privateConstructorUsedError;
  bool get isPickingFiles => throw _privateConstructorUsedError;

  /// Create a copy of FileSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileSelectionStateCopyWith<FileSelectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileSelectionStateCopyWith<$Res> {
  factory $FileSelectionStateCopyWith(
    FileSelectionState value,
    $Res Function(FileSelectionState) then,
  ) = _$FileSelectionStateCopyWithImpl<$Res, FileSelectionState>;
  @useResult
  $Res call({
    List<SelectedSendFile> selectedFiles,
    List<FileSelectionMessage> messages,
    bool isPickingFiles,
  });
}

/// @nodoc
class _$FileSelectionStateCopyWithImpl<$Res, $Val extends FileSelectionState>
    implements $FileSelectionStateCopyWith<$Res> {
  _$FileSelectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedFiles = null,
    Object? messages = null,
    Object? isPickingFiles = null,
  }) {
    return _then(
      _value.copyWith(
            selectedFiles: null == selectedFiles
                ? _value.selectedFiles
                : selectedFiles // ignore: cast_nullable_to_non_nullable
                      as List<SelectedSendFile>,
            messages: null == messages
                ? _value.messages
                : messages // ignore: cast_nullable_to_non_nullable
                      as List<FileSelectionMessage>,
            isPickingFiles: null == isPickingFiles
                ? _value.isPickingFiles
                : isPickingFiles // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FileSelectionStateImplCopyWith<$Res>
    implements $FileSelectionStateCopyWith<$Res> {
  factory _$$FileSelectionStateImplCopyWith(
    _$FileSelectionStateImpl value,
    $Res Function(_$FileSelectionStateImpl) then,
  ) = __$$FileSelectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<SelectedSendFile> selectedFiles,
    List<FileSelectionMessage> messages,
    bool isPickingFiles,
  });
}

/// @nodoc
class __$$FileSelectionStateImplCopyWithImpl<$Res>
    extends _$FileSelectionStateCopyWithImpl<$Res, _$FileSelectionStateImpl>
    implements _$$FileSelectionStateImplCopyWith<$Res> {
  __$$FileSelectionStateImplCopyWithImpl(
    _$FileSelectionStateImpl _value,
    $Res Function(_$FileSelectionStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FileSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedFiles = null,
    Object? messages = null,
    Object? isPickingFiles = null,
  }) {
    return _then(
      _$FileSelectionStateImpl(
        selectedFiles: null == selectedFiles
            ? _value._selectedFiles
            : selectedFiles // ignore: cast_nullable_to_non_nullable
                  as List<SelectedSendFile>,
        messages: null == messages
            ? _value._messages
            : messages // ignore: cast_nullable_to_non_nullable
                  as List<FileSelectionMessage>,
        isPickingFiles: null == isPickingFiles
            ? _value.isPickingFiles
            : isPickingFiles // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$FileSelectionStateImpl implements _FileSelectionState {
  const _$FileSelectionStateImpl({
    final List<SelectedSendFile> selectedFiles = const [],
    final List<FileSelectionMessage> messages = const [],
    this.isPickingFiles = false,
  }) : _selectedFiles = selectedFiles,
       _messages = messages;

  final List<SelectedSendFile> _selectedFiles;
  @override
  @JsonKey()
  List<SelectedSendFile> get selectedFiles {
    if (_selectedFiles is EqualUnmodifiableListView) return _selectedFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedFiles);
  }

  final List<FileSelectionMessage> _messages;
  @override
  @JsonKey()
  List<FileSelectionMessage> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  @JsonKey()
  final bool isPickingFiles;

  @override
  String toString() {
    return 'FileSelectionState(selectedFiles: $selectedFiles, messages: $messages, isPickingFiles: $isPickingFiles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileSelectionStateImpl &&
            const DeepCollectionEquality().equals(
              other._selectedFiles,
              _selectedFiles,
            ) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.isPickingFiles, isPickingFiles) ||
                other.isPickingFiles == isPickingFiles));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_selectedFiles),
    const DeepCollectionEquality().hash(_messages),
    isPickingFiles,
  );

  /// Create a copy of FileSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileSelectionStateImplCopyWith<_$FileSelectionStateImpl> get copyWith =>
      __$$FileSelectionStateImplCopyWithImpl<_$FileSelectionStateImpl>(
        this,
        _$identity,
      );
}

abstract class _FileSelectionState implements FileSelectionState {
  const factory _FileSelectionState({
    final List<SelectedSendFile> selectedFiles,
    final List<FileSelectionMessage> messages,
    final bool isPickingFiles,
  }) = _$FileSelectionStateImpl;

  @override
  List<SelectedSendFile> get selectedFiles;
  @override
  List<FileSelectionMessage> get messages;
  @override
  bool get isPickingFiles;

  /// Create a copy of FileSelectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileSelectionStateImplCopyWith<_$FileSelectionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

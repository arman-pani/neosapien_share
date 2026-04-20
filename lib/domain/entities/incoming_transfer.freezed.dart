// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incoming_transfer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransferFile {

 String get fileId; String get name; int get size; String get mimeType; String get storageUrl; String get sha256;
/// Create a copy of TransferFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferFileCopyWith<TransferFile> get copyWith => _$TransferFileCopyWithImpl<TransferFile>(this as TransferFile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferFile&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.storageUrl, storageUrl) || other.storageUrl == storageUrl)&&(identical(other.sha256, sha256) || other.sha256 == sha256));
}


@override
int get hashCode => Object.hash(runtimeType,fileId,name,size,mimeType,storageUrl,sha256);

@override
String toString() {
  return 'TransferFile(fileId: $fileId, name: $name, size: $size, mimeType: $mimeType, storageUrl: $storageUrl, sha256: $sha256)';
}


}

/// @nodoc
abstract mixin class $TransferFileCopyWith<$Res>  {
  factory $TransferFileCopyWith(TransferFile value, $Res Function(TransferFile) _then) = _$TransferFileCopyWithImpl;
@useResult
$Res call({
 String fileId, String name, int size, String mimeType, String storageUrl, String sha256
});




}
/// @nodoc
class _$TransferFileCopyWithImpl<$Res>
    implements $TransferFileCopyWith<$Res> {
  _$TransferFileCopyWithImpl(this._self, this._then);

  final TransferFile _self;
  final $Res Function(TransferFile) _then;

/// Create a copy of TransferFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileId = null,Object? name = null,Object? size = null,Object? mimeType = null,Object? storageUrl = null,Object? sha256 = null,}) {
  return _then(_self.copyWith(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,storageUrl: null == storageUrl ? _self.storageUrl : storageUrl // ignore: cast_nullable_to_non_nullable
as String,sha256: null == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferFile].
extension TransferFilePatterns on TransferFile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferFile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferFile value)  $default,){
final _that = this;
switch (_that) {
case _TransferFile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferFile value)?  $default,){
final _that = this;
switch (_that) {
case _TransferFile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileId,  String name,  int size,  String mimeType,  String storageUrl,  String sha256)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferFile() when $default != null:
return $default(_that.fileId,_that.name,_that.size,_that.mimeType,_that.storageUrl,_that.sha256);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileId,  String name,  int size,  String mimeType,  String storageUrl,  String sha256)  $default,) {final _that = this;
switch (_that) {
case _TransferFile():
return $default(_that.fileId,_that.name,_that.size,_that.mimeType,_that.storageUrl,_that.sha256);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileId,  String name,  int size,  String mimeType,  String storageUrl,  String sha256)?  $default,) {final _that = this;
switch (_that) {
case _TransferFile() when $default != null:
return $default(_that.fileId,_that.name,_that.size,_that.mimeType,_that.storageUrl,_that.sha256);case _:
  return null;

}
}

}

/// @nodoc


class _TransferFile implements TransferFile {
  const _TransferFile({required this.fileId, required this.name, required this.size, required this.mimeType, required this.storageUrl, required this.sha256});
  

@override final  String fileId;
@override final  String name;
@override final  int size;
@override final  String mimeType;
@override final  String storageUrl;
@override final  String sha256;

/// Create a copy of TransferFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferFileCopyWith<_TransferFile> get copyWith => __$TransferFileCopyWithImpl<_TransferFile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferFile&&(identical(other.fileId, fileId) || other.fileId == fileId)&&(identical(other.name, name) || other.name == name)&&(identical(other.size, size) || other.size == size)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.storageUrl, storageUrl) || other.storageUrl == storageUrl)&&(identical(other.sha256, sha256) || other.sha256 == sha256));
}


@override
int get hashCode => Object.hash(runtimeType,fileId,name,size,mimeType,storageUrl,sha256);

@override
String toString() {
  return 'TransferFile(fileId: $fileId, name: $name, size: $size, mimeType: $mimeType, storageUrl: $storageUrl, sha256: $sha256)';
}


}

/// @nodoc
abstract mixin class _$TransferFileCopyWith<$Res> implements $TransferFileCopyWith<$Res> {
  factory _$TransferFileCopyWith(_TransferFile value, $Res Function(_TransferFile) _then) = __$TransferFileCopyWithImpl;
@override @useResult
$Res call({
 String fileId, String name, int size, String mimeType, String storageUrl, String sha256
});




}
/// @nodoc
class __$TransferFileCopyWithImpl<$Res>
    implements _$TransferFileCopyWith<$Res> {
  __$TransferFileCopyWithImpl(this._self, this._then);

  final _TransferFile _self;
  final $Res Function(_TransferFile) _then;

/// Create a copy of TransferFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileId = null,Object? name = null,Object? size = null,Object? mimeType = null,Object? storageUrl = null,Object? sha256 = null,}) {
  return _then(_TransferFile(
fileId: null == fileId ? _self.fileId : fileId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,storageUrl: null == storageUrl ? _self.storageUrl : storageUrl // ignore: cast_nullable_to_non_nullable
as String,sha256: null == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$IncomingTransfer {

 String get transferId; String get senderCode; String get recipientCode; String get status; DateTime get createdAt; DateTime get expiresAt; List<TransferFile> get files;
/// Create a copy of IncomingTransfer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomingTransferCopyWith<IncomingTransfer> get copyWith => _$IncomingTransferCopyWithImpl<IncomingTransfer>(this as IncomingTransfer, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncomingTransfer&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.senderCode, senderCode) || other.senderCode == senderCode)&&(identical(other.recipientCode, recipientCode) || other.recipientCode == recipientCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&const DeepCollectionEquality().equals(other.files, files));
}


@override
int get hashCode => Object.hash(runtimeType,transferId,senderCode,recipientCode,status,createdAt,expiresAt,const DeepCollectionEquality().hash(files));

@override
String toString() {
  return 'IncomingTransfer(transferId: $transferId, senderCode: $senderCode, recipientCode: $recipientCode, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, files: $files)';
}


}

/// @nodoc
abstract mixin class $IncomingTransferCopyWith<$Res>  {
  factory $IncomingTransferCopyWith(IncomingTransfer value, $Res Function(IncomingTransfer) _then) = _$IncomingTransferCopyWithImpl;
@useResult
$Res call({
 String transferId, String senderCode, String recipientCode, String status, DateTime createdAt, DateTime expiresAt, List<TransferFile> files
});




}
/// @nodoc
class _$IncomingTransferCopyWithImpl<$Res>
    implements $IncomingTransferCopyWith<$Res> {
  _$IncomingTransferCopyWithImpl(this._self, this._then);

  final IncomingTransfer _self;
  final $Res Function(IncomingTransfer) _then;

/// Create a copy of IncomingTransfer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? transferId = null,Object? senderCode = null,Object? recipientCode = null,Object? status = null,Object? createdAt = null,Object? expiresAt = null,Object? files = null,}) {
  return _then(_self.copyWith(
transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,senderCode: null == senderCode ? _self.senderCode : senderCode // ignore: cast_nullable_to_non_nullable
as String,recipientCode: null == recipientCode ? _self.recipientCode : recipientCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<TransferFile>,
  ));
}

}


/// Adds pattern-matching-related methods to [IncomingTransfer].
extension IncomingTransferPatterns on IncomingTransfer {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IncomingTransfer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IncomingTransfer() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IncomingTransfer value)  $default,){
final _that = this;
switch (_that) {
case _IncomingTransfer():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IncomingTransfer value)?  $default,){
final _that = this;
switch (_that) {
case _IncomingTransfer() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String transferId,  String senderCode,  String recipientCode,  String status,  DateTime createdAt,  DateTime expiresAt,  List<TransferFile> files)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IncomingTransfer() when $default != null:
return $default(_that.transferId,_that.senderCode,_that.recipientCode,_that.status,_that.createdAt,_that.expiresAt,_that.files);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String transferId,  String senderCode,  String recipientCode,  String status,  DateTime createdAt,  DateTime expiresAt,  List<TransferFile> files)  $default,) {final _that = this;
switch (_that) {
case _IncomingTransfer():
return $default(_that.transferId,_that.senderCode,_that.recipientCode,_that.status,_that.createdAt,_that.expiresAt,_that.files);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String transferId,  String senderCode,  String recipientCode,  String status,  DateTime createdAt,  DateTime expiresAt,  List<TransferFile> files)?  $default,) {final _that = this;
switch (_that) {
case _IncomingTransfer() when $default != null:
return $default(_that.transferId,_that.senderCode,_that.recipientCode,_that.status,_that.createdAt,_that.expiresAt,_that.files);case _:
  return null;

}
}

}

/// @nodoc


class _IncomingTransfer implements IncomingTransfer {
  const _IncomingTransfer({required this.transferId, required this.senderCode, required this.recipientCode, required this.status, required this.createdAt, required this.expiresAt, required final  List<TransferFile> files}): _files = files;
  

@override final  String transferId;
@override final  String senderCode;
@override final  String recipientCode;
@override final  String status;
@override final  DateTime createdAt;
@override final  DateTime expiresAt;
 final  List<TransferFile> _files;
@override List<TransferFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of IncomingTransfer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomingTransferCopyWith<_IncomingTransfer> get copyWith => __$IncomingTransferCopyWithImpl<_IncomingTransfer>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomingTransfer&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.senderCode, senderCode) || other.senderCode == senderCode)&&(identical(other.recipientCode, recipientCode) || other.recipientCode == recipientCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&const DeepCollectionEquality().equals(other._files, _files));
}


@override
int get hashCode => Object.hash(runtimeType,transferId,senderCode,recipientCode,status,createdAt,expiresAt,const DeepCollectionEquality().hash(_files));

@override
String toString() {
  return 'IncomingTransfer(transferId: $transferId, senderCode: $senderCode, recipientCode: $recipientCode, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, files: $files)';
}


}

/// @nodoc
abstract mixin class _$IncomingTransferCopyWith<$Res> implements $IncomingTransferCopyWith<$Res> {
  factory _$IncomingTransferCopyWith(_IncomingTransfer value, $Res Function(_IncomingTransfer) _then) = __$IncomingTransferCopyWithImpl;
@override @useResult
$Res call({
 String transferId, String senderCode, String recipientCode, String status, DateTime createdAt, DateTime expiresAt, List<TransferFile> files
});




}
/// @nodoc
class __$IncomingTransferCopyWithImpl<$Res>
    implements _$IncomingTransferCopyWith<$Res> {
  __$IncomingTransferCopyWithImpl(this._self, this._then);

  final _IncomingTransfer _self;
  final $Res Function(_IncomingTransfer) _then;

/// Create a copy of IncomingTransfer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? transferId = null,Object? senderCode = null,Object? recipientCode = null,Object? status = null,Object? createdAt = null,Object? expiresAt = null,Object? files = null,}) {
  return _then(_IncomingTransfer(
transferId: null == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String,senderCode: null == senderCode ? _self.senderCode : senderCode // ignore: cast_nullable_to_non_nullable
as String,recipientCode: null == recipientCode ? _self.recipientCode : recipientCode // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<TransferFile>,
  ));
}


}

// dart format on

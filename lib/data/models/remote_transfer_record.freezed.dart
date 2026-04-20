// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_transfer_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemoteTransferRecord {

 String get id; String get shortCode; String get fileName; int get sizeInBytes; DateTime get createdAt;
/// Create a copy of RemoteTransferRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteTransferRecordCopyWith<RemoteTransferRecord> get copyWith => _$RemoteTransferRecordCopyWithImpl<RemoteTransferRecord>(this as RemoteTransferRecord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteTransferRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.shortCode, shortCode) || other.shortCode == shortCode)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.sizeInBytes, sizeInBytes) || other.sizeInBytes == sizeInBytes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,shortCode,fileName,sizeInBytes,createdAt);

@override
String toString() {
  return 'RemoteTransferRecord(id: $id, shortCode: $shortCode, fileName: $fileName, sizeInBytes: $sizeInBytes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RemoteTransferRecordCopyWith<$Res>  {
  factory $RemoteTransferRecordCopyWith(RemoteTransferRecord value, $Res Function(RemoteTransferRecord) _then) = _$RemoteTransferRecordCopyWithImpl;
@useResult
$Res call({
 String id, String shortCode, String fileName, int sizeInBytes, DateTime createdAt
});




}
/// @nodoc
class _$RemoteTransferRecordCopyWithImpl<$Res>
    implements $RemoteTransferRecordCopyWith<$Res> {
  _$RemoteTransferRecordCopyWithImpl(this._self, this._then);

  final RemoteTransferRecord _self;
  final $Res Function(RemoteTransferRecord) _then;

/// Create a copy of RemoteTransferRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? shortCode = null,Object? fileName = null,Object? sizeInBytes = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shortCode: null == shortCode ? _self.shortCode : shortCode // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,sizeInBytes: null == sizeInBytes ? _self.sizeInBytes : sizeInBytes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RemoteTransferRecord].
extension RemoteTransferRecordPatterns on RemoteTransferRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemoteTransferRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemoteTransferRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemoteTransferRecord value)  $default,){
final _that = this;
switch (_that) {
case _RemoteTransferRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemoteTransferRecord value)?  $default,){
final _that = this;
switch (_that) {
case _RemoteTransferRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String shortCode,  String fileName,  int sizeInBytes,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemoteTransferRecord() when $default != null:
return $default(_that.id,_that.shortCode,_that.fileName,_that.sizeInBytes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String shortCode,  String fileName,  int sizeInBytes,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _RemoteTransferRecord():
return $default(_that.id,_that.shortCode,_that.fileName,_that.sizeInBytes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String shortCode,  String fileName,  int sizeInBytes,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RemoteTransferRecord() when $default != null:
return $default(_that.id,_that.shortCode,_that.fileName,_that.sizeInBytes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _RemoteTransferRecord extends RemoteTransferRecord {
  const _RemoteTransferRecord({required this.id, required this.shortCode, required this.fileName, required this.sizeInBytes, required this.createdAt}): super._();
  

@override final  String id;
@override final  String shortCode;
@override final  String fileName;
@override final  int sizeInBytes;
@override final  DateTime createdAt;

/// Create a copy of RemoteTransferRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteTransferRecordCopyWith<_RemoteTransferRecord> get copyWith => __$RemoteTransferRecordCopyWithImpl<_RemoteTransferRecord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteTransferRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.shortCode, shortCode) || other.shortCode == shortCode)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.sizeInBytes, sizeInBytes) || other.sizeInBytes == sizeInBytes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,shortCode,fileName,sizeInBytes,createdAt);

@override
String toString() {
  return 'RemoteTransferRecord(id: $id, shortCode: $shortCode, fileName: $fileName, sizeInBytes: $sizeInBytes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RemoteTransferRecordCopyWith<$Res> implements $RemoteTransferRecordCopyWith<$Res> {
  factory _$RemoteTransferRecordCopyWith(_RemoteTransferRecord value, $Res Function(_RemoteTransferRecord) _then) = __$RemoteTransferRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String shortCode, String fileName, int sizeInBytes, DateTime createdAt
});




}
/// @nodoc
class __$RemoteTransferRecordCopyWithImpl<$Res>
    implements _$RemoteTransferRecordCopyWith<$Res> {
  __$RemoteTransferRecordCopyWithImpl(this._self, this._then);

  final _RemoteTransferRecord _self;
  final $Res Function(_RemoteTransferRecord) _then;

/// Create a copy of RemoteTransferRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? shortCode = null,Object? fileName = null,Object? sizeInBytes = null,Object? createdAt = null,}) {
  return _then(_RemoteTransferRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,shortCode: null == shortCode ? _self.shortCode : shortCode // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,sizeInBytes: null == sizeInBytes ? _self.sizeInBytes : sizeInBytes // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

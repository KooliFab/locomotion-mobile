// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'uploaded_file_ref.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UploadedFileRef {

 int get id;@JsonKey(name: 'original_filename') String get originalFilename; String get field;
/// Create a copy of UploadedFileRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadedFileRefCopyWith<UploadedFileRef> get copyWith => _$UploadedFileRefCopyWithImpl<UploadedFileRef>(this as UploadedFileRef, _$identity);

  /// Serializes this UploadedFileRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadedFileRef&&(identical(other.id, id) || other.id == id)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.field, field) || other.field == field));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,originalFilename,field);

@override
String toString() {
  return 'UploadedFileRef(id: $id, originalFilename: $originalFilename, field: $field)';
}


}

/// @nodoc
abstract mixin class $UploadedFileRefCopyWith<$Res>  {
  factory $UploadedFileRefCopyWith(UploadedFileRef value, $Res Function(UploadedFileRef) _then) = _$UploadedFileRefCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'original_filename') String originalFilename, String field
});




}
/// @nodoc
class _$UploadedFileRefCopyWithImpl<$Res>
    implements $UploadedFileRefCopyWith<$Res> {
  _$UploadedFileRefCopyWithImpl(this._self, this._then);

  final UploadedFileRef _self;
  final $Res Function(UploadedFileRef) _then;

/// Create a copy of UploadedFileRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? originalFilename = null,Object? field = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadedFileRef].
extension UploadedFileRefPatterns on UploadedFileRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadedFileRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadedFileRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadedFileRef value)  $default,){
final _that = this;
switch (_that) {
case _UploadedFileRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadedFileRef value)?  $default,){
final _that = this;
switch (_that) {
case _UploadedFileRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'original_filename')  String originalFilename,  String field)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadedFileRef() when $default != null:
return $default(_that.id,_that.originalFilename,_that.field);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'original_filename')  String originalFilename,  String field)  $default,) {final _that = this;
switch (_that) {
case _UploadedFileRef():
return $default(_that.id,_that.originalFilename,_that.field);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'original_filename')  String originalFilename,  String field)?  $default,) {final _that = this;
switch (_that) {
case _UploadedFileRef() when $default != null:
return $default(_that.id,_that.originalFilename,_that.field);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UploadedFileRef implements UploadedFileRef {
  const _UploadedFileRef({required this.id, @JsonKey(name: 'original_filename') required this.originalFilename, required this.field});
  factory _UploadedFileRef.fromJson(Map<String, dynamic> json) => _$UploadedFileRefFromJson(json);

@override final  int id;
@override@JsonKey(name: 'original_filename') final  String originalFilename;
@override final  String field;

/// Create a copy of UploadedFileRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadedFileRefCopyWith<_UploadedFileRef> get copyWith => __$UploadedFileRefCopyWithImpl<_UploadedFileRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadedFileRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadedFileRef&&(identical(other.id, id) || other.id == id)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.field, field) || other.field == field));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,originalFilename,field);

@override
String toString() {
  return 'UploadedFileRef(id: $id, originalFilename: $originalFilename, field: $field)';
}


}

/// @nodoc
abstract mixin class _$UploadedFileRefCopyWith<$Res> implements $UploadedFileRefCopyWith<$Res> {
  factory _$UploadedFileRefCopyWith(_UploadedFileRef value, $Res Function(_UploadedFileRef) _then) = __$UploadedFileRefCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'original_filename') String originalFilename, String field
});




}
/// @nodoc
class __$UploadedFileRefCopyWithImpl<$Res>
    implements _$UploadedFileRefCopyWith<$Res> {
  __$UploadedFileRefCopyWithImpl(this._self, this._then);

  final _UploadedFileRef _self;
  final $Res Function(_UploadedFileRef) _then;

/// Create a copy of UploadedFileRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? originalFilename = null,Object? field = null,}) {
  return _then(_UploadedFileRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,originalFilename: null == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String,field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

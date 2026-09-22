// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loanable_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoanableImage {

 int get id; String? get field; String? get filename;@JsonKey(name: 'original_filename') String? get originalFilename; int? get width; int? get height; int? get order;
/// Create a copy of LoanableImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanableImageCopyWith<LoanableImage> get copyWith => _$LoanableImageCopyWithImpl<LoanableImage>(this as LoanableImage, _$identity);

  /// Serializes this LoanableImage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanableImage&&(identical(other.id, id) || other.id == id)&&(identical(other.field, field) || other.field == field)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,field,filename,originalFilename,width,height,order);

@override
String toString() {
  return 'LoanableImage(id: $id, field: $field, filename: $filename, originalFilename: $originalFilename, width: $width, height: $height, order: $order)';
}


}

/// @nodoc
abstract mixin class $LoanableImageCopyWith<$Res>  {
  factory $LoanableImageCopyWith(LoanableImage value, $Res Function(LoanableImage) _then) = _$LoanableImageCopyWithImpl;
@useResult
$Res call({
 int id, String? field, String? filename,@JsonKey(name: 'original_filename') String? originalFilename, int? width, int? height, int? order
});




}
/// @nodoc
class _$LoanableImageCopyWithImpl<$Res>
    implements $LoanableImageCopyWith<$Res> {
  _$LoanableImageCopyWithImpl(this._self, this._then);

  final LoanableImage _self;
  final $Res Function(LoanableImage) _then;

/// Create a copy of LoanableImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? field = freezed,Object? filename = freezed,Object? originalFilename = freezed,Object? width = freezed,Object? height = freezed,Object? order = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,field: freezed == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String?,filename: freezed == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String?,originalFilename: freezed == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanableImage].
extension LoanableImagePatterns on LoanableImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanableImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanableImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanableImage value)  $default,){
final _that = this;
switch (_that) {
case _LoanableImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanableImage value)?  $default,){
final _that = this;
switch (_that) {
case _LoanableImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? field,  String? filename, @JsonKey(name: 'original_filename')  String? originalFilename,  int? width,  int? height,  int? order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanableImage() when $default != null:
return $default(_that.id,_that.field,_that.filename,_that.originalFilename,_that.width,_that.height,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? field,  String? filename, @JsonKey(name: 'original_filename')  String? originalFilename,  int? width,  int? height,  int? order)  $default,) {final _that = this;
switch (_that) {
case _LoanableImage():
return $default(_that.id,_that.field,_that.filename,_that.originalFilename,_that.width,_that.height,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? field,  String? filename, @JsonKey(name: 'original_filename')  String? originalFilename,  int? width,  int? height,  int? order)?  $default,) {final _that = this;
switch (_that) {
case _LoanableImage() when $default != null:
return $default(_that.id,_that.field,_that.filename,_that.originalFilename,_that.width,_that.height,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoanableImage extends LoanableImage {
  const _LoanableImage({required this.id, this.field, this.filename, @JsonKey(name: 'original_filename') this.originalFilename, this.width, this.height, this.order}): super._();
  factory _LoanableImage.fromJson(Map<String, dynamic> json) => _$LoanableImageFromJson(json);

@override final  int id;
@override final  String? field;
@override final  String? filename;
@override@JsonKey(name: 'original_filename') final  String? originalFilename;
@override final  int? width;
@override final  int? height;
@override final  int? order;

/// Create a copy of LoanableImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanableImageCopyWith<_LoanableImage> get copyWith => __$LoanableImageCopyWithImpl<_LoanableImage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoanableImageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanableImage&&(identical(other.id, id) || other.id == id)&&(identical(other.field, field) || other.field == field)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.originalFilename, originalFilename) || other.originalFilename == originalFilename)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,field,filename,originalFilename,width,height,order);

@override
String toString() {
  return 'LoanableImage(id: $id, field: $field, filename: $filename, originalFilename: $originalFilename, width: $width, height: $height, order: $order)';
}


}

/// @nodoc
abstract mixin class _$LoanableImageCopyWith<$Res> implements $LoanableImageCopyWith<$Res> {
  factory _$LoanableImageCopyWith(_LoanableImage value, $Res Function(_LoanableImage) _then) = __$LoanableImageCopyWithImpl;
@override @useResult
$Res call({
 int id, String? field, String? filename,@JsonKey(name: 'original_filename') String? originalFilename, int? width, int? height, int? order
});




}
/// @nodoc
class __$LoanableImageCopyWithImpl<$Res>
    implements _$LoanableImageCopyWith<$Res> {
  __$LoanableImageCopyWithImpl(this._self, this._then);

  final _LoanableImage _self;
  final $Res Function(_LoanableImage) _then;

/// Create a copy of LoanableImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? field = freezed,Object? filename = freezed,Object? originalFilename = freezed,Object? width = freezed,Object? height = freezed,Object? order = freezed,}) {
  return _then(_LoanableImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,field: freezed == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String?,filename: freezed == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String?,originalFilename: freezed == originalFilename ? _self.originalFilename : originalFilename // ignore: cast_nullable_to_non_nullable
as String?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

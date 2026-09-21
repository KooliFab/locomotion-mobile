// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loanable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Loanable {

 int get id; String get name; String get type;// 'car', 'bike', 'trailer'
 String? get description; String? get address; double? get latitude; double? get longitude; String? get imageUrl; bool get isAvailable; String? get communityName; int? get communityId;
/// Create a copy of Loanable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanableCopyWith<Loanable> get copyWith => _$LoanableCopyWithImpl<Loanable>(this as Loanable, _$identity);

  /// Serializes this Loanable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loanable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.communityName, communityName) || other.communityName == communityName)&&(identical(other.communityId, communityId) || other.communityId == communityId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,description,address,latitude,longitude,imageUrl,isAvailable,communityName,communityId);

@override
String toString() {
  return 'Loanable(id: $id, name: $name, type: $type, description: $description, address: $address, latitude: $latitude, longitude: $longitude, imageUrl: $imageUrl, isAvailable: $isAvailable, communityName: $communityName, communityId: $communityId)';
}


}

/// @nodoc
abstract mixin class $LoanableCopyWith<$Res>  {
  factory $LoanableCopyWith(Loanable value, $Res Function(Loanable) _then) = _$LoanableCopyWithImpl;
@useResult
$Res call({
 int id, String name, String type, String? description, String? address, double? latitude, double? longitude, String? imageUrl, bool isAvailable, String? communityName, int? communityId
});




}
/// @nodoc
class _$LoanableCopyWithImpl<$Res>
    implements $LoanableCopyWith<$Res> {
  _$LoanableCopyWithImpl(this._self, this._then);

  final Loanable _self;
  final $Res Function(Loanable) _then;

/// Create a copy of Loanable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? description = freezed,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? imageUrl = freezed,Object? isAvailable = null,Object? communityName = freezed,Object? communityId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,communityName: freezed == communityName ? _self.communityName : communityName // ignore: cast_nullable_to_non_nullable
as String?,communityId: freezed == communityId ? _self.communityId : communityId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Loanable].
extension LoanablePatterns on Loanable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Loanable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Loanable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Loanable value)  $default,){
final _that = this;
switch (_that) {
case _Loanable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Loanable value)?  $default,){
final _that = this;
switch (_that) {
case _Loanable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String type,  String? description,  String? address,  double? latitude,  double? longitude,  String? imageUrl,  bool isAvailable,  String? communityName,  int? communityId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loanable() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.description,_that.address,_that.latitude,_that.longitude,_that.imageUrl,_that.isAvailable,_that.communityName,_that.communityId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String type,  String? description,  String? address,  double? latitude,  double? longitude,  String? imageUrl,  bool isAvailable,  String? communityName,  int? communityId)  $default,) {final _that = this;
switch (_that) {
case _Loanable():
return $default(_that.id,_that.name,_that.type,_that.description,_that.address,_that.latitude,_that.longitude,_that.imageUrl,_that.isAvailable,_that.communityName,_that.communityId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String type,  String? description,  String? address,  double? latitude,  double? longitude,  String? imageUrl,  bool isAvailable,  String? communityName,  int? communityId)?  $default,) {final _that = this;
switch (_that) {
case _Loanable() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.description,_that.address,_that.latitude,_that.longitude,_that.imageUrl,_that.isAvailable,_that.communityName,_that.communityId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Loanable implements Loanable {
  const _Loanable({required this.id, required this.name, required this.type, this.description, this.address, this.latitude, this.longitude, this.imageUrl, this.isAvailable = true, this.communityName, this.communityId});
  factory _Loanable.fromJson(Map<String, dynamic> json) => _$LoanableFromJson(json);

@override final  int id;
@override final  String name;
@override final  String type;
// 'car', 'bike', 'trailer'
@override final  String? description;
@override final  String? address;
@override final  double? latitude;
@override final  double? longitude;
@override final  String? imageUrl;
@override@JsonKey() final  bool isAvailable;
@override final  String? communityName;
@override final  int? communityId;

/// Create a copy of Loanable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanableCopyWith<_Loanable> get copyWith => __$LoanableCopyWithImpl<_Loanable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoanableToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loanable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.communityName, communityName) || other.communityName == communityName)&&(identical(other.communityId, communityId) || other.communityId == communityId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,description,address,latitude,longitude,imageUrl,isAvailable,communityName,communityId);

@override
String toString() {
  return 'Loanable(id: $id, name: $name, type: $type, description: $description, address: $address, latitude: $latitude, longitude: $longitude, imageUrl: $imageUrl, isAvailable: $isAvailable, communityName: $communityName, communityId: $communityId)';
}


}

/// @nodoc
abstract mixin class _$LoanableCopyWith<$Res> implements $LoanableCopyWith<$Res> {
  factory _$LoanableCopyWith(_Loanable value, $Res Function(_Loanable) _then) = __$LoanableCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String type, String? description, String? address, double? latitude, double? longitude, String? imageUrl, bool isAvailable, String? communityName, int? communityId
});




}
/// @nodoc
class __$LoanableCopyWithImpl<$Res>
    implements _$LoanableCopyWith<$Res> {
  __$LoanableCopyWithImpl(this._self, this._then);

  final _Loanable _self;
  final $Res Function(_Loanable) _then;

/// Create a copy of Loanable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? description = freezed,Object? address = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? imageUrl = freezed,Object? isAvailable = null,Object? communityName = freezed,Object? communityId = freezed,}) {
  return _then(_Loanable(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,communityName: freezed == communityName ? _self.communityName : communityName // ignore: cast_nullable_to_non_nullable
as String?,communityId: freezed == communityId ? _self.communityId : communityId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

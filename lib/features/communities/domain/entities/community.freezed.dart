// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'community.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Community {

 int get id; String get name; String? get description; String? get city; int? get membersCount; int? get loanablesCount;
/// Create a copy of Community
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunityCopyWith<Community> get copyWith => _$CommunityCopyWithImpl<Community>(this as Community, _$identity);

  /// Serializes this Community to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Community&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&(identical(other.membersCount, membersCount) || other.membersCount == membersCount)&&(identical(other.loanablesCount, loanablesCount) || other.loanablesCount == loanablesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,city,membersCount,loanablesCount);

@override
String toString() {
  return 'Community(id: $id, name: $name, description: $description, city: $city, membersCount: $membersCount, loanablesCount: $loanablesCount)';
}


}

/// @nodoc
abstract mixin class $CommunityCopyWith<$Res>  {
  factory $CommunityCopyWith(Community value, $Res Function(Community) _then) = _$CommunityCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? description, String? city, int? membersCount, int? loanablesCount
});




}
/// @nodoc
class _$CommunityCopyWithImpl<$Res>
    implements $CommunityCopyWith<$Res> {
  _$CommunityCopyWithImpl(this._self, this._then);

  final Community _self;
  final $Res Function(Community) _then;

/// Create a copy of Community
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? city = freezed,Object? membersCount = freezed,Object? loanablesCount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,membersCount: freezed == membersCount ? _self.membersCount : membersCount // ignore: cast_nullable_to_non_nullable
as int?,loanablesCount: freezed == loanablesCount ? _self.loanablesCount : loanablesCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Community].
extension CommunityPatterns on Community {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Community value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Community() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Community value)  $default,){
final _that = this;
switch (_that) {
case _Community():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Community value)?  $default,){
final _that = this;
switch (_that) {
case _Community() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  String? city,  int? membersCount,  int? loanablesCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Community() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.city,_that.membersCount,_that.loanablesCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? description,  String? city,  int? membersCount,  int? loanablesCount)  $default,) {final _that = this;
switch (_that) {
case _Community():
return $default(_that.id,_that.name,_that.description,_that.city,_that.membersCount,_that.loanablesCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? description,  String? city,  int? membersCount,  int? loanablesCount)?  $default,) {final _that = this;
switch (_that) {
case _Community() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.city,_that.membersCount,_that.loanablesCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Community implements Community {
  const _Community({required this.id, required this.name, this.description, this.city, this.membersCount, this.loanablesCount});
  factory _Community.fromJson(Map<String, dynamic> json) => _$CommunityFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? description;
@override final  String? city;
@override final  int? membersCount;
@override final  int? loanablesCount;

/// Create a copy of Community
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunityCopyWith<_Community> get copyWith => __$CommunityCopyWithImpl<_Community>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommunityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Community&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.city, city) || other.city == city)&&(identical(other.membersCount, membersCount) || other.membersCount == membersCount)&&(identical(other.loanablesCount, loanablesCount) || other.loanablesCount == loanablesCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,city,membersCount,loanablesCount);

@override
String toString() {
  return 'Community(id: $id, name: $name, description: $description, city: $city, membersCount: $membersCount, loanablesCount: $loanablesCount)';
}


}

/// @nodoc
abstract mixin class _$CommunityCopyWith<$Res> implements $CommunityCopyWith<$Res> {
  factory _$CommunityCopyWith(_Community value, $Res Function(_Community) _then) = __$CommunityCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? description, String? city, int? membersCount, int? loanablesCount
});




}
/// @nodoc
class __$CommunityCopyWithImpl<$Res>
    implements _$CommunityCopyWith<$Res> {
  __$CommunityCopyWithImpl(this._self, this._then);

  final _Community _self;
  final $Res Function(_Community) _then;

/// Create a copy of Community
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? city = freezed,Object? membersCount = freezed,Object? loanablesCount = freezed,}) {
  return _then(_Community(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,membersCount: freezed == membersCount ? _self.membersCount : membersCount // ignore: cast_nullable_to_non_nullable
as int?,loanablesCount: freezed == loanablesCount ? _self.loanablesCount : loanablesCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

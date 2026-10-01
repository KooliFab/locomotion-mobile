// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_token.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushToken {

 int? get id; String get token; String get platform;@JsonKey(name: 'installation_id') String get installationId;@JsonKey(name: 'app_version') String? get appVersion;@JsonKey(name: 'last_active_at') DateTime? get lastActiveAt;
/// Create a copy of PushToken
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushTokenCopyWith<PushToken> get copyWith => _$PushTokenCopyWithImpl<PushToken>(this as PushToken, _$identity);

  /// Serializes this PushToken to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushToken&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.installationId, installationId) || other.installationId == installationId)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,token,platform,installationId,appVersion,lastActiveAt);

@override
String toString() {
  return 'PushToken(id: $id, token: $token, platform: $platform, installationId: $installationId, appVersion: $appVersion, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class $PushTokenCopyWith<$Res>  {
  factory $PushTokenCopyWith(PushToken value, $Res Function(PushToken) _then) = _$PushTokenCopyWithImpl;
@useResult
$Res call({
 int? id, String token, String platform,@JsonKey(name: 'installation_id') String installationId,@JsonKey(name: 'app_version') String? appVersion,@JsonKey(name: 'last_active_at') DateTime? lastActiveAt
});




}
/// @nodoc
class _$PushTokenCopyWithImpl<$Res>
    implements $PushTokenCopyWith<$Res> {
  _$PushTokenCopyWithImpl(this._self, this._then);

  final PushToken _self;
  final $Res Function(PushToken) _then;

/// Create a copy of PushToken
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? token = null,Object? platform = null,Object? installationId = null,Object? appVersion = freezed,Object? lastActiveAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,installationId: null == installationId ? _self.installationId : installationId // ignore: cast_nullable_to_non_nullable
as String,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PushToken].
extension PushTokenPatterns on PushToken {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushToken value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushToken() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushToken value)  $default,){
final _that = this;
switch (_that) {
case _PushToken():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushToken value)?  $default,){
final _that = this;
switch (_that) {
case _PushToken() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String token,  String platform, @JsonKey(name: 'installation_id')  String installationId, @JsonKey(name: 'app_version')  String? appVersion, @JsonKey(name: 'last_active_at')  DateTime? lastActiveAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushToken() when $default != null:
return $default(_that.id,_that.token,_that.platform,_that.installationId,_that.appVersion,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String token,  String platform, @JsonKey(name: 'installation_id')  String installationId, @JsonKey(name: 'app_version')  String? appVersion, @JsonKey(name: 'last_active_at')  DateTime? lastActiveAt)  $default,) {final _that = this;
switch (_that) {
case _PushToken():
return $default(_that.id,_that.token,_that.platform,_that.installationId,_that.appVersion,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String token,  String platform, @JsonKey(name: 'installation_id')  String installationId, @JsonKey(name: 'app_version')  String? appVersion, @JsonKey(name: 'last_active_at')  DateTime? lastActiveAt)?  $default,) {final _that = this;
switch (_that) {
case _PushToken() when $default != null:
return $default(_that.id,_that.token,_that.platform,_that.installationId,_that.appVersion,_that.lastActiveAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushToken extends PushToken {
  const _PushToken({this.id, required this.token, required this.platform, @JsonKey(name: 'installation_id') required this.installationId, @JsonKey(name: 'app_version') this.appVersion, @JsonKey(name: 'last_active_at') this.lastActiveAt}): super._();
  factory _PushToken.fromJson(Map<String, dynamic> json) => _$PushTokenFromJson(json);

@override final  int? id;
@override final  String token;
@override final  String platform;
@override@JsonKey(name: 'installation_id') final  String installationId;
@override@JsonKey(name: 'app_version') final  String? appVersion;
@override@JsonKey(name: 'last_active_at') final  DateTime? lastActiveAt;

/// Create a copy of PushToken
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushTokenCopyWith<_PushToken> get copyWith => __$PushTokenCopyWithImpl<_PushToken>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushTokenToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushToken&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.installationId, installationId) || other.installationId == installationId)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,token,platform,installationId,appVersion,lastActiveAt);

@override
String toString() {
  return 'PushToken(id: $id, token: $token, platform: $platform, installationId: $installationId, appVersion: $appVersion, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class _$PushTokenCopyWith<$Res> implements $PushTokenCopyWith<$Res> {
  factory _$PushTokenCopyWith(_PushToken value, $Res Function(_PushToken) _then) = __$PushTokenCopyWithImpl;
@override @useResult
$Res call({
 int? id, String token, String platform,@JsonKey(name: 'installation_id') String installationId,@JsonKey(name: 'app_version') String? appVersion,@JsonKey(name: 'last_active_at') DateTime? lastActiveAt
});




}
/// @nodoc
class __$PushTokenCopyWithImpl<$Res>
    implements _$PushTokenCopyWith<$Res> {
  __$PushTokenCopyWithImpl(this._self, this._then);

  final _PushToken _self;
  final $Res Function(_PushToken) _then;

/// Create a copy of PushToken
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? token = null,Object? platform = null,Object? installationId = null,Object? appVersion = freezed,Object? lastActiveAt = freezed,}) {
  return _then(_PushToken(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,installationId: null == installationId ? _self.installationId : installationId // ignore: cast_nullable_to_non_nullable
as String,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_dates_update_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoanDatesUpdateRequest {

/// Wall-clock string formatted as `Y-m-d H:i:s` in the vehicle's timezone.
/// Never send UTC or device-local timestamps here.
@JsonKey(name: 'departure_at') String get departureAt;@JsonKey(name: 'duration_in_minutes') int get durationInMinutes;
/// Create a copy of LoanDatesUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanDatesUpdateRequestCopyWith<LoanDatesUpdateRequest> get copyWith => _$LoanDatesUpdateRequestCopyWithImpl<LoanDatesUpdateRequest>(this as LoanDatesUpdateRequest, _$identity);

  /// Serializes this LoanDatesUpdateRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanDatesUpdateRequest&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,departureAt,durationInMinutes);

@override
String toString() {
  return 'LoanDatesUpdateRequest(departureAt: $departureAt, durationInMinutes: $durationInMinutes)';
}


}

/// @nodoc
abstract mixin class $LoanDatesUpdateRequestCopyWith<$Res>  {
  factory $LoanDatesUpdateRequestCopyWith(LoanDatesUpdateRequest value, $Res Function(LoanDatesUpdateRequest) _then) = _$LoanDatesUpdateRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'departure_at') String departureAt,@JsonKey(name: 'duration_in_minutes') int durationInMinutes
});




}
/// @nodoc
class _$LoanDatesUpdateRequestCopyWithImpl<$Res>
    implements $LoanDatesUpdateRequestCopyWith<$Res> {
  _$LoanDatesUpdateRequestCopyWithImpl(this._self, this._then);

  final LoanDatesUpdateRequest _self;
  final $Res Function(LoanDatesUpdateRequest) _then;

/// Create a copy of LoanDatesUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? departureAt = null,Object? durationInMinutes = null,}) {
  return _then(_self.copyWith(
departureAt: null == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as String,durationInMinutes: null == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanDatesUpdateRequest].
extension LoanDatesUpdateRequestPatterns on LoanDatesUpdateRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanDatesUpdateRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanDatesUpdateRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanDatesUpdateRequest value)  $default,){
final _that = this;
switch (_that) {
case _LoanDatesUpdateRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanDatesUpdateRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LoanDatesUpdateRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'departure_at')  String departureAt, @JsonKey(name: 'duration_in_minutes')  int durationInMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanDatesUpdateRequest() when $default != null:
return $default(_that.departureAt,_that.durationInMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'departure_at')  String departureAt, @JsonKey(name: 'duration_in_minutes')  int durationInMinutes)  $default,) {final _that = this;
switch (_that) {
case _LoanDatesUpdateRequest():
return $default(_that.departureAt,_that.durationInMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'departure_at')  String departureAt, @JsonKey(name: 'duration_in_minutes')  int durationInMinutes)?  $default,) {final _that = this;
switch (_that) {
case _LoanDatesUpdateRequest() when $default != null:
return $default(_that.departureAt,_that.durationInMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoanDatesUpdateRequest extends LoanDatesUpdateRequest {
  const _LoanDatesUpdateRequest({@JsonKey(name: 'departure_at') required this.departureAt, @JsonKey(name: 'duration_in_minutes') required this.durationInMinutes}): super._();
  factory _LoanDatesUpdateRequest.fromJson(Map<String, dynamic> json) => _$LoanDatesUpdateRequestFromJson(json);

/// Wall-clock string formatted as `Y-m-d H:i:s` in the vehicle's timezone.
/// Never send UTC or device-local timestamps here.
@override@JsonKey(name: 'departure_at') final  String departureAt;
@override@JsonKey(name: 'duration_in_minutes') final  int durationInMinutes;

/// Create a copy of LoanDatesUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanDatesUpdateRequestCopyWith<_LoanDatesUpdateRequest> get copyWith => __$LoanDatesUpdateRequestCopyWithImpl<_LoanDatesUpdateRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoanDatesUpdateRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanDatesUpdateRequest&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,departureAt,durationInMinutes);

@override
String toString() {
  return 'LoanDatesUpdateRequest(departureAt: $departureAt, durationInMinutes: $durationInMinutes)';
}


}

/// @nodoc
abstract mixin class _$LoanDatesUpdateRequestCopyWith<$Res> implements $LoanDatesUpdateRequestCopyWith<$Res> {
  factory _$LoanDatesUpdateRequestCopyWith(_LoanDatesUpdateRequest value, $Res Function(_LoanDatesUpdateRequest) _then) = __$LoanDatesUpdateRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'departure_at') String departureAt,@JsonKey(name: 'duration_in_minutes') int durationInMinutes
});




}
/// @nodoc
class __$LoanDatesUpdateRequestCopyWithImpl<$Res>
    implements _$LoanDatesUpdateRequestCopyWith<$Res> {
  __$LoanDatesUpdateRequestCopyWithImpl(this._self, this._then);

  final _LoanDatesUpdateRequest _self;
  final $Res Function(_LoanDatesUpdateRequest) _then;

/// Create a copy of LoanDatesUpdateRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? departureAt = null,Object? durationInMinutes = null,}) {
  return _then(_LoanDatesUpdateRequest(
departureAt: null == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as String,durationInMinutes: null == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

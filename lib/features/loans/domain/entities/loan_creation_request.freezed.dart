// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_creation_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoanCreationRequest {

@JsonKey(name: 'loanable_id') int get loanableId;@JsonKey(name: 'borrower_user_id') int get borrowerUserId;@JsonKey(name: 'departure_at') String get departureAt;@JsonKey(name: 'duration_in_minutes') int get durationInMinutes;@JsonKey(name: 'estimated_distance') int get estimatedDistance;@JsonKey(name: 'alternative_to') String get alternativeTo;@JsonKey(name: 'alternative_to_other') String? get alternativeToOther;@JsonKey(name: 'message_for_owner') String? get messageForOwner;@JsonKey(name: 'community_id') int? get communityId;
/// Create a copy of LoanCreationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanCreationRequestCopyWith<LoanCreationRequest> get copyWith => _$LoanCreationRequestCopyWithImpl<LoanCreationRequest>(this as LoanCreationRequest, _$identity);

  /// Serializes this LoanCreationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanCreationRequest&&(identical(other.loanableId, loanableId) || other.loanableId == loanableId)&&(identical(other.borrowerUserId, borrowerUserId) || other.borrowerUserId == borrowerUserId)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&(identical(other.estimatedDistance, estimatedDistance) || other.estimatedDistance == estimatedDistance)&&(identical(other.alternativeTo, alternativeTo) || other.alternativeTo == alternativeTo)&&(identical(other.alternativeToOther, alternativeToOther) || other.alternativeToOther == alternativeToOther)&&(identical(other.messageForOwner, messageForOwner) || other.messageForOwner == messageForOwner)&&(identical(other.communityId, communityId) || other.communityId == communityId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,loanableId,borrowerUserId,departureAt,durationInMinutes,estimatedDistance,alternativeTo,alternativeToOther,messageForOwner,communityId);

@override
String toString() {
  return 'LoanCreationRequest(loanableId: $loanableId, borrowerUserId: $borrowerUserId, departureAt: $departureAt, durationInMinutes: $durationInMinutes, estimatedDistance: $estimatedDistance, alternativeTo: $alternativeTo, alternativeToOther: $alternativeToOther, messageForOwner: $messageForOwner, communityId: $communityId)';
}


}

/// @nodoc
abstract mixin class $LoanCreationRequestCopyWith<$Res>  {
  factory $LoanCreationRequestCopyWith(LoanCreationRequest value, $Res Function(LoanCreationRequest) _then) = _$LoanCreationRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'loanable_id') int loanableId,@JsonKey(name: 'borrower_user_id') int borrowerUserId,@JsonKey(name: 'departure_at') String departureAt,@JsonKey(name: 'duration_in_minutes') int durationInMinutes,@JsonKey(name: 'estimated_distance') int estimatedDistance,@JsonKey(name: 'alternative_to') String alternativeTo,@JsonKey(name: 'alternative_to_other') String? alternativeToOther,@JsonKey(name: 'message_for_owner') String? messageForOwner,@JsonKey(name: 'community_id') int? communityId
});




}
/// @nodoc
class _$LoanCreationRequestCopyWithImpl<$Res>
    implements $LoanCreationRequestCopyWith<$Res> {
  _$LoanCreationRequestCopyWithImpl(this._self, this._then);

  final LoanCreationRequest _self;
  final $Res Function(LoanCreationRequest) _then;

/// Create a copy of LoanCreationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loanableId = null,Object? borrowerUserId = null,Object? departureAt = null,Object? durationInMinutes = null,Object? estimatedDistance = null,Object? alternativeTo = null,Object? alternativeToOther = freezed,Object? messageForOwner = freezed,Object? communityId = freezed,}) {
  return _then(_self.copyWith(
loanableId: null == loanableId ? _self.loanableId : loanableId // ignore: cast_nullable_to_non_nullable
as int,borrowerUserId: null == borrowerUserId ? _self.borrowerUserId : borrowerUserId // ignore: cast_nullable_to_non_nullable
as int,departureAt: null == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as String,durationInMinutes: null == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int,estimatedDistance: null == estimatedDistance ? _self.estimatedDistance : estimatedDistance // ignore: cast_nullable_to_non_nullable
as int,alternativeTo: null == alternativeTo ? _self.alternativeTo : alternativeTo // ignore: cast_nullable_to_non_nullable
as String,alternativeToOther: freezed == alternativeToOther ? _self.alternativeToOther : alternativeToOther // ignore: cast_nullable_to_non_nullable
as String?,messageForOwner: freezed == messageForOwner ? _self.messageForOwner : messageForOwner // ignore: cast_nullable_to_non_nullable
as String?,communityId: freezed == communityId ? _self.communityId : communityId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanCreationRequest].
extension LoanCreationRequestPatterns on LoanCreationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanCreationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanCreationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanCreationRequest value)  $default,){
final _that = this;
switch (_that) {
case _LoanCreationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanCreationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LoanCreationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'loanable_id')  int loanableId, @JsonKey(name: 'borrower_user_id')  int borrowerUserId, @JsonKey(name: 'departure_at')  String departureAt, @JsonKey(name: 'duration_in_minutes')  int durationInMinutes, @JsonKey(name: 'estimated_distance')  int estimatedDistance, @JsonKey(name: 'alternative_to')  String alternativeTo, @JsonKey(name: 'alternative_to_other')  String? alternativeToOther, @JsonKey(name: 'message_for_owner')  String? messageForOwner, @JsonKey(name: 'community_id')  int? communityId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanCreationRequest() when $default != null:
return $default(_that.loanableId,_that.borrowerUserId,_that.departureAt,_that.durationInMinutes,_that.estimatedDistance,_that.alternativeTo,_that.alternativeToOther,_that.messageForOwner,_that.communityId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'loanable_id')  int loanableId, @JsonKey(name: 'borrower_user_id')  int borrowerUserId, @JsonKey(name: 'departure_at')  String departureAt, @JsonKey(name: 'duration_in_minutes')  int durationInMinutes, @JsonKey(name: 'estimated_distance')  int estimatedDistance, @JsonKey(name: 'alternative_to')  String alternativeTo, @JsonKey(name: 'alternative_to_other')  String? alternativeToOther, @JsonKey(name: 'message_for_owner')  String? messageForOwner, @JsonKey(name: 'community_id')  int? communityId)  $default,) {final _that = this;
switch (_that) {
case _LoanCreationRequest():
return $default(_that.loanableId,_that.borrowerUserId,_that.departureAt,_that.durationInMinutes,_that.estimatedDistance,_that.alternativeTo,_that.alternativeToOther,_that.messageForOwner,_that.communityId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'loanable_id')  int loanableId, @JsonKey(name: 'borrower_user_id')  int borrowerUserId, @JsonKey(name: 'departure_at')  String departureAt, @JsonKey(name: 'duration_in_minutes')  int durationInMinutes, @JsonKey(name: 'estimated_distance')  int estimatedDistance, @JsonKey(name: 'alternative_to')  String alternativeTo, @JsonKey(name: 'alternative_to_other')  String? alternativeToOther, @JsonKey(name: 'message_for_owner')  String? messageForOwner, @JsonKey(name: 'community_id')  int? communityId)?  $default,) {final _that = this;
switch (_that) {
case _LoanCreationRequest() when $default != null:
return $default(_that.loanableId,_that.borrowerUserId,_that.departureAt,_that.durationInMinutes,_that.estimatedDistance,_that.alternativeTo,_that.alternativeToOther,_that.messageForOwner,_that.communityId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoanCreationRequest implements LoanCreationRequest {
  const _LoanCreationRequest({@JsonKey(name: 'loanable_id') required this.loanableId, @JsonKey(name: 'borrower_user_id') required this.borrowerUserId, @JsonKey(name: 'departure_at') required this.departureAt, @JsonKey(name: 'duration_in_minutes') required this.durationInMinutes, @JsonKey(name: 'estimated_distance') required this.estimatedDistance, @JsonKey(name: 'alternative_to') required this.alternativeTo, @JsonKey(name: 'alternative_to_other') this.alternativeToOther, @JsonKey(name: 'message_for_owner') this.messageForOwner, @JsonKey(name: 'community_id') this.communityId});
  factory _LoanCreationRequest.fromJson(Map<String, dynamic> json) => _$LoanCreationRequestFromJson(json);

@override@JsonKey(name: 'loanable_id') final  int loanableId;
@override@JsonKey(name: 'borrower_user_id') final  int borrowerUserId;
@override@JsonKey(name: 'departure_at') final  String departureAt;
@override@JsonKey(name: 'duration_in_minutes') final  int durationInMinutes;
@override@JsonKey(name: 'estimated_distance') final  int estimatedDistance;
@override@JsonKey(name: 'alternative_to') final  String alternativeTo;
@override@JsonKey(name: 'alternative_to_other') final  String? alternativeToOther;
@override@JsonKey(name: 'message_for_owner') final  String? messageForOwner;
@override@JsonKey(name: 'community_id') final  int? communityId;

/// Create a copy of LoanCreationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanCreationRequestCopyWith<_LoanCreationRequest> get copyWith => __$LoanCreationRequestCopyWithImpl<_LoanCreationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoanCreationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanCreationRequest&&(identical(other.loanableId, loanableId) || other.loanableId == loanableId)&&(identical(other.borrowerUserId, borrowerUserId) || other.borrowerUserId == borrowerUserId)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&(identical(other.estimatedDistance, estimatedDistance) || other.estimatedDistance == estimatedDistance)&&(identical(other.alternativeTo, alternativeTo) || other.alternativeTo == alternativeTo)&&(identical(other.alternativeToOther, alternativeToOther) || other.alternativeToOther == alternativeToOther)&&(identical(other.messageForOwner, messageForOwner) || other.messageForOwner == messageForOwner)&&(identical(other.communityId, communityId) || other.communityId == communityId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,loanableId,borrowerUserId,departureAt,durationInMinutes,estimatedDistance,alternativeTo,alternativeToOther,messageForOwner,communityId);

@override
String toString() {
  return 'LoanCreationRequest(loanableId: $loanableId, borrowerUserId: $borrowerUserId, departureAt: $departureAt, durationInMinutes: $durationInMinutes, estimatedDistance: $estimatedDistance, alternativeTo: $alternativeTo, alternativeToOther: $alternativeToOther, messageForOwner: $messageForOwner, communityId: $communityId)';
}


}

/// @nodoc
abstract mixin class _$LoanCreationRequestCopyWith<$Res> implements $LoanCreationRequestCopyWith<$Res> {
  factory _$LoanCreationRequestCopyWith(_LoanCreationRequest value, $Res Function(_LoanCreationRequest) _then) = __$LoanCreationRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'loanable_id') int loanableId,@JsonKey(name: 'borrower_user_id') int borrowerUserId,@JsonKey(name: 'departure_at') String departureAt,@JsonKey(name: 'duration_in_minutes') int durationInMinutes,@JsonKey(name: 'estimated_distance') int estimatedDistance,@JsonKey(name: 'alternative_to') String alternativeTo,@JsonKey(name: 'alternative_to_other') String? alternativeToOther,@JsonKey(name: 'message_for_owner') String? messageForOwner,@JsonKey(name: 'community_id') int? communityId
});




}
/// @nodoc
class __$LoanCreationRequestCopyWithImpl<$Res>
    implements _$LoanCreationRequestCopyWith<$Res> {
  __$LoanCreationRequestCopyWithImpl(this._self, this._then);

  final _LoanCreationRequest _self;
  final $Res Function(_LoanCreationRequest) _then;

/// Create a copy of LoanCreationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loanableId = null,Object? borrowerUserId = null,Object? departureAt = null,Object? durationInMinutes = null,Object? estimatedDistance = null,Object? alternativeTo = null,Object? alternativeToOther = freezed,Object? messageForOwner = freezed,Object? communityId = freezed,}) {
  return _then(_LoanCreationRequest(
loanableId: null == loanableId ? _self.loanableId : loanableId // ignore: cast_nullable_to_non_nullable
as int,borrowerUserId: null == borrowerUserId ? _self.borrowerUserId : borrowerUserId // ignore: cast_nullable_to_non_nullable
as int,departureAt: null == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as String,durationInMinutes: null == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int,estimatedDistance: null == estimatedDistance ? _self.estimatedDistance : estimatedDistance // ignore: cast_nullable_to_non_nullable
as int,alternativeTo: null == alternativeTo ? _self.alternativeTo : alternativeTo // ignore: cast_nullable_to_non_nullable
as String,alternativeToOther: freezed == alternativeToOther ? _self.alternativeToOther : alternativeToOther // ignore: cast_nullable_to_non_nullable
as String?,messageForOwner: freezed == messageForOwner ? _self.messageForOwner : messageForOwner // ignore: cast_nullable_to_non_nullable
as String?,communityId: freezed == communityId ? _self.communityId : communityId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

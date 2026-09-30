// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoanDraft {

 int get loanableId; String get loanableName; String get loanableType; int? get communityId; String? get communityName; String? get vehicleTimezone; int? get minLoanDurationInMinutes; int? get maxLoanDurationInMinutes;// Step 1: Schedule
 String? get departureDate;// yyyy-MM-dd in vehicle timezone
 String? get departureTime;// HH:mm in vehicle timezone
 int? get durationInMinutes;// Step 2: Trip details
 int? get estimatedDistance; TransportAlternative? get alternativeTo; String? get alternativeToOther; String? get messageForOwner;
/// Create a copy of LoanDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanDraftCopyWith<LoanDraft> get copyWith => _$LoanDraftCopyWithImpl<LoanDraft>(this as LoanDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanDraft&&(identical(other.loanableId, loanableId) || other.loanableId == loanableId)&&(identical(other.loanableName, loanableName) || other.loanableName == loanableName)&&(identical(other.loanableType, loanableType) || other.loanableType == loanableType)&&(identical(other.communityId, communityId) || other.communityId == communityId)&&(identical(other.communityName, communityName) || other.communityName == communityName)&&(identical(other.vehicleTimezone, vehicleTimezone) || other.vehicleTimezone == vehicleTimezone)&&(identical(other.minLoanDurationInMinutes, minLoanDurationInMinutes) || other.minLoanDurationInMinutes == minLoanDurationInMinutes)&&(identical(other.maxLoanDurationInMinutes, maxLoanDurationInMinutes) || other.maxLoanDurationInMinutes == maxLoanDurationInMinutes)&&(identical(other.departureDate, departureDate) || other.departureDate == departureDate)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&(identical(other.estimatedDistance, estimatedDistance) || other.estimatedDistance == estimatedDistance)&&(identical(other.alternativeTo, alternativeTo) || other.alternativeTo == alternativeTo)&&(identical(other.alternativeToOther, alternativeToOther) || other.alternativeToOther == alternativeToOther)&&(identical(other.messageForOwner, messageForOwner) || other.messageForOwner == messageForOwner));
}


@override
int get hashCode => Object.hash(runtimeType,loanableId,loanableName,loanableType,communityId,communityName,vehicleTimezone,minLoanDurationInMinutes,maxLoanDurationInMinutes,departureDate,departureTime,durationInMinutes,estimatedDistance,alternativeTo,alternativeToOther,messageForOwner);

@override
String toString() {
  return 'LoanDraft(loanableId: $loanableId, loanableName: $loanableName, loanableType: $loanableType, communityId: $communityId, communityName: $communityName, vehicleTimezone: $vehicleTimezone, minLoanDurationInMinutes: $minLoanDurationInMinutes, maxLoanDurationInMinutes: $maxLoanDurationInMinutes, departureDate: $departureDate, departureTime: $departureTime, durationInMinutes: $durationInMinutes, estimatedDistance: $estimatedDistance, alternativeTo: $alternativeTo, alternativeToOther: $alternativeToOther, messageForOwner: $messageForOwner)';
}


}

/// @nodoc
abstract mixin class $LoanDraftCopyWith<$Res>  {
  factory $LoanDraftCopyWith(LoanDraft value, $Res Function(LoanDraft) _then) = _$LoanDraftCopyWithImpl;
@useResult
$Res call({
 int loanableId, String loanableName, String loanableType, int? communityId, String? communityName, String? vehicleTimezone, int? minLoanDurationInMinutes, int? maxLoanDurationInMinutes, String? departureDate, String? departureTime, int? durationInMinutes, int? estimatedDistance, TransportAlternative? alternativeTo, String? alternativeToOther, String? messageForOwner
});




}
/// @nodoc
class _$LoanDraftCopyWithImpl<$Res>
    implements $LoanDraftCopyWith<$Res> {
  _$LoanDraftCopyWithImpl(this._self, this._then);

  final LoanDraft _self;
  final $Res Function(LoanDraft) _then;

/// Create a copy of LoanDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loanableId = null,Object? loanableName = null,Object? loanableType = null,Object? communityId = freezed,Object? communityName = freezed,Object? vehicleTimezone = freezed,Object? minLoanDurationInMinutes = freezed,Object? maxLoanDurationInMinutes = freezed,Object? departureDate = freezed,Object? departureTime = freezed,Object? durationInMinutes = freezed,Object? estimatedDistance = freezed,Object? alternativeTo = freezed,Object? alternativeToOther = freezed,Object? messageForOwner = freezed,}) {
  return _then(_self.copyWith(
loanableId: null == loanableId ? _self.loanableId : loanableId // ignore: cast_nullable_to_non_nullable
as int,loanableName: null == loanableName ? _self.loanableName : loanableName // ignore: cast_nullable_to_non_nullable
as String,loanableType: null == loanableType ? _self.loanableType : loanableType // ignore: cast_nullable_to_non_nullable
as String,communityId: freezed == communityId ? _self.communityId : communityId // ignore: cast_nullable_to_non_nullable
as int?,communityName: freezed == communityName ? _self.communityName : communityName // ignore: cast_nullable_to_non_nullable
as String?,vehicleTimezone: freezed == vehicleTimezone ? _self.vehicleTimezone : vehicleTimezone // ignore: cast_nullable_to_non_nullable
as String?,minLoanDurationInMinutes: freezed == minLoanDurationInMinutes ? _self.minLoanDurationInMinutes : minLoanDurationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,maxLoanDurationInMinutes: freezed == maxLoanDurationInMinutes ? _self.maxLoanDurationInMinutes : maxLoanDurationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,departureDate: freezed == departureDate ? _self.departureDate : departureDate // ignore: cast_nullable_to_non_nullable
as String?,departureTime: freezed == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String?,durationInMinutes: freezed == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,estimatedDistance: freezed == estimatedDistance ? _self.estimatedDistance : estimatedDistance // ignore: cast_nullable_to_non_nullable
as int?,alternativeTo: freezed == alternativeTo ? _self.alternativeTo : alternativeTo // ignore: cast_nullable_to_non_nullable
as TransportAlternative?,alternativeToOther: freezed == alternativeToOther ? _self.alternativeToOther : alternativeToOther // ignore: cast_nullable_to_non_nullable
as String?,messageForOwner: freezed == messageForOwner ? _self.messageForOwner : messageForOwner // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanDraft].
extension LoanDraftPatterns on LoanDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanDraft value)  $default,){
final _that = this;
switch (_that) {
case _LoanDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanDraft value)?  $default,){
final _that = this;
switch (_that) {
case _LoanDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int loanableId,  String loanableName,  String loanableType,  int? communityId,  String? communityName,  String? vehicleTimezone,  int? minLoanDurationInMinutes,  int? maxLoanDurationInMinutes,  String? departureDate,  String? departureTime,  int? durationInMinutes,  int? estimatedDistance,  TransportAlternative? alternativeTo,  String? alternativeToOther,  String? messageForOwner)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanDraft() when $default != null:
return $default(_that.loanableId,_that.loanableName,_that.loanableType,_that.communityId,_that.communityName,_that.vehicleTimezone,_that.minLoanDurationInMinutes,_that.maxLoanDurationInMinutes,_that.departureDate,_that.departureTime,_that.durationInMinutes,_that.estimatedDistance,_that.alternativeTo,_that.alternativeToOther,_that.messageForOwner);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int loanableId,  String loanableName,  String loanableType,  int? communityId,  String? communityName,  String? vehicleTimezone,  int? minLoanDurationInMinutes,  int? maxLoanDurationInMinutes,  String? departureDate,  String? departureTime,  int? durationInMinutes,  int? estimatedDistance,  TransportAlternative? alternativeTo,  String? alternativeToOther,  String? messageForOwner)  $default,) {final _that = this;
switch (_that) {
case _LoanDraft():
return $default(_that.loanableId,_that.loanableName,_that.loanableType,_that.communityId,_that.communityName,_that.vehicleTimezone,_that.minLoanDurationInMinutes,_that.maxLoanDurationInMinutes,_that.departureDate,_that.departureTime,_that.durationInMinutes,_that.estimatedDistance,_that.alternativeTo,_that.alternativeToOther,_that.messageForOwner);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int loanableId,  String loanableName,  String loanableType,  int? communityId,  String? communityName,  String? vehicleTimezone,  int? minLoanDurationInMinutes,  int? maxLoanDurationInMinutes,  String? departureDate,  String? departureTime,  int? durationInMinutes,  int? estimatedDistance,  TransportAlternative? alternativeTo,  String? alternativeToOther,  String? messageForOwner)?  $default,) {final _that = this;
switch (_that) {
case _LoanDraft() when $default != null:
return $default(_that.loanableId,_that.loanableName,_that.loanableType,_that.communityId,_that.communityName,_that.vehicleTimezone,_that.minLoanDurationInMinutes,_that.maxLoanDurationInMinutes,_that.departureDate,_that.departureTime,_that.durationInMinutes,_that.estimatedDistance,_that.alternativeTo,_that.alternativeToOther,_that.messageForOwner);case _:
  return null;

}
}

}

/// @nodoc


class _LoanDraft extends LoanDraft {
  const _LoanDraft({required this.loanableId, required this.loanableName, required this.loanableType, this.communityId, this.communityName, this.vehicleTimezone, this.minLoanDurationInMinutes, this.maxLoanDurationInMinutes, this.departureDate, this.departureTime, this.durationInMinutes, this.estimatedDistance, this.alternativeTo, this.alternativeToOther, this.messageForOwner}): super._();
  

@override final  int loanableId;
@override final  String loanableName;
@override final  String loanableType;
@override final  int? communityId;
@override final  String? communityName;
@override final  String? vehicleTimezone;
@override final  int? minLoanDurationInMinutes;
@override final  int? maxLoanDurationInMinutes;
// Step 1: Schedule
@override final  String? departureDate;
// yyyy-MM-dd in vehicle timezone
@override final  String? departureTime;
// HH:mm in vehicle timezone
@override final  int? durationInMinutes;
// Step 2: Trip details
@override final  int? estimatedDistance;
@override final  TransportAlternative? alternativeTo;
@override final  String? alternativeToOther;
@override final  String? messageForOwner;

/// Create a copy of LoanDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanDraftCopyWith<_LoanDraft> get copyWith => __$LoanDraftCopyWithImpl<_LoanDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanDraft&&(identical(other.loanableId, loanableId) || other.loanableId == loanableId)&&(identical(other.loanableName, loanableName) || other.loanableName == loanableName)&&(identical(other.loanableType, loanableType) || other.loanableType == loanableType)&&(identical(other.communityId, communityId) || other.communityId == communityId)&&(identical(other.communityName, communityName) || other.communityName == communityName)&&(identical(other.vehicleTimezone, vehicleTimezone) || other.vehicleTimezone == vehicleTimezone)&&(identical(other.minLoanDurationInMinutes, minLoanDurationInMinutes) || other.minLoanDurationInMinutes == minLoanDurationInMinutes)&&(identical(other.maxLoanDurationInMinutes, maxLoanDurationInMinutes) || other.maxLoanDurationInMinutes == maxLoanDurationInMinutes)&&(identical(other.departureDate, departureDate) || other.departureDate == departureDate)&&(identical(other.departureTime, departureTime) || other.departureTime == departureTime)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&(identical(other.estimatedDistance, estimatedDistance) || other.estimatedDistance == estimatedDistance)&&(identical(other.alternativeTo, alternativeTo) || other.alternativeTo == alternativeTo)&&(identical(other.alternativeToOther, alternativeToOther) || other.alternativeToOther == alternativeToOther)&&(identical(other.messageForOwner, messageForOwner) || other.messageForOwner == messageForOwner));
}


@override
int get hashCode => Object.hash(runtimeType,loanableId,loanableName,loanableType,communityId,communityName,vehicleTimezone,minLoanDurationInMinutes,maxLoanDurationInMinutes,departureDate,departureTime,durationInMinutes,estimatedDistance,alternativeTo,alternativeToOther,messageForOwner);

@override
String toString() {
  return 'LoanDraft(loanableId: $loanableId, loanableName: $loanableName, loanableType: $loanableType, communityId: $communityId, communityName: $communityName, vehicleTimezone: $vehicleTimezone, minLoanDurationInMinutes: $minLoanDurationInMinutes, maxLoanDurationInMinutes: $maxLoanDurationInMinutes, departureDate: $departureDate, departureTime: $departureTime, durationInMinutes: $durationInMinutes, estimatedDistance: $estimatedDistance, alternativeTo: $alternativeTo, alternativeToOther: $alternativeToOther, messageForOwner: $messageForOwner)';
}


}

/// @nodoc
abstract mixin class _$LoanDraftCopyWith<$Res> implements $LoanDraftCopyWith<$Res> {
  factory _$LoanDraftCopyWith(_LoanDraft value, $Res Function(_LoanDraft) _then) = __$LoanDraftCopyWithImpl;
@override @useResult
$Res call({
 int loanableId, String loanableName, String loanableType, int? communityId, String? communityName, String? vehicleTimezone, int? minLoanDurationInMinutes, int? maxLoanDurationInMinutes, String? departureDate, String? departureTime, int? durationInMinutes, int? estimatedDistance, TransportAlternative? alternativeTo, String? alternativeToOther, String? messageForOwner
});




}
/// @nodoc
class __$LoanDraftCopyWithImpl<$Res>
    implements _$LoanDraftCopyWith<$Res> {
  __$LoanDraftCopyWithImpl(this._self, this._then);

  final _LoanDraft _self;
  final $Res Function(_LoanDraft) _then;

/// Create a copy of LoanDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loanableId = null,Object? loanableName = null,Object? loanableType = null,Object? communityId = freezed,Object? communityName = freezed,Object? vehicleTimezone = freezed,Object? minLoanDurationInMinutes = freezed,Object? maxLoanDurationInMinutes = freezed,Object? departureDate = freezed,Object? departureTime = freezed,Object? durationInMinutes = freezed,Object? estimatedDistance = freezed,Object? alternativeTo = freezed,Object? alternativeToOther = freezed,Object? messageForOwner = freezed,}) {
  return _then(_LoanDraft(
loanableId: null == loanableId ? _self.loanableId : loanableId // ignore: cast_nullable_to_non_nullable
as int,loanableName: null == loanableName ? _self.loanableName : loanableName // ignore: cast_nullable_to_non_nullable
as String,loanableType: null == loanableType ? _self.loanableType : loanableType // ignore: cast_nullable_to_non_nullable
as String,communityId: freezed == communityId ? _self.communityId : communityId // ignore: cast_nullable_to_non_nullable
as int?,communityName: freezed == communityName ? _self.communityName : communityName // ignore: cast_nullable_to_non_nullable
as String?,vehicleTimezone: freezed == vehicleTimezone ? _self.vehicleTimezone : vehicleTimezone // ignore: cast_nullable_to_non_nullable
as String?,minLoanDurationInMinutes: freezed == minLoanDurationInMinutes ? _self.minLoanDurationInMinutes : minLoanDurationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,maxLoanDurationInMinutes: freezed == maxLoanDurationInMinutes ? _self.maxLoanDurationInMinutes : maxLoanDurationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,departureDate: freezed == departureDate ? _self.departureDate : departureDate // ignore: cast_nullable_to_non_nullable
as String?,departureTime: freezed == departureTime ? _self.departureTime : departureTime // ignore: cast_nullable_to_non_nullable
as String?,durationInMinutes: freezed == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,estimatedDistance: freezed == estimatedDistance ? _self.estimatedDistance : estimatedDistance // ignore: cast_nullable_to_non_nullable
as int?,alternativeTo: freezed == alternativeTo ? _self.alternativeTo : alternativeTo // ignore: cast_nullable_to_non_nullable
as TransportAlternative?,alternativeToOther: freezed == alternativeToOther ? _self.alternativeToOther : alternativeToOther // ignore: cast_nullable_to_non_nullable
as String?,messageForOwner: freezed == messageForOwner ? _self.messageForOwner : messageForOwner // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

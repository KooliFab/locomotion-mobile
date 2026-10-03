// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_breakdown.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentBreakdown {

@JsonKey(name: 'mandatory_contribution_cents') int get mandatoryContributionCents;@JsonKey(name: 'estimated_distance_cents') int get estimatedDistanceCents;@JsonKey(name: 'estimated_duration_cents') int get estimatedDurationCents;@JsonKey(name: 'taxes_tps_cents') int get taxesTpsCents;@JsonKey(name: 'taxes_tvq_cents') int get taxesTvqCents;@JsonKey(name: 'platform_tip_cents') int get platformTipCents;@JsonKey(name: 'total_estimated_contribution_cents') int get totalEstimatedContributionCents;@JsonKey(name: 'user_balance_applied_cents') int get userBalanceAppliedCents;@JsonKey(name: 'remaining_contribution_to_pay_cents') int get remainingContributionToPayCents;@JsonKey(name: 'security_deposit_cents') int get securityDepositCents;
/// Create a copy of PaymentBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentBreakdownCopyWith<PaymentBreakdown> get copyWith => _$PaymentBreakdownCopyWithImpl<PaymentBreakdown>(this as PaymentBreakdown, _$identity);

  /// Serializes this PaymentBreakdown to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentBreakdown&&(identical(other.mandatoryContributionCents, mandatoryContributionCents) || other.mandatoryContributionCents == mandatoryContributionCents)&&(identical(other.estimatedDistanceCents, estimatedDistanceCents) || other.estimatedDistanceCents == estimatedDistanceCents)&&(identical(other.estimatedDurationCents, estimatedDurationCents) || other.estimatedDurationCents == estimatedDurationCents)&&(identical(other.taxesTpsCents, taxesTpsCents) || other.taxesTpsCents == taxesTpsCents)&&(identical(other.taxesTvqCents, taxesTvqCents) || other.taxesTvqCents == taxesTvqCents)&&(identical(other.platformTipCents, platformTipCents) || other.platformTipCents == platformTipCents)&&(identical(other.totalEstimatedContributionCents, totalEstimatedContributionCents) || other.totalEstimatedContributionCents == totalEstimatedContributionCents)&&(identical(other.userBalanceAppliedCents, userBalanceAppliedCents) || other.userBalanceAppliedCents == userBalanceAppliedCents)&&(identical(other.remainingContributionToPayCents, remainingContributionToPayCents) || other.remainingContributionToPayCents == remainingContributionToPayCents)&&(identical(other.securityDepositCents, securityDepositCents) || other.securityDepositCents == securityDepositCents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mandatoryContributionCents,estimatedDistanceCents,estimatedDurationCents,taxesTpsCents,taxesTvqCents,platformTipCents,totalEstimatedContributionCents,userBalanceAppliedCents,remainingContributionToPayCents,securityDepositCents);

@override
String toString() {
  return 'PaymentBreakdown(mandatoryContributionCents: $mandatoryContributionCents, estimatedDistanceCents: $estimatedDistanceCents, estimatedDurationCents: $estimatedDurationCents, taxesTpsCents: $taxesTpsCents, taxesTvqCents: $taxesTvqCents, platformTipCents: $platformTipCents, totalEstimatedContributionCents: $totalEstimatedContributionCents, userBalanceAppliedCents: $userBalanceAppliedCents, remainingContributionToPayCents: $remainingContributionToPayCents, securityDepositCents: $securityDepositCents)';
}


}

/// @nodoc
abstract mixin class $PaymentBreakdownCopyWith<$Res>  {
  factory $PaymentBreakdownCopyWith(PaymentBreakdown value, $Res Function(PaymentBreakdown) _then) = _$PaymentBreakdownCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'mandatory_contribution_cents') int mandatoryContributionCents,@JsonKey(name: 'estimated_distance_cents') int estimatedDistanceCents,@JsonKey(name: 'estimated_duration_cents') int estimatedDurationCents,@JsonKey(name: 'taxes_tps_cents') int taxesTpsCents,@JsonKey(name: 'taxes_tvq_cents') int taxesTvqCents,@JsonKey(name: 'platform_tip_cents') int platformTipCents,@JsonKey(name: 'total_estimated_contribution_cents') int totalEstimatedContributionCents,@JsonKey(name: 'user_balance_applied_cents') int userBalanceAppliedCents,@JsonKey(name: 'remaining_contribution_to_pay_cents') int remainingContributionToPayCents,@JsonKey(name: 'security_deposit_cents') int securityDepositCents
});




}
/// @nodoc
class _$PaymentBreakdownCopyWithImpl<$Res>
    implements $PaymentBreakdownCopyWith<$Res> {
  _$PaymentBreakdownCopyWithImpl(this._self, this._then);

  final PaymentBreakdown _self;
  final $Res Function(PaymentBreakdown) _then;

/// Create a copy of PaymentBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mandatoryContributionCents = null,Object? estimatedDistanceCents = null,Object? estimatedDurationCents = null,Object? taxesTpsCents = null,Object? taxesTvqCents = null,Object? platformTipCents = null,Object? totalEstimatedContributionCents = null,Object? userBalanceAppliedCents = null,Object? remainingContributionToPayCents = null,Object? securityDepositCents = null,}) {
  return _then(_self.copyWith(
mandatoryContributionCents: null == mandatoryContributionCents ? _self.mandatoryContributionCents : mandatoryContributionCents // ignore: cast_nullable_to_non_nullable
as int,estimatedDistanceCents: null == estimatedDistanceCents ? _self.estimatedDistanceCents : estimatedDistanceCents // ignore: cast_nullable_to_non_nullable
as int,estimatedDurationCents: null == estimatedDurationCents ? _self.estimatedDurationCents : estimatedDurationCents // ignore: cast_nullable_to_non_nullable
as int,taxesTpsCents: null == taxesTpsCents ? _self.taxesTpsCents : taxesTpsCents // ignore: cast_nullable_to_non_nullable
as int,taxesTvqCents: null == taxesTvqCents ? _self.taxesTvqCents : taxesTvqCents // ignore: cast_nullable_to_non_nullable
as int,platformTipCents: null == platformTipCents ? _self.platformTipCents : platformTipCents // ignore: cast_nullable_to_non_nullable
as int,totalEstimatedContributionCents: null == totalEstimatedContributionCents ? _self.totalEstimatedContributionCents : totalEstimatedContributionCents // ignore: cast_nullable_to_non_nullable
as int,userBalanceAppliedCents: null == userBalanceAppliedCents ? _self.userBalanceAppliedCents : userBalanceAppliedCents // ignore: cast_nullable_to_non_nullable
as int,remainingContributionToPayCents: null == remainingContributionToPayCents ? _self.remainingContributionToPayCents : remainingContributionToPayCents // ignore: cast_nullable_to_non_nullable
as int,securityDepositCents: null == securityDepositCents ? _self.securityDepositCents : securityDepositCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentBreakdown].
extension PaymentBreakdownPatterns on PaymentBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _PaymentBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'mandatory_contribution_cents')  int mandatoryContributionCents, @JsonKey(name: 'estimated_distance_cents')  int estimatedDistanceCents, @JsonKey(name: 'estimated_duration_cents')  int estimatedDurationCents, @JsonKey(name: 'taxes_tps_cents')  int taxesTpsCents, @JsonKey(name: 'taxes_tvq_cents')  int taxesTvqCents, @JsonKey(name: 'platform_tip_cents')  int platformTipCents, @JsonKey(name: 'total_estimated_contribution_cents')  int totalEstimatedContributionCents, @JsonKey(name: 'user_balance_applied_cents')  int userBalanceAppliedCents, @JsonKey(name: 'remaining_contribution_to_pay_cents')  int remainingContributionToPayCents, @JsonKey(name: 'security_deposit_cents')  int securityDepositCents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentBreakdown() when $default != null:
return $default(_that.mandatoryContributionCents,_that.estimatedDistanceCents,_that.estimatedDurationCents,_that.taxesTpsCents,_that.taxesTvqCents,_that.platformTipCents,_that.totalEstimatedContributionCents,_that.userBalanceAppliedCents,_that.remainingContributionToPayCents,_that.securityDepositCents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'mandatory_contribution_cents')  int mandatoryContributionCents, @JsonKey(name: 'estimated_distance_cents')  int estimatedDistanceCents, @JsonKey(name: 'estimated_duration_cents')  int estimatedDurationCents, @JsonKey(name: 'taxes_tps_cents')  int taxesTpsCents, @JsonKey(name: 'taxes_tvq_cents')  int taxesTvqCents, @JsonKey(name: 'platform_tip_cents')  int platformTipCents, @JsonKey(name: 'total_estimated_contribution_cents')  int totalEstimatedContributionCents, @JsonKey(name: 'user_balance_applied_cents')  int userBalanceAppliedCents, @JsonKey(name: 'remaining_contribution_to_pay_cents')  int remainingContributionToPayCents, @JsonKey(name: 'security_deposit_cents')  int securityDepositCents)  $default,) {final _that = this;
switch (_that) {
case _PaymentBreakdown():
return $default(_that.mandatoryContributionCents,_that.estimatedDistanceCents,_that.estimatedDurationCents,_that.taxesTpsCents,_that.taxesTvqCents,_that.platformTipCents,_that.totalEstimatedContributionCents,_that.userBalanceAppliedCents,_that.remainingContributionToPayCents,_that.securityDepositCents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'mandatory_contribution_cents')  int mandatoryContributionCents, @JsonKey(name: 'estimated_distance_cents')  int estimatedDistanceCents, @JsonKey(name: 'estimated_duration_cents')  int estimatedDurationCents, @JsonKey(name: 'taxes_tps_cents')  int taxesTpsCents, @JsonKey(name: 'taxes_tvq_cents')  int taxesTvqCents, @JsonKey(name: 'platform_tip_cents')  int platformTipCents, @JsonKey(name: 'total_estimated_contribution_cents')  int totalEstimatedContributionCents, @JsonKey(name: 'user_balance_applied_cents')  int userBalanceAppliedCents, @JsonKey(name: 'remaining_contribution_to_pay_cents')  int remainingContributionToPayCents, @JsonKey(name: 'security_deposit_cents')  int securityDepositCents)?  $default,) {final _that = this;
switch (_that) {
case _PaymentBreakdown() when $default != null:
return $default(_that.mandatoryContributionCents,_that.estimatedDistanceCents,_that.estimatedDurationCents,_that.taxesTpsCents,_that.taxesTvqCents,_that.platformTipCents,_that.totalEstimatedContributionCents,_that.userBalanceAppliedCents,_that.remainingContributionToPayCents,_that.securityDepositCents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentBreakdown extends PaymentBreakdown {
  const _PaymentBreakdown({@JsonKey(name: 'mandatory_contribution_cents') this.mandatoryContributionCents = 0, @JsonKey(name: 'estimated_distance_cents') this.estimatedDistanceCents = 0, @JsonKey(name: 'estimated_duration_cents') this.estimatedDurationCents = 0, @JsonKey(name: 'taxes_tps_cents') this.taxesTpsCents = 0, @JsonKey(name: 'taxes_tvq_cents') this.taxesTvqCents = 0, @JsonKey(name: 'platform_tip_cents') this.platformTipCents = 0, @JsonKey(name: 'total_estimated_contribution_cents') this.totalEstimatedContributionCents = 0, @JsonKey(name: 'user_balance_applied_cents') this.userBalanceAppliedCents = 0, @JsonKey(name: 'remaining_contribution_to_pay_cents') this.remainingContributionToPayCents = 0, @JsonKey(name: 'security_deposit_cents') this.securityDepositCents = 0}): super._();
  factory _PaymentBreakdown.fromJson(Map<String, dynamic> json) => _$PaymentBreakdownFromJson(json);

@override@JsonKey(name: 'mandatory_contribution_cents') final  int mandatoryContributionCents;
@override@JsonKey(name: 'estimated_distance_cents') final  int estimatedDistanceCents;
@override@JsonKey(name: 'estimated_duration_cents') final  int estimatedDurationCents;
@override@JsonKey(name: 'taxes_tps_cents') final  int taxesTpsCents;
@override@JsonKey(name: 'taxes_tvq_cents') final  int taxesTvqCents;
@override@JsonKey(name: 'platform_tip_cents') final  int platformTipCents;
@override@JsonKey(name: 'total_estimated_contribution_cents') final  int totalEstimatedContributionCents;
@override@JsonKey(name: 'user_balance_applied_cents') final  int userBalanceAppliedCents;
@override@JsonKey(name: 'remaining_contribution_to_pay_cents') final  int remainingContributionToPayCents;
@override@JsonKey(name: 'security_deposit_cents') final  int securityDepositCents;

/// Create a copy of PaymentBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentBreakdownCopyWith<_PaymentBreakdown> get copyWith => __$PaymentBreakdownCopyWithImpl<_PaymentBreakdown>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentBreakdownToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentBreakdown&&(identical(other.mandatoryContributionCents, mandatoryContributionCents) || other.mandatoryContributionCents == mandatoryContributionCents)&&(identical(other.estimatedDistanceCents, estimatedDistanceCents) || other.estimatedDistanceCents == estimatedDistanceCents)&&(identical(other.estimatedDurationCents, estimatedDurationCents) || other.estimatedDurationCents == estimatedDurationCents)&&(identical(other.taxesTpsCents, taxesTpsCents) || other.taxesTpsCents == taxesTpsCents)&&(identical(other.taxesTvqCents, taxesTvqCents) || other.taxesTvqCents == taxesTvqCents)&&(identical(other.platformTipCents, platformTipCents) || other.platformTipCents == platformTipCents)&&(identical(other.totalEstimatedContributionCents, totalEstimatedContributionCents) || other.totalEstimatedContributionCents == totalEstimatedContributionCents)&&(identical(other.userBalanceAppliedCents, userBalanceAppliedCents) || other.userBalanceAppliedCents == userBalanceAppliedCents)&&(identical(other.remainingContributionToPayCents, remainingContributionToPayCents) || other.remainingContributionToPayCents == remainingContributionToPayCents)&&(identical(other.securityDepositCents, securityDepositCents) || other.securityDepositCents == securityDepositCents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mandatoryContributionCents,estimatedDistanceCents,estimatedDurationCents,taxesTpsCents,taxesTvqCents,platformTipCents,totalEstimatedContributionCents,userBalanceAppliedCents,remainingContributionToPayCents,securityDepositCents);

@override
String toString() {
  return 'PaymentBreakdown(mandatoryContributionCents: $mandatoryContributionCents, estimatedDistanceCents: $estimatedDistanceCents, estimatedDurationCents: $estimatedDurationCents, taxesTpsCents: $taxesTpsCents, taxesTvqCents: $taxesTvqCents, platformTipCents: $platformTipCents, totalEstimatedContributionCents: $totalEstimatedContributionCents, userBalanceAppliedCents: $userBalanceAppliedCents, remainingContributionToPayCents: $remainingContributionToPayCents, securityDepositCents: $securityDepositCents)';
}


}

/// @nodoc
abstract mixin class _$PaymentBreakdownCopyWith<$Res> implements $PaymentBreakdownCopyWith<$Res> {
  factory _$PaymentBreakdownCopyWith(_PaymentBreakdown value, $Res Function(_PaymentBreakdown) _then) = __$PaymentBreakdownCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'mandatory_contribution_cents') int mandatoryContributionCents,@JsonKey(name: 'estimated_distance_cents') int estimatedDistanceCents,@JsonKey(name: 'estimated_duration_cents') int estimatedDurationCents,@JsonKey(name: 'taxes_tps_cents') int taxesTpsCents,@JsonKey(name: 'taxes_tvq_cents') int taxesTvqCents,@JsonKey(name: 'platform_tip_cents') int platformTipCents,@JsonKey(name: 'total_estimated_contribution_cents') int totalEstimatedContributionCents,@JsonKey(name: 'user_balance_applied_cents') int userBalanceAppliedCents,@JsonKey(name: 'remaining_contribution_to_pay_cents') int remainingContributionToPayCents,@JsonKey(name: 'security_deposit_cents') int securityDepositCents
});




}
/// @nodoc
class __$PaymentBreakdownCopyWithImpl<$Res>
    implements _$PaymentBreakdownCopyWith<$Res> {
  __$PaymentBreakdownCopyWithImpl(this._self, this._then);

  final _PaymentBreakdown _self;
  final $Res Function(_PaymentBreakdown) _then;

/// Create a copy of PaymentBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mandatoryContributionCents = null,Object? estimatedDistanceCents = null,Object? estimatedDurationCents = null,Object? taxesTpsCents = null,Object? taxesTvqCents = null,Object? platformTipCents = null,Object? totalEstimatedContributionCents = null,Object? userBalanceAppliedCents = null,Object? remainingContributionToPayCents = null,Object? securityDepositCents = null,}) {
  return _then(_PaymentBreakdown(
mandatoryContributionCents: null == mandatoryContributionCents ? _self.mandatoryContributionCents : mandatoryContributionCents // ignore: cast_nullable_to_non_nullable
as int,estimatedDistanceCents: null == estimatedDistanceCents ? _self.estimatedDistanceCents : estimatedDistanceCents // ignore: cast_nullable_to_non_nullable
as int,estimatedDurationCents: null == estimatedDurationCents ? _self.estimatedDurationCents : estimatedDurationCents // ignore: cast_nullable_to_non_nullable
as int,taxesTpsCents: null == taxesTpsCents ? _self.taxesTpsCents : taxesTpsCents // ignore: cast_nullable_to_non_nullable
as int,taxesTvqCents: null == taxesTvqCents ? _self.taxesTvqCents : taxesTvqCents // ignore: cast_nullable_to_non_nullable
as int,platformTipCents: null == platformTipCents ? _self.platformTipCents : platformTipCents // ignore: cast_nullable_to_non_nullable
as int,totalEstimatedContributionCents: null == totalEstimatedContributionCents ? _self.totalEstimatedContributionCents : totalEstimatedContributionCents // ignore: cast_nullable_to_non_nullable
as int,userBalanceAppliedCents: null == userBalanceAppliedCents ? _self.userBalanceAppliedCents : userBalanceAppliedCents // ignore: cast_nullable_to_non_nullable
as int,remainingContributionToPayCents: null == remainingContributionToPayCents ? _self.remainingContributionToPayCents : remainingContributionToPayCents // ignore: cast_nullable_to_non_nullable
as int,securityDepositCents: null == securityDepositCents ? _self.securityDepositCents : securityDepositCents // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

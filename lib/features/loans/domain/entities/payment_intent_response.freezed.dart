// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_intent_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StripePaymentParams {

@JsonKey(name: 'customer_id') String get customerId;@JsonKey(name: 'ephemeral_key_secret') String get ephemeralKeySecret;@JsonKey(name: 'contribution_payment_intent_client_secret') String? get contributionPaymentIntentClientSecret;@JsonKey(name: 'deposit_payment_intent_client_secret') String? get depositPaymentIntentClientSecret;@JsonKey(name: 'publishable_key') String? get publishableKey;
/// Create a copy of StripePaymentParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StripePaymentParamsCopyWith<StripePaymentParams> get copyWith => _$StripePaymentParamsCopyWithImpl<StripePaymentParams>(this as StripePaymentParams, _$identity);

  /// Serializes this StripePaymentParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StripePaymentParams&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.ephemeralKeySecret, ephemeralKeySecret) || other.ephemeralKeySecret == ephemeralKeySecret)&&(identical(other.contributionPaymentIntentClientSecret, contributionPaymentIntentClientSecret) || other.contributionPaymentIntentClientSecret == contributionPaymentIntentClientSecret)&&(identical(other.depositPaymentIntentClientSecret, depositPaymentIntentClientSecret) || other.depositPaymentIntentClientSecret == depositPaymentIntentClientSecret)&&(identical(other.publishableKey, publishableKey) || other.publishableKey == publishableKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,customerId,ephemeralKeySecret,contributionPaymentIntentClientSecret,depositPaymentIntentClientSecret,publishableKey);

@override
String toString() {
  return 'StripePaymentParams(customerId: $customerId, ephemeralKeySecret: $ephemeralKeySecret, contributionPaymentIntentClientSecret: $contributionPaymentIntentClientSecret, depositPaymentIntentClientSecret: $depositPaymentIntentClientSecret, publishableKey: $publishableKey)';
}


}

/// @nodoc
abstract mixin class $StripePaymentParamsCopyWith<$Res>  {
  factory $StripePaymentParamsCopyWith(StripePaymentParams value, $Res Function(StripePaymentParams) _then) = _$StripePaymentParamsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'customer_id') String customerId,@JsonKey(name: 'ephemeral_key_secret') String ephemeralKeySecret,@JsonKey(name: 'contribution_payment_intent_client_secret') String? contributionPaymentIntentClientSecret,@JsonKey(name: 'deposit_payment_intent_client_secret') String? depositPaymentIntentClientSecret,@JsonKey(name: 'publishable_key') String? publishableKey
});




}
/// @nodoc
class _$StripePaymentParamsCopyWithImpl<$Res>
    implements $StripePaymentParamsCopyWith<$Res> {
  _$StripePaymentParamsCopyWithImpl(this._self, this._then);

  final StripePaymentParams _self;
  final $Res Function(StripePaymentParams) _then;

/// Create a copy of StripePaymentParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? customerId = null,Object? ephemeralKeySecret = null,Object? contributionPaymentIntentClientSecret = freezed,Object? depositPaymentIntentClientSecret = freezed,Object? publishableKey = freezed,}) {
  return _then(_self.copyWith(
customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,ephemeralKeySecret: null == ephemeralKeySecret ? _self.ephemeralKeySecret : ephemeralKeySecret // ignore: cast_nullable_to_non_nullable
as String,contributionPaymentIntentClientSecret: freezed == contributionPaymentIntentClientSecret ? _self.contributionPaymentIntentClientSecret : contributionPaymentIntentClientSecret // ignore: cast_nullable_to_non_nullable
as String?,depositPaymentIntentClientSecret: freezed == depositPaymentIntentClientSecret ? _self.depositPaymentIntentClientSecret : depositPaymentIntentClientSecret // ignore: cast_nullable_to_non_nullable
as String?,publishableKey: freezed == publishableKey ? _self.publishableKey : publishableKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StripePaymentParams].
extension StripePaymentParamsPatterns on StripePaymentParams {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StripePaymentParams value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StripePaymentParams() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StripePaymentParams value)  $default,){
final _that = this;
switch (_that) {
case _StripePaymentParams():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StripePaymentParams value)?  $default,){
final _that = this;
switch (_that) {
case _StripePaymentParams() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'ephemeral_key_secret')  String ephemeralKeySecret, @JsonKey(name: 'contribution_payment_intent_client_secret')  String? contributionPaymentIntentClientSecret, @JsonKey(name: 'deposit_payment_intent_client_secret')  String? depositPaymentIntentClientSecret, @JsonKey(name: 'publishable_key')  String? publishableKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StripePaymentParams() when $default != null:
return $default(_that.customerId,_that.ephemeralKeySecret,_that.contributionPaymentIntentClientSecret,_that.depositPaymentIntentClientSecret,_that.publishableKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'ephemeral_key_secret')  String ephemeralKeySecret, @JsonKey(name: 'contribution_payment_intent_client_secret')  String? contributionPaymentIntentClientSecret, @JsonKey(name: 'deposit_payment_intent_client_secret')  String? depositPaymentIntentClientSecret, @JsonKey(name: 'publishable_key')  String? publishableKey)  $default,) {final _that = this;
switch (_that) {
case _StripePaymentParams():
return $default(_that.customerId,_that.ephemeralKeySecret,_that.contributionPaymentIntentClientSecret,_that.depositPaymentIntentClientSecret,_that.publishableKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'ephemeral_key_secret')  String ephemeralKeySecret, @JsonKey(name: 'contribution_payment_intent_client_secret')  String? contributionPaymentIntentClientSecret, @JsonKey(name: 'deposit_payment_intent_client_secret')  String? depositPaymentIntentClientSecret, @JsonKey(name: 'publishable_key')  String? publishableKey)?  $default,) {final _that = this;
switch (_that) {
case _StripePaymentParams() when $default != null:
return $default(_that.customerId,_that.ephemeralKeySecret,_that.contributionPaymentIntentClientSecret,_that.depositPaymentIntentClientSecret,_that.publishableKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StripePaymentParams implements StripePaymentParams {
  const _StripePaymentParams({@JsonKey(name: 'customer_id') required this.customerId, @JsonKey(name: 'ephemeral_key_secret') required this.ephemeralKeySecret, @JsonKey(name: 'contribution_payment_intent_client_secret') this.contributionPaymentIntentClientSecret, @JsonKey(name: 'deposit_payment_intent_client_secret') this.depositPaymentIntentClientSecret, @JsonKey(name: 'publishable_key') this.publishableKey});
  factory _StripePaymentParams.fromJson(Map<String, dynamic> json) => _$StripePaymentParamsFromJson(json);

@override@JsonKey(name: 'customer_id') final  String customerId;
@override@JsonKey(name: 'ephemeral_key_secret') final  String ephemeralKeySecret;
@override@JsonKey(name: 'contribution_payment_intent_client_secret') final  String? contributionPaymentIntentClientSecret;
@override@JsonKey(name: 'deposit_payment_intent_client_secret') final  String? depositPaymentIntentClientSecret;
@override@JsonKey(name: 'publishable_key') final  String? publishableKey;

/// Create a copy of StripePaymentParams
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StripePaymentParamsCopyWith<_StripePaymentParams> get copyWith => __$StripePaymentParamsCopyWithImpl<_StripePaymentParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StripePaymentParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StripePaymentParams&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.ephemeralKeySecret, ephemeralKeySecret) || other.ephemeralKeySecret == ephemeralKeySecret)&&(identical(other.contributionPaymentIntentClientSecret, contributionPaymentIntentClientSecret) || other.contributionPaymentIntentClientSecret == contributionPaymentIntentClientSecret)&&(identical(other.depositPaymentIntentClientSecret, depositPaymentIntentClientSecret) || other.depositPaymentIntentClientSecret == depositPaymentIntentClientSecret)&&(identical(other.publishableKey, publishableKey) || other.publishableKey == publishableKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,customerId,ephemeralKeySecret,contributionPaymentIntentClientSecret,depositPaymentIntentClientSecret,publishableKey);

@override
String toString() {
  return 'StripePaymentParams(customerId: $customerId, ephemeralKeySecret: $ephemeralKeySecret, contributionPaymentIntentClientSecret: $contributionPaymentIntentClientSecret, depositPaymentIntentClientSecret: $depositPaymentIntentClientSecret, publishableKey: $publishableKey)';
}


}

/// @nodoc
abstract mixin class _$StripePaymentParamsCopyWith<$Res> implements $StripePaymentParamsCopyWith<$Res> {
  factory _$StripePaymentParamsCopyWith(_StripePaymentParams value, $Res Function(_StripePaymentParams) _then) = __$StripePaymentParamsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'customer_id') String customerId,@JsonKey(name: 'ephemeral_key_secret') String ephemeralKeySecret,@JsonKey(name: 'contribution_payment_intent_client_secret') String? contributionPaymentIntentClientSecret,@JsonKey(name: 'deposit_payment_intent_client_secret') String? depositPaymentIntentClientSecret,@JsonKey(name: 'publishable_key') String? publishableKey
});




}
/// @nodoc
class __$StripePaymentParamsCopyWithImpl<$Res>
    implements _$StripePaymentParamsCopyWith<$Res> {
  __$StripePaymentParamsCopyWithImpl(this._self, this._then);

  final _StripePaymentParams _self;
  final $Res Function(_StripePaymentParams) _then;

/// Create a copy of StripePaymentParams
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? customerId = null,Object? ephemeralKeySecret = null,Object? contributionPaymentIntentClientSecret = freezed,Object? depositPaymentIntentClientSecret = freezed,Object? publishableKey = freezed,}) {
  return _then(_StripePaymentParams(
customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,ephemeralKeySecret: null == ephemeralKeySecret ? _self.ephemeralKeySecret : ephemeralKeySecret // ignore: cast_nullable_to_non_nullable
as String,contributionPaymentIntentClientSecret: freezed == contributionPaymentIntentClientSecret ? _self.contributionPaymentIntentClientSecret : contributionPaymentIntentClientSecret // ignore: cast_nullable_to_non_nullable
as String?,depositPaymentIntentClientSecret: freezed == depositPaymentIntentClientSecret ? _self.depositPaymentIntentClientSecret : depositPaymentIntentClientSecret // ignore: cast_nullable_to_non_nullable
as String?,publishableKey: freezed == publishableKey ? _self.publishableKey : publishableKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PaymentIntentResponse {

@JsonKey(name: 'loan_id') int get loanId;@JsonKey(name: 'currency') String get currency;@JsonKey(name: 'financial_breakdown') PaymentBreakdown get financialBreakdown;@JsonKey(name: 'requires_stripe_action') bool get requiresStripeAction;@JsonKey(name: 'stripe') StripePaymentParams? get stripe;
/// Create a copy of PaymentIntentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentIntentResponseCopyWith<PaymentIntentResponse> get copyWith => _$PaymentIntentResponseCopyWithImpl<PaymentIntentResponse>(this as PaymentIntentResponse, _$identity);

  /// Serializes this PaymentIntentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentIntentResponse&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.financialBreakdown, financialBreakdown) || other.financialBreakdown == financialBreakdown)&&(identical(other.requiresStripeAction, requiresStripeAction) || other.requiresStripeAction == requiresStripeAction)&&(identical(other.stripe, stripe) || other.stripe == stripe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,loanId,currency,financialBreakdown,requiresStripeAction,stripe);

@override
String toString() {
  return 'PaymentIntentResponse(loanId: $loanId, currency: $currency, financialBreakdown: $financialBreakdown, requiresStripeAction: $requiresStripeAction, stripe: $stripe)';
}


}

/// @nodoc
abstract mixin class $PaymentIntentResponseCopyWith<$Res>  {
  factory $PaymentIntentResponseCopyWith(PaymentIntentResponse value, $Res Function(PaymentIntentResponse) _then) = _$PaymentIntentResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'loan_id') int loanId,@JsonKey(name: 'currency') String currency,@JsonKey(name: 'financial_breakdown') PaymentBreakdown financialBreakdown,@JsonKey(name: 'requires_stripe_action') bool requiresStripeAction,@JsonKey(name: 'stripe') StripePaymentParams? stripe
});


$PaymentBreakdownCopyWith<$Res> get financialBreakdown;$StripePaymentParamsCopyWith<$Res>? get stripe;

}
/// @nodoc
class _$PaymentIntentResponseCopyWithImpl<$Res>
    implements $PaymentIntentResponseCopyWith<$Res> {
  _$PaymentIntentResponseCopyWithImpl(this._self, this._then);

  final PaymentIntentResponse _self;
  final $Res Function(PaymentIntentResponse) _then;

/// Create a copy of PaymentIntentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loanId = null,Object? currency = null,Object? financialBreakdown = null,Object? requiresStripeAction = null,Object? stripe = freezed,}) {
  return _then(_self.copyWith(
loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,financialBreakdown: null == financialBreakdown ? _self.financialBreakdown : financialBreakdown // ignore: cast_nullable_to_non_nullable
as PaymentBreakdown,requiresStripeAction: null == requiresStripeAction ? _self.requiresStripeAction : requiresStripeAction // ignore: cast_nullable_to_non_nullable
as bool,stripe: freezed == stripe ? _self.stripe : stripe // ignore: cast_nullable_to_non_nullable
as StripePaymentParams?,
  ));
}
/// Create a copy of PaymentIntentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentBreakdownCopyWith<$Res> get financialBreakdown {
  
  return $PaymentBreakdownCopyWith<$Res>(_self.financialBreakdown, (value) {
    return _then(_self.copyWith(financialBreakdown: value));
  });
}/// Create a copy of PaymentIntentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StripePaymentParamsCopyWith<$Res>? get stripe {
    if (_self.stripe == null) {
    return null;
  }

  return $StripePaymentParamsCopyWith<$Res>(_self.stripe!, (value) {
    return _then(_self.copyWith(stripe: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaymentIntentResponse].
extension PaymentIntentResponsePatterns on PaymentIntentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentIntentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentIntentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentIntentResponse value)  $default,){
final _that = this;
switch (_that) {
case _PaymentIntentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentIntentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentIntentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'loan_id')  int loanId, @JsonKey(name: 'currency')  String currency, @JsonKey(name: 'financial_breakdown')  PaymentBreakdown financialBreakdown, @JsonKey(name: 'requires_stripe_action')  bool requiresStripeAction, @JsonKey(name: 'stripe')  StripePaymentParams? stripe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentIntentResponse() when $default != null:
return $default(_that.loanId,_that.currency,_that.financialBreakdown,_that.requiresStripeAction,_that.stripe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'loan_id')  int loanId, @JsonKey(name: 'currency')  String currency, @JsonKey(name: 'financial_breakdown')  PaymentBreakdown financialBreakdown, @JsonKey(name: 'requires_stripe_action')  bool requiresStripeAction, @JsonKey(name: 'stripe')  StripePaymentParams? stripe)  $default,) {final _that = this;
switch (_that) {
case _PaymentIntentResponse():
return $default(_that.loanId,_that.currency,_that.financialBreakdown,_that.requiresStripeAction,_that.stripe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'loan_id')  int loanId, @JsonKey(name: 'currency')  String currency, @JsonKey(name: 'financial_breakdown')  PaymentBreakdown financialBreakdown, @JsonKey(name: 'requires_stripe_action')  bool requiresStripeAction, @JsonKey(name: 'stripe')  StripePaymentParams? stripe)?  $default,) {final _that = this;
switch (_that) {
case _PaymentIntentResponse() when $default != null:
return $default(_that.loanId,_that.currency,_that.financialBreakdown,_that.requiresStripeAction,_that.stripe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentIntentResponse extends PaymentIntentResponse {
  const _PaymentIntentResponse({@JsonKey(name: 'loan_id') required this.loanId, @JsonKey(name: 'currency') this.currency = 'CAD', @JsonKey(name: 'financial_breakdown') required this.financialBreakdown, @JsonKey(name: 'requires_stripe_action') this.requiresStripeAction = false, @JsonKey(name: 'stripe') this.stripe}): super._();
  factory _PaymentIntentResponse.fromJson(Map<String, dynamic> json) => _$PaymentIntentResponseFromJson(json);

@override@JsonKey(name: 'loan_id') final  int loanId;
@override@JsonKey(name: 'currency') final  String currency;
@override@JsonKey(name: 'financial_breakdown') final  PaymentBreakdown financialBreakdown;
@override@JsonKey(name: 'requires_stripe_action') final  bool requiresStripeAction;
@override@JsonKey(name: 'stripe') final  StripePaymentParams? stripe;

/// Create a copy of PaymentIntentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentIntentResponseCopyWith<_PaymentIntentResponse> get copyWith => __$PaymentIntentResponseCopyWithImpl<_PaymentIntentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentIntentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentIntentResponse&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.financialBreakdown, financialBreakdown) || other.financialBreakdown == financialBreakdown)&&(identical(other.requiresStripeAction, requiresStripeAction) || other.requiresStripeAction == requiresStripeAction)&&(identical(other.stripe, stripe) || other.stripe == stripe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,loanId,currency,financialBreakdown,requiresStripeAction,stripe);

@override
String toString() {
  return 'PaymentIntentResponse(loanId: $loanId, currency: $currency, financialBreakdown: $financialBreakdown, requiresStripeAction: $requiresStripeAction, stripe: $stripe)';
}


}

/// @nodoc
abstract mixin class _$PaymentIntentResponseCopyWith<$Res> implements $PaymentIntentResponseCopyWith<$Res> {
  factory _$PaymentIntentResponseCopyWith(_PaymentIntentResponse value, $Res Function(_PaymentIntentResponse) _then) = __$PaymentIntentResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'loan_id') int loanId,@JsonKey(name: 'currency') String currency,@JsonKey(name: 'financial_breakdown') PaymentBreakdown financialBreakdown,@JsonKey(name: 'requires_stripe_action') bool requiresStripeAction,@JsonKey(name: 'stripe') StripePaymentParams? stripe
});


@override $PaymentBreakdownCopyWith<$Res> get financialBreakdown;@override $StripePaymentParamsCopyWith<$Res>? get stripe;

}
/// @nodoc
class __$PaymentIntentResponseCopyWithImpl<$Res>
    implements _$PaymentIntentResponseCopyWith<$Res> {
  __$PaymentIntentResponseCopyWithImpl(this._self, this._then);

  final _PaymentIntentResponse _self;
  final $Res Function(_PaymentIntentResponse) _then;

/// Create a copy of PaymentIntentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loanId = null,Object? currency = null,Object? financialBreakdown = null,Object? requiresStripeAction = null,Object? stripe = freezed,}) {
  return _then(_PaymentIntentResponse(
loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,financialBreakdown: null == financialBreakdown ? _self.financialBreakdown : financialBreakdown // ignore: cast_nullable_to_non_nullable
as PaymentBreakdown,requiresStripeAction: null == requiresStripeAction ? _self.requiresStripeAction : requiresStripeAction // ignore: cast_nullable_to_non_nullable
as bool,stripe: freezed == stripe ? _self.stripe : stripe // ignore: cast_nullable_to_non_nullable
as StripePaymentParams?,
  ));
}

/// Create a copy of PaymentIntentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaymentBreakdownCopyWith<$Res> get financialBreakdown {
  
  return $PaymentBreakdownCopyWith<$Res>(_self.financialBreakdown, (value) {
    return _then(_self.copyWith(financialBreakdown: value));
  });
}/// Create a copy of PaymentIntentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StripePaymentParamsCopyWith<$Res>? get stripe {
    if (_self.stripe == null) {
    return null;
  }

  return $StripePaymentParamsCopyWith<$Res>(_self.stripe!, (value) {
    return _then(_self.copyWith(stripe: value));
  });
}
}

// dart format on

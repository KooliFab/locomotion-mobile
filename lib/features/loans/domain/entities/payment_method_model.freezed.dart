// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_method_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentMethodModel {

 int get id;@JsonKey(name: 'credit_card_type') String get creditCardType;@JsonKey(name: 'four_last_digits') String get fourLastDigits;@JsonKey(name: 'country') String? get country;@JsonKey(name: 'name') String? get name;@JsonKey(name: 'is_default') bool get isDefault;@JsonKey(name: 'user_id') int? get userId;
/// Create a copy of PaymentMethodModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentMethodModelCopyWith<PaymentMethodModel> get copyWith => _$PaymentMethodModelCopyWithImpl<PaymentMethodModel>(this as PaymentMethodModel, _$identity);

  /// Serializes this PaymentMethodModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentMethodModel&&(identical(other.id, id) || other.id == id)&&(identical(other.creditCardType, creditCardType) || other.creditCardType == creditCardType)&&(identical(other.fourLastDigits, fourLastDigits) || other.fourLastDigits == fourLastDigits)&&(identical(other.country, country) || other.country == country)&&(identical(other.name, name) || other.name == name)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,creditCardType,fourLastDigits,country,name,isDefault,userId);

@override
String toString() {
  return 'PaymentMethodModel(id: $id, creditCardType: $creditCardType, fourLastDigits: $fourLastDigits, country: $country, name: $name, isDefault: $isDefault, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $PaymentMethodModelCopyWith<$Res>  {
  factory $PaymentMethodModelCopyWith(PaymentMethodModel value, $Res Function(PaymentMethodModel) _then) = _$PaymentMethodModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'credit_card_type') String creditCardType,@JsonKey(name: 'four_last_digits') String fourLastDigits,@JsonKey(name: 'country') String? country,@JsonKey(name: 'name') String? name,@JsonKey(name: 'is_default') bool isDefault,@JsonKey(name: 'user_id') int? userId
});




}
/// @nodoc
class _$PaymentMethodModelCopyWithImpl<$Res>
    implements $PaymentMethodModelCopyWith<$Res> {
  _$PaymentMethodModelCopyWithImpl(this._self, this._then);

  final PaymentMethodModel _self;
  final $Res Function(PaymentMethodModel) _then;

/// Create a copy of PaymentMethodModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? creditCardType = null,Object? fourLastDigits = null,Object? country = freezed,Object? name = freezed,Object? isDefault = null,Object? userId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,creditCardType: null == creditCardType ? _self.creditCardType : creditCardType // ignore: cast_nullable_to_non_nullable
as String,fourLastDigits: null == fourLastDigits ? _self.fourLastDigits : fourLastDigits // ignore: cast_nullable_to_non_nullable
as String,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentMethodModel].
extension PaymentMethodModelPatterns on PaymentMethodModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentMethodModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentMethodModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentMethodModel value)  $default,){
final _that = this;
switch (_that) {
case _PaymentMethodModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentMethodModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentMethodModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'credit_card_type')  String creditCardType, @JsonKey(name: 'four_last_digits')  String fourLastDigits, @JsonKey(name: 'country')  String? country, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'is_default')  bool isDefault, @JsonKey(name: 'user_id')  int? userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentMethodModel() when $default != null:
return $default(_that.id,_that.creditCardType,_that.fourLastDigits,_that.country,_that.name,_that.isDefault,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'credit_card_type')  String creditCardType, @JsonKey(name: 'four_last_digits')  String fourLastDigits, @JsonKey(name: 'country')  String? country, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'is_default')  bool isDefault, @JsonKey(name: 'user_id')  int? userId)  $default,) {final _that = this;
switch (_that) {
case _PaymentMethodModel():
return $default(_that.id,_that.creditCardType,_that.fourLastDigits,_that.country,_that.name,_that.isDefault,_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'credit_card_type')  String creditCardType, @JsonKey(name: 'four_last_digits')  String fourLastDigits, @JsonKey(name: 'country')  String? country, @JsonKey(name: 'name')  String? name, @JsonKey(name: 'is_default')  bool isDefault, @JsonKey(name: 'user_id')  int? userId)?  $default,) {final _that = this;
switch (_that) {
case _PaymentMethodModel() when $default != null:
return $default(_that.id,_that.creditCardType,_that.fourLastDigits,_that.country,_that.name,_that.isDefault,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentMethodModel extends PaymentMethodModel {
  const _PaymentMethodModel({required this.id, @JsonKey(name: 'credit_card_type') required this.creditCardType, @JsonKey(name: 'four_last_digits') required this.fourLastDigits, @JsonKey(name: 'country') this.country, @JsonKey(name: 'name') this.name, @JsonKey(name: 'is_default') this.isDefault = false, @JsonKey(name: 'user_id') this.userId}): super._();
  factory _PaymentMethodModel.fromJson(Map<String, dynamic> json) => _$PaymentMethodModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'credit_card_type') final  String creditCardType;
@override@JsonKey(name: 'four_last_digits') final  String fourLastDigits;
@override@JsonKey(name: 'country') final  String? country;
@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'is_default') final  bool isDefault;
@override@JsonKey(name: 'user_id') final  int? userId;

/// Create a copy of PaymentMethodModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentMethodModelCopyWith<_PaymentMethodModel> get copyWith => __$PaymentMethodModelCopyWithImpl<_PaymentMethodModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentMethodModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentMethodModel&&(identical(other.id, id) || other.id == id)&&(identical(other.creditCardType, creditCardType) || other.creditCardType == creditCardType)&&(identical(other.fourLastDigits, fourLastDigits) || other.fourLastDigits == fourLastDigits)&&(identical(other.country, country) || other.country == country)&&(identical(other.name, name) || other.name == name)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,creditCardType,fourLastDigits,country,name,isDefault,userId);

@override
String toString() {
  return 'PaymentMethodModel(id: $id, creditCardType: $creditCardType, fourLastDigits: $fourLastDigits, country: $country, name: $name, isDefault: $isDefault, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$PaymentMethodModelCopyWith<$Res> implements $PaymentMethodModelCopyWith<$Res> {
  factory _$PaymentMethodModelCopyWith(_PaymentMethodModel value, $Res Function(_PaymentMethodModel) _then) = __$PaymentMethodModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'credit_card_type') String creditCardType,@JsonKey(name: 'four_last_digits') String fourLastDigits,@JsonKey(name: 'country') String? country,@JsonKey(name: 'name') String? name,@JsonKey(name: 'is_default') bool isDefault,@JsonKey(name: 'user_id') int? userId
});




}
/// @nodoc
class __$PaymentMethodModelCopyWithImpl<$Res>
    implements _$PaymentMethodModelCopyWith<$Res> {
  __$PaymentMethodModelCopyWithImpl(this._self, this._then);

  final _PaymentMethodModel _self;
  final $Res Function(_PaymentMethodModel) _then;

/// Create a copy of PaymentMethodModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? creditCardType = null,Object? fourLastDigits = null,Object? country = freezed,Object? name = freezed,Object? isDefault = null,Object? userId = freezed,}) {
  return _then(_PaymentMethodModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,creditCardType: null == creditCardType ? _self.creditCardType : creditCardType // ignore: cast_nullable_to_non_nullable
as String,fourLastDigits: null == fourLastDigits ? _self.fourLastDigits : fourLastDigits // ignore: cast_nullable_to_non_nullable
as String,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

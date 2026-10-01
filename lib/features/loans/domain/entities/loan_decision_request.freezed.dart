// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_decision_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoanDecisionRequest {

/// Optional comment sent when accepting or rejecting a loan.
@JsonKey(includeIfNull: false) String? get comment;
/// Create a copy of LoanDecisionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanDecisionRequestCopyWith<LoanDecisionRequest> get copyWith => _$LoanDecisionRequestCopyWithImpl<LoanDecisionRequest>(this as LoanDecisionRequest, _$identity);

  /// Serializes this LoanDecisionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanDecisionRequest&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,comment);

@override
String toString() {
  return 'LoanDecisionRequest(comment: $comment)';
}


}

/// @nodoc
abstract mixin class $LoanDecisionRequestCopyWith<$Res>  {
  factory $LoanDecisionRequestCopyWith(LoanDecisionRequest value, $Res Function(LoanDecisionRequest) _then) = _$LoanDecisionRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) String? comment
});




}
/// @nodoc
class _$LoanDecisionRequestCopyWithImpl<$Res>
    implements $LoanDecisionRequestCopyWith<$Res> {
  _$LoanDecisionRequestCopyWithImpl(this._self, this._then);

  final LoanDecisionRequest _self;
  final $Res Function(LoanDecisionRequest) _then;

/// Create a copy of LoanDecisionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? comment = freezed,}) {
  return _then(_self.copyWith(
comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanDecisionRequest].
extension LoanDecisionRequestPatterns on LoanDecisionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanDecisionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanDecisionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanDecisionRequest value)  $default,){
final _that = this;
switch (_that) {
case _LoanDecisionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanDecisionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LoanDecisionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanDecisionRequest() when $default != null:
return $default(_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? comment)  $default,) {final _that = this;
switch (_that) {
case _LoanDecisionRequest():
return $default(_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _LoanDecisionRequest() when $default != null:
return $default(_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoanDecisionRequest extends LoanDecisionRequest {
  const _LoanDecisionRequest({@JsonKey(includeIfNull: false) this.comment}): super._();
  factory _LoanDecisionRequest.fromJson(Map<String, dynamic> json) => _$LoanDecisionRequestFromJson(json);

/// Optional comment sent when accepting or rejecting a loan.
@override@JsonKey(includeIfNull: false) final  String? comment;

/// Create a copy of LoanDecisionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanDecisionRequestCopyWith<_LoanDecisionRequest> get copyWith => __$LoanDecisionRequestCopyWithImpl<_LoanDecisionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoanDecisionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanDecisionRequest&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,comment);

@override
String toString() {
  return 'LoanDecisionRequest(comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$LoanDecisionRequestCopyWith<$Res> implements $LoanDecisionRequestCopyWith<$Res> {
  factory _$LoanDecisionRequestCopyWith(_LoanDecisionRequest value, $Res Function(_LoanDecisionRequest) _then) = __$LoanDecisionRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) String? comment
});




}
/// @nodoc
class __$LoanDecisionRequestCopyWithImpl<$Res>
    implements _$LoanDecisionRequestCopyWith<$Res> {
  __$LoanDecisionRequestCopyWithImpl(this._self, this._then);

  final _LoanDecisionRequest _self;
  final $Res Function(_LoanDecisionRequest) _then;

/// Create a copy of LoanDecisionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? comment = freezed,}) {
  return _then(_LoanDecisionRequest(
comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

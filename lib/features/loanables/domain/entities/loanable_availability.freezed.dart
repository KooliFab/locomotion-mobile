// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loanable_availability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoanableAvailabilityInterval {

 String get type; DateTime get start; DateTime get end; bool get isAvailable; String? get rawStart; String? get rawEnd;
/// Create a copy of LoanableAvailabilityInterval
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanableAvailabilityIntervalCopyWith<LoanableAvailabilityInterval> get copyWith => _$LoanableAvailabilityIntervalCopyWithImpl<LoanableAvailabilityInterval>(this as LoanableAvailabilityInterval, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanableAvailabilityInterval&&(identical(other.type, type) || other.type == type)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.rawStart, rawStart) || other.rawStart == rawStart)&&(identical(other.rawEnd, rawEnd) || other.rawEnd == rawEnd));
}


@override
int get hashCode => Object.hash(runtimeType,type,start,end,isAvailable,rawStart,rawEnd);

@override
String toString() {
  return 'LoanableAvailabilityInterval(type: $type, start: $start, end: $end, isAvailable: $isAvailable, rawStart: $rawStart, rawEnd: $rawEnd)';
}


}

/// @nodoc
abstract mixin class $LoanableAvailabilityIntervalCopyWith<$Res>  {
  factory $LoanableAvailabilityIntervalCopyWith(LoanableAvailabilityInterval value, $Res Function(LoanableAvailabilityInterval) _then) = _$LoanableAvailabilityIntervalCopyWithImpl;
@useResult
$Res call({
 String type, DateTime start, DateTime end, bool isAvailable, String? rawStart, String? rawEnd
});




}
/// @nodoc
class _$LoanableAvailabilityIntervalCopyWithImpl<$Res>
    implements $LoanableAvailabilityIntervalCopyWith<$Res> {
  _$LoanableAvailabilityIntervalCopyWithImpl(this._self, this._then);

  final LoanableAvailabilityInterval _self;
  final $Res Function(LoanableAvailabilityInterval) _then;

/// Create a copy of LoanableAvailabilityInterval
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? start = null,Object? end = null,Object? isAvailable = null,Object? rawStart = freezed,Object? rawEnd = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,rawStart: freezed == rawStart ? _self.rawStart : rawStart // ignore: cast_nullable_to_non_nullable
as String?,rawEnd: freezed == rawEnd ? _self.rawEnd : rawEnd // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanableAvailabilityInterval].
extension LoanableAvailabilityIntervalPatterns on LoanableAvailabilityInterval {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanableAvailabilityInterval value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanableAvailabilityInterval() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanableAvailabilityInterval value)  $default,){
final _that = this;
switch (_that) {
case _LoanableAvailabilityInterval():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanableAvailabilityInterval value)?  $default,){
final _that = this;
switch (_that) {
case _LoanableAvailabilityInterval() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  DateTime start,  DateTime end,  bool isAvailable,  String? rawStart,  String? rawEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanableAvailabilityInterval() when $default != null:
return $default(_that.type,_that.start,_that.end,_that.isAvailable,_that.rawStart,_that.rawEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  DateTime start,  DateTime end,  bool isAvailable,  String? rawStart,  String? rawEnd)  $default,) {final _that = this;
switch (_that) {
case _LoanableAvailabilityInterval():
return $default(_that.type,_that.start,_that.end,_that.isAvailable,_that.rawStart,_that.rawEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  DateTime start,  DateTime end,  bool isAvailable,  String? rawStart,  String? rawEnd)?  $default,) {final _that = this;
switch (_that) {
case _LoanableAvailabilityInterval() when $default != null:
return $default(_that.type,_that.start,_that.end,_that.isAvailable,_that.rawStart,_that.rawEnd);case _:
  return null;

}
}

}

/// @nodoc


class _LoanableAvailabilityInterval extends LoanableAvailabilityInterval {
  const _LoanableAvailabilityInterval({required this.type, required this.start, required this.end, required this.isAvailable, this.rawStart, this.rawEnd}): super._();
  

@override final  String type;
@override final  DateTime start;
@override final  DateTime end;
@override final  bool isAvailable;
@override final  String? rawStart;
@override final  String? rawEnd;

/// Create a copy of LoanableAvailabilityInterval
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanableAvailabilityIntervalCopyWith<_LoanableAvailabilityInterval> get copyWith => __$LoanableAvailabilityIntervalCopyWithImpl<_LoanableAvailabilityInterval>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanableAvailabilityInterval&&(identical(other.type, type) || other.type == type)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.rawStart, rawStart) || other.rawStart == rawStart)&&(identical(other.rawEnd, rawEnd) || other.rawEnd == rawEnd));
}


@override
int get hashCode => Object.hash(runtimeType,type,start,end,isAvailable,rawStart,rawEnd);

@override
String toString() {
  return 'LoanableAvailabilityInterval(type: $type, start: $start, end: $end, isAvailable: $isAvailable, rawStart: $rawStart, rawEnd: $rawEnd)';
}


}

/// @nodoc
abstract mixin class _$LoanableAvailabilityIntervalCopyWith<$Res> implements $LoanableAvailabilityIntervalCopyWith<$Res> {
  factory _$LoanableAvailabilityIntervalCopyWith(_LoanableAvailabilityInterval value, $Res Function(_LoanableAvailabilityInterval) _then) = __$LoanableAvailabilityIntervalCopyWithImpl;
@override @useResult
$Res call({
 String type, DateTime start, DateTime end, bool isAvailable, String? rawStart, String? rawEnd
});




}
/// @nodoc
class __$LoanableAvailabilityIntervalCopyWithImpl<$Res>
    implements _$LoanableAvailabilityIntervalCopyWith<$Res> {
  __$LoanableAvailabilityIntervalCopyWithImpl(this._self, this._then);

  final _LoanableAvailabilityInterval _self;
  final $Res Function(_LoanableAvailabilityInterval) _then;

/// Create a copy of LoanableAvailabilityInterval
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? start = null,Object? end = null,Object? isAvailable = null,Object? rawStart = freezed,Object? rawEnd = freezed,}) {
  return _then(_LoanableAvailabilityInterval(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,rawStart: freezed == rawStart ? _self.rawStart : rawStart // ignore: cast_nullable_to_non_nullable
as String?,rawEnd: freezed == rawEnd ? _self.rawEnd : rawEnd // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

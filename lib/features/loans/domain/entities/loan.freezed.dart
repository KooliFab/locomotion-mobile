// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Loan {

 int get id; int get loanableId; String get loanableName; String get status;// 'pending', 'accepted', 'in_progress', 'completed', 'cancelled'
 DateTime get startAt; DateTime get endAt; double? get totalCost; String? get comment;
/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanCopyWith<Loan> get copyWith => _$LoanCopyWithImpl<Loan>(this as Loan, _$identity);

  /// Serializes this Loan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loan&&(identical(other.id, id) || other.id == id)&&(identical(other.loanableId, loanableId) || other.loanableId == loanableId)&&(identical(other.loanableName, loanableName) || other.loanableName == loanableName)&&(identical(other.status, status) || other.status == status)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,loanableId,loanableName,status,startAt,endAt,totalCost,comment);

@override
String toString() {
  return 'Loan(id: $id, loanableId: $loanableId, loanableName: $loanableName, status: $status, startAt: $startAt, endAt: $endAt, totalCost: $totalCost, comment: $comment)';
}


}

/// @nodoc
abstract mixin class $LoanCopyWith<$Res>  {
  factory $LoanCopyWith(Loan value, $Res Function(Loan) _then) = _$LoanCopyWithImpl;
@useResult
$Res call({
 int id, int loanableId, String loanableName, String status, DateTime startAt, DateTime endAt, double? totalCost, String? comment
});




}
/// @nodoc
class _$LoanCopyWithImpl<$Res>
    implements $LoanCopyWith<$Res> {
  _$LoanCopyWithImpl(this._self, this._then);

  final Loan _self;
  final $Res Function(Loan) _then;

/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? loanableId = null,Object? loanableName = null,Object? status = null,Object? startAt = null,Object? endAt = null,Object? totalCost = freezed,Object? comment = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,loanableId: null == loanableId ? _self.loanableId : loanableId // ignore: cast_nullable_to_non_nullable
as int,loanableName: null == loanableName ? _self.loanableName : loanableName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalCost: freezed == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Loan].
extension LoanPatterns on Loan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Loan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Loan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Loan value)  $default,){
final _that = this;
switch (_that) {
case _Loan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Loan value)?  $default,){
final _that = this;
switch (_that) {
case _Loan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int loanableId,  String loanableName,  String status,  DateTime startAt,  DateTime endAt,  double? totalCost,  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loan() when $default != null:
return $default(_that.id,_that.loanableId,_that.loanableName,_that.status,_that.startAt,_that.endAt,_that.totalCost,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int loanableId,  String loanableName,  String status,  DateTime startAt,  DateTime endAt,  double? totalCost,  String? comment)  $default,) {final _that = this;
switch (_that) {
case _Loan():
return $default(_that.id,_that.loanableId,_that.loanableName,_that.status,_that.startAt,_that.endAt,_that.totalCost,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int loanableId,  String loanableName,  String status,  DateTime startAt,  DateTime endAt,  double? totalCost,  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _Loan() when $default != null:
return $default(_that.id,_that.loanableId,_that.loanableName,_that.status,_that.startAt,_that.endAt,_that.totalCost,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Loan implements Loan {
  const _Loan({required this.id, required this.loanableId, required this.loanableName, required this.status, required this.startAt, required this.endAt, this.totalCost, this.comment});
  factory _Loan.fromJson(Map<String, dynamic> json) => _$LoanFromJson(json);

@override final  int id;
@override final  int loanableId;
@override final  String loanableName;
@override final  String status;
// 'pending', 'accepted', 'in_progress', 'completed', 'cancelled'
@override final  DateTime startAt;
@override final  DateTime endAt;
@override final  double? totalCost;
@override final  String? comment;

/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanCopyWith<_Loan> get copyWith => __$LoanCopyWithImpl<_Loan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loan&&(identical(other.id, id) || other.id == id)&&(identical(other.loanableId, loanableId) || other.loanableId == loanableId)&&(identical(other.loanableName, loanableName) || other.loanableName == loanableName)&&(identical(other.status, status) || other.status == status)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.totalCost, totalCost) || other.totalCost == totalCost)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,loanableId,loanableName,status,startAt,endAt,totalCost,comment);

@override
String toString() {
  return 'Loan(id: $id, loanableId: $loanableId, loanableName: $loanableName, status: $status, startAt: $startAt, endAt: $endAt, totalCost: $totalCost, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$LoanCopyWith<$Res> implements $LoanCopyWith<$Res> {
  factory _$LoanCopyWith(_Loan value, $Res Function(_Loan) _then) = __$LoanCopyWithImpl;
@override @useResult
$Res call({
 int id, int loanableId, String loanableName, String status, DateTime startAt, DateTime endAt, double? totalCost, String? comment
});




}
/// @nodoc
class __$LoanCopyWithImpl<$Res>
    implements _$LoanCopyWith<$Res> {
  __$LoanCopyWithImpl(this._self, this._then);

  final _Loan _self;
  final $Res Function(_Loan) _then;

/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? loanableId = null,Object? loanableName = null,Object? status = null,Object? startAt = null,Object? endAt = null,Object? totalCost = freezed,Object? comment = freezed,}) {
  return _then(_Loan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,loanableId: null == loanableId ? _self.loanableId : loanableId // ignore: cast_nullable_to_non_nullable
as int,loanableName: null == loanableName ? _self.loanableName : loanableName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: null == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalCost: freezed == totalCost ? _self.totalCost : totalCost // ignore: cast_nullable_to_non_nullable
as double?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

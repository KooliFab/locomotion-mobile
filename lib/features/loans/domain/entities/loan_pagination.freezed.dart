// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_pagination.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoanPagination {

 List<Loan> get data; int get currentPage; int get lastPage; int get total; int get perPage;
/// Create a copy of LoanPagination
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanPaginationCopyWith<LoanPagination> get copyWith => _$LoanPaginationCopyWithImpl<LoanPagination>(this as LoanPagination, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanPagination&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.perPage, perPage) || other.perPage == perPage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data),currentPage,lastPage,total,perPage);

@override
String toString() {
  return 'LoanPagination(data: $data, currentPage: $currentPage, lastPage: $lastPage, total: $total, perPage: $perPage)';
}


}

/// @nodoc
abstract mixin class $LoanPaginationCopyWith<$Res>  {
  factory $LoanPaginationCopyWith(LoanPagination value, $Res Function(LoanPagination) _then) = _$LoanPaginationCopyWithImpl;
@useResult
$Res call({
 List<Loan> data, int currentPage, int lastPage, int total, int perPage
});




}
/// @nodoc
class _$LoanPaginationCopyWithImpl<$Res>
    implements $LoanPaginationCopyWith<$Res> {
  _$LoanPaginationCopyWithImpl(this._self, this._then);

  final LoanPagination _self;
  final $Res Function(LoanPagination) _then;

/// Create a copy of LoanPagination
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,Object? currentPage = null,Object? lastPage = null,Object? total = null,Object? perPage = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<Loan>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanPagination].
extension LoanPaginationPatterns on LoanPagination {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanPagination value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanPagination() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanPagination value)  $default,){
final _that = this;
switch (_that) {
case _LoanPagination():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanPagination value)?  $default,){
final _that = this;
switch (_that) {
case _LoanPagination() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Loan> data,  int currentPage,  int lastPage,  int total,  int perPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanPagination() when $default != null:
return $default(_that.data,_that.currentPage,_that.lastPage,_that.total,_that.perPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Loan> data,  int currentPage,  int lastPage,  int total,  int perPage)  $default,) {final _that = this;
switch (_that) {
case _LoanPagination():
return $default(_that.data,_that.currentPage,_that.lastPage,_that.total,_that.perPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Loan> data,  int currentPage,  int lastPage,  int total,  int perPage)?  $default,) {final _that = this;
switch (_that) {
case _LoanPagination() when $default != null:
return $default(_that.data,_that.currentPage,_that.lastPage,_that.total,_that.perPage);case _:
  return null;

}
}

}

/// @nodoc


class _LoanPagination extends LoanPagination {
  const _LoanPagination({final  List<Loan> data = const [], this.currentPage = 1, this.lastPage = 1, this.total = 0, this.perPage = 10}): _data = data,super._();
  

 final  List<Loan> _data;
@override@JsonKey() List<Loan> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}

@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int lastPage;
@override@JsonKey() final  int total;
@override@JsonKey() final  int perPage;

/// Create a copy of LoanPagination
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanPaginationCopyWith<_LoanPagination> get copyWith => __$LoanPaginationCopyWithImpl<_LoanPagination>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanPagination&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.lastPage, lastPage) || other.lastPage == lastPage)&&(identical(other.total, total) || other.total == total)&&(identical(other.perPage, perPage) || other.perPage == perPage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_data),currentPage,lastPage,total,perPage);

@override
String toString() {
  return 'LoanPagination(data: $data, currentPage: $currentPage, lastPage: $lastPage, total: $total, perPage: $perPage)';
}


}

/// @nodoc
abstract mixin class _$LoanPaginationCopyWith<$Res> implements $LoanPaginationCopyWith<$Res> {
  factory _$LoanPaginationCopyWith(_LoanPagination value, $Res Function(_LoanPagination) _then) = __$LoanPaginationCopyWithImpl;
@override @useResult
$Res call({
 List<Loan> data, int currentPage, int lastPage, int total, int perPage
});




}
/// @nodoc
class __$LoanPaginationCopyWithImpl<$Res>
    implements _$LoanPaginationCopyWith<$Res> {
  __$LoanPaginationCopyWithImpl(this._self, this._then);

  final _LoanPagination _self;
  final $Res Function(_LoanPagination) _then;

/// Create a copy of LoanPagination
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,Object? currentPage = null,Object? lastPage = null,Object? total = null,Object? perPage = null,}) {
  return _then(_LoanPagination(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<Loan>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,lastPage: null == lastPage ? _self.lastPage : lastPage // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

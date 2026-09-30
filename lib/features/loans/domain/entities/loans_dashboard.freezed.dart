// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loans_dashboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoansDashboard {

 LoansDashboardCategory get started; LoansDashboardCategory get waiting;@JsonKey(name: 'need_approval') LoansDashboardCategory get needApproval; LoansDashboardCategory get future; LoansDashboardCategory get completed;
/// Create a copy of LoansDashboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoansDashboardCopyWith<LoansDashboard> get copyWith => _$LoansDashboardCopyWithImpl<LoansDashboard>(this as LoansDashboard, _$identity);

  /// Serializes this LoansDashboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoansDashboard&&(identical(other.started, started) || other.started == started)&&(identical(other.waiting, waiting) || other.waiting == waiting)&&(identical(other.needApproval, needApproval) || other.needApproval == needApproval)&&(identical(other.future, future) || other.future == future)&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,started,waiting,needApproval,future,completed);

@override
String toString() {
  return 'LoansDashboard(started: $started, waiting: $waiting, needApproval: $needApproval, future: $future, completed: $completed)';
}


}

/// @nodoc
abstract mixin class $LoansDashboardCopyWith<$Res>  {
  factory $LoansDashboardCopyWith(LoansDashboard value, $Res Function(LoansDashboard) _then) = _$LoansDashboardCopyWithImpl;
@useResult
$Res call({
 LoansDashboardCategory started, LoansDashboardCategory waiting,@JsonKey(name: 'need_approval') LoansDashboardCategory needApproval, LoansDashboardCategory future, LoansDashboardCategory completed
});


$LoansDashboardCategoryCopyWith<$Res> get started;$LoansDashboardCategoryCopyWith<$Res> get waiting;$LoansDashboardCategoryCopyWith<$Res> get needApproval;$LoansDashboardCategoryCopyWith<$Res> get future;$LoansDashboardCategoryCopyWith<$Res> get completed;

}
/// @nodoc
class _$LoansDashboardCopyWithImpl<$Res>
    implements $LoansDashboardCopyWith<$Res> {
  _$LoansDashboardCopyWithImpl(this._self, this._then);

  final LoansDashboard _self;
  final $Res Function(LoansDashboard) _then;

/// Create a copy of LoansDashboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? started = null,Object? waiting = null,Object? needApproval = null,Object? future = null,Object? completed = null,}) {
  return _then(_self.copyWith(
started: null == started ? _self.started : started // ignore: cast_nullable_to_non_nullable
as LoansDashboardCategory,waiting: null == waiting ? _self.waiting : waiting // ignore: cast_nullable_to_non_nullable
as LoansDashboardCategory,needApproval: null == needApproval ? _self.needApproval : needApproval // ignore: cast_nullable_to_non_nullable
as LoansDashboardCategory,future: null == future ? _self.future : future // ignore: cast_nullable_to_non_nullable
as LoansDashboardCategory,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as LoansDashboardCategory,
  ));
}
/// Create a copy of LoansDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoansDashboardCategoryCopyWith<$Res> get started {
  
  return $LoansDashboardCategoryCopyWith<$Res>(_self.started, (value) {
    return _then(_self.copyWith(started: value));
  });
}/// Create a copy of LoansDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoansDashboardCategoryCopyWith<$Res> get waiting {
  
  return $LoansDashboardCategoryCopyWith<$Res>(_self.waiting, (value) {
    return _then(_self.copyWith(waiting: value));
  });
}/// Create a copy of LoansDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoansDashboardCategoryCopyWith<$Res> get needApproval {
  
  return $LoansDashboardCategoryCopyWith<$Res>(_self.needApproval, (value) {
    return _then(_self.copyWith(needApproval: value));
  });
}/// Create a copy of LoansDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoansDashboardCategoryCopyWith<$Res> get future {
  
  return $LoansDashboardCategoryCopyWith<$Res>(_self.future, (value) {
    return _then(_self.copyWith(future: value));
  });
}/// Create a copy of LoansDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoansDashboardCategoryCopyWith<$Res> get completed {
  
  return $LoansDashboardCategoryCopyWith<$Res>(_self.completed, (value) {
    return _then(_self.copyWith(completed: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoansDashboard].
extension LoansDashboardPatterns on LoansDashboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoansDashboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoansDashboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoansDashboard value)  $default,){
final _that = this;
switch (_that) {
case _LoansDashboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoansDashboard value)?  $default,){
final _that = this;
switch (_that) {
case _LoansDashboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoansDashboardCategory started,  LoansDashboardCategory waiting, @JsonKey(name: 'need_approval')  LoansDashboardCategory needApproval,  LoansDashboardCategory future,  LoansDashboardCategory completed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoansDashboard() when $default != null:
return $default(_that.started,_that.waiting,_that.needApproval,_that.future,_that.completed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoansDashboardCategory started,  LoansDashboardCategory waiting, @JsonKey(name: 'need_approval')  LoansDashboardCategory needApproval,  LoansDashboardCategory future,  LoansDashboardCategory completed)  $default,) {final _that = this;
switch (_that) {
case _LoansDashboard():
return $default(_that.started,_that.waiting,_that.needApproval,_that.future,_that.completed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoansDashboardCategory started,  LoansDashboardCategory waiting, @JsonKey(name: 'need_approval')  LoansDashboardCategory needApproval,  LoansDashboardCategory future,  LoansDashboardCategory completed)?  $default,) {final _that = this;
switch (_that) {
case _LoansDashboard() when $default != null:
return $default(_that.started,_that.waiting,_that.needApproval,_that.future,_that.completed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoansDashboard implements LoansDashboard {
  const _LoansDashboard({this.started = const LoansDashboardCategory(), this.waiting = const LoansDashboardCategory(), @JsonKey(name: 'need_approval') this.needApproval = const LoansDashboardCategory(), this.future = const LoansDashboardCategory(), this.completed = const LoansDashboardCategory()});
  factory _LoansDashboard.fromJson(Map<String, dynamic> json) => _$LoansDashboardFromJson(json);

@override@JsonKey() final  LoansDashboardCategory started;
@override@JsonKey() final  LoansDashboardCategory waiting;
@override@JsonKey(name: 'need_approval') final  LoansDashboardCategory needApproval;
@override@JsonKey() final  LoansDashboardCategory future;
@override@JsonKey() final  LoansDashboardCategory completed;

/// Create a copy of LoansDashboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoansDashboardCopyWith<_LoansDashboard> get copyWith => __$LoansDashboardCopyWithImpl<_LoansDashboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoansDashboardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoansDashboard&&(identical(other.started, started) || other.started == started)&&(identical(other.waiting, waiting) || other.waiting == waiting)&&(identical(other.needApproval, needApproval) || other.needApproval == needApproval)&&(identical(other.future, future) || other.future == future)&&(identical(other.completed, completed) || other.completed == completed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,started,waiting,needApproval,future,completed);

@override
String toString() {
  return 'LoansDashboard(started: $started, waiting: $waiting, needApproval: $needApproval, future: $future, completed: $completed)';
}


}

/// @nodoc
abstract mixin class _$LoansDashboardCopyWith<$Res> implements $LoansDashboardCopyWith<$Res> {
  factory _$LoansDashboardCopyWith(_LoansDashboard value, $Res Function(_LoansDashboard) _then) = __$LoansDashboardCopyWithImpl;
@override @useResult
$Res call({
 LoansDashboardCategory started, LoansDashboardCategory waiting,@JsonKey(name: 'need_approval') LoansDashboardCategory needApproval, LoansDashboardCategory future, LoansDashboardCategory completed
});


@override $LoansDashboardCategoryCopyWith<$Res> get started;@override $LoansDashboardCategoryCopyWith<$Res> get waiting;@override $LoansDashboardCategoryCopyWith<$Res> get needApproval;@override $LoansDashboardCategoryCopyWith<$Res> get future;@override $LoansDashboardCategoryCopyWith<$Res> get completed;

}
/// @nodoc
class __$LoansDashboardCopyWithImpl<$Res>
    implements _$LoansDashboardCopyWith<$Res> {
  __$LoansDashboardCopyWithImpl(this._self, this._then);

  final _LoansDashboard _self;
  final $Res Function(_LoansDashboard) _then;

/// Create a copy of LoansDashboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? started = null,Object? waiting = null,Object? needApproval = null,Object? future = null,Object? completed = null,}) {
  return _then(_LoansDashboard(
started: null == started ? _self.started : started // ignore: cast_nullable_to_non_nullable
as LoansDashboardCategory,waiting: null == waiting ? _self.waiting : waiting // ignore: cast_nullable_to_non_nullable
as LoansDashboardCategory,needApproval: null == needApproval ? _self.needApproval : needApproval // ignore: cast_nullable_to_non_nullable
as LoansDashboardCategory,future: null == future ? _self.future : future // ignore: cast_nullable_to_non_nullable
as LoansDashboardCategory,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as LoansDashboardCategory,
  ));
}

/// Create a copy of LoansDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoansDashboardCategoryCopyWith<$Res> get started {
  
  return $LoansDashboardCategoryCopyWith<$Res>(_self.started, (value) {
    return _then(_self.copyWith(started: value));
  });
}/// Create a copy of LoansDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoansDashboardCategoryCopyWith<$Res> get waiting {
  
  return $LoansDashboardCategoryCopyWith<$Res>(_self.waiting, (value) {
    return _then(_self.copyWith(waiting: value));
  });
}/// Create a copy of LoansDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoansDashboardCategoryCopyWith<$Res> get needApproval {
  
  return $LoansDashboardCategoryCopyWith<$Res>(_self.needApproval, (value) {
    return _then(_self.copyWith(needApproval: value));
  });
}/// Create a copy of LoansDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoansDashboardCategoryCopyWith<$Res> get future {
  
  return $LoansDashboardCategoryCopyWith<$Res>(_self.future, (value) {
    return _then(_self.copyWith(future: value));
  });
}/// Create a copy of LoansDashboard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoansDashboardCategoryCopyWith<$Res> get completed {
  
  return $LoansDashboardCategoryCopyWith<$Res>(_self.completed, (value) {
    return _then(_self.copyWith(completed: value));
  });
}
}


/// @nodoc
mixin _$LoansDashboardCategory {

 int get total; List<Loan> get loans;
/// Create a copy of LoansDashboardCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoansDashboardCategoryCopyWith<LoansDashboardCategory> get copyWith => _$LoansDashboardCategoryCopyWithImpl<LoansDashboardCategory>(this as LoansDashboardCategory, _$identity);

  /// Serializes this LoansDashboardCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoansDashboardCategory&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other.loans, loans));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,const DeepCollectionEquality().hash(loans));

@override
String toString() {
  return 'LoansDashboardCategory(total: $total, loans: $loans)';
}


}

/// @nodoc
abstract mixin class $LoansDashboardCategoryCopyWith<$Res>  {
  factory $LoansDashboardCategoryCopyWith(LoansDashboardCategory value, $Res Function(LoansDashboardCategory) _then) = _$LoansDashboardCategoryCopyWithImpl;
@useResult
$Res call({
 int total, List<Loan> loans
});




}
/// @nodoc
class _$LoansDashboardCategoryCopyWithImpl<$Res>
    implements $LoansDashboardCategoryCopyWith<$Res> {
  _$LoansDashboardCategoryCopyWithImpl(this._self, this._then);

  final LoansDashboardCategory _self;
  final $Res Function(LoansDashboardCategory) _then;

/// Create a copy of LoansDashboardCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? loans = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,loans: null == loans ? _self.loans : loans // ignore: cast_nullable_to_non_nullable
as List<Loan>,
  ));
}

}


/// Adds pattern-matching-related methods to [LoansDashboardCategory].
extension LoansDashboardCategoryPatterns on LoansDashboardCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoansDashboardCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoansDashboardCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoansDashboardCategory value)  $default,){
final _that = this;
switch (_that) {
case _LoansDashboardCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoansDashboardCategory value)?  $default,){
final _that = this;
switch (_that) {
case _LoansDashboardCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  List<Loan> loans)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoansDashboardCategory() when $default != null:
return $default(_that.total,_that.loans);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  List<Loan> loans)  $default,) {final _that = this;
switch (_that) {
case _LoansDashboardCategory():
return $default(_that.total,_that.loans);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  List<Loan> loans)?  $default,) {final _that = this;
switch (_that) {
case _LoansDashboardCategory() when $default != null:
return $default(_that.total,_that.loans);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoansDashboardCategory implements LoansDashboardCategory {
  const _LoansDashboardCategory({this.total = 0, final  List<Loan> loans = const []}): _loans = loans;
  factory _LoansDashboardCategory.fromJson(Map<String, dynamic> json) => _$LoansDashboardCategoryFromJson(json);

@override@JsonKey() final  int total;
 final  List<Loan> _loans;
@override@JsonKey() List<Loan> get loans {
  if (_loans is EqualUnmodifiableListView) return _loans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_loans);
}


/// Create a copy of LoansDashboardCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoansDashboardCategoryCopyWith<_LoansDashboardCategory> get copyWith => __$LoansDashboardCategoryCopyWithImpl<_LoansDashboardCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoansDashboardCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoansDashboardCategory&&(identical(other.total, total) || other.total == total)&&const DeepCollectionEquality().equals(other._loans, _loans));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,const DeepCollectionEquality().hash(_loans));

@override
String toString() {
  return 'LoansDashboardCategory(total: $total, loans: $loans)';
}


}

/// @nodoc
abstract mixin class _$LoansDashboardCategoryCopyWith<$Res> implements $LoansDashboardCategoryCopyWith<$Res> {
  factory _$LoansDashboardCategoryCopyWith(_LoansDashboardCategory value, $Res Function(_LoansDashboardCategory) _then) = __$LoansDashboardCategoryCopyWithImpl;
@override @useResult
$Res call({
 int total, List<Loan> loans
});




}
/// @nodoc
class __$LoansDashboardCategoryCopyWithImpl<$Res>
    implements _$LoansDashboardCategoryCopyWith<$Res> {
  __$LoansDashboardCategoryCopyWithImpl(this._self, this._then);

  final _LoansDashboardCategory _self;
  final $Res Function(_LoansDashboardCategory) _then;

/// Create a copy of LoansDashboardCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? loans = null,}) {
  return _then(_LoansDashboardCategory(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,loans: null == loans ? _self._loans : loans // ignore: cast_nullable_to_non_nullable
as List<Loan>,
  ));
}


}

// dart format on

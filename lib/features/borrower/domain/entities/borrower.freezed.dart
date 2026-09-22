// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'borrower.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Borrower {

@JsonKey(name: 'user_id') int get userId; bool get approved; bool get suspended; bool get validated;@JsonKey(name: 'submitted_at') DateTime? get submittedAt;@JsonKey(name: 'approved_at') DateTime? get approvedAt;@JsonKey(name: 'suspended_at') DateTime? get suspendedAt;// Conditional fields — only present when viewer has 'view-license' permission
@JsonKey(name: 'drivers_license_number') String? get driversLicenseNumber;@JsonKey(name: 'has_not_been_sued_last_ten_years') bool? get hasNotBeenSuedLastTenYears; List<UploadedFileRef> get gaa; List<UploadedFileRef> get saaq;
/// Create a copy of Borrower
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BorrowerCopyWith<Borrower> get copyWith => _$BorrowerCopyWithImpl<Borrower>(this as Borrower, _$identity);

  /// Serializes this Borrower to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Borrower&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.suspended, suspended) || other.suspended == suspended)&&(identical(other.validated, validated) || other.validated == validated)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.suspendedAt, suspendedAt) || other.suspendedAt == suspendedAt)&&(identical(other.driversLicenseNumber, driversLicenseNumber) || other.driversLicenseNumber == driversLicenseNumber)&&(identical(other.hasNotBeenSuedLastTenYears, hasNotBeenSuedLastTenYears) || other.hasNotBeenSuedLastTenYears == hasNotBeenSuedLastTenYears)&&const DeepCollectionEquality().equals(other.gaa, gaa)&&const DeepCollectionEquality().equals(other.saaq, saaq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,approved,suspended,validated,submittedAt,approvedAt,suspendedAt,driversLicenseNumber,hasNotBeenSuedLastTenYears,const DeepCollectionEquality().hash(gaa),const DeepCollectionEquality().hash(saaq));



}

/// @nodoc
abstract mixin class $BorrowerCopyWith<$Res>  {
  factory $BorrowerCopyWith(Borrower value, $Res Function(Borrower) _then) = _$BorrowerCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') int userId, bool approved, bool suspended, bool validated,@JsonKey(name: 'submitted_at') DateTime? submittedAt,@JsonKey(name: 'approved_at') DateTime? approvedAt,@JsonKey(name: 'suspended_at') DateTime? suspendedAt,@JsonKey(name: 'drivers_license_number') String? driversLicenseNumber,@JsonKey(name: 'has_not_been_sued_last_ten_years') bool? hasNotBeenSuedLastTenYears, List<UploadedFileRef> gaa, List<UploadedFileRef> saaq
});




}
/// @nodoc
class _$BorrowerCopyWithImpl<$Res>
    implements $BorrowerCopyWith<$Res> {
  _$BorrowerCopyWithImpl(this._self, this._then);

  final Borrower _self;
  final $Res Function(Borrower) _then;

/// Create a copy of Borrower
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? approved = null,Object? suspended = null,Object? validated = null,Object? submittedAt = freezed,Object? approvedAt = freezed,Object? suspendedAt = freezed,Object? driversLicenseNumber = freezed,Object? hasNotBeenSuedLastTenYears = freezed,Object? gaa = null,Object? saaq = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as bool,suspended: null == suspended ? _self.suspended : suspended // ignore: cast_nullable_to_non_nullable
as bool,validated: null == validated ? _self.validated : validated // ignore: cast_nullable_to_non_nullable
as bool,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,suspendedAt: freezed == suspendedAt ? _self.suspendedAt : suspendedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,driversLicenseNumber: freezed == driversLicenseNumber ? _self.driversLicenseNumber : driversLicenseNumber // ignore: cast_nullable_to_non_nullable
as String?,hasNotBeenSuedLastTenYears: freezed == hasNotBeenSuedLastTenYears ? _self.hasNotBeenSuedLastTenYears : hasNotBeenSuedLastTenYears // ignore: cast_nullable_to_non_nullable
as bool?,gaa: null == gaa ? _self.gaa : gaa // ignore: cast_nullable_to_non_nullable
as List<UploadedFileRef>,saaq: null == saaq ? _self.saaq : saaq // ignore: cast_nullable_to_non_nullable
as List<UploadedFileRef>,
  ));
}

}


/// Adds pattern-matching-related methods to [Borrower].
extension BorrowerPatterns on Borrower {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Borrower value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Borrower() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Borrower value)  $default,){
final _that = this;
switch (_that) {
case _Borrower():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Borrower value)?  $default,){
final _that = this;
switch (_that) {
case _Borrower() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  int userId,  bool approved,  bool suspended,  bool validated, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'approved_at')  DateTime? approvedAt, @JsonKey(name: 'suspended_at')  DateTime? suspendedAt, @JsonKey(name: 'drivers_license_number')  String? driversLicenseNumber, @JsonKey(name: 'has_not_been_sued_last_ten_years')  bool? hasNotBeenSuedLastTenYears,  List<UploadedFileRef> gaa,  List<UploadedFileRef> saaq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Borrower() when $default != null:
return $default(_that.userId,_that.approved,_that.suspended,_that.validated,_that.submittedAt,_that.approvedAt,_that.suspendedAt,_that.driversLicenseNumber,_that.hasNotBeenSuedLastTenYears,_that.gaa,_that.saaq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  int userId,  bool approved,  bool suspended,  bool validated, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'approved_at')  DateTime? approvedAt, @JsonKey(name: 'suspended_at')  DateTime? suspendedAt, @JsonKey(name: 'drivers_license_number')  String? driversLicenseNumber, @JsonKey(name: 'has_not_been_sued_last_ten_years')  bool? hasNotBeenSuedLastTenYears,  List<UploadedFileRef> gaa,  List<UploadedFileRef> saaq)  $default,) {final _that = this;
switch (_that) {
case _Borrower():
return $default(_that.userId,_that.approved,_that.suspended,_that.validated,_that.submittedAt,_that.approvedAt,_that.suspendedAt,_that.driversLicenseNumber,_that.hasNotBeenSuedLastTenYears,_that.gaa,_that.saaq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  int userId,  bool approved,  bool suspended,  bool validated, @JsonKey(name: 'submitted_at')  DateTime? submittedAt, @JsonKey(name: 'approved_at')  DateTime? approvedAt, @JsonKey(name: 'suspended_at')  DateTime? suspendedAt, @JsonKey(name: 'drivers_license_number')  String? driversLicenseNumber, @JsonKey(name: 'has_not_been_sued_last_ten_years')  bool? hasNotBeenSuedLastTenYears,  List<UploadedFileRef> gaa,  List<UploadedFileRef> saaq)?  $default,) {final _that = this;
switch (_that) {
case _Borrower() when $default != null:
return $default(_that.userId,_that.approved,_that.suspended,_that.validated,_that.submittedAt,_that.approvedAt,_that.suspendedAt,_that.driversLicenseNumber,_that.hasNotBeenSuedLastTenYears,_that.gaa,_that.saaq);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Borrower extends Borrower {
  const _Borrower({@JsonKey(name: 'user_id') required this.userId, this.approved = false, this.suspended = false, this.validated = false, @JsonKey(name: 'submitted_at') this.submittedAt, @JsonKey(name: 'approved_at') this.approvedAt, @JsonKey(name: 'suspended_at') this.suspendedAt, @JsonKey(name: 'drivers_license_number') this.driversLicenseNumber, @JsonKey(name: 'has_not_been_sued_last_ten_years') this.hasNotBeenSuedLastTenYears, final  List<UploadedFileRef> gaa = const [], final  List<UploadedFileRef> saaq = const []}): _gaa = gaa,_saaq = saaq,super._();
  factory _Borrower.fromJson(Map<String, dynamic> json) => _$BorrowerFromJson(json);

@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey() final  bool approved;
@override@JsonKey() final  bool suspended;
@override@JsonKey() final  bool validated;
@override@JsonKey(name: 'submitted_at') final  DateTime? submittedAt;
@override@JsonKey(name: 'approved_at') final  DateTime? approvedAt;
@override@JsonKey(name: 'suspended_at') final  DateTime? suspendedAt;
// Conditional fields — only present when viewer has 'view-license' permission
@override@JsonKey(name: 'drivers_license_number') final  String? driversLicenseNumber;
@override@JsonKey(name: 'has_not_been_sued_last_ten_years') final  bool? hasNotBeenSuedLastTenYears;
 final  List<UploadedFileRef> _gaa;
@override@JsonKey() List<UploadedFileRef> get gaa {
  if (_gaa is EqualUnmodifiableListView) return _gaa;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gaa);
}

 final  List<UploadedFileRef> _saaq;
@override@JsonKey() List<UploadedFileRef> get saaq {
  if (_saaq is EqualUnmodifiableListView) return _saaq;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_saaq);
}


/// Create a copy of Borrower
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BorrowerCopyWith<_Borrower> get copyWith => __$BorrowerCopyWithImpl<_Borrower>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BorrowerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Borrower&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.approved, approved) || other.approved == approved)&&(identical(other.suspended, suspended) || other.suspended == suspended)&&(identical(other.validated, validated) || other.validated == validated)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.suspendedAt, suspendedAt) || other.suspendedAt == suspendedAt)&&(identical(other.driversLicenseNumber, driversLicenseNumber) || other.driversLicenseNumber == driversLicenseNumber)&&(identical(other.hasNotBeenSuedLastTenYears, hasNotBeenSuedLastTenYears) || other.hasNotBeenSuedLastTenYears == hasNotBeenSuedLastTenYears)&&const DeepCollectionEquality().equals(other._gaa, _gaa)&&const DeepCollectionEquality().equals(other._saaq, _saaq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,approved,suspended,validated,submittedAt,approvedAt,suspendedAt,driversLicenseNumber,hasNotBeenSuedLastTenYears,const DeepCollectionEquality().hash(_gaa),const DeepCollectionEquality().hash(_saaq));



}

/// @nodoc
abstract mixin class _$BorrowerCopyWith<$Res> implements $BorrowerCopyWith<$Res> {
  factory _$BorrowerCopyWith(_Borrower value, $Res Function(_Borrower) _then) = __$BorrowerCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') int userId, bool approved, bool suspended, bool validated,@JsonKey(name: 'submitted_at') DateTime? submittedAt,@JsonKey(name: 'approved_at') DateTime? approvedAt,@JsonKey(name: 'suspended_at') DateTime? suspendedAt,@JsonKey(name: 'drivers_license_number') String? driversLicenseNumber,@JsonKey(name: 'has_not_been_sued_last_ten_years') bool? hasNotBeenSuedLastTenYears, List<UploadedFileRef> gaa, List<UploadedFileRef> saaq
});




}
/// @nodoc
class __$BorrowerCopyWithImpl<$Res>
    implements _$BorrowerCopyWith<$Res> {
  __$BorrowerCopyWithImpl(this._self, this._then);

  final _Borrower _self;
  final $Res Function(_Borrower) _then;

/// Create a copy of Borrower
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? approved = null,Object? suspended = null,Object? validated = null,Object? submittedAt = freezed,Object? approvedAt = freezed,Object? suspendedAt = freezed,Object? driversLicenseNumber = freezed,Object? hasNotBeenSuedLastTenYears = freezed,Object? gaa = null,Object? saaq = null,}) {
  return _then(_Borrower(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,approved: null == approved ? _self.approved : approved // ignore: cast_nullable_to_non_nullable
as bool,suspended: null == suspended ? _self.suspended : suspended // ignore: cast_nullable_to_non_nullable
as bool,validated: null == validated ? _self.validated : validated // ignore: cast_nullable_to_non_nullable
as bool,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,suspendedAt: freezed == suspendedAt ? _self.suspendedAt : suspendedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,driversLicenseNumber: freezed == driversLicenseNumber ? _self.driversLicenseNumber : driversLicenseNumber // ignore: cast_nullable_to_non_nullable
as String?,hasNotBeenSuedLastTenYears: freezed == hasNotBeenSuedLastTenYears ? _self.hasNotBeenSuedLastTenYears : hasNotBeenSuedLastTenYears // ignore: cast_nullable_to_non_nullable
as bool?,gaa: null == gaa ? _self._gaa : gaa // ignore: cast_nullable_to_non_nullable
as List<UploadedFileRef>,saaq: null == saaq ? _self._saaq : saaq // ignore: cast_nullable_to_non_nullable
as List<UploadedFileRef>,
  ));
}


}

// dart format on

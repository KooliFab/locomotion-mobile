// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'borrower_submission_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FileIdRef {

 int get id;
/// Create a copy of FileIdRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileIdRefCopyWith<FileIdRef> get copyWith => _$FileIdRefCopyWithImpl<FileIdRef>(this as FileIdRef, _$identity);

  /// Serializes this FileIdRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileIdRef&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'FileIdRef(id: $id)';
}


}

/// @nodoc
abstract mixin class $FileIdRefCopyWith<$Res>  {
  factory $FileIdRefCopyWith(FileIdRef value, $Res Function(FileIdRef) _then) = _$FileIdRefCopyWithImpl;
@useResult
$Res call({
 int id
});




}
/// @nodoc
class _$FileIdRefCopyWithImpl<$Res>
    implements $FileIdRefCopyWith<$Res> {
  _$FileIdRefCopyWithImpl(this._self, this._then);

  final FileIdRef _self;
  final $Res Function(FileIdRef) _then;

/// Create a copy of FileIdRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FileIdRef].
extension FileIdRefPatterns on FileIdRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileIdRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileIdRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileIdRef value)  $default,){
final _that = this;
switch (_that) {
case _FileIdRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileIdRef value)?  $default,){
final _that = this;
switch (_that) {
case _FileIdRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileIdRef() when $default != null:
return $default(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id)  $default,) {final _that = this;
switch (_that) {
case _FileIdRef():
return $default(_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id)?  $default,) {final _that = this;
switch (_that) {
case _FileIdRef() when $default != null:
return $default(_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FileIdRef implements FileIdRef {
  const _FileIdRef({required this.id});
  factory _FileIdRef.fromJson(Map<String, dynamic> json) => _$FileIdRefFromJson(json);

@override final  int id;

/// Create a copy of FileIdRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileIdRefCopyWith<_FileIdRef> get copyWith => __$FileIdRefCopyWithImpl<_FileIdRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FileIdRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileIdRef&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'FileIdRef(id: $id)';
}


}

/// @nodoc
abstract mixin class _$FileIdRefCopyWith<$Res> implements $FileIdRefCopyWith<$Res> {
  factory _$FileIdRefCopyWith(_FileIdRef value, $Res Function(_FileIdRef) _then) = __$FileIdRefCopyWithImpl;
@override @useResult
$Res call({
 int id
});




}
/// @nodoc
class __$FileIdRefCopyWithImpl<$Res>
    implements _$FileIdRefCopyWith<$Res> {
  __$FileIdRefCopyWithImpl(this._self, this._then);

  final _FileIdRef _self;
  final $Res Function(_FileIdRef) _then;

/// Create a copy of FileIdRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_FileIdRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BorrowerSubmissionRequest {

@JsonKey(name: 'user_id') int get userId;@JsonKey(name: 'drivers_license_number') String get driversLicenseNumber;@JsonKey(name: 'has_not_been_sued_last_ten_years') bool get hasNotBeenSuedLastTenYears; List<FileIdRef> get gaa; List<FileIdRef> get saaq;
/// Create a copy of BorrowerSubmissionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BorrowerSubmissionRequestCopyWith<BorrowerSubmissionRequest> get copyWith => _$BorrowerSubmissionRequestCopyWithImpl<BorrowerSubmissionRequest>(this as BorrowerSubmissionRequest, _$identity);

  /// Serializes this BorrowerSubmissionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BorrowerSubmissionRequest&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.driversLicenseNumber, driversLicenseNumber) || other.driversLicenseNumber == driversLicenseNumber)&&(identical(other.hasNotBeenSuedLastTenYears, hasNotBeenSuedLastTenYears) || other.hasNotBeenSuedLastTenYears == hasNotBeenSuedLastTenYears)&&const DeepCollectionEquality().equals(other.gaa, gaa)&&const DeepCollectionEquality().equals(other.saaq, saaq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,driversLicenseNumber,hasNotBeenSuedLastTenYears,const DeepCollectionEquality().hash(gaa),const DeepCollectionEquality().hash(saaq));



}

/// @nodoc
abstract mixin class $BorrowerSubmissionRequestCopyWith<$Res>  {
  factory $BorrowerSubmissionRequestCopyWith(BorrowerSubmissionRequest value, $Res Function(BorrowerSubmissionRequest) _then) = _$BorrowerSubmissionRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'drivers_license_number') String driversLicenseNumber,@JsonKey(name: 'has_not_been_sued_last_ten_years') bool hasNotBeenSuedLastTenYears, List<FileIdRef> gaa, List<FileIdRef> saaq
});




}
/// @nodoc
class _$BorrowerSubmissionRequestCopyWithImpl<$Res>
    implements $BorrowerSubmissionRequestCopyWith<$Res> {
  _$BorrowerSubmissionRequestCopyWithImpl(this._self, this._then);

  final BorrowerSubmissionRequest _self;
  final $Res Function(BorrowerSubmissionRequest) _then;

/// Create a copy of BorrowerSubmissionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? driversLicenseNumber = null,Object? hasNotBeenSuedLastTenYears = null,Object? gaa = null,Object? saaq = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,driversLicenseNumber: null == driversLicenseNumber ? _self.driversLicenseNumber : driversLicenseNumber // ignore: cast_nullable_to_non_nullable
as String,hasNotBeenSuedLastTenYears: null == hasNotBeenSuedLastTenYears ? _self.hasNotBeenSuedLastTenYears : hasNotBeenSuedLastTenYears // ignore: cast_nullable_to_non_nullable
as bool,gaa: null == gaa ? _self.gaa : gaa // ignore: cast_nullable_to_non_nullable
as List<FileIdRef>,saaq: null == saaq ? _self.saaq : saaq // ignore: cast_nullable_to_non_nullable
as List<FileIdRef>,
  ));
}

}


/// Adds pattern-matching-related methods to [BorrowerSubmissionRequest].
extension BorrowerSubmissionRequestPatterns on BorrowerSubmissionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BorrowerSubmissionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BorrowerSubmissionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BorrowerSubmissionRequest value)  $default,){
final _that = this;
switch (_that) {
case _BorrowerSubmissionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BorrowerSubmissionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _BorrowerSubmissionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'drivers_license_number')  String driversLicenseNumber, @JsonKey(name: 'has_not_been_sued_last_ten_years')  bool hasNotBeenSuedLastTenYears,  List<FileIdRef> gaa,  List<FileIdRef> saaq)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BorrowerSubmissionRequest() when $default != null:
return $default(_that.userId,_that.driversLicenseNumber,_that.hasNotBeenSuedLastTenYears,_that.gaa,_that.saaq);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'drivers_license_number')  String driversLicenseNumber, @JsonKey(name: 'has_not_been_sued_last_ten_years')  bool hasNotBeenSuedLastTenYears,  List<FileIdRef> gaa,  List<FileIdRef> saaq)  $default,) {final _that = this;
switch (_that) {
case _BorrowerSubmissionRequest():
return $default(_that.userId,_that.driversLicenseNumber,_that.hasNotBeenSuedLastTenYears,_that.gaa,_that.saaq);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  int userId, @JsonKey(name: 'drivers_license_number')  String driversLicenseNumber, @JsonKey(name: 'has_not_been_sued_last_ten_years')  bool hasNotBeenSuedLastTenYears,  List<FileIdRef> gaa,  List<FileIdRef> saaq)?  $default,) {final _that = this;
switch (_that) {
case _BorrowerSubmissionRequest() when $default != null:
return $default(_that.userId,_that.driversLicenseNumber,_that.hasNotBeenSuedLastTenYears,_that.gaa,_that.saaq);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _BorrowerSubmissionRequest extends BorrowerSubmissionRequest {
  const _BorrowerSubmissionRequest({@JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'drivers_license_number') required this.driversLicenseNumber, @JsonKey(name: 'has_not_been_sued_last_ten_years') required this.hasNotBeenSuedLastTenYears, required final  List<FileIdRef> gaa, required final  List<FileIdRef> saaq}): _gaa = gaa,_saaq = saaq,super._();
  factory _BorrowerSubmissionRequest.fromJson(Map<String, dynamic> json) => _$BorrowerSubmissionRequestFromJson(json);

@override@JsonKey(name: 'user_id') final  int userId;
@override@JsonKey(name: 'drivers_license_number') final  String driversLicenseNumber;
@override@JsonKey(name: 'has_not_been_sued_last_ten_years') final  bool hasNotBeenSuedLastTenYears;
 final  List<FileIdRef> _gaa;
@override List<FileIdRef> get gaa {
  if (_gaa is EqualUnmodifiableListView) return _gaa;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gaa);
}

 final  List<FileIdRef> _saaq;
@override List<FileIdRef> get saaq {
  if (_saaq is EqualUnmodifiableListView) return _saaq;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_saaq);
}


/// Create a copy of BorrowerSubmissionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BorrowerSubmissionRequestCopyWith<_BorrowerSubmissionRequest> get copyWith => __$BorrowerSubmissionRequestCopyWithImpl<_BorrowerSubmissionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BorrowerSubmissionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BorrowerSubmissionRequest&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.driversLicenseNumber, driversLicenseNumber) || other.driversLicenseNumber == driversLicenseNumber)&&(identical(other.hasNotBeenSuedLastTenYears, hasNotBeenSuedLastTenYears) || other.hasNotBeenSuedLastTenYears == hasNotBeenSuedLastTenYears)&&const DeepCollectionEquality().equals(other._gaa, _gaa)&&const DeepCollectionEquality().equals(other._saaq, _saaq));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,driversLicenseNumber,hasNotBeenSuedLastTenYears,const DeepCollectionEquality().hash(_gaa),const DeepCollectionEquality().hash(_saaq));



}

/// @nodoc
abstract mixin class _$BorrowerSubmissionRequestCopyWith<$Res> implements $BorrowerSubmissionRequestCopyWith<$Res> {
  factory _$BorrowerSubmissionRequestCopyWith(_BorrowerSubmissionRequest value, $Res Function(_BorrowerSubmissionRequest) _then) = __$BorrowerSubmissionRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') int userId,@JsonKey(name: 'drivers_license_number') String driversLicenseNumber,@JsonKey(name: 'has_not_been_sued_last_ten_years') bool hasNotBeenSuedLastTenYears, List<FileIdRef> gaa, List<FileIdRef> saaq
});




}
/// @nodoc
class __$BorrowerSubmissionRequestCopyWithImpl<$Res>
    implements _$BorrowerSubmissionRequestCopyWith<$Res> {
  __$BorrowerSubmissionRequestCopyWithImpl(this._self, this._then);

  final _BorrowerSubmissionRequest _self;
  final $Res Function(_BorrowerSubmissionRequest) _then;

/// Create a copy of BorrowerSubmissionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? driversLicenseNumber = null,Object? hasNotBeenSuedLastTenYears = null,Object? gaa = null,Object? saaq = null,}) {
  return _then(_BorrowerSubmissionRequest(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,driversLicenseNumber: null == driversLicenseNumber ? _self.driversLicenseNumber : driversLicenseNumber // ignore: cast_nullable_to_non_nullable
as String,hasNotBeenSuedLastTenYears: null == hasNotBeenSuedLastTenYears ? _self.hasNotBeenSuedLastTenYears : hasNotBeenSuedLastTenYears // ignore: cast_nullable_to_non_nullable
as bool,gaa: null == gaa ? _self._gaa : gaa // ignore: cast_nullable_to_non_nullable
as List<FileIdRef>,saaq: null == saaq ? _self._saaq : saaq // ignore: cast_nullable_to_non_nullable
as List<FileIdRef>,
  ));
}


}

// dart format on

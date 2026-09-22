// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loanable_incident.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoanableIncident {

 int get id; String? get status;@JsonKey(name: 'incident_type') String? get incidentType;@JsonKey(name: 'blocking_until') DateTime? get blockingUntil;@JsonKey(name: 'is_blocking') bool get isBlocking;@JsonKey(name: 'start_at') DateTime? get startAt;@JsonKey(name: 'loan_id') int? get loanId;@JsonKey(name: 'loanable_id') int? get loanableId; String? get title; String? get description;
/// Create a copy of LoanableIncident
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanableIncidentCopyWith<LoanableIncident> get copyWith => _$LoanableIncidentCopyWithImpl<LoanableIncident>(this as LoanableIncident, _$identity);

  /// Serializes this LoanableIncident to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanableIncident&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.incidentType, incidentType) || other.incidentType == incidentType)&&(identical(other.blockingUntil, blockingUntil) || other.blockingUntil == blockingUntil)&&(identical(other.isBlocking, isBlocking) || other.isBlocking == isBlocking)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.loanableId, loanableId) || other.loanableId == loanableId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,incidentType,blockingUntil,isBlocking,startAt,loanId,loanableId,title,description);

@override
String toString() {
  return 'LoanableIncident(id: $id, status: $status, incidentType: $incidentType, blockingUntil: $blockingUntil, isBlocking: $isBlocking, startAt: $startAt, loanId: $loanId, loanableId: $loanableId, title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class $LoanableIncidentCopyWith<$Res>  {
  factory $LoanableIncidentCopyWith(LoanableIncident value, $Res Function(LoanableIncident) _then) = _$LoanableIncidentCopyWithImpl;
@useResult
$Res call({
 int id, String? status,@JsonKey(name: 'incident_type') String? incidentType,@JsonKey(name: 'blocking_until') DateTime? blockingUntil,@JsonKey(name: 'is_blocking') bool isBlocking,@JsonKey(name: 'start_at') DateTime? startAt,@JsonKey(name: 'loan_id') int? loanId,@JsonKey(name: 'loanable_id') int? loanableId, String? title, String? description
});




}
/// @nodoc
class _$LoanableIncidentCopyWithImpl<$Res>
    implements $LoanableIncidentCopyWith<$Res> {
  _$LoanableIncidentCopyWithImpl(this._self, this._then);

  final LoanableIncident _self;
  final $Res Function(LoanableIncident) _then;

/// Create a copy of LoanableIncident
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = freezed,Object? incidentType = freezed,Object? blockingUntil = freezed,Object? isBlocking = null,Object? startAt = freezed,Object? loanId = freezed,Object? loanableId = freezed,Object? title = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,incidentType: freezed == incidentType ? _self.incidentType : incidentType // ignore: cast_nullable_to_non_nullable
as String?,blockingUntil: freezed == blockingUntil ? _self.blockingUntil : blockingUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,isBlocking: null == isBlocking ? _self.isBlocking : isBlocking // ignore: cast_nullable_to_non_nullable
as bool,startAt: freezed == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime?,loanId: freezed == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int?,loanableId: freezed == loanableId ? _self.loanableId : loanableId // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanableIncident].
extension LoanableIncidentPatterns on LoanableIncident {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanableIncident value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanableIncident() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanableIncident value)  $default,){
final _that = this;
switch (_that) {
case _LoanableIncident():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanableIncident value)?  $default,){
final _that = this;
switch (_that) {
case _LoanableIncident() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? status, @JsonKey(name: 'incident_type')  String? incidentType, @JsonKey(name: 'blocking_until')  DateTime? blockingUntil, @JsonKey(name: 'is_blocking')  bool isBlocking, @JsonKey(name: 'start_at')  DateTime? startAt, @JsonKey(name: 'loan_id')  int? loanId, @JsonKey(name: 'loanable_id')  int? loanableId,  String? title,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanableIncident() when $default != null:
return $default(_that.id,_that.status,_that.incidentType,_that.blockingUntil,_that.isBlocking,_that.startAt,_that.loanId,_that.loanableId,_that.title,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? status, @JsonKey(name: 'incident_type')  String? incidentType, @JsonKey(name: 'blocking_until')  DateTime? blockingUntil, @JsonKey(name: 'is_blocking')  bool isBlocking, @JsonKey(name: 'start_at')  DateTime? startAt, @JsonKey(name: 'loan_id')  int? loanId, @JsonKey(name: 'loanable_id')  int? loanableId,  String? title,  String? description)  $default,) {final _that = this;
switch (_that) {
case _LoanableIncident():
return $default(_that.id,_that.status,_that.incidentType,_that.blockingUntil,_that.isBlocking,_that.startAt,_that.loanId,_that.loanableId,_that.title,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? status, @JsonKey(name: 'incident_type')  String? incidentType, @JsonKey(name: 'blocking_until')  DateTime? blockingUntil, @JsonKey(name: 'is_blocking')  bool isBlocking, @JsonKey(name: 'start_at')  DateTime? startAt, @JsonKey(name: 'loan_id')  int? loanId, @JsonKey(name: 'loanable_id')  int? loanableId,  String? title,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _LoanableIncident() when $default != null:
return $default(_that.id,_that.status,_that.incidentType,_that.blockingUntil,_that.isBlocking,_that.startAt,_that.loanId,_that.loanableId,_that.title,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoanableIncident implements LoanableIncident {
  const _LoanableIncident({required this.id, this.status, @JsonKey(name: 'incident_type') this.incidentType, @JsonKey(name: 'blocking_until') this.blockingUntil, @JsonKey(name: 'is_blocking') this.isBlocking = false, @JsonKey(name: 'start_at') this.startAt, @JsonKey(name: 'loan_id') this.loanId, @JsonKey(name: 'loanable_id') this.loanableId, this.title, this.description});
  factory _LoanableIncident.fromJson(Map<String, dynamic> json) => _$LoanableIncidentFromJson(json);

@override final  int id;
@override final  String? status;
@override@JsonKey(name: 'incident_type') final  String? incidentType;
@override@JsonKey(name: 'blocking_until') final  DateTime? blockingUntil;
@override@JsonKey(name: 'is_blocking') final  bool isBlocking;
@override@JsonKey(name: 'start_at') final  DateTime? startAt;
@override@JsonKey(name: 'loan_id') final  int? loanId;
@override@JsonKey(name: 'loanable_id') final  int? loanableId;
@override final  String? title;
@override final  String? description;

/// Create a copy of LoanableIncident
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanableIncidentCopyWith<_LoanableIncident> get copyWith => __$LoanableIncidentCopyWithImpl<_LoanableIncident>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoanableIncidentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanableIncident&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.incidentType, incidentType) || other.incidentType == incidentType)&&(identical(other.blockingUntil, blockingUntil) || other.blockingUntil == blockingUntil)&&(identical(other.isBlocking, isBlocking) || other.isBlocking == isBlocking)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.loanableId, loanableId) || other.loanableId == loanableId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,incidentType,blockingUntil,isBlocking,startAt,loanId,loanableId,title,description);

@override
String toString() {
  return 'LoanableIncident(id: $id, status: $status, incidentType: $incidentType, blockingUntil: $blockingUntil, isBlocking: $isBlocking, startAt: $startAt, loanId: $loanId, loanableId: $loanableId, title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class _$LoanableIncidentCopyWith<$Res> implements $LoanableIncidentCopyWith<$Res> {
  factory _$LoanableIncidentCopyWith(_LoanableIncident value, $Res Function(_LoanableIncident) _then) = __$LoanableIncidentCopyWithImpl;
@override @useResult
$Res call({
 int id, String? status,@JsonKey(name: 'incident_type') String? incidentType,@JsonKey(name: 'blocking_until') DateTime? blockingUntil,@JsonKey(name: 'is_blocking') bool isBlocking,@JsonKey(name: 'start_at') DateTime? startAt,@JsonKey(name: 'loan_id') int? loanId,@JsonKey(name: 'loanable_id') int? loanableId, String? title, String? description
});




}
/// @nodoc
class __$LoanableIncidentCopyWithImpl<$Res>
    implements _$LoanableIncidentCopyWith<$Res> {
  __$LoanableIncidentCopyWithImpl(this._self, this._then);

  final _LoanableIncident _self;
  final $Res Function(_LoanableIncident) _then;

/// Create a copy of LoanableIncident
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = freezed,Object? incidentType = freezed,Object? blockingUntil = freezed,Object? isBlocking = null,Object? startAt = freezed,Object? loanId = freezed,Object? loanableId = freezed,Object? title = freezed,Object? description = freezed,}) {
  return _then(_LoanableIncident(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,incidentType: freezed == incidentType ? _self.incidentType : incidentType // ignore: cast_nullable_to_non_nullable
as String?,blockingUntil: freezed == blockingUntil ? _self.blockingUntil : blockingUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,isBlocking: null == isBlocking ? _self.isBlocking : isBlocking // ignore: cast_nullable_to_non_nullable
as bool,startAt: freezed == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime?,loanId: freezed == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int?,loanableId: freezed == loanableId ? _self.loanableId : loanableId // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

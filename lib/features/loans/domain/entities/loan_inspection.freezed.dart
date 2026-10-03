// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_inspection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoanInspection {

@JsonKey(name: 'loan_id') int get loanId;@JsonKey(name: 'inspection_type') String get inspectionType;@JsonKey(name: 'odometer_km') int? get odometerKm;@JsonKey(name: 'fuel_battery_level_percent') int? get fuelBatteryLevelPercent;@JsonKey(name: 'cleanliness_rating') int? get cleanlinessRating; Map<String, dynamic> get checklist; Map<String, String> get photos;@JsonKey(name: 'existing_damages_notes') String? get existingDamagesNotes;@JsonKey(name: 'sealed_hash') String? get sealedHash;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'loan_status') String? get loanStatus;
/// Create a copy of LoanInspection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanInspectionCopyWith<LoanInspection> get copyWith => _$LoanInspectionCopyWithImpl<LoanInspection>(this as LoanInspection, _$identity);

  /// Serializes this LoanInspection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanInspection&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.inspectionType, inspectionType) || other.inspectionType == inspectionType)&&(identical(other.odometerKm, odometerKm) || other.odometerKm == odometerKm)&&(identical(other.fuelBatteryLevelPercent, fuelBatteryLevelPercent) || other.fuelBatteryLevelPercent == fuelBatteryLevelPercent)&&(identical(other.cleanlinessRating, cleanlinessRating) || other.cleanlinessRating == cleanlinessRating)&&const DeepCollectionEquality().equals(other.checklist, checklist)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.existingDamagesNotes, existingDamagesNotes) || other.existingDamagesNotes == existingDamagesNotes)&&(identical(other.sealedHash, sealedHash) || other.sealedHash == sealedHash)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.loanStatus, loanStatus) || other.loanStatus == loanStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,loanId,inspectionType,odometerKm,fuelBatteryLevelPercent,cleanlinessRating,const DeepCollectionEquality().hash(checklist),const DeepCollectionEquality().hash(photos),existingDamagesNotes,sealedHash,createdAt,loanStatus);

@override
String toString() {
  return 'LoanInspection(loanId: $loanId, inspectionType: $inspectionType, odometerKm: $odometerKm, fuelBatteryLevelPercent: $fuelBatteryLevelPercent, cleanlinessRating: $cleanlinessRating, checklist: $checklist, photos: $photos, existingDamagesNotes: $existingDamagesNotes, sealedHash: $sealedHash, createdAt: $createdAt, loanStatus: $loanStatus)';
}


}

/// @nodoc
abstract mixin class $LoanInspectionCopyWith<$Res>  {
  factory $LoanInspectionCopyWith(LoanInspection value, $Res Function(LoanInspection) _then) = _$LoanInspectionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'loan_id') int loanId,@JsonKey(name: 'inspection_type') String inspectionType,@JsonKey(name: 'odometer_km') int? odometerKm,@JsonKey(name: 'fuel_battery_level_percent') int? fuelBatteryLevelPercent,@JsonKey(name: 'cleanliness_rating') int? cleanlinessRating, Map<String, dynamic> checklist, Map<String, String> photos,@JsonKey(name: 'existing_damages_notes') String? existingDamagesNotes,@JsonKey(name: 'sealed_hash') String? sealedHash,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'loan_status') String? loanStatus
});




}
/// @nodoc
class _$LoanInspectionCopyWithImpl<$Res>
    implements $LoanInspectionCopyWith<$Res> {
  _$LoanInspectionCopyWithImpl(this._self, this._then);

  final LoanInspection _self;
  final $Res Function(LoanInspection) _then;

/// Create a copy of LoanInspection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loanId = null,Object? inspectionType = null,Object? odometerKm = freezed,Object? fuelBatteryLevelPercent = freezed,Object? cleanlinessRating = freezed,Object? checklist = null,Object? photos = null,Object? existingDamagesNotes = freezed,Object? sealedHash = freezed,Object? createdAt = freezed,Object? loanStatus = freezed,}) {
  return _then(_self.copyWith(
loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int,inspectionType: null == inspectionType ? _self.inspectionType : inspectionType // ignore: cast_nullable_to_non_nullable
as String,odometerKm: freezed == odometerKm ? _self.odometerKm : odometerKm // ignore: cast_nullable_to_non_nullable
as int?,fuelBatteryLevelPercent: freezed == fuelBatteryLevelPercent ? _self.fuelBatteryLevelPercent : fuelBatteryLevelPercent // ignore: cast_nullable_to_non_nullable
as int?,cleanlinessRating: freezed == cleanlinessRating ? _self.cleanlinessRating : cleanlinessRating // ignore: cast_nullable_to_non_nullable
as int?,checklist: null == checklist ? _self.checklist : checklist // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as Map<String, String>,existingDamagesNotes: freezed == existingDamagesNotes ? _self.existingDamagesNotes : existingDamagesNotes // ignore: cast_nullable_to_non_nullable
as String?,sealedHash: freezed == sealedHash ? _self.sealedHash : sealedHash // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,loanStatus: freezed == loanStatus ? _self.loanStatus : loanStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanInspection].
extension LoanInspectionPatterns on LoanInspection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanInspection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanInspection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanInspection value)  $default,){
final _that = this;
switch (_that) {
case _LoanInspection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanInspection value)?  $default,){
final _that = this;
switch (_that) {
case _LoanInspection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'loan_id')  int loanId, @JsonKey(name: 'inspection_type')  String inspectionType, @JsonKey(name: 'odometer_km')  int? odometerKm, @JsonKey(name: 'fuel_battery_level_percent')  int? fuelBatteryLevelPercent, @JsonKey(name: 'cleanliness_rating')  int? cleanlinessRating,  Map<String, dynamic> checklist,  Map<String, String> photos, @JsonKey(name: 'existing_damages_notes')  String? existingDamagesNotes, @JsonKey(name: 'sealed_hash')  String? sealedHash, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'loan_status')  String? loanStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanInspection() when $default != null:
return $default(_that.loanId,_that.inspectionType,_that.odometerKm,_that.fuelBatteryLevelPercent,_that.cleanlinessRating,_that.checklist,_that.photos,_that.existingDamagesNotes,_that.sealedHash,_that.createdAt,_that.loanStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'loan_id')  int loanId, @JsonKey(name: 'inspection_type')  String inspectionType, @JsonKey(name: 'odometer_km')  int? odometerKm, @JsonKey(name: 'fuel_battery_level_percent')  int? fuelBatteryLevelPercent, @JsonKey(name: 'cleanliness_rating')  int? cleanlinessRating,  Map<String, dynamic> checklist,  Map<String, String> photos, @JsonKey(name: 'existing_damages_notes')  String? existingDamagesNotes, @JsonKey(name: 'sealed_hash')  String? sealedHash, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'loan_status')  String? loanStatus)  $default,) {final _that = this;
switch (_that) {
case _LoanInspection():
return $default(_that.loanId,_that.inspectionType,_that.odometerKm,_that.fuelBatteryLevelPercent,_that.cleanlinessRating,_that.checklist,_that.photos,_that.existingDamagesNotes,_that.sealedHash,_that.createdAt,_that.loanStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'loan_id')  int loanId, @JsonKey(name: 'inspection_type')  String inspectionType, @JsonKey(name: 'odometer_km')  int? odometerKm, @JsonKey(name: 'fuel_battery_level_percent')  int? fuelBatteryLevelPercent, @JsonKey(name: 'cleanliness_rating')  int? cleanlinessRating,  Map<String, dynamic> checklist,  Map<String, String> photos, @JsonKey(name: 'existing_damages_notes')  String? existingDamagesNotes, @JsonKey(name: 'sealed_hash')  String? sealedHash, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'loan_status')  String? loanStatus)?  $default,) {final _that = this;
switch (_that) {
case _LoanInspection() when $default != null:
return $default(_that.loanId,_that.inspectionType,_that.odometerKm,_that.fuelBatteryLevelPercent,_that.cleanlinessRating,_that.checklist,_that.photos,_that.existingDamagesNotes,_that.sealedHash,_that.createdAt,_that.loanStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoanInspection implements LoanInspection {
  const _LoanInspection({@JsonKey(name: 'loan_id') required this.loanId, @JsonKey(name: 'inspection_type') required this.inspectionType, @JsonKey(name: 'odometer_km') this.odometerKm, @JsonKey(name: 'fuel_battery_level_percent') this.fuelBatteryLevelPercent, @JsonKey(name: 'cleanliness_rating') this.cleanlinessRating, final  Map<String, dynamic> checklist = const {}, final  Map<String, String> photos = const {}, @JsonKey(name: 'existing_damages_notes') this.existingDamagesNotes, @JsonKey(name: 'sealed_hash') this.sealedHash, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'loan_status') this.loanStatus}): _checklist = checklist,_photos = photos;
  factory _LoanInspection.fromJson(Map<String, dynamic> json) => _$LoanInspectionFromJson(json);

@override@JsonKey(name: 'loan_id') final  int loanId;
@override@JsonKey(name: 'inspection_type') final  String inspectionType;
@override@JsonKey(name: 'odometer_km') final  int? odometerKm;
@override@JsonKey(name: 'fuel_battery_level_percent') final  int? fuelBatteryLevelPercent;
@override@JsonKey(name: 'cleanliness_rating') final  int? cleanlinessRating;
 final  Map<String, dynamic> _checklist;
@override@JsonKey() Map<String, dynamic> get checklist {
  if (_checklist is EqualUnmodifiableMapView) return _checklist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_checklist);
}

 final  Map<String, String> _photos;
@override@JsonKey() Map<String, String> get photos {
  if (_photos is EqualUnmodifiableMapView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_photos);
}

@override@JsonKey(name: 'existing_damages_notes') final  String? existingDamagesNotes;
@override@JsonKey(name: 'sealed_hash') final  String? sealedHash;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'loan_status') final  String? loanStatus;

/// Create a copy of LoanInspection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanInspectionCopyWith<_LoanInspection> get copyWith => __$LoanInspectionCopyWithImpl<_LoanInspection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoanInspectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanInspection&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.inspectionType, inspectionType) || other.inspectionType == inspectionType)&&(identical(other.odometerKm, odometerKm) || other.odometerKm == odometerKm)&&(identical(other.fuelBatteryLevelPercent, fuelBatteryLevelPercent) || other.fuelBatteryLevelPercent == fuelBatteryLevelPercent)&&(identical(other.cleanlinessRating, cleanlinessRating) || other.cleanlinessRating == cleanlinessRating)&&const DeepCollectionEquality().equals(other._checklist, _checklist)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.existingDamagesNotes, existingDamagesNotes) || other.existingDamagesNotes == existingDamagesNotes)&&(identical(other.sealedHash, sealedHash) || other.sealedHash == sealedHash)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.loanStatus, loanStatus) || other.loanStatus == loanStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,loanId,inspectionType,odometerKm,fuelBatteryLevelPercent,cleanlinessRating,const DeepCollectionEquality().hash(_checklist),const DeepCollectionEquality().hash(_photos),existingDamagesNotes,sealedHash,createdAt,loanStatus);

@override
String toString() {
  return 'LoanInspection(loanId: $loanId, inspectionType: $inspectionType, odometerKm: $odometerKm, fuelBatteryLevelPercent: $fuelBatteryLevelPercent, cleanlinessRating: $cleanlinessRating, checklist: $checklist, photos: $photos, existingDamagesNotes: $existingDamagesNotes, sealedHash: $sealedHash, createdAt: $createdAt, loanStatus: $loanStatus)';
}


}

/// @nodoc
abstract mixin class _$LoanInspectionCopyWith<$Res> implements $LoanInspectionCopyWith<$Res> {
  factory _$LoanInspectionCopyWith(_LoanInspection value, $Res Function(_LoanInspection) _then) = __$LoanInspectionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'loan_id') int loanId,@JsonKey(name: 'inspection_type') String inspectionType,@JsonKey(name: 'odometer_km') int? odometerKm,@JsonKey(name: 'fuel_battery_level_percent') int? fuelBatteryLevelPercent,@JsonKey(name: 'cleanliness_rating') int? cleanlinessRating, Map<String, dynamic> checklist, Map<String, String> photos,@JsonKey(name: 'existing_damages_notes') String? existingDamagesNotes,@JsonKey(name: 'sealed_hash') String? sealedHash,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'loan_status') String? loanStatus
});




}
/// @nodoc
class __$LoanInspectionCopyWithImpl<$Res>
    implements _$LoanInspectionCopyWith<$Res> {
  __$LoanInspectionCopyWithImpl(this._self, this._then);

  final _LoanInspection _self;
  final $Res Function(_LoanInspection) _then;

/// Create a copy of LoanInspection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loanId = null,Object? inspectionType = null,Object? odometerKm = freezed,Object? fuelBatteryLevelPercent = freezed,Object? cleanlinessRating = freezed,Object? checklist = null,Object? photos = null,Object? existingDamagesNotes = freezed,Object? sealedHash = freezed,Object? createdAt = freezed,Object? loanStatus = freezed,}) {
  return _then(_LoanInspection(
loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int,inspectionType: null == inspectionType ? _self.inspectionType : inspectionType // ignore: cast_nullable_to_non_nullable
as String,odometerKm: freezed == odometerKm ? _self.odometerKm : odometerKm // ignore: cast_nullable_to_non_nullable
as int?,fuelBatteryLevelPercent: freezed == fuelBatteryLevelPercent ? _self.fuelBatteryLevelPercent : fuelBatteryLevelPercent // ignore: cast_nullable_to_non_nullable
as int?,cleanlinessRating: freezed == cleanlinessRating ? _self.cleanlinessRating : cleanlinessRating // ignore: cast_nullable_to_non_nullable
as int?,checklist: null == checklist ? _self._checklist : checklist // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as Map<String, String>,existingDamagesNotes: freezed == existingDamagesNotes ? _self.existingDamagesNotes : existingDamagesNotes // ignore: cast_nullable_to_non_nullable
as String?,sealedHash: freezed == sealedHash ? _self.sealedHash : sealedHash // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,loanStatus: freezed == loanStatus ? _self.loanStatus : loanStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

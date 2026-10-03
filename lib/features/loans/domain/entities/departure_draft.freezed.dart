// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'departure_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DraftPhotoEntry {

 String get field; String? get localPath; DraftPhotoStatus get status; int? get imageId; String? get errorMessage;
/// Create a copy of DraftPhotoEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DraftPhotoEntryCopyWith<DraftPhotoEntry> get copyWith => _$DraftPhotoEntryCopyWithImpl<DraftPhotoEntry>(this as DraftPhotoEntry, _$identity);

  /// Serializes this DraftPhotoEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DraftPhotoEntry&&(identical(other.field, field) || other.field == field)&&(identical(other.localPath, localPath) || other.localPath == localPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.imageId, imageId) || other.imageId == imageId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,localPath,status,imageId,errorMessage);

@override
String toString() {
  return 'DraftPhotoEntry(field: $field, localPath: $localPath, status: $status, imageId: $imageId, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $DraftPhotoEntryCopyWith<$Res>  {
  factory $DraftPhotoEntryCopyWith(DraftPhotoEntry value, $Res Function(DraftPhotoEntry) _then) = _$DraftPhotoEntryCopyWithImpl;
@useResult
$Res call({
 String field, String? localPath, DraftPhotoStatus status, int? imageId, String? errorMessage
});




}
/// @nodoc
class _$DraftPhotoEntryCopyWithImpl<$Res>
    implements $DraftPhotoEntryCopyWith<$Res> {
  _$DraftPhotoEntryCopyWithImpl(this._self, this._then);

  final DraftPhotoEntry _self;
  final $Res Function(DraftPhotoEntry) _then;

/// Create a copy of DraftPhotoEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field = null,Object? localPath = freezed,Object? status = null,Object? imageId = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DraftPhotoStatus,imageId: freezed == imageId ? _self.imageId : imageId // ignore: cast_nullable_to_non_nullable
as int?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DraftPhotoEntry].
extension DraftPhotoEntryPatterns on DraftPhotoEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DraftPhotoEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DraftPhotoEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DraftPhotoEntry value)  $default,){
final _that = this;
switch (_that) {
case _DraftPhotoEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DraftPhotoEntry value)?  $default,){
final _that = this;
switch (_that) {
case _DraftPhotoEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String field,  String? localPath,  DraftPhotoStatus status,  int? imageId,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DraftPhotoEntry() when $default != null:
return $default(_that.field,_that.localPath,_that.status,_that.imageId,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String field,  String? localPath,  DraftPhotoStatus status,  int? imageId,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _DraftPhotoEntry():
return $default(_that.field,_that.localPath,_that.status,_that.imageId,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String field,  String? localPath,  DraftPhotoStatus status,  int? imageId,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _DraftPhotoEntry() when $default != null:
return $default(_that.field,_that.localPath,_that.status,_that.imageId,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DraftPhotoEntry implements DraftPhotoEntry {
  const _DraftPhotoEntry({required this.field, this.localPath, this.status = DraftPhotoStatus.notTaken, this.imageId, this.errorMessage});
  factory _DraftPhotoEntry.fromJson(Map<String, dynamic> json) => _$DraftPhotoEntryFromJson(json);

@override final  String field;
@override final  String? localPath;
@override@JsonKey() final  DraftPhotoStatus status;
@override final  int? imageId;
@override final  String? errorMessage;

/// Create a copy of DraftPhotoEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DraftPhotoEntryCopyWith<_DraftPhotoEntry> get copyWith => __$DraftPhotoEntryCopyWithImpl<_DraftPhotoEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DraftPhotoEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DraftPhotoEntry&&(identical(other.field, field) || other.field == field)&&(identical(other.localPath, localPath) || other.localPath == localPath)&&(identical(other.status, status) || other.status == status)&&(identical(other.imageId, imageId) || other.imageId == imageId)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,field,localPath,status,imageId,errorMessage);

@override
String toString() {
  return 'DraftPhotoEntry(field: $field, localPath: $localPath, status: $status, imageId: $imageId, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$DraftPhotoEntryCopyWith<$Res> implements $DraftPhotoEntryCopyWith<$Res> {
  factory _$DraftPhotoEntryCopyWith(_DraftPhotoEntry value, $Res Function(_DraftPhotoEntry) _then) = __$DraftPhotoEntryCopyWithImpl;
@override @useResult
$Res call({
 String field, String? localPath, DraftPhotoStatus status, int? imageId, String? errorMessage
});




}
/// @nodoc
class __$DraftPhotoEntryCopyWithImpl<$Res>
    implements _$DraftPhotoEntryCopyWith<$Res> {
  __$DraftPhotoEntryCopyWithImpl(this._self, this._then);

  final _DraftPhotoEntry _self;
  final $Res Function(_DraftPhotoEntry) _then;

/// Create a copy of DraftPhotoEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? localPath = freezed,Object? status = null,Object? imageId = freezed,Object? errorMessage = freezed,}) {
  return _then(_DraftPhotoEntry(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,localPath: freezed == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DraftPhotoStatus,imageId: freezed == imageId ? _self.imageId : imageId // ignore: cast_nullable_to_non_nullable
as int?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DepartureDraft {

 int get userId; int get loanId; int? get odometerKm; int get fuelBatteryLevelPercent; int get cleanlinessRating; Map<String, bool> get checklist; String? get existingDamagesNotes; Map<String, DraftPhotoEntry> get photos; DateTime? get updatedAt;
/// Create a copy of DepartureDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DepartureDraftCopyWith<DepartureDraft> get copyWith => _$DepartureDraftCopyWithImpl<DepartureDraft>(this as DepartureDraft, _$identity);

  /// Serializes this DepartureDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DepartureDraft&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.odometerKm, odometerKm) || other.odometerKm == odometerKm)&&(identical(other.fuelBatteryLevelPercent, fuelBatteryLevelPercent) || other.fuelBatteryLevelPercent == fuelBatteryLevelPercent)&&(identical(other.cleanlinessRating, cleanlinessRating) || other.cleanlinessRating == cleanlinessRating)&&const DeepCollectionEquality().equals(other.checklist, checklist)&&(identical(other.existingDamagesNotes, existingDamagesNotes) || other.existingDamagesNotes == existingDamagesNotes)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,loanId,odometerKm,fuelBatteryLevelPercent,cleanlinessRating,const DeepCollectionEquality().hash(checklist),existingDamagesNotes,const DeepCollectionEquality().hash(photos),updatedAt);

@override
String toString() {
  return 'DepartureDraft(userId: $userId, loanId: $loanId, odometerKm: $odometerKm, fuelBatteryLevelPercent: $fuelBatteryLevelPercent, cleanlinessRating: $cleanlinessRating, checklist: $checklist, existingDamagesNotes: $existingDamagesNotes, photos: $photos, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DepartureDraftCopyWith<$Res>  {
  factory $DepartureDraftCopyWith(DepartureDraft value, $Res Function(DepartureDraft) _then) = _$DepartureDraftCopyWithImpl;
@useResult
$Res call({
 int userId, int loanId, int? odometerKm, int fuelBatteryLevelPercent, int cleanlinessRating, Map<String, bool> checklist, String? existingDamagesNotes, Map<String, DraftPhotoEntry> photos, DateTime? updatedAt
});




}
/// @nodoc
class _$DepartureDraftCopyWithImpl<$Res>
    implements $DepartureDraftCopyWith<$Res> {
  _$DepartureDraftCopyWithImpl(this._self, this._then);

  final DepartureDraft _self;
  final $Res Function(DepartureDraft) _then;

/// Create a copy of DepartureDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? loanId = null,Object? odometerKm = freezed,Object? fuelBatteryLevelPercent = null,Object? cleanlinessRating = null,Object? checklist = null,Object? existingDamagesNotes = freezed,Object? photos = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int,odometerKm: freezed == odometerKm ? _self.odometerKm : odometerKm // ignore: cast_nullable_to_non_nullable
as int?,fuelBatteryLevelPercent: null == fuelBatteryLevelPercent ? _self.fuelBatteryLevelPercent : fuelBatteryLevelPercent // ignore: cast_nullable_to_non_nullable
as int,cleanlinessRating: null == cleanlinessRating ? _self.cleanlinessRating : cleanlinessRating // ignore: cast_nullable_to_non_nullable
as int,checklist: null == checklist ? _self.checklist : checklist // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,existingDamagesNotes: freezed == existingDamagesNotes ? _self.existingDamagesNotes : existingDamagesNotes // ignore: cast_nullable_to_non_nullable
as String?,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as Map<String, DraftPhotoEntry>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DepartureDraft].
extension DepartureDraftPatterns on DepartureDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DepartureDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DepartureDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DepartureDraft value)  $default,){
final _that = this;
switch (_that) {
case _DepartureDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DepartureDraft value)?  $default,){
final _that = this;
switch (_that) {
case _DepartureDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  int loanId,  int? odometerKm,  int fuelBatteryLevelPercent,  int cleanlinessRating,  Map<String, bool> checklist,  String? existingDamagesNotes,  Map<String, DraftPhotoEntry> photos,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DepartureDraft() when $default != null:
return $default(_that.userId,_that.loanId,_that.odometerKm,_that.fuelBatteryLevelPercent,_that.cleanlinessRating,_that.checklist,_that.existingDamagesNotes,_that.photos,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  int loanId,  int? odometerKm,  int fuelBatteryLevelPercent,  int cleanlinessRating,  Map<String, bool> checklist,  String? existingDamagesNotes,  Map<String, DraftPhotoEntry> photos,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DepartureDraft():
return $default(_that.userId,_that.loanId,_that.odometerKm,_that.fuelBatteryLevelPercent,_that.cleanlinessRating,_that.checklist,_that.existingDamagesNotes,_that.photos,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  int loanId,  int? odometerKm,  int fuelBatteryLevelPercent,  int cleanlinessRating,  Map<String, bool> checklist,  String? existingDamagesNotes,  Map<String, DraftPhotoEntry> photos,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DepartureDraft() when $default != null:
return $default(_that.userId,_that.loanId,_that.odometerKm,_that.fuelBatteryLevelPercent,_that.cleanlinessRating,_that.checklist,_that.existingDamagesNotes,_that.photos,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DepartureDraft extends DepartureDraft {
  const _DepartureDraft({required this.userId, required this.loanId, this.odometerKm, this.fuelBatteryLevelPercent = 80, this.cleanlinessRating = 4, final  Map<String, bool> checklist = const {}, this.existingDamagesNotes, final  Map<String, DraftPhotoEntry> photos = const {}, this.updatedAt}): _checklist = checklist,_photos = photos,super._();
  factory _DepartureDraft.fromJson(Map<String, dynamic> json) => _$DepartureDraftFromJson(json);

@override final  int userId;
@override final  int loanId;
@override final  int? odometerKm;
@override@JsonKey() final  int fuelBatteryLevelPercent;
@override@JsonKey() final  int cleanlinessRating;
 final  Map<String, bool> _checklist;
@override@JsonKey() Map<String, bool> get checklist {
  if (_checklist is EqualUnmodifiableMapView) return _checklist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_checklist);
}

@override final  String? existingDamagesNotes;
 final  Map<String, DraftPhotoEntry> _photos;
@override@JsonKey() Map<String, DraftPhotoEntry> get photos {
  if (_photos is EqualUnmodifiableMapView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_photos);
}

@override final  DateTime? updatedAt;

/// Create a copy of DepartureDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DepartureDraftCopyWith<_DepartureDraft> get copyWith => __$DepartureDraftCopyWithImpl<_DepartureDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DepartureDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DepartureDraft&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.odometerKm, odometerKm) || other.odometerKm == odometerKm)&&(identical(other.fuelBatteryLevelPercent, fuelBatteryLevelPercent) || other.fuelBatteryLevelPercent == fuelBatteryLevelPercent)&&(identical(other.cleanlinessRating, cleanlinessRating) || other.cleanlinessRating == cleanlinessRating)&&const DeepCollectionEquality().equals(other._checklist, _checklist)&&(identical(other.existingDamagesNotes, existingDamagesNotes) || other.existingDamagesNotes == existingDamagesNotes)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,loanId,odometerKm,fuelBatteryLevelPercent,cleanlinessRating,const DeepCollectionEquality().hash(_checklist),existingDamagesNotes,const DeepCollectionEquality().hash(_photos),updatedAt);

@override
String toString() {
  return 'DepartureDraft(userId: $userId, loanId: $loanId, odometerKm: $odometerKm, fuelBatteryLevelPercent: $fuelBatteryLevelPercent, cleanlinessRating: $cleanlinessRating, checklist: $checklist, existingDamagesNotes: $existingDamagesNotes, photos: $photos, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DepartureDraftCopyWith<$Res> implements $DepartureDraftCopyWith<$Res> {
  factory _$DepartureDraftCopyWith(_DepartureDraft value, $Res Function(_DepartureDraft) _then) = __$DepartureDraftCopyWithImpl;
@override @useResult
$Res call({
 int userId, int loanId, int? odometerKm, int fuelBatteryLevelPercent, int cleanlinessRating, Map<String, bool> checklist, String? existingDamagesNotes, Map<String, DraftPhotoEntry> photos, DateTime? updatedAt
});




}
/// @nodoc
class __$DepartureDraftCopyWithImpl<$Res>
    implements _$DepartureDraftCopyWith<$Res> {
  __$DepartureDraftCopyWithImpl(this._self, this._then);

  final _DepartureDraft _self;
  final $Res Function(_DepartureDraft) _then;

/// Create a copy of DepartureDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? loanId = null,Object? odometerKm = freezed,Object? fuelBatteryLevelPercent = null,Object? cleanlinessRating = null,Object? checklist = null,Object? existingDamagesNotes = freezed,Object? photos = null,Object? updatedAt = freezed,}) {
  return _then(_DepartureDraft(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int,odometerKm: freezed == odometerKm ? _self.odometerKm : odometerKm // ignore: cast_nullable_to_non_nullable
as int?,fuelBatteryLevelPercent: null == fuelBatteryLevelPercent ? _self.fuelBatteryLevelPercent : fuelBatteryLevelPercent // ignore: cast_nullable_to_non_nullable
as int,cleanlinessRating: null == cleanlinessRating ? _self.cleanlinessRating : cleanlinessRating // ignore: cast_nullable_to_non_nullable
as int,checklist: null == checklist ? _self._checklist : checklist // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,existingDamagesNotes: freezed == existingDamagesNotes ? _self.existingDamagesNotes : existingDamagesNotes // ignore: cast_nullable_to_non_nullable
as String?,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as Map<String, DraftPhotoEntry>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

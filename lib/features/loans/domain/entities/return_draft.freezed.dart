// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'return_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReturnDraft {

 int get userId; int get loanId; int? get odometerKm; int get fuelBatteryLevelPercent; int get cleanlinessRating; Map<String, bool> get checklist; bool get newDamagesDeclared; String? get comments; DraftPhotoEntry? get signaturePhoto; String? get signerFullName; Map<String, DraftPhotoEntry> get photos; DateTime? get updatedAt;
/// Create a copy of ReturnDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnDraftCopyWith<ReturnDraft> get copyWith => _$ReturnDraftCopyWithImpl<ReturnDraft>(this as ReturnDraft, _$identity);

  /// Serializes this ReturnDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnDraft&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.odometerKm, odometerKm) || other.odometerKm == odometerKm)&&(identical(other.fuelBatteryLevelPercent, fuelBatteryLevelPercent) || other.fuelBatteryLevelPercent == fuelBatteryLevelPercent)&&(identical(other.cleanlinessRating, cleanlinessRating) || other.cleanlinessRating == cleanlinessRating)&&const DeepCollectionEquality().equals(other.checklist, checklist)&&(identical(other.newDamagesDeclared, newDamagesDeclared) || other.newDamagesDeclared == newDamagesDeclared)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.signaturePhoto, signaturePhoto) || other.signaturePhoto == signaturePhoto)&&(identical(other.signerFullName, signerFullName) || other.signerFullName == signerFullName)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,loanId,odometerKm,fuelBatteryLevelPercent,cleanlinessRating,const DeepCollectionEquality().hash(checklist),newDamagesDeclared,comments,signaturePhoto,signerFullName,const DeepCollectionEquality().hash(photos),updatedAt);

@override
String toString() {
  return 'ReturnDraft(userId: $userId, loanId: $loanId, odometerKm: $odometerKm, fuelBatteryLevelPercent: $fuelBatteryLevelPercent, cleanlinessRating: $cleanlinessRating, checklist: $checklist, newDamagesDeclared: $newDamagesDeclared, comments: $comments, signaturePhoto: $signaturePhoto, signerFullName: $signerFullName, photos: $photos, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReturnDraftCopyWith<$Res>  {
  factory $ReturnDraftCopyWith(ReturnDraft value, $Res Function(ReturnDraft) _then) = _$ReturnDraftCopyWithImpl;
@useResult
$Res call({
 int userId, int loanId, int? odometerKm, int fuelBatteryLevelPercent, int cleanlinessRating, Map<String, bool> checklist, bool newDamagesDeclared, String? comments, DraftPhotoEntry? signaturePhoto, String? signerFullName, Map<String, DraftPhotoEntry> photos, DateTime? updatedAt
});


$DraftPhotoEntryCopyWith<$Res>? get signaturePhoto;

}
/// @nodoc
class _$ReturnDraftCopyWithImpl<$Res>
    implements $ReturnDraftCopyWith<$Res> {
  _$ReturnDraftCopyWithImpl(this._self, this._then);

  final ReturnDraft _self;
  final $Res Function(ReturnDraft) _then;

/// Create a copy of ReturnDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? loanId = null,Object? odometerKm = freezed,Object? fuelBatteryLevelPercent = null,Object? cleanlinessRating = null,Object? checklist = null,Object? newDamagesDeclared = null,Object? comments = freezed,Object? signaturePhoto = freezed,Object? signerFullName = freezed,Object? photos = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int,odometerKm: freezed == odometerKm ? _self.odometerKm : odometerKm // ignore: cast_nullable_to_non_nullable
as int?,fuelBatteryLevelPercent: null == fuelBatteryLevelPercent ? _self.fuelBatteryLevelPercent : fuelBatteryLevelPercent // ignore: cast_nullable_to_non_nullable
as int,cleanlinessRating: null == cleanlinessRating ? _self.cleanlinessRating : cleanlinessRating // ignore: cast_nullable_to_non_nullable
as int,checklist: null == checklist ? _self.checklist : checklist // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,newDamagesDeclared: null == newDamagesDeclared ? _self.newDamagesDeclared : newDamagesDeclared // ignore: cast_nullable_to_non_nullable
as bool,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,signaturePhoto: freezed == signaturePhoto ? _self.signaturePhoto : signaturePhoto // ignore: cast_nullable_to_non_nullable
as DraftPhotoEntry?,signerFullName: freezed == signerFullName ? _self.signerFullName : signerFullName // ignore: cast_nullable_to_non_nullable
as String?,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as Map<String, DraftPhotoEntry>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of ReturnDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DraftPhotoEntryCopyWith<$Res>? get signaturePhoto {
    if (_self.signaturePhoto == null) {
    return null;
  }

  return $DraftPhotoEntryCopyWith<$Res>(_self.signaturePhoto!, (value) {
    return _then(_self.copyWith(signaturePhoto: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReturnDraft].
extension ReturnDraftPatterns on ReturnDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnDraft value)  $default,){
final _that = this;
switch (_that) {
case _ReturnDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  int loanId,  int? odometerKm,  int fuelBatteryLevelPercent,  int cleanlinessRating,  Map<String, bool> checklist,  bool newDamagesDeclared,  String? comments,  DraftPhotoEntry? signaturePhoto,  String? signerFullName,  Map<String, DraftPhotoEntry> photos,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReturnDraft() when $default != null:
return $default(_that.userId,_that.loanId,_that.odometerKm,_that.fuelBatteryLevelPercent,_that.cleanlinessRating,_that.checklist,_that.newDamagesDeclared,_that.comments,_that.signaturePhoto,_that.signerFullName,_that.photos,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  int loanId,  int? odometerKm,  int fuelBatteryLevelPercent,  int cleanlinessRating,  Map<String, bool> checklist,  bool newDamagesDeclared,  String? comments,  DraftPhotoEntry? signaturePhoto,  String? signerFullName,  Map<String, DraftPhotoEntry> photos,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReturnDraft():
return $default(_that.userId,_that.loanId,_that.odometerKm,_that.fuelBatteryLevelPercent,_that.cleanlinessRating,_that.checklist,_that.newDamagesDeclared,_that.comments,_that.signaturePhoto,_that.signerFullName,_that.photos,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  int loanId,  int? odometerKm,  int fuelBatteryLevelPercent,  int cleanlinessRating,  Map<String, bool> checklist,  bool newDamagesDeclared,  String? comments,  DraftPhotoEntry? signaturePhoto,  String? signerFullName,  Map<String, DraftPhotoEntry> photos,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReturnDraft() when $default != null:
return $default(_that.userId,_that.loanId,_that.odometerKm,_that.fuelBatteryLevelPercent,_that.cleanlinessRating,_that.checklist,_that.newDamagesDeclared,_that.comments,_that.signaturePhoto,_that.signerFullName,_that.photos,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReturnDraft extends ReturnDraft {
  const _ReturnDraft({required this.userId, required this.loanId, this.odometerKm, this.fuelBatteryLevelPercent = 80, this.cleanlinessRating = 4, final  Map<String, bool> checklist = const {}, this.newDamagesDeclared = false, this.comments, this.signaturePhoto, this.signerFullName, final  Map<String, DraftPhotoEntry> photos = const {}, this.updatedAt}): _checklist = checklist,_photos = photos,super._();
  factory _ReturnDraft.fromJson(Map<String, dynamic> json) => _$ReturnDraftFromJson(json);

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

@override@JsonKey() final  bool newDamagesDeclared;
@override final  String? comments;
@override final  DraftPhotoEntry? signaturePhoto;
@override final  String? signerFullName;
 final  Map<String, DraftPhotoEntry> _photos;
@override@JsonKey() Map<String, DraftPhotoEntry> get photos {
  if (_photos is EqualUnmodifiableMapView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_photos);
}

@override final  DateTime? updatedAt;

/// Create a copy of ReturnDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnDraftCopyWith<_ReturnDraft> get copyWith => __$ReturnDraftCopyWithImpl<_ReturnDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReturnDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnDraft&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.odometerKm, odometerKm) || other.odometerKm == odometerKm)&&(identical(other.fuelBatteryLevelPercent, fuelBatteryLevelPercent) || other.fuelBatteryLevelPercent == fuelBatteryLevelPercent)&&(identical(other.cleanlinessRating, cleanlinessRating) || other.cleanlinessRating == cleanlinessRating)&&const DeepCollectionEquality().equals(other._checklist, _checklist)&&(identical(other.newDamagesDeclared, newDamagesDeclared) || other.newDamagesDeclared == newDamagesDeclared)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.signaturePhoto, signaturePhoto) || other.signaturePhoto == signaturePhoto)&&(identical(other.signerFullName, signerFullName) || other.signerFullName == signerFullName)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,loanId,odometerKm,fuelBatteryLevelPercent,cleanlinessRating,const DeepCollectionEquality().hash(_checklist),newDamagesDeclared,comments,signaturePhoto,signerFullName,const DeepCollectionEquality().hash(_photos),updatedAt);

@override
String toString() {
  return 'ReturnDraft(userId: $userId, loanId: $loanId, odometerKm: $odometerKm, fuelBatteryLevelPercent: $fuelBatteryLevelPercent, cleanlinessRating: $cleanlinessRating, checklist: $checklist, newDamagesDeclared: $newDamagesDeclared, comments: $comments, signaturePhoto: $signaturePhoto, signerFullName: $signerFullName, photos: $photos, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReturnDraftCopyWith<$Res> implements $ReturnDraftCopyWith<$Res> {
  factory _$ReturnDraftCopyWith(_ReturnDraft value, $Res Function(_ReturnDraft) _then) = __$ReturnDraftCopyWithImpl;
@override @useResult
$Res call({
 int userId, int loanId, int? odometerKm, int fuelBatteryLevelPercent, int cleanlinessRating, Map<String, bool> checklist, bool newDamagesDeclared, String? comments, DraftPhotoEntry? signaturePhoto, String? signerFullName, Map<String, DraftPhotoEntry> photos, DateTime? updatedAt
});


@override $DraftPhotoEntryCopyWith<$Res>? get signaturePhoto;

}
/// @nodoc
class __$ReturnDraftCopyWithImpl<$Res>
    implements _$ReturnDraftCopyWith<$Res> {
  __$ReturnDraftCopyWithImpl(this._self, this._then);

  final _ReturnDraft _self;
  final $Res Function(_ReturnDraft) _then;

/// Create a copy of ReturnDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? loanId = null,Object? odometerKm = freezed,Object? fuelBatteryLevelPercent = null,Object? cleanlinessRating = null,Object? checklist = null,Object? newDamagesDeclared = null,Object? comments = freezed,Object? signaturePhoto = freezed,Object? signerFullName = freezed,Object? photos = null,Object? updatedAt = freezed,}) {
  return _then(_ReturnDraft(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,loanId: null == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int,odometerKm: freezed == odometerKm ? _self.odometerKm : odometerKm // ignore: cast_nullable_to_non_nullable
as int?,fuelBatteryLevelPercent: null == fuelBatteryLevelPercent ? _self.fuelBatteryLevelPercent : fuelBatteryLevelPercent // ignore: cast_nullable_to_non_nullable
as int,cleanlinessRating: null == cleanlinessRating ? _self.cleanlinessRating : cleanlinessRating // ignore: cast_nullable_to_non_nullable
as int,checklist: null == checklist ? _self._checklist : checklist // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,newDamagesDeclared: null == newDamagesDeclared ? _self.newDamagesDeclared : newDamagesDeclared // ignore: cast_nullable_to_non_nullable
as bool,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,signaturePhoto: freezed == signaturePhoto ? _self.signaturePhoto : signaturePhoto // ignore: cast_nullable_to_non_nullable
as DraftPhotoEntry?,signerFullName: freezed == signerFullName ? _self.signerFullName : signerFullName // ignore: cast_nullable_to_non_nullable
as String?,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as Map<String, DraftPhotoEntry>,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ReturnDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DraftPhotoEntryCopyWith<$Res>? get signaturePhoto {
    if (_self.signaturePhoto == null) {
    return null;
  }

  return $DraftPhotoEntryCopyWith<$Res>(_self.signaturePhoto!, (value) {
    return _then(_self.copyWith(signaturePhoto: value));
  });
}
}

// dart format on

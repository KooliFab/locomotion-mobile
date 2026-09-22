// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loanable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Loanable {

 int get id; String get name; String get type;// 'bike', 'car', 'trailer', 'car_trailer'
@JsonKey(name: 'sharing_mode') String? get sharingMode;@JsonKey(name: 'availability_status') String? get availabilityStatus;@JsonKey(name: 'availability_mode') String? get availabilityMode; String? get timezone; double? get latitude; double? get longitude;@JsonKey(name: 'location_description') String? get locationDescription; String? get comments; String? get instructions;@JsonKey(name: 'return_instructions') String? get returnInstructions;@JsonKey(name: 'min_loan_duration_in_minutes') int? get minLoanDurationInMinutes;@JsonKey(name: 'max_loan_duration_in_minutes') int? get maxLoanDurationInMinutes; LoanableImage? get image; List<LoanableImage> get images;@JsonKey(name: 'active_incidents') List<LoanableIncident> get activeIncidents; Map<String, dynamic>? get details;@JsonKey(name: 'community_ids') List<int>? get communityIds;@JsonKey(name: 'community_name') String? get communityName;@JsonKey(name: 'community_id') int? get communityId;// Convenience / legacy compatibility fields
 String? get description; String? get address; String? get imageUrl;
/// Create a copy of Loanable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanableCopyWith<Loanable> get copyWith => _$LoanableCopyWithImpl<Loanable>(this as Loanable, _$identity);

  /// Serializes this Loanable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loanable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.sharingMode, sharingMode) || other.sharingMode == sharingMode)&&(identical(other.availabilityStatus, availabilityStatus) || other.availabilityStatus == availabilityStatus)&&(identical(other.availabilityMode, availabilityMode) || other.availabilityMode == availabilityMode)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.locationDescription, locationDescription) || other.locationDescription == locationDescription)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.returnInstructions, returnInstructions) || other.returnInstructions == returnInstructions)&&(identical(other.minLoanDurationInMinutes, minLoanDurationInMinutes) || other.minLoanDurationInMinutes == minLoanDurationInMinutes)&&(identical(other.maxLoanDurationInMinutes, maxLoanDurationInMinutes) || other.maxLoanDurationInMinutes == maxLoanDurationInMinutes)&&(identical(other.image, image) || other.image == image)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.activeIncidents, activeIncidents)&&const DeepCollectionEquality().equals(other.details, details)&&const DeepCollectionEquality().equals(other.communityIds, communityIds)&&(identical(other.communityName, communityName) || other.communityName == communityName)&&(identical(other.communityId, communityId) || other.communityId == communityId)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,type,sharingMode,availabilityStatus,availabilityMode,timezone,latitude,longitude,locationDescription,comments,instructions,returnInstructions,minLoanDurationInMinutes,maxLoanDurationInMinutes,image,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(activeIncidents),const DeepCollectionEquality().hash(details),const DeepCollectionEquality().hash(communityIds),communityName,communityId,description,address,imageUrl]);

@override
String toString() {
  return 'Loanable(id: $id, name: $name, type: $type, sharingMode: $sharingMode, availabilityStatus: $availabilityStatus, availabilityMode: $availabilityMode, timezone: $timezone, latitude: $latitude, longitude: $longitude, locationDescription: $locationDescription, comments: $comments, instructions: $instructions, returnInstructions: $returnInstructions, minLoanDurationInMinutes: $minLoanDurationInMinutes, maxLoanDurationInMinutes: $maxLoanDurationInMinutes, image: $image, images: $images, activeIncidents: $activeIncidents, details: $details, communityIds: $communityIds, communityName: $communityName, communityId: $communityId, description: $description, address: $address, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $LoanableCopyWith<$Res>  {
  factory $LoanableCopyWith(Loanable value, $Res Function(Loanable) _then) = _$LoanableCopyWithImpl;
@useResult
$Res call({
 int id, String name, String type,@JsonKey(name: 'sharing_mode') String? sharingMode,@JsonKey(name: 'availability_status') String? availabilityStatus,@JsonKey(name: 'availability_mode') String? availabilityMode, String? timezone, double? latitude, double? longitude,@JsonKey(name: 'location_description') String? locationDescription, String? comments, String? instructions,@JsonKey(name: 'return_instructions') String? returnInstructions,@JsonKey(name: 'min_loan_duration_in_minutes') int? minLoanDurationInMinutes,@JsonKey(name: 'max_loan_duration_in_minutes') int? maxLoanDurationInMinutes, LoanableImage? image, List<LoanableImage> images,@JsonKey(name: 'active_incidents') List<LoanableIncident> activeIncidents, Map<String, dynamic>? details,@JsonKey(name: 'community_ids') List<int>? communityIds,@JsonKey(name: 'community_name') String? communityName,@JsonKey(name: 'community_id') int? communityId, String? description, String? address, String? imageUrl
});


$LoanableImageCopyWith<$Res>? get image;

}
/// @nodoc
class _$LoanableCopyWithImpl<$Res>
    implements $LoanableCopyWith<$Res> {
  _$LoanableCopyWithImpl(this._self, this._then);

  final Loanable _self;
  final $Res Function(Loanable) _then;

/// Create a copy of Loanable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? sharingMode = freezed,Object? availabilityStatus = freezed,Object? availabilityMode = freezed,Object? timezone = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? locationDescription = freezed,Object? comments = freezed,Object? instructions = freezed,Object? returnInstructions = freezed,Object? minLoanDurationInMinutes = freezed,Object? maxLoanDurationInMinutes = freezed,Object? image = freezed,Object? images = null,Object? activeIncidents = null,Object? details = freezed,Object? communityIds = freezed,Object? communityName = freezed,Object? communityId = freezed,Object? description = freezed,Object? address = freezed,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,sharingMode: freezed == sharingMode ? _self.sharingMode : sharingMode // ignore: cast_nullable_to_non_nullable
as String?,availabilityStatus: freezed == availabilityStatus ? _self.availabilityStatus : availabilityStatus // ignore: cast_nullable_to_non_nullable
as String?,availabilityMode: freezed == availabilityMode ? _self.availabilityMode : availabilityMode // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,locationDescription: freezed == locationDescription ? _self.locationDescription : locationDescription // ignore: cast_nullable_to_non_nullable
as String?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,returnInstructions: freezed == returnInstructions ? _self.returnInstructions : returnInstructions // ignore: cast_nullable_to_non_nullable
as String?,minLoanDurationInMinutes: freezed == minLoanDurationInMinutes ? _self.minLoanDurationInMinutes : minLoanDurationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,maxLoanDurationInMinutes: freezed == maxLoanDurationInMinutes ? _self.maxLoanDurationInMinutes : maxLoanDurationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as LoanableImage?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<LoanableImage>,activeIncidents: null == activeIncidents ? _self.activeIncidents : activeIncidents // ignore: cast_nullable_to_non_nullable
as List<LoanableIncident>,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,communityIds: freezed == communityIds ? _self.communityIds : communityIds // ignore: cast_nullable_to_non_nullable
as List<int>?,communityName: freezed == communityName ? _self.communityName : communityName // ignore: cast_nullable_to_non_nullable
as String?,communityId: freezed == communityId ? _self.communityId : communityId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Loanable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoanableImageCopyWith<$Res>? get image {
    if (_self.image == null) {
    return null;
  }

  return $LoanableImageCopyWith<$Res>(_self.image!, (value) {
    return _then(_self.copyWith(image: value));
  });
}
}


/// Adds pattern-matching-related methods to [Loanable].
extension LoanablePatterns on Loanable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Loanable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Loanable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Loanable value)  $default,){
final _that = this;
switch (_that) {
case _Loanable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Loanable value)?  $default,){
final _that = this;
switch (_that) {
case _Loanable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String type, @JsonKey(name: 'sharing_mode')  String? sharingMode, @JsonKey(name: 'availability_status')  String? availabilityStatus, @JsonKey(name: 'availability_mode')  String? availabilityMode,  String? timezone,  double? latitude,  double? longitude, @JsonKey(name: 'location_description')  String? locationDescription,  String? comments,  String? instructions, @JsonKey(name: 'return_instructions')  String? returnInstructions, @JsonKey(name: 'min_loan_duration_in_minutes')  int? minLoanDurationInMinutes, @JsonKey(name: 'max_loan_duration_in_minutes')  int? maxLoanDurationInMinutes,  LoanableImage? image,  List<LoanableImage> images, @JsonKey(name: 'active_incidents')  List<LoanableIncident> activeIncidents,  Map<String, dynamic>? details, @JsonKey(name: 'community_ids')  List<int>? communityIds, @JsonKey(name: 'community_name')  String? communityName, @JsonKey(name: 'community_id')  int? communityId,  String? description,  String? address,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loanable() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.sharingMode,_that.availabilityStatus,_that.availabilityMode,_that.timezone,_that.latitude,_that.longitude,_that.locationDescription,_that.comments,_that.instructions,_that.returnInstructions,_that.minLoanDurationInMinutes,_that.maxLoanDurationInMinutes,_that.image,_that.images,_that.activeIncidents,_that.details,_that.communityIds,_that.communityName,_that.communityId,_that.description,_that.address,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String type, @JsonKey(name: 'sharing_mode')  String? sharingMode, @JsonKey(name: 'availability_status')  String? availabilityStatus, @JsonKey(name: 'availability_mode')  String? availabilityMode,  String? timezone,  double? latitude,  double? longitude, @JsonKey(name: 'location_description')  String? locationDescription,  String? comments,  String? instructions, @JsonKey(name: 'return_instructions')  String? returnInstructions, @JsonKey(name: 'min_loan_duration_in_minutes')  int? minLoanDurationInMinutes, @JsonKey(name: 'max_loan_duration_in_minutes')  int? maxLoanDurationInMinutes,  LoanableImage? image,  List<LoanableImage> images, @JsonKey(name: 'active_incidents')  List<LoanableIncident> activeIncidents,  Map<String, dynamic>? details, @JsonKey(name: 'community_ids')  List<int>? communityIds, @JsonKey(name: 'community_name')  String? communityName, @JsonKey(name: 'community_id')  int? communityId,  String? description,  String? address,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _Loanable():
return $default(_that.id,_that.name,_that.type,_that.sharingMode,_that.availabilityStatus,_that.availabilityMode,_that.timezone,_that.latitude,_that.longitude,_that.locationDescription,_that.comments,_that.instructions,_that.returnInstructions,_that.minLoanDurationInMinutes,_that.maxLoanDurationInMinutes,_that.image,_that.images,_that.activeIncidents,_that.details,_that.communityIds,_that.communityName,_that.communityId,_that.description,_that.address,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String type, @JsonKey(name: 'sharing_mode')  String? sharingMode, @JsonKey(name: 'availability_status')  String? availabilityStatus, @JsonKey(name: 'availability_mode')  String? availabilityMode,  String? timezone,  double? latitude,  double? longitude, @JsonKey(name: 'location_description')  String? locationDescription,  String? comments,  String? instructions, @JsonKey(name: 'return_instructions')  String? returnInstructions, @JsonKey(name: 'min_loan_duration_in_minutes')  int? minLoanDurationInMinutes, @JsonKey(name: 'max_loan_duration_in_minutes')  int? maxLoanDurationInMinutes,  LoanableImage? image,  List<LoanableImage> images, @JsonKey(name: 'active_incidents')  List<LoanableIncident> activeIncidents,  Map<String, dynamic>? details, @JsonKey(name: 'community_ids')  List<int>? communityIds, @JsonKey(name: 'community_name')  String? communityName, @JsonKey(name: 'community_id')  int? communityId,  String? description,  String? address,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _Loanable() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.sharingMode,_that.availabilityStatus,_that.availabilityMode,_that.timezone,_that.latitude,_that.longitude,_that.locationDescription,_that.comments,_that.instructions,_that.returnInstructions,_that.minLoanDurationInMinutes,_that.maxLoanDurationInMinutes,_that.image,_that.images,_that.activeIncidents,_that.details,_that.communityIds,_that.communityName,_that.communityId,_that.description,_that.address,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Loanable extends Loanable {
  const _Loanable({required this.id, required this.name, required this.type, @JsonKey(name: 'sharing_mode') this.sharingMode, @JsonKey(name: 'availability_status') this.availabilityStatus, @JsonKey(name: 'availability_mode') this.availabilityMode, this.timezone, this.latitude, this.longitude, @JsonKey(name: 'location_description') this.locationDescription, this.comments, this.instructions, @JsonKey(name: 'return_instructions') this.returnInstructions, @JsonKey(name: 'min_loan_duration_in_minutes') this.minLoanDurationInMinutes, @JsonKey(name: 'max_loan_duration_in_minutes') this.maxLoanDurationInMinutes, this.image, final  List<LoanableImage> images = const [], @JsonKey(name: 'active_incidents') final  List<LoanableIncident> activeIncidents = const [], final  Map<String, dynamic>? details, @JsonKey(name: 'community_ids') final  List<int>? communityIds, @JsonKey(name: 'community_name') this.communityName, @JsonKey(name: 'community_id') this.communityId, this.description, this.address, this.imageUrl}): _images = images,_activeIncidents = activeIncidents,_details = details,_communityIds = communityIds,super._();
  factory _Loanable.fromJson(Map<String, dynamic> json) => _$LoanableFromJson(json);

@override final  int id;
@override final  String name;
@override final  String type;
// 'bike', 'car', 'trailer', 'car_trailer'
@override@JsonKey(name: 'sharing_mode') final  String? sharingMode;
@override@JsonKey(name: 'availability_status') final  String? availabilityStatus;
@override@JsonKey(name: 'availability_mode') final  String? availabilityMode;
@override final  String? timezone;
@override final  double? latitude;
@override final  double? longitude;
@override@JsonKey(name: 'location_description') final  String? locationDescription;
@override final  String? comments;
@override final  String? instructions;
@override@JsonKey(name: 'return_instructions') final  String? returnInstructions;
@override@JsonKey(name: 'min_loan_duration_in_minutes') final  int? minLoanDurationInMinutes;
@override@JsonKey(name: 'max_loan_duration_in_minutes') final  int? maxLoanDurationInMinutes;
@override final  LoanableImage? image;
 final  List<LoanableImage> _images;
@override@JsonKey() List<LoanableImage> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

 final  List<LoanableIncident> _activeIncidents;
@override@JsonKey(name: 'active_incidents') List<LoanableIncident> get activeIncidents {
  if (_activeIncidents is EqualUnmodifiableListView) return _activeIncidents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeIncidents);
}

 final  Map<String, dynamic>? _details;
@override Map<String, dynamic>? get details {
  final value = _details;
  if (value == null) return null;
  if (_details is EqualUnmodifiableMapView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<int>? _communityIds;
@override@JsonKey(name: 'community_ids') List<int>? get communityIds {
  final value = _communityIds;
  if (value == null) return null;
  if (_communityIds is EqualUnmodifiableListView) return _communityIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'community_name') final  String? communityName;
@override@JsonKey(name: 'community_id') final  int? communityId;
// Convenience / legacy compatibility fields
@override final  String? description;
@override final  String? address;
@override final  String? imageUrl;

/// Create a copy of Loanable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanableCopyWith<_Loanable> get copyWith => __$LoanableCopyWithImpl<_Loanable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoanableToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loanable&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.sharingMode, sharingMode) || other.sharingMode == sharingMode)&&(identical(other.availabilityStatus, availabilityStatus) || other.availabilityStatus == availabilityStatus)&&(identical(other.availabilityMode, availabilityMode) || other.availabilityMode == availabilityMode)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.locationDescription, locationDescription) || other.locationDescription == locationDescription)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.returnInstructions, returnInstructions) || other.returnInstructions == returnInstructions)&&(identical(other.minLoanDurationInMinutes, minLoanDurationInMinutes) || other.minLoanDurationInMinutes == minLoanDurationInMinutes)&&(identical(other.maxLoanDurationInMinutes, maxLoanDurationInMinutes) || other.maxLoanDurationInMinutes == maxLoanDurationInMinutes)&&(identical(other.image, image) || other.image == image)&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other._activeIncidents, _activeIncidents)&&const DeepCollectionEquality().equals(other._details, _details)&&const DeepCollectionEquality().equals(other._communityIds, _communityIds)&&(identical(other.communityName, communityName) || other.communityName == communityName)&&(identical(other.communityId, communityId) || other.communityId == communityId)&&(identical(other.description, description) || other.description == description)&&(identical(other.address, address) || other.address == address)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,type,sharingMode,availabilityStatus,availabilityMode,timezone,latitude,longitude,locationDescription,comments,instructions,returnInstructions,minLoanDurationInMinutes,maxLoanDurationInMinutes,image,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_activeIncidents),const DeepCollectionEquality().hash(_details),const DeepCollectionEquality().hash(_communityIds),communityName,communityId,description,address,imageUrl]);

@override
String toString() {
  return 'Loanable(id: $id, name: $name, type: $type, sharingMode: $sharingMode, availabilityStatus: $availabilityStatus, availabilityMode: $availabilityMode, timezone: $timezone, latitude: $latitude, longitude: $longitude, locationDescription: $locationDescription, comments: $comments, instructions: $instructions, returnInstructions: $returnInstructions, minLoanDurationInMinutes: $minLoanDurationInMinutes, maxLoanDurationInMinutes: $maxLoanDurationInMinutes, image: $image, images: $images, activeIncidents: $activeIncidents, details: $details, communityIds: $communityIds, communityName: $communityName, communityId: $communityId, description: $description, address: $address, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$LoanableCopyWith<$Res> implements $LoanableCopyWith<$Res> {
  factory _$LoanableCopyWith(_Loanable value, $Res Function(_Loanable) _then) = __$LoanableCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String type,@JsonKey(name: 'sharing_mode') String? sharingMode,@JsonKey(name: 'availability_status') String? availabilityStatus,@JsonKey(name: 'availability_mode') String? availabilityMode, String? timezone, double? latitude, double? longitude,@JsonKey(name: 'location_description') String? locationDescription, String? comments, String? instructions,@JsonKey(name: 'return_instructions') String? returnInstructions,@JsonKey(name: 'min_loan_duration_in_minutes') int? minLoanDurationInMinutes,@JsonKey(name: 'max_loan_duration_in_minutes') int? maxLoanDurationInMinutes, LoanableImage? image, List<LoanableImage> images,@JsonKey(name: 'active_incidents') List<LoanableIncident> activeIncidents, Map<String, dynamic>? details,@JsonKey(name: 'community_ids') List<int>? communityIds,@JsonKey(name: 'community_name') String? communityName,@JsonKey(name: 'community_id') int? communityId, String? description, String? address, String? imageUrl
});


@override $LoanableImageCopyWith<$Res>? get image;

}
/// @nodoc
class __$LoanableCopyWithImpl<$Res>
    implements _$LoanableCopyWith<$Res> {
  __$LoanableCopyWithImpl(this._self, this._then);

  final _Loanable _self;
  final $Res Function(_Loanable) _then;

/// Create a copy of Loanable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? sharingMode = freezed,Object? availabilityStatus = freezed,Object? availabilityMode = freezed,Object? timezone = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? locationDescription = freezed,Object? comments = freezed,Object? instructions = freezed,Object? returnInstructions = freezed,Object? minLoanDurationInMinutes = freezed,Object? maxLoanDurationInMinutes = freezed,Object? image = freezed,Object? images = null,Object? activeIncidents = null,Object? details = freezed,Object? communityIds = freezed,Object? communityName = freezed,Object? communityId = freezed,Object? description = freezed,Object? address = freezed,Object? imageUrl = freezed,}) {
  return _then(_Loanable(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,sharingMode: freezed == sharingMode ? _self.sharingMode : sharingMode // ignore: cast_nullable_to_non_nullable
as String?,availabilityStatus: freezed == availabilityStatus ? _self.availabilityStatus : availabilityStatus // ignore: cast_nullable_to_non_nullable
as String?,availabilityMode: freezed == availabilityMode ? _self.availabilityMode : availabilityMode // ignore: cast_nullable_to_non_nullable
as String?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,locationDescription: freezed == locationDescription ? _self.locationDescription : locationDescription // ignore: cast_nullable_to_non_nullable
as String?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,returnInstructions: freezed == returnInstructions ? _self.returnInstructions : returnInstructions // ignore: cast_nullable_to_non_nullable
as String?,minLoanDurationInMinutes: freezed == minLoanDurationInMinutes ? _self.minLoanDurationInMinutes : minLoanDurationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,maxLoanDurationInMinutes: freezed == maxLoanDurationInMinutes ? _self.maxLoanDurationInMinutes : maxLoanDurationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as LoanableImage?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<LoanableImage>,activeIncidents: null == activeIncidents ? _self._activeIncidents : activeIncidents // ignore: cast_nullable_to_non_nullable
as List<LoanableIncident>,details: freezed == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,communityIds: freezed == communityIds ? _self._communityIds : communityIds // ignore: cast_nullable_to_non_nullable
as List<int>?,communityName: freezed == communityName ? _self.communityName : communityName // ignore: cast_nullable_to_non_nullable
as String?,communityId: freezed == communityId ? _self.communityId : communityId // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Loanable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoanableImageCopyWith<$Res>? get image {
    if (_self.image == null) {
    return null;
  }

  return $LoanableImageCopyWith<$Res>(_self.image!, (value) {
    return _then(_self.copyWith(image: value));
  });
}
}

// dart format on

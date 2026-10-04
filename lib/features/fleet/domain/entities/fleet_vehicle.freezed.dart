// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fleet_vehicle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FleetVehicle {

 int get id; String get name; String get type;// 'bike', 'car', 'trailer', 'car_trailer'
@JsonKey(name: 'sharing_mode') String? get sharingMode;@JsonKey(name: 'availability_mode') String? get availabilityMode;@JsonKey(name: 'availability_status') String? get availabilityStatus;@JsonKey(name: 'location_description') String? get locationDescription;@JsonKey(name: 'published') bool get published;@JsonKey(name: 'is_suspended') bool get isSuspended;@JsonKey(name: 'suspended_at') DateTime? get suspendedAt;@JsonKey(name: 'suspension_reason') String? get suspensionReason;@JsonKey(name: 'active_loans_count') int get activeLoansCount;@JsonKey(name: 'confirmed_future_loans_count') int get confirmedFutureLoansCount;@JsonKey(name: 'pending_requests_count') int get pendingRequestsCount;@JsonKey(name: 'future_loans_count') int get futureLoansCount;@JsonKey(name: 'min_loan_duration_in_minutes') int? get minLoanDurationInMinutes;@JsonKey(name: 'max_loan_duration_in_minutes') int? get maxLoanDurationInMinutes;@JsonKey(name: 'timezone') String? get timezone;@JsonKey(name: 'user_role') String? get userRole;@JsonKey(name: 'updated_at') String? get updatedAt; String? get comments; String? get instructions;@JsonKey(name: 'return_instructions') String? get returnInstructions;@JsonKey(name: 'trusted_borrower_instructions') String? get trustedBorrowerInstructions; double? get latitude; double? get longitude; LoanableImage? get image; List<LoanableImage> get images; Map<String, dynamic>? get details; Map<String, dynamic>? get community;
/// Create a copy of FleetVehicle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FleetVehicleCopyWith<FleetVehicle> get copyWith => _$FleetVehicleCopyWithImpl<FleetVehicle>(this as FleetVehicle, _$identity);

  /// Serializes this FleetVehicle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FleetVehicle&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.sharingMode, sharingMode) || other.sharingMode == sharingMode)&&(identical(other.availabilityMode, availabilityMode) || other.availabilityMode == availabilityMode)&&(identical(other.availabilityStatus, availabilityStatus) || other.availabilityStatus == availabilityStatus)&&(identical(other.locationDescription, locationDescription) || other.locationDescription == locationDescription)&&(identical(other.published, published) || other.published == published)&&(identical(other.isSuspended, isSuspended) || other.isSuspended == isSuspended)&&(identical(other.suspendedAt, suspendedAt) || other.suspendedAt == suspendedAt)&&(identical(other.suspensionReason, suspensionReason) || other.suspensionReason == suspensionReason)&&(identical(other.activeLoansCount, activeLoansCount) || other.activeLoansCount == activeLoansCount)&&(identical(other.confirmedFutureLoansCount, confirmedFutureLoansCount) || other.confirmedFutureLoansCount == confirmedFutureLoansCount)&&(identical(other.pendingRequestsCount, pendingRequestsCount) || other.pendingRequestsCount == pendingRequestsCount)&&(identical(other.futureLoansCount, futureLoansCount) || other.futureLoansCount == futureLoansCount)&&(identical(other.minLoanDurationInMinutes, minLoanDurationInMinutes) || other.minLoanDurationInMinutes == minLoanDurationInMinutes)&&(identical(other.maxLoanDurationInMinutes, maxLoanDurationInMinutes) || other.maxLoanDurationInMinutes == maxLoanDurationInMinutes)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.returnInstructions, returnInstructions) || other.returnInstructions == returnInstructions)&&(identical(other.trustedBorrowerInstructions, trustedBorrowerInstructions) || other.trustedBorrowerInstructions == trustedBorrowerInstructions)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.image, image) || other.image == image)&&const DeepCollectionEquality().equals(other.images, images)&&const DeepCollectionEquality().equals(other.details, details)&&const DeepCollectionEquality().equals(other.community, community));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,type,sharingMode,availabilityMode,availabilityStatus,locationDescription,published,isSuspended,suspendedAt,suspensionReason,activeLoansCount,confirmedFutureLoansCount,pendingRequestsCount,futureLoansCount,minLoanDurationInMinutes,maxLoanDurationInMinutes,timezone,userRole,updatedAt,comments,instructions,returnInstructions,trustedBorrowerInstructions,latitude,longitude,image,const DeepCollectionEquality().hash(images),const DeepCollectionEquality().hash(details),const DeepCollectionEquality().hash(community)]);

@override
String toString() {
  return 'FleetVehicle(id: $id, name: $name, type: $type, sharingMode: $sharingMode, availabilityMode: $availabilityMode, availabilityStatus: $availabilityStatus, locationDescription: $locationDescription, published: $published, isSuspended: $isSuspended, suspendedAt: $suspendedAt, suspensionReason: $suspensionReason, activeLoansCount: $activeLoansCount, confirmedFutureLoansCount: $confirmedFutureLoansCount, pendingRequestsCount: $pendingRequestsCount, futureLoansCount: $futureLoansCount, minLoanDurationInMinutes: $minLoanDurationInMinutes, maxLoanDurationInMinutes: $maxLoanDurationInMinutes, timezone: $timezone, userRole: $userRole, updatedAt: $updatedAt, comments: $comments, instructions: $instructions, returnInstructions: $returnInstructions, trustedBorrowerInstructions: $trustedBorrowerInstructions, latitude: $latitude, longitude: $longitude, image: $image, images: $images, details: $details, community: $community)';
}


}

/// @nodoc
abstract mixin class $FleetVehicleCopyWith<$Res>  {
  factory $FleetVehicleCopyWith(FleetVehicle value, $Res Function(FleetVehicle) _then) = _$FleetVehicleCopyWithImpl;
@useResult
$Res call({
 int id, String name, String type,@JsonKey(name: 'sharing_mode') String? sharingMode,@JsonKey(name: 'availability_mode') String? availabilityMode,@JsonKey(name: 'availability_status') String? availabilityStatus,@JsonKey(name: 'location_description') String? locationDescription,@JsonKey(name: 'published') bool published,@JsonKey(name: 'is_suspended') bool isSuspended,@JsonKey(name: 'suspended_at') DateTime? suspendedAt,@JsonKey(name: 'suspension_reason') String? suspensionReason,@JsonKey(name: 'active_loans_count') int activeLoansCount,@JsonKey(name: 'confirmed_future_loans_count') int confirmedFutureLoansCount,@JsonKey(name: 'pending_requests_count') int pendingRequestsCount,@JsonKey(name: 'future_loans_count') int futureLoansCount,@JsonKey(name: 'min_loan_duration_in_minutes') int? minLoanDurationInMinutes,@JsonKey(name: 'max_loan_duration_in_minutes') int? maxLoanDurationInMinutes,@JsonKey(name: 'timezone') String? timezone,@JsonKey(name: 'user_role') String? userRole,@JsonKey(name: 'updated_at') String? updatedAt, String? comments, String? instructions,@JsonKey(name: 'return_instructions') String? returnInstructions,@JsonKey(name: 'trusted_borrower_instructions') String? trustedBorrowerInstructions, double? latitude, double? longitude, LoanableImage? image, List<LoanableImage> images, Map<String, dynamic>? details, Map<String, dynamic>? community
});


$LoanableImageCopyWith<$Res>? get image;

}
/// @nodoc
class _$FleetVehicleCopyWithImpl<$Res>
    implements $FleetVehicleCopyWith<$Res> {
  _$FleetVehicleCopyWithImpl(this._self, this._then);

  final FleetVehicle _self;
  final $Res Function(FleetVehicle) _then;

/// Create a copy of FleetVehicle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? sharingMode = freezed,Object? availabilityMode = freezed,Object? availabilityStatus = freezed,Object? locationDescription = freezed,Object? published = null,Object? isSuspended = null,Object? suspendedAt = freezed,Object? suspensionReason = freezed,Object? activeLoansCount = null,Object? confirmedFutureLoansCount = null,Object? pendingRequestsCount = null,Object? futureLoansCount = null,Object? minLoanDurationInMinutes = freezed,Object? maxLoanDurationInMinutes = freezed,Object? timezone = freezed,Object? userRole = freezed,Object? updatedAt = freezed,Object? comments = freezed,Object? instructions = freezed,Object? returnInstructions = freezed,Object? trustedBorrowerInstructions = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? image = freezed,Object? images = null,Object? details = freezed,Object? community = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,sharingMode: freezed == sharingMode ? _self.sharingMode : sharingMode // ignore: cast_nullable_to_non_nullable
as String?,availabilityMode: freezed == availabilityMode ? _self.availabilityMode : availabilityMode // ignore: cast_nullable_to_non_nullable
as String?,availabilityStatus: freezed == availabilityStatus ? _self.availabilityStatus : availabilityStatus // ignore: cast_nullable_to_non_nullable
as String?,locationDescription: freezed == locationDescription ? _self.locationDescription : locationDescription // ignore: cast_nullable_to_non_nullable
as String?,published: null == published ? _self.published : published // ignore: cast_nullable_to_non_nullable
as bool,isSuspended: null == isSuspended ? _self.isSuspended : isSuspended // ignore: cast_nullable_to_non_nullable
as bool,suspendedAt: freezed == suspendedAt ? _self.suspendedAt : suspendedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,suspensionReason: freezed == suspensionReason ? _self.suspensionReason : suspensionReason // ignore: cast_nullable_to_non_nullable
as String?,activeLoansCount: null == activeLoansCount ? _self.activeLoansCount : activeLoansCount // ignore: cast_nullable_to_non_nullable
as int,confirmedFutureLoansCount: null == confirmedFutureLoansCount ? _self.confirmedFutureLoansCount : confirmedFutureLoansCount // ignore: cast_nullable_to_non_nullable
as int,pendingRequestsCount: null == pendingRequestsCount ? _self.pendingRequestsCount : pendingRequestsCount // ignore: cast_nullable_to_non_nullable
as int,futureLoansCount: null == futureLoansCount ? _self.futureLoansCount : futureLoansCount // ignore: cast_nullable_to_non_nullable
as int,minLoanDurationInMinutes: freezed == minLoanDurationInMinutes ? _self.minLoanDurationInMinutes : minLoanDurationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,maxLoanDurationInMinutes: freezed == maxLoanDurationInMinutes ? _self.maxLoanDurationInMinutes : maxLoanDurationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,userRole: freezed == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,returnInstructions: freezed == returnInstructions ? _self.returnInstructions : returnInstructions // ignore: cast_nullable_to_non_nullable
as String?,trustedBorrowerInstructions: freezed == trustedBorrowerInstructions ? _self.trustedBorrowerInstructions : trustedBorrowerInstructions // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as LoanableImage?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<LoanableImage>,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,community: freezed == community ? _self.community : community // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}
/// Create a copy of FleetVehicle
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


/// Adds pattern-matching-related methods to [FleetVehicle].
extension FleetVehiclePatterns on FleetVehicle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FleetVehicle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FleetVehicle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FleetVehicle value)  $default,){
final _that = this;
switch (_that) {
case _FleetVehicle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FleetVehicle value)?  $default,){
final _that = this;
switch (_that) {
case _FleetVehicle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String type, @JsonKey(name: 'sharing_mode')  String? sharingMode, @JsonKey(name: 'availability_mode')  String? availabilityMode, @JsonKey(name: 'availability_status')  String? availabilityStatus, @JsonKey(name: 'location_description')  String? locationDescription, @JsonKey(name: 'published')  bool published, @JsonKey(name: 'is_suspended')  bool isSuspended, @JsonKey(name: 'suspended_at')  DateTime? suspendedAt, @JsonKey(name: 'suspension_reason')  String? suspensionReason, @JsonKey(name: 'active_loans_count')  int activeLoansCount, @JsonKey(name: 'confirmed_future_loans_count')  int confirmedFutureLoansCount, @JsonKey(name: 'pending_requests_count')  int pendingRequestsCount, @JsonKey(name: 'future_loans_count')  int futureLoansCount, @JsonKey(name: 'min_loan_duration_in_minutes')  int? minLoanDurationInMinutes, @JsonKey(name: 'max_loan_duration_in_minutes')  int? maxLoanDurationInMinutes, @JsonKey(name: 'timezone')  String? timezone, @JsonKey(name: 'user_role')  String? userRole, @JsonKey(name: 'updated_at')  String? updatedAt,  String? comments,  String? instructions, @JsonKey(name: 'return_instructions')  String? returnInstructions, @JsonKey(name: 'trusted_borrower_instructions')  String? trustedBorrowerInstructions,  double? latitude,  double? longitude,  LoanableImage? image,  List<LoanableImage> images,  Map<String, dynamic>? details,  Map<String, dynamic>? community)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FleetVehicle() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.sharingMode,_that.availabilityMode,_that.availabilityStatus,_that.locationDescription,_that.published,_that.isSuspended,_that.suspendedAt,_that.suspensionReason,_that.activeLoansCount,_that.confirmedFutureLoansCount,_that.pendingRequestsCount,_that.futureLoansCount,_that.minLoanDurationInMinutes,_that.maxLoanDurationInMinutes,_that.timezone,_that.userRole,_that.updatedAt,_that.comments,_that.instructions,_that.returnInstructions,_that.trustedBorrowerInstructions,_that.latitude,_that.longitude,_that.image,_that.images,_that.details,_that.community);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String type, @JsonKey(name: 'sharing_mode')  String? sharingMode, @JsonKey(name: 'availability_mode')  String? availabilityMode, @JsonKey(name: 'availability_status')  String? availabilityStatus, @JsonKey(name: 'location_description')  String? locationDescription, @JsonKey(name: 'published')  bool published, @JsonKey(name: 'is_suspended')  bool isSuspended, @JsonKey(name: 'suspended_at')  DateTime? suspendedAt, @JsonKey(name: 'suspension_reason')  String? suspensionReason, @JsonKey(name: 'active_loans_count')  int activeLoansCount, @JsonKey(name: 'confirmed_future_loans_count')  int confirmedFutureLoansCount, @JsonKey(name: 'pending_requests_count')  int pendingRequestsCount, @JsonKey(name: 'future_loans_count')  int futureLoansCount, @JsonKey(name: 'min_loan_duration_in_minutes')  int? minLoanDurationInMinutes, @JsonKey(name: 'max_loan_duration_in_minutes')  int? maxLoanDurationInMinutes, @JsonKey(name: 'timezone')  String? timezone, @JsonKey(name: 'user_role')  String? userRole, @JsonKey(name: 'updated_at')  String? updatedAt,  String? comments,  String? instructions, @JsonKey(name: 'return_instructions')  String? returnInstructions, @JsonKey(name: 'trusted_borrower_instructions')  String? trustedBorrowerInstructions,  double? latitude,  double? longitude,  LoanableImage? image,  List<LoanableImage> images,  Map<String, dynamic>? details,  Map<String, dynamic>? community)  $default,) {final _that = this;
switch (_that) {
case _FleetVehicle():
return $default(_that.id,_that.name,_that.type,_that.sharingMode,_that.availabilityMode,_that.availabilityStatus,_that.locationDescription,_that.published,_that.isSuspended,_that.suspendedAt,_that.suspensionReason,_that.activeLoansCount,_that.confirmedFutureLoansCount,_that.pendingRequestsCount,_that.futureLoansCount,_that.minLoanDurationInMinutes,_that.maxLoanDurationInMinutes,_that.timezone,_that.userRole,_that.updatedAt,_that.comments,_that.instructions,_that.returnInstructions,_that.trustedBorrowerInstructions,_that.latitude,_that.longitude,_that.image,_that.images,_that.details,_that.community);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String type, @JsonKey(name: 'sharing_mode')  String? sharingMode, @JsonKey(name: 'availability_mode')  String? availabilityMode, @JsonKey(name: 'availability_status')  String? availabilityStatus, @JsonKey(name: 'location_description')  String? locationDescription, @JsonKey(name: 'published')  bool published, @JsonKey(name: 'is_suspended')  bool isSuspended, @JsonKey(name: 'suspended_at')  DateTime? suspendedAt, @JsonKey(name: 'suspension_reason')  String? suspensionReason, @JsonKey(name: 'active_loans_count')  int activeLoansCount, @JsonKey(name: 'confirmed_future_loans_count')  int confirmedFutureLoansCount, @JsonKey(name: 'pending_requests_count')  int pendingRequestsCount, @JsonKey(name: 'future_loans_count')  int futureLoansCount, @JsonKey(name: 'min_loan_duration_in_minutes')  int? minLoanDurationInMinutes, @JsonKey(name: 'max_loan_duration_in_minutes')  int? maxLoanDurationInMinutes, @JsonKey(name: 'timezone')  String? timezone, @JsonKey(name: 'user_role')  String? userRole, @JsonKey(name: 'updated_at')  String? updatedAt,  String? comments,  String? instructions, @JsonKey(name: 'return_instructions')  String? returnInstructions, @JsonKey(name: 'trusted_borrower_instructions')  String? trustedBorrowerInstructions,  double? latitude,  double? longitude,  LoanableImage? image,  List<LoanableImage> images,  Map<String, dynamic>? details,  Map<String, dynamic>? community)?  $default,) {final _that = this;
switch (_that) {
case _FleetVehicle() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.sharingMode,_that.availabilityMode,_that.availabilityStatus,_that.locationDescription,_that.published,_that.isSuspended,_that.suspendedAt,_that.suspensionReason,_that.activeLoansCount,_that.confirmedFutureLoansCount,_that.pendingRequestsCount,_that.futureLoansCount,_that.minLoanDurationInMinutes,_that.maxLoanDurationInMinutes,_that.timezone,_that.userRole,_that.updatedAt,_that.comments,_that.instructions,_that.returnInstructions,_that.trustedBorrowerInstructions,_that.latitude,_that.longitude,_that.image,_that.images,_that.details,_that.community);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FleetVehicle extends FleetVehicle {
  const _FleetVehicle({required this.id, required this.name, required this.type, @JsonKey(name: 'sharing_mode') this.sharingMode, @JsonKey(name: 'availability_mode') this.availabilityMode, @JsonKey(name: 'availability_status') this.availabilityStatus, @JsonKey(name: 'location_description') this.locationDescription, @JsonKey(name: 'published') this.published = false, @JsonKey(name: 'is_suspended') this.isSuspended = false, @JsonKey(name: 'suspended_at') this.suspendedAt, @JsonKey(name: 'suspension_reason') this.suspensionReason, @JsonKey(name: 'active_loans_count') this.activeLoansCount = 0, @JsonKey(name: 'confirmed_future_loans_count') this.confirmedFutureLoansCount = 0, @JsonKey(name: 'pending_requests_count') this.pendingRequestsCount = 0, @JsonKey(name: 'future_loans_count') this.futureLoansCount = 0, @JsonKey(name: 'min_loan_duration_in_minutes') this.minLoanDurationInMinutes, @JsonKey(name: 'max_loan_duration_in_minutes') this.maxLoanDurationInMinutes, @JsonKey(name: 'timezone') this.timezone, @JsonKey(name: 'user_role') this.userRole, @JsonKey(name: 'updated_at') this.updatedAt, this.comments, this.instructions, @JsonKey(name: 'return_instructions') this.returnInstructions, @JsonKey(name: 'trusted_borrower_instructions') this.trustedBorrowerInstructions, this.latitude, this.longitude, this.image, final  List<LoanableImage> images = const [], final  Map<String, dynamic>? details, final  Map<String, dynamic>? community}): _images = images,_details = details,_community = community,super._();
  factory _FleetVehicle.fromJson(Map<String, dynamic> json) => _$FleetVehicleFromJson(json);

@override final  int id;
@override final  String name;
@override final  String type;
// 'bike', 'car', 'trailer', 'car_trailer'
@override@JsonKey(name: 'sharing_mode') final  String? sharingMode;
@override@JsonKey(name: 'availability_mode') final  String? availabilityMode;
@override@JsonKey(name: 'availability_status') final  String? availabilityStatus;
@override@JsonKey(name: 'location_description') final  String? locationDescription;
@override@JsonKey(name: 'published') final  bool published;
@override@JsonKey(name: 'is_suspended') final  bool isSuspended;
@override@JsonKey(name: 'suspended_at') final  DateTime? suspendedAt;
@override@JsonKey(name: 'suspension_reason') final  String? suspensionReason;
@override@JsonKey(name: 'active_loans_count') final  int activeLoansCount;
@override@JsonKey(name: 'confirmed_future_loans_count') final  int confirmedFutureLoansCount;
@override@JsonKey(name: 'pending_requests_count') final  int pendingRequestsCount;
@override@JsonKey(name: 'future_loans_count') final  int futureLoansCount;
@override@JsonKey(name: 'min_loan_duration_in_minutes') final  int? minLoanDurationInMinutes;
@override@JsonKey(name: 'max_loan_duration_in_minutes') final  int? maxLoanDurationInMinutes;
@override@JsonKey(name: 'timezone') final  String? timezone;
@override@JsonKey(name: 'user_role') final  String? userRole;
@override@JsonKey(name: 'updated_at') final  String? updatedAt;
@override final  String? comments;
@override final  String? instructions;
@override@JsonKey(name: 'return_instructions') final  String? returnInstructions;
@override@JsonKey(name: 'trusted_borrower_instructions') final  String? trustedBorrowerInstructions;
@override final  double? latitude;
@override final  double? longitude;
@override final  LoanableImage? image;
 final  List<LoanableImage> _images;
@override@JsonKey() List<LoanableImage> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

 final  Map<String, dynamic>? _details;
@override Map<String, dynamic>? get details {
  final value = _details;
  if (value == null) return null;
  if (_details is EqualUnmodifiableMapView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _community;
@override Map<String, dynamic>? get community {
  final value = _community;
  if (value == null) return null;
  if (_community is EqualUnmodifiableMapView) return _community;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of FleetVehicle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FleetVehicleCopyWith<_FleetVehicle> get copyWith => __$FleetVehicleCopyWithImpl<_FleetVehicle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FleetVehicleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FleetVehicle&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.sharingMode, sharingMode) || other.sharingMode == sharingMode)&&(identical(other.availabilityMode, availabilityMode) || other.availabilityMode == availabilityMode)&&(identical(other.availabilityStatus, availabilityStatus) || other.availabilityStatus == availabilityStatus)&&(identical(other.locationDescription, locationDescription) || other.locationDescription == locationDescription)&&(identical(other.published, published) || other.published == published)&&(identical(other.isSuspended, isSuspended) || other.isSuspended == isSuspended)&&(identical(other.suspendedAt, suspendedAt) || other.suspendedAt == suspendedAt)&&(identical(other.suspensionReason, suspensionReason) || other.suspensionReason == suspensionReason)&&(identical(other.activeLoansCount, activeLoansCount) || other.activeLoansCount == activeLoansCount)&&(identical(other.confirmedFutureLoansCount, confirmedFutureLoansCount) || other.confirmedFutureLoansCount == confirmedFutureLoansCount)&&(identical(other.pendingRequestsCount, pendingRequestsCount) || other.pendingRequestsCount == pendingRequestsCount)&&(identical(other.futureLoansCount, futureLoansCount) || other.futureLoansCount == futureLoansCount)&&(identical(other.minLoanDurationInMinutes, minLoanDurationInMinutes) || other.minLoanDurationInMinutes == minLoanDurationInMinutes)&&(identical(other.maxLoanDurationInMinutes, maxLoanDurationInMinutes) || other.maxLoanDurationInMinutes == maxLoanDurationInMinutes)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.comments, comments) || other.comments == comments)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.returnInstructions, returnInstructions) || other.returnInstructions == returnInstructions)&&(identical(other.trustedBorrowerInstructions, trustedBorrowerInstructions) || other.trustedBorrowerInstructions == trustedBorrowerInstructions)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.image, image) || other.image == image)&&const DeepCollectionEquality().equals(other._images, _images)&&const DeepCollectionEquality().equals(other._details, _details)&&const DeepCollectionEquality().equals(other._community, _community));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,type,sharingMode,availabilityMode,availabilityStatus,locationDescription,published,isSuspended,suspendedAt,suspensionReason,activeLoansCount,confirmedFutureLoansCount,pendingRequestsCount,futureLoansCount,minLoanDurationInMinutes,maxLoanDurationInMinutes,timezone,userRole,updatedAt,comments,instructions,returnInstructions,trustedBorrowerInstructions,latitude,longitude,image,const DeepCollectionEquality().hash(_images),const DeepCollectionEquality().hash(_details),const DeepCollectionEquality().hash(_community)]);

@override
String toString() {
  return 'FleetVehicle(id: $id, name: $name, type: $type, sharingMode: $sharingMode, availabilityMode: $availabilityMode, availabilityStatus: $availabilityStatus, locationDescription: $locationDescription, published: $published, isSuspended: $isSuspended, suspendedAt: $suspendedAt, suspensionReason: $suspensionReason, activeLoansCount: $activeLoansCount, confirmedFutureLoansCount: $confirmedFutureLoansCount, pendingRequestsCount: $pendingRequestsCount, futureLoansCount: $futureLoansCount, minLoanDurationInMinutes: $minLoanDurationInMinutes, maxLoanDurationInMinutes: $maxLoanDurationInMinutes, timezone: $timezone, userRole: $userRole, updatedAt: $updatedAt, comments: $comments, instructions: $instructions, returnInstructions: $returnInstructions, trustedBorrowerInstructions: $trustedBorrowerInstructions, latitude: $latitude, longitude: $longitude, image: $image, images: $images, details: $details, community: $community)';
}


}

/// @nodoc
abstract mixin class _$FleetVehicleCopyWith<$Res> implements $FleetVehicleCopyWith<$Res> {
  factory _$FleetVehicleCopyWith(_FleetVehicle value, $Res Function(_FleetVehicle) _then) = __$FleetVehicleCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String type,@JsonKey(name: 'sharing_mode') String? sharingMode,@JsonKey(name: 'availability_mode') String? availabilityMode,@JsonKey(name: 'availability_status') String? availabilityStatus,@JsonKey(name: 'location_description') String? locationDescription,@JsonKey(name: 'published') bool published,@JsonKey(name: 'is_suspended') bool isSuspended,@JsonKey(name: 'suspended_at') DateTime? suspendedAt,@JsonKey(name: 'suspension_reason') String? suspensionReason,@JsonKey(name: 'active_loans_count') int activeLoansCount,@JsonKey(name: 'confirmed_future_loans_count') int confirmedFutureLoansCount,@JsonKey(name: 'pending_requests_count') int pendingRequestsCount,@JsonKey(name: 'future_loans_count') int futureLoansCount,@JsonKey(name: 'min_loan_duration_in_minutes') int? minLoanDurationInMinutes,@JsonKey(name: 'max_loan_duration_in_minutes') int? maxLoanDurationInMinutes,@JsonKey(name: 'timezone') String? timezone,@JsonKey(name: 'user_role') String? userRole,@JsonKey(name: 'updated_at') String? updatedAt, String? comments, String? instructions,@JsonKey(name: 'return_instructions') String? returnInstructions,@JsonKey(name: 'trusted_borrower_instructions') String? trustedBorrowerInstructions, double? latitude, double? longitude, LoanableImage? image, List<LoanableImage> images, Map<String, dynamic>? details, Map<String, dynamic>? community
});


@override $LoanableImageCopyWith<$Res>? get image;

}
/// @nodoc
class __$FleetVehicleCopyWithImpl<$Res>
    implements _$FleetVehicleCopyWith<$Res> {
  __$FleetVehicleCopyWithImpl(this._self, this._then);

  final _FleetVehicle _self;
  final $Res Function(_FleetVehicle) _then;

/// Create a copy of FleetVehicle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? sharingMode = freezed,Object? availabilityMode = freezed,Object? availabilityStatus = freezed,Object? locationDescription = freezed,Object? published = null,Object? isSuspended = null,Object? suspendedAt = freezed,Object? suspensionReason = freezed,Object? activeLoansCount = null,Object? confirmedFutureLoansCount = null,Object? pendingRequestsCount = null,Object? futureLoansCount = null,Object? minLoanDurationInMinutes = freezed,Object? maxLoanDurationInMinutes = freezed,Object? timezone = freezed,Object? userRole = freezed,Object? updatedAt = freezed,Object? comments = freezed,Object? instructions = freezed,Object? returnInstructions = freezed,Object? trustedBorrowerInstructions = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? image = freezed,Object? images = null,Object? details = freezed,Object? community = freezed,}) {
  return _then(_FleetVehicle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,sharingMode: freezed == sharingMode ? _self.sharingMode : sharingMode // ignore: cast_nullable_to_non_nullable
as String?,availabilityMode: freezed == availabilityMode ? _self.availabilityMode : availabilityMode // ignore: cast_nullable_to_non_nullable
as String?,availabilityStatus: freezed == availabilityStatus ? _self.availabilityStatus : availabilityStatus // ignore: cast_nullable_to_non_nullable
as String?,locationDescription: freezed == locationDescription ? _self.locationDescription : locationDescription // ignore: cast_nullable_to_non_nullable
as String?,published: null == published ? _self.published : published // ignore: cast_nullable_to_non_nullable
as bool,isSuspended: null == isSuspended ? _self.isSuspended : isSuspended // ignore: cast_nullable_to_non_nullable
as bool,suspendedAt: freezed == suspendedAt ? _self.suspendedAt : suspendedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,suspensionReason: freezed == suspensionReason ? _self.suspensionReason : suspensionReason // ignore: cast_nullable_to_non_nullable
as String?,activeLoansCount: null == activeLoansCount ? _self.activeLoansCount : activeLoansCount // ignore: cast_nullable_to_non_nullable
as int,confirmedFutureLoansCount: null == confirmedFutureLoansCount ? _self.confirmedFutureLoansCount : confirmedFutureLoansCount // ignore: cast_nullable_to_non_nullable
as int,pendingRequestsCount: null == pendingRequestsCount ? _self.pendingRequestsCount : pendingRequestsCount // ignore: cast_nullable_to_non_nullable
as int,futureLoansCount: null == futureLoansCount ? _self.futureLoansCount : futureLoansCount // ignore: cast_nullable_to_non_nullable
as int,minLoanDurationInMinutes: freezed == minLoanDurationInMinutes ? _self.minLoanDurationInMinutes : minLoanDurationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,maxLoanDurationInMinutes: freezed == maxLoanDurationInMinutes ? _self.maxLoanDurationInMinutes : maxLoanDurationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,userRole: freezed == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String?,comments: freezed == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as String?,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,returnInstructions: freezed == returnInstructions ? _self.returnInstructions : returnInstructions // ignore: cast_nullable_to_non_nullable
as String?,trustedBorrowerInstructions: freezed == trustedBorrowerInstructions ? _self.trustedBorrowerInstructions : trustedBorrowerInstructions // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as LoanableImage?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<LoanableImage>,details: freezed == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,community: freezed == community ? _self._community : community // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

/// Create a copy of FleetVehicle
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

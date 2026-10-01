// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loanable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Loanable _$LoanableFromJson(Map<String, dynamic> json) => _Loanable(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  type: json['type'] as String,
  sharingMode: json['sharing_mode'] as String?,
  availabilityStatus: json['availability_status'] as String?,
  availabilityMode: json['availability_mode'] as String?,
  timezone: json['timezone'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  locationDescription: json['location_description'] as String?,
  comments: json['comments'] as String?,
  instructions: json['instructions'] as String?,
  returnInstructions: json['return_instructions'] as String?,
  minLoanDurationInMinutes: (json['min_loan_duration_in_minutes'] as num?)
      ?.toInt(),
  maxLoanDurationInMinutes: (json['max_loan_duration_in_minutes'] as num?)
      ?.toInt(),
  image: json['image'] == null
      ? null
      : LoanableImage.fromJson(json['image'] as Map<String, dynamic>),
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => LoanableImage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  activeIncidents:
      (json['active_incidents'] as List<dynamic>?)
          ?.map((e) => LoanableIncident.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  details: json['details'] as Map<String, dynamic>?,
  communityIds: (json['community_ids'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  communityName: json['community_name'] as String?,
  communityId: (json['community_id'] as num?)?.toInt(),
  mergedUserRoles: (json['merged_user_roles'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  description: json['description'] as String?,
  address: json['address'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$LoanableToJson(_Loanable instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'sharing_mode': instance.sharingMode,
  'availability_status': instance.availabilityStatus,
  'availability_mode': instance.availabilityMode,
  'timezone': instance.timezone,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'location_description': instance.locationDescription,
  'comments': instance.comments,
  'instructions': instance.instructions,
  'return_instructions': instance.returnInstructions,
  'min_loan_duration_in_minutes': instance.minLoanDurationInMinutes,
  'max_loan_duration_in_minutes': instance.maxLoanDurationInMinutes,
  'image': instance.image,
  'images': instance.images,
  'active_incidents': instance.activeIncidents,
  'details': instance.details,
  'community_ids': instance.communityIds,
  'community_name': instance.communityName,
  'community_id': instance.communityId,
  'merged_user_roles': instance.mergedUserRoles,
  'description': instance.description,
  'address': instance.address,
  'imageUrl': instance.imageUrl,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fleet_vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FleetVehicle _$FleetVehicleFromJson(
  Map<String, dynamic> json,
) => _FleetVehicle(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  type: json['type'] as String,
  sharingMode: json['sharing_mode'] as String?,
  availabilityMode: json['availability_mode'] as String?,
  availabilityStatus: json['availability_status'] as String?,
  locationDescription: json['location_description'] as String?,
  published: json['published'] as bool? ?? false,
  isSuspended: json['is_suspended'] as bool? ?? false,
  suspendedAt: json['suspended_at'] == null
      ? null
      : DateTime.parse(json['suspended_at'] as String),
  suspensionReason: json['suspension_reason'] as String?,
  activeLoansCount: (json['active_loans_count'] as num?)?.toInt() ?? 0,
  confirmedFutureLoansCount:
      (json['confirmed_future_loans_count'] as num?)?.toInt() ?? 0,
  pendingRequestsCount: (json['pending_requests_count'] as num?)?.toInt() ?? 0,
  futureLoansCount: (json['future_loans_count'] as num?)?.toInt() ?? 0,
  minLoanDurationInMinutes: (json['min_loan_duration_in_minutes'] as num?)
      ?.toInt(),
  maxLoanDurationInMinutes: (json['max_loan_duration_in_minutes'] as num?)
      ?.toInt(),
  timezone: json['timezone'] as String?,
  userRole: json['user_role'] as String?,
  updatedAt: json['updated_at'] as String?,
  comments: json['comments'] as String?,
  instructions: json['instructions'] as String?,
  returnInstructions: json['return_instructions'] as String?,
  trustedBorrowerInstructions: json['trusted_borrower_instructions'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  image: json['image'] == null
      ? null
      : LoanableImage.fromJson(json['image'] as Map<String, dynamic>),
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => LoanableImage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  details: json['details'] as Map<String, dynamic>?,
  community: json['community'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$FleetVehicleToJson(_FleetVehicle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'sharing_mode': instance.sharingMode,
      'availability_mode': instance.availabilityMode,
      'availability_status': instance.availabilityStatus,
      'location_description': instance.locationDescription,
      'published': instance.published,
      'is_suspended': instance.isSuspended,
      'suspended_at': instance.suspendedAt?.toIso8601String(),
      'suspension_reason': instance.suspensionReason,
      'active_loans_count': instance.activeLoansCount,
      'confirmed_future_loans_count': instance.confirmedFutureLoansCount,
      'pending_requests_count': instance.pendingRequestsCount,
      'future_loans_count': instance.futureLoansCount,
      'min_loan_duration_in_minutes': instance.minLoanDurationInMinutes,
      'max_loan_duration_in_minutes': instance.maxLoanDurationInMinutes,
      'timezone': instance.timezone,
      'user_role': instance.userRole,
      'updated_at': instance.updatedAt,
      'comments': instance.comments,
      'instructions': instance.instructions,
      'return_instructions': instance.returnInstructions,
      'trusted_borrower_instructions': instance.trustedBorrowerInstructions,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'image': instance.image,
      'images': instance.images,
      'details': instance.details,
      'community': instance.community,
    };

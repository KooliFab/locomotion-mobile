// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrower.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Borrower _$BorrowerFromJson(Map<String, dynamic> json) => _Borrower(
  userId: (json['user_id'] as num).toInt(),
  approved: json['approved'] as bool? ?? false,
  suspended: json['suspended'] as bool? ?? false,
  validated: json['validated'] as bool? ?? false,
  submittedAt: json['submitted_at'] == null
      ? null
      : DateTime.parse(json['submitted_at'] as String),
  approvedAt: json['approved_at'] == null
      ? null
      : DateTime.parse(json['approved_at'] as String),
  suspendedAt: json['suspended_at'] == null
      ? null
      : DateTime.parse(json['suspended_at'] as String),
  driversLicenseNumber: json['drivers_license_number'] as String?,
  hasNotBeenSuedLastTenYears: json['has_not_been_sued_last_ten_years'] as bool?,
  gaa:
      (json['gaa'] as List<dynamic>?)
          ?.map((e) => UploadedFileRef.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  saaq:
      (json['saaq'] as List<dynamic>?)
          ?.map((e) => UploadedFileRef.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$BorrowerToJson(_Borrower instance) => <String, dynamic>{
  'user_id': instance.userId,
  'approved': instance.approved,
  'suspended': instance.suspended,
  'validated': instance.validated,
  'submitted_at': instance.submittedAt?.toIso8601String(),
  'approved_at': instance.approvedAt?.toIso8601String(),
  'suspended_at': instance.suspendedAt?.toIso8601String(),
  'drivers_license_number': instance.driversLicenseNumber,
  'has_not_been_sued_last_ten_years': instance.hasNotBeenSuedLastTenYears,
  'gaa': instance.gaa,
  'saaq': instance.saaq,
};

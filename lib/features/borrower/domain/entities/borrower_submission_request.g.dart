// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrower_submission_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FileIdRef _$FileIdRefFromJson(Map<String, dynamic> json) =>
    _FileIdRef(id: (json['id'] as num).toInt());

Map<String, dynamic> _$FileIdRefToJson(_FileIdRef instance) =>
    <String, dynamic>{'id': instance.id};

_BorrowerSubmissionRequest _$BorrowerSubmissionRequestFromJson(
  Map<String, dynamic> json,
) => _BorrowerSubmissionRequest(
  userId: (json['user_id'] as num).toInt(),
  driversLicenseNumber: json['drivers_license_number'] as String,
  hasNotBeenSuedLastTenYears: json['has_not_been_sued_last_ten_years'] as bool,
  gaa: (json['gaa'] as List<dynamic>)
      .map((e) => FileIdRef.fromJson(e as Map<String, dynamic>))
      .toList(),
  saaq: (json['saaq'] as List<dynamic>)
      .map((e) => FileIdRef.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BorrowerSubmissionRequestToJson(
  _BorrowerSubmissionRequest instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'drivers_license_number': instance.driversLicenseNumber,
  'has_not_been_sued_last_ten_years': instance.hasNotBeenSuedLastTenYears,
  'gaa': instance.gaa.map((e) => e.toJson()).toList(),
  'saaq': instance.saaq.map((e) => e.toJson()).toList(),
};

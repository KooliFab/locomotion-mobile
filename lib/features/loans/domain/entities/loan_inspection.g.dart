// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_inspection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoanInspection _$LoanInspectionFromJson(Map<String, dynamic> json) =>
    _LoanInspection(
      loanId: (json['loan_id'] as num).toInt(),
      inspectionType: json['inspection_type'] as String,
      odometerKm: (json['odometer_km'] as num?)?.toInt(),
      fuelBatteryLevelPercent: (json['fuel_battery_level_percent'] as num?)
          ?.toInt(),
      cleanlinessRating: (json['cleanliness_rating'] as num?)?.toInt(),
      checklist: json['checklist'] as Map<String, dynamic>? ?? const {},
      photos:
          (json['photos'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      existingDamagesNotes: json['existing_damages_notes'] as String?,
      sealedHash: json['sealed_hash'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      loanStatus: json['loan_status'] as String?,
    );

Map<String, dynamic> _$LoanInspectionToJson(_LoanInspection instance) =>
    <String, dynamic>{
      'loan_id': instance.loanId,
      'inspection_type': instance.inspectionType,
      'odometer_km': instance.odometerKm,
      'fuel_battery_level_percent': instance.fuelBatteryLevelPercent,
      'cleanliness_rating': instance.cleanlinessRating,
      'checklist': instance.checklist,
      'photos': instance.photos,
      'existing_damages_notes': instance.existingDamagesNotes,
      'sealed_hash': instance.sealedHash,
      'created_at': instance.createdAt?.toIso8601String(),
      'loan_status': instance.loanStatus,
    };

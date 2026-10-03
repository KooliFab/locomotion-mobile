// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'departure_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DraftPhotoEntry _$DraftPhotoEntryFromJson(Map<String, dynamic> json) =>
    _DraftPhotoEntry(
      field: json['field'] as String,
      localPath: json['localPath'] as String?,
      status:
          $enumDecodeNullable(_$DraftPhotoStatusEnumMap, json['status']) ??
          DraftPhotoStatus.notTaken,
      imageId: (json['imageId'] as num?)?.toInt(),
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$DraftPhotoEntryToJson(_DraftPhotoEntry instance) =>
    <String, dynamic>{
      'field': instance.field,
      'localPath': instance.localPath,
      'status': _$DraftPhotoStatusEnumMap[instance.status]!,
      'imageId': instance.imageId,
      'errorMessage': instance.errorMessage,
    };

const _$DraftPhotoStatusEnumMap = {
  DraftPhotoStatus.notTaken: 'notTaken',
  DraftPhotoStatus.uploading: 'uploading',
  DraftPhotoStatus.uploaded: 'uploaded',
  DraftPhotoStatus.error: 'error',
};

_DepartureDraft _$DepartureDraftFromJson(Map<String, dynamic> json) =>
    _DepartureDraft(
      userId: (json['userId'] as num).toInt(),
      loanId: (json['loanId'] as num).toInt(),
      odometerKm: (json['odometerKm'] as num?)?.toInt(),
      fuelBatteryLevelPercent:
          (json['fuelBatteryLevelPercent'] as num?)?.toInt() ?? 80,
      cleanlinessRating: (json['cleanlinessRating'] as num?)?.toInt() ?? 4,
      checklist:
          (json['checklist'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      existingDamagesNotes: json['existingDamagesNotes'] as String?,
      photos:
          (json['photos'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              DraftPhotoEntry.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          const {},
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$DepartureDraftToJson(_DepartureDraft instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'loanId': instance.loanId,
      'odometerKm': instance.odometerKm,
      'fuelBatteryLevelPercent': instance.fuelBatteryLevelPercent,
      'cleanlinessRating': instance.cleanlinessRating,
      'checklist': instance.checklist,
      'existingDamagesNotes': instance.existingDamagesNotes,
      'photos': instance.photos,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

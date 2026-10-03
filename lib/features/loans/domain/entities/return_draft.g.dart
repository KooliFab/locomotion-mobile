// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'return_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReturnDraft _$ReturnDraftFromJson(Map<String, dynamic> json) => _ReturnDraft(
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
  newDamagesDeclared: json['newDamagesDeclared'] as bool? ?? false,
  comments: json['comments'] as String?,
  signaturePhoto: json['signaturePhoto'] == null
      ? null
      : DraftPhotoEntry.fromJson(
          json['signaturePhoto'] as Map<String, dynamic>,
        ),
  signerFullName: json['signerFullName'] as String?,
  photos:
      (json['photos'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, DraftPhotoEntry.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ReturnDraftToJson(_ReturnDraft instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'loanId': instance.loanId,
      'odometerKm': instance.odometerKm,
      'fuelBatteryLevelPercent': instance.fuelBatteryLevelPercent,
      'cleanlinessRating': instance.cleanlinessRating,
      'checklist': instance.checklist,
      'newDamagesDeclared': instance.newDamagesDeclared,
      'comments': instance.comments,
      'signaturePhoto': instance.signaturePhoto,
      'signerFullName': instance.signerFullName,
      'photos': instance.photos,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

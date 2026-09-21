// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Community _$CommunityFromJson(Map<String, dynamic> json) => _Community(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  city: json['city'] as String?,
  membersCount: (json['membersCount'] as num?)?.toInt(),
  loanablesCount: (json['loanablesCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$CommunityToJson(_Community instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'city': instance.city,
      'membersCount': instance.membersCount,
      'loanablesCount': instance.loanablesCount,
    };

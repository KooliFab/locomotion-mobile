// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushToken _$PushTokenFromJson(Map<String, dynamic> json) => _PushToken(
  id: (json['id'] as num?)?.toInt(),
  token: json['token'] as String,
  platform: json['platform'] as String,
  installationId: json['installation_id'] as String,
  appVersion: json['app_version'] as String?,
  lastActiveAt: json['last_active_at'] == null
      ? null
      : DateTime.parse(json['last_active_at'] as String),
);

Map<String, dynamic> _$PushTokenToJson(_PushToken instance) =>
    <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'platform': instance.platform,
      'installation_id': instance.installationId,
      'app_version': instance.appVersion,
      'last_active_at': instance.lastActiveAt?.toIso8601String(),
    };

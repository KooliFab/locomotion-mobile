// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loanable.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Loanable _$LoanableFromJson(Map<String, dynamic> json) => _Loanable(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  type: json['type'] as String,
  description: json['description'] as String?,
  address: json['address'] as String?,
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  imageUrl: json['imageUrl'] as String?,
  isAvailable: json['isAvailable'] as bool? ?? true,
  communityName: json['communityName'] as String?,
  communityId: (json['communityId'] as num?)?.toInt(),
);

Map<String, dynamic> _$LoanableToJson(_Loanable instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'description': instance.description,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'imageUrl': instance.imageUrl,
  'isAvailable': instance.isAvailable,
  'communityName': instance.communityName,
  'communityId': instance.communityId,
};

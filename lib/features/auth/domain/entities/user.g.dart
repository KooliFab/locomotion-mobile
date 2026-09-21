// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  phone: json['phone'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  isEmailVerified: json['isEmailVerified'] as bool? ?? false,
  isBorrowerApproved: json['isBorrowerApproved'] as bool? ?? false,
  currentCommunityId: (json['currentCommunityId'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'phone': instance.phone,
  'avatarUrl': instance.avatarUrl,
  'isEmailVerified': instance.isEmailVerified,
  'isBorrowerApproved': instance.isBorrowerApproved,
  'currentCommunityId': instance.currentCommunityId,
};

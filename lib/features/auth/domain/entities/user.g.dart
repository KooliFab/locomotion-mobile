// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  firstName: json['name'] as String?,
  lastName: json['last_name'] as String?,
  phone: json['phone'] as String?,
  emailVerifiedAt: json['email_verified_at'] == null
      ? null
      : DateTime.parse(json['email_verified_at'] as String),
  currentCommunityId: (json['currentCommunityId'] as num?)?.toInt(),
  borrower: json['borrower'] == null
      ? null
      : Borrower.fromJson(json['borrower'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.firstName,
  'last_name': instance.lastName,
  'phone': instance.phone,
  'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
  'currentCommunityId': instance.currentCommunityId,
  'borrower': instance.borrower,
};

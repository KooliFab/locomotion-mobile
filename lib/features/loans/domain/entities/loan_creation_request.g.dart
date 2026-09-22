// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_creation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoanCreationRequest _$LoanCreationRequestFromJson(Map<String, dynamic> json) =>
    _LoanCreationRequest(
      loanableId: (json['loanable_id'] as num).toInt(),
      borrowerUserId: (json['borrower_user_id'] as num).toInt(),
      departureAt: json['departure_at'] as String,
      durationInMinutes: (json['duration_in_minutes'] as num).toInt(),
      estimatedDistance: (json['estimated_distance'] as num).toInt(),
      alternativeTo: json['alternative_to'] as String,
      alternativeToOther: json['alternative_to_other'] as String?,
      messageForOwner: json['message_for_owner'] as String?,
      communityId: (json['community_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoanCreationRequestToJson(
  _LoanCreationRequest instance,
) => <String, dynamic>{
  'loanable_id': instance.loanableId,
  'borrower_user_id': instance.borrowerUserId,
  'departure_at': instance.departureAt,
  'duration_in_minutes': instance.durationInMinutes,
  'estimated_distance': instance.estimatedDistance,
  'alternative_to': instance.alternativeTo,
  'alternative_to_other': instance.alternativeToOther,
  'message_for_owner': instance.messageForOwner,
  'community_id': instance.communityId,
};

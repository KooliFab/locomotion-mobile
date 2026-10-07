// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Loan _$LoanFromJson(Map<String, dynamic> json) => _Loan(
  id: (json['id'] as num).toInt(),
  departureAt: DateTime.parse(json['departure_at'] as String),
  durationInMinutes: (json['duration_in_minutes'] as num).toInt(),
  status: json['status'] as String,
  loanableId: (json['loanable_id'] as num?)?.toInt(),
  loanableName: json['loanable_name'] as String?,
  loanable: const LoanableConverter().fromJson(
    json['loanable'] as Map<String, dynamic>?,
  ),
  communityId: (json['community_id'] as num?)?.toInt(),
  communityName: json['community_name'] as String?,
  borrowerUserId: (json['borrower_user_id'] as num?)?.toInt(),
  borrowerUserName: json['borrower_user_name'] as String?,
  borrowerUserEmail: json['borrower_user_email'] as String?,
  borrowerUserPhone: json['borrower_user_phone'] as String?,
  acceptedAt: json['accepted_at'] == null
      ? null
      : DateTime.parse(json['accepted_at'] as String),
  prepaidAt: json['prepaid_at'] == null
      ? null
      : DateTime.parse(json['prepaid_at'] as String),
  canceledAt: json['canceled_at'] == null
      ? null
      : DateTime.parse(json['canceled_at'] as String),
  actualReturnAt: json['actual_return_at'] == null
      ? null
      : DateTime.parse(json['actual_return_at'] as String),
  borrowerValidatedAt: json['borrower_validated_at'] == null
      ? null
      : DateTime.parse(json['borrower_validated_at'] as String),
  ownerValidatedAt: json['owner_validated_at'] == null
      ? null
      : DateTime.parse(json['owner_validated_at'] as String),
  needsValidation: json['needs_validation'] as bool? ?? false,
  isFree: json['is_free'] as bool? ?? false,
  borrowerTotal: (json['borrower_total'] as num?)?.toDouble(),
  ownerTotal: (json['owner_total'] as num?)?.toDouble(),
  ownerActionRequired: json['owner_action_required'] as bool? ?? false,
  borrowerActionRequired: json['borrower_action_required'] as bool? ?? false,
  isSelfService: json['is_self_service'] as bool? ?? false,
  estimatedDistance: (json['estimated_distance'] as num?)?.toInt(),
  actualDistance: (json['actual_distance'] as num?)?.toInt(),
  mileageStart: (json['mileage_start'] as num?)?.toInt(),
  mileageEnd: (json['mileage_end'] as num?)?.toInt(),
  requiresMileage: json['requires_mileage'] as bool?,
  requiresDetailedMileage: json['requires_detailed_mileage'] as bool?,
  alternativeTo: json['alternative_to'] as String?,
  alternativeToOther: json['alternative_to_other'] as String?,
  comment: json['comment'] as String?,
  comments:
      (json['comments'] as List<dynamic>?)
          ?.map((e) => LoanComment.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  extensionDurationInMinutes: (json['extension_duration_in_minutes'] as num?)
      ?.toInt(),
  platformTip: (json['platform_tip'] as num?)?.toDouble(),
  desiredContribution: (json['desired_contribution'] as num?)?.toDouble(),
  borrowerMayContribute: json['borrower_may_contribute'] as bool? ?? false,
  borrowerMustPayCompensation:
      json['borrower_must_pay_compensation'] as bool? ?? false,
  borrowerMustPayInsurance:
      json['borrower_must_pay_insurance'] as bool? ?? false,
  applicableAmountTypes:
      json['applicable_amount_types'] as Map<String, dynamic>?,
  canAddExpenses: json['can_add_expenses'] as bool? ?? false,
  expensesAmount: (json['expenses_amount'] as num?)?.toDouble(),
  mileageStartImage: json['mileage_start_image'] as Map<String, dynamic>?,
  mileageEndImage: json['mileage_end_image'] as Map<String, dynamic>?,
  expenseImage: json['expense_image'] as Map<String, dynamic>?,
  borrowerInvoiceJson: json['borrower_invoice'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$LoanToJson(_Loan instance) => <String, dynamic>{
  'id': instance.id,
  'departure_at': instance.departureAt.toIso8601String(),
  'duration_in_minutes': instance.durationInMinutes,
  'status': instance.status,
  'loanable_id': instance.loanableId,
  'loanable_name': instance.loanableName,
  'loanable': const LoanableConverter().toJson(instance.loanable),
  'community_id': instance.communityId,
  'community_name': instance.communityName,
  'borrower_user_id': instance.borrowerUserId,
  'borrower_user_name': instance.borrowerUserName,
  'borrower_user_email': instance.borrowerUserEmail,
  'borrower_user_phone': instance.borrowerUserPhone,
  'accepted_at': instance.acceptedAt?.toIso8601String(),
  'prepaid_at': instance.prepaidAt?.toIso8601String(),
  'canceled_at': instance.canceledAt?.toIso8601String(),
  'actual_return_at': instance.actualReturnAt?.toIso8601String(),
  'borrower_validated_at': instance.borrowerValidatedAt?.toIso8601String(),
  'owner_validated_at': instance.ownerValidatedAt?.toIso8601String(),
  'needs_validation': instance.needsValidation,
  'is_free': instance.isFree,
  'borrower_total': instance.borrowerTotal,
  'owner_total': instance.ownerTotal,
  'owner_action_required': instance.ownerActionRequired,
  'borrower_action_required': instance.borrowerActionRequired,
  'is_self_service': instance.isSelfService,
  'estimated_distance': instance.estimatedDistance,
  'actual_distance': instance.actualDistance,
  'mileage_start': instance.mileageStart,
  'mileage_end': instance.mileageEnd,
  'requires_mileage': instance.requiresMileage,
  'requires_detailed_mileage': instance.requiresDetailedMileage,
  'alternative_to': instance.alternativeTo,
  'alternative_to_other': instance.alternativeToOther,
  'comment': instance.comment,
  'comments': instance.comments,
  'created_at': instance.createdAt?.toIso8601String(),
  'extension_duration_in_minutes': instance.extensionDurationInMinutes,
  'platform_tip': instance.platformTip,
  'desired_contribution': instance.desiredContribution,
  'borrower_may_contribute': instance.borrowerMayContribute,
  'borrower_must_pay_compensation': instance.borrowerMustPayCompensation,
  'borrower_must_pay_insurance': instance.borrowerMustPayInsurance,
  'applicable_amount_types': instance.applicableAmountTypes,
  'can_add_expenses': instance.canAddExpenses,
  'expenses_amount': instance.expensesAmount,
  'mileage_start_image': instance.mileageStartImage,
  'mileage_end_image': instance.mileageEndImage,
  'expense_image': instance.expenseImage,
  'borrower_invoice': instance.borrowerInvoiceJson,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_breakdown.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentBreakdown _$PaymentBreakdownFromJson(Map<String, dynamic> json) =>
    _PaymentBreakdown(
      mandatoryContributionCents:
          (json['mandatory_contribution_cents'] as num?)?.toInt() ?? 0,
      estimatedDistanceCents:
          (json['estimated_distance_cents'] as num?)?.toInt() ?? 0,
      estimatedDurationCents:
          (json['estimated_duration_cents'] as num?)?.toInt() ?? 0,
      taxesTpsCents: (json['taxes_tps_cents'] as num?)?.toInt() ?? 0,
      taxesTvqCents: (json['taxes_tvq_cents'] as num?)?.toInt() ?? 0,
      platformTipCents: (json['platform_tip_cents'] as num?)?.toInt() ?? 0,
      totalEstimatedContributionCents:
          (json['total_estimated_contribution_cents'] as num?)?.toInt() ?? 0,
      userBalanceAppliedCents:
          (json['user_balance_applied_cents'] as num?)?.toInt() ?? 0,
      remainingContributionToPayCents:
          (json['remaining_contribution_to_pay_cents'] as num?)?.toInt() ?? 0,
      securityDepositCents:
          (json['security_deposit_cents'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PaymentBreakdownToJson(_PaymentBreakdown instance) =>
    <String, dynamic>{
      'mandatory_contribution_cents': instance.mandatoryContributionCents,
      'estimated_distance_cents': instance.estimatedDistanceCents,
      'estimated_duration_cents': instance.estimatedDurationCents,
      'taxes_tps_cents': instance.taxesTpsCents,
      'taxes_tvq_cents': instance.taxesTvqCents,
      'platform_tip_cents': instance.platformTipCents,
      'total_estimated_contribution_cents':
          instance.totalEstimatedContributionCents,
      'user_balance_applied_cents': instance.userBalanceAppliedCents,
      'remaining_contribution_to_pay_cents':
          instance.remainingContributionToPayCents,
      'security_deposit_cents': instance.securityDepositCents,
    };

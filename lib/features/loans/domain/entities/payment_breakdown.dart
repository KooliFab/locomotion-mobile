import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_breakdown.freezed.dart';
part 'payment_breakdown.g.dart';

@freezed
abstract class PaymentBreakdown with _$PaymentBreakdown {
  const PaymentBreakdown._();

  const factory PaymentBreakdown({
    @JsonKey(name: 'mandatory_contribution_cents')
    @Default(0)
    int mandatoryContributionCents,
    @JsonKey(name: 'estimated_distance_cents')
    @Default(0)
    int estimatedDistanceCents,
    @JsonKey(name: 'estimated_duration_cents')
    @Default(0)
    int estimatedDurationCents,
    @JsonKey(name: 'taxes_tps_cents') @Default(0) int taxesTpsCents,
    @JsonKey(name: 'taxes_tvq_cents') @Default(0) int taxesTvqCents,
    @JsonKey(name: 'platform_tip_cents') @Default(0) int platformTipCents,
    @JsonKey(name: 'total_estimated_contribution_cents')
    @Default(0)
    int totalEstimatedContributionCents,
    @JsonKey(name: 'user_balance_applied_cents')
    @Default(0)
    int userBalanceAppliedCents,
    @JsonKey(name: 'remaining_contribution_to_pay_cents')
    @Default(0)
    int remainingContributionToPayCents,
    @JsonKey(name: 'security_deposit_cents')
    @Default(0)
    int securityDepositCents,
  }) = _PaymentBreakdown;

  factory PaymentBreakdown.fromJson(Map<String, dynamic> json) =>
      _$PaymentBreakdownFromJson(json);

  double get mandatoryContributionDollars => mandatoryContributionCents / 100.0;
  double get estimatedDistanceDollars => estimatedDistanceCents / 100.0;
  double get estimatedDurationDollars => estimatedDurationCents / 100.0;
  double get taxesTpsDollars => taxesTpsCents / 100.0;
  double get taxesTvqDollars => taxesTvqCents / 100.0;
  double get platformTipDollars => platformTipCents / 100.0;
  double get totalEstimatedContributionDollars =>
      totalEstimatedContributionCents / 100.0;
  double get userBalanceAppliedDollars => userBalanceAppliedCents / 100.0;
  double get remainingContributionToPayDollars =>
      remainingContributionToPayCents / 100.0;
  double get securityDepositDollars => securityDepositCents / 100.0;

  bool get hasDeposit => securityDepositCents > 0;
  bool get hasBalanceDeduction => userBalanceAppliedCents > 0;
  bool get isFullyCoveredByBalance => remainingContributionToPayCents == 0;
}

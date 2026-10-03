import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/loans/domain/entities/payment_breakdown.dart';

void main() {
  group('PaymentBreakdown', () {
    test('converts CAD cents to dollars correctly', () {
      const breakdown = PaymentBreakdown(
        mandatoryContributionCents: 3450,
        estimatedDistanceCents: 1200,
        estimatedDurationCents: 1800,
        taxesTpsCents: 173,
        taxesTvqCents: 344,
        platformTipCents: 200,
        totalEstimatedContributionCents: 3650,
        userBalanceAppliedCents: 1000,
        remainingContributionToPayCents: 2650,
        securityDepositCents: 25000,
      );

      expect(breakdown.mandatoryContributionDollars, 34.50);
      expect(breakdown.estimatedDistanceDollars, 12.00);
      expect(breakdown.estimatedDurationDollars, 18.00);
      expect(breakdown.taxesTpsDollars, 1.73);
      expect(breakdown.taxesTvqDollars, 3.44);
      expect(breakdown.platformTipDollars, 2.00);
      expect(breakdown.totalEstimatedContributionDollars, 36.50);
      expect(breakdown.userBalanceAppliedDollars, 10.00);
      expect(breakdown.remainingContributionToPayDollars, 26.50);
      expect(breakdown.securityDepositDollars, 250.00);

      expect(breakdown.hasDeposit, isTrue);
      expect(breakdown.hasBalanceDeduction, isTrue);
      expect(breakdown.isFullyCoveredByBalance, isFalse);
    });

    test('correctly handles zero balance and zero deposit (e.g. bike)', () {
      const breakdown = PaymentBreakdown(
        mandatoryContributionCents: 1500,
        totalEstimatedContributionCents: 1500,
        userBalanceAppliedCents: 1500,
        remainingContributionToPayCents: 0,
        securityDepositCents: 0,
      );

      expect(breakdown.hasDeposit, isFalse);
      expect(breakdown.isFullyCoveredByBalance, isTrue);
      expect(breakdown.remainingContributionToPayDollars, 0.0);
    });

    test('serializes and deserializes from JSON according to API contract', () {
      final json = {
        'mandatory_contribution_cents': 3450,
        'estimated_distance_cents': 1200,
        'estimated_duration_cents': 1800,
        'taxes_tps_cents': 173,
        'taxes_tvq_cents': 344,
        'platform_tip_cents': 200,
        'total_estimated_contribution_cents': 3650,
        'user_balance_applied_cents': 1000,
        'remaining_contribution_to_pay_cents': 2650,
        'security_deposit_cents': 25000,
      };

      final breakdown = PaymentBreakdown.fromJson(json);
      expect(breakdown.mandatoryContributionCents, 3450);
      expect(breakdown.securityDepositCents, 25000);
      expect(breakdown.toJson()['security_deposit_cents'], 25000);
    });
  });
}

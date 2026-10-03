import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/loans/domain/entities/payment_intent_response.dart';

void main() {
  group('PaymentIntentResponse', () {
    test('parses contract response with Stripe action required', () {
      final json = {
        'loan_id': 42,
        'currency': 'CAD',
        'financial_breakdown': {
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
        },
        'requires_stripe_action': true,
        'stripe': {
          'customer_id': 'cus_N123abc456',
          'ephemeral_key_secret': 'ek_test_987654321',
          'contribution_payment_intent_client_secret':
              'pi_3MtwLw2eZvKYlo2C0VvsmQry_secret_xyz',
          'deposit_payment_intent_client_secret':
              'pi_3MtwLw2eZvKYlo2C0VvsmDep_secret_abc',
          'publishable_key': 'pk_test_locomotion_demo',
        },
      };

      final response = PaymentIntentResponse.fromJson(json);
      expect(response.loanId, 42);
      expect(response.currency, 'CAD');
      expect(response.requiresStripeAction, isTrue);
      expect(response.financialBreakdown.securityDepositCents, 25000);
      expect(response.stripe?.customerId, 'cus_N123abc456');
      expect(response.stripe?.depositPaymentIntentClientSecret,
          'pi_3MtwLw2eZvKYlo2C0VvsmDep_secret_abc');
    });

    test('parses contract response when no Stripe action is required', () {
      final json = {
        'loan_id': 101,
        'currency': 'CAD',
        'financial_breakdown': {
          'mandatory_contribution_cents': 1500,
          'estimated_distance_cents': 0,
          'estimated_duration_cents': 1500,
          'taxes_tps_cents': 75,
          'taxes_tvq_cents': 150,
          'platform_tip_cents': 0,
          'total_estimated_contribution_cents': 1500,
          'user_balance_applied_cents': 1500,
          'remaining_contribution_to_pay_cents': 0,
          'security_deposit_cents': 0,
        },
        'requires_stripe_action': false,
        'stripe': null,
      };

      final response = PaymentIntentResponse.fromJson(json);
      expect(response.loanId, 101);
      expect(response.requiresStripeAction, isFalse);
      expect(response.stripe, isNull);
    });
  });
}

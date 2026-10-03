import '../entities/loan.dart';
import '../entities/payment_intent_response.dart';
import '../entities/payment_method_model.dart';

abstract class LoanPaymentRepository {
  Future<PaymentIntentResponse> createPaymentIntent({
    required int loanId,
    int? platformTipCents,
    bool useBalance = true,
  });

  Future<Loan> prepay({
    required int loanId,
    int? platformTipCents,
    String? contributionPaymentIntentId,
    String? depositPaymentIntentId,
  });

  Future<List<PaymentMethodModel>> getPaymentMethods();

  Future<void> deletePaymentMethod(int id);
}

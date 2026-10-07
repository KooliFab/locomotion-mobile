import '../entities/invoice_summary.dart';
import '../entities/loan.dart';
import '../entities/payment_method_model.dart';

abstract class LoanPaymentRepository {
  Future<InvoiceSummary?> estimateBorrowerInvoice({
    required int loanId,
    required double platformTip,
  });

  Future<double> addToBalance({required double amount, int? paymentMethodId});

  Future<Loan> prepay({required int loanId, required double platformTip});

  Future<Loan> pay({required int loanId, required double platformTip});

  Future<List<PaymentMethodModel>> getPaymentMethods();

  Future<void> deletePaymentMethod(int id);
}

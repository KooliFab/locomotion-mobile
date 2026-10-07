import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_providers.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/invoice_summary.dart';
import '../../domain/entities/payment_method_model.dart';
import '../../domain/repositories/loan_payment_repository.dart';
import '../datasources/loan_payment_remote_data_source.dart';

class LoanPaymentRepositoryImpl implements LoanPaymentRepository {
  final LoanPaymentRemoteDataSource _remoteDataSource;

  const LoanPaymentRepositoryImpl(this._remoteDataSource);

  @override
  Future<InvoiceSummary?> estimateBorrowerInvoice({
    required int loanId,
    required double platformTip,
  }) {
    return _remoteDataSource.estimateBorrowerInvoice(
      loanId: loanId,
      platformTip: platformTip,
    );
  }

  @override
  Future<double> addToBalance({required double amount, int? paymentMethodId}) {
    return _remoteDataSource.addToBalance(
      amount: amount,
      paymentMethodId: paymentMethodId,
    );
  }

  @override
  Future<Loan> prepay({required int loanId, required double platformTip}) {
    return _remoteDataSource.prepay(loanId: loanId, platformTip: platformTip);
  }

  @override
  Future<Loan> pay({required int loanId, required double platformTip}) {
    return _remoteDataSource.pay(loanId: loanId, platformTip: platformTip);
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() {
    return _remoteDataSource.getPaymentMethods();
  }

  @override
  Future<void> deletePaymentMethod(int id) {
    return _remoteDataSource.deletePaymentMethod(id);
  }
}

final loanPaymentRemoteDataSourceProvider =
    Provider<LoanPaymentRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return LoanPaymentRemoteDataSourceImpl(apiClient);
    });

final loanPaymentRepositoryProvider = Provider<LoanPaymentRepository>((ref) {
  final remoteDataSource = ref.watch(loanPaymentRemoteDataSourceProvider);
  return LoanPaymentRepositoryImpl(remoteDataSource);
});

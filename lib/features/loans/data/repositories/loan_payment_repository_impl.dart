import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_providers.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/payment_intent_response.dart';
import '../../domain/entities/payment_method_model.dart';
import '../../domain/repositories/loan_payment_repository.dart';
import '../datasources/loan_payment_remote_data_source.dart';

class LoanPaymentRepositoryImpl implements LoanPaymentRepository {
  final LoanPaymentRemoteDataSource _remoteDataSource;

  const LoanPaymentRepositoryImpl(this._remoteDataSource);

  @override
  Future<PaymentIntentResponse> createPaymentIntent({
    required int loanId,
    int? platformTipCents,
    bool useBalance = true,
  }) {
    return _remoteDataSource.createPaymentIntent(
      loanId: loanId,
      platformTipCents: platformTipCents,
      useBalance: useBalance,
    );
  }

  @override
  Future<Loan> prepay({
    required int loanId,
    int? platformTipCents,
    String? contributionPaymentIntentId,
    String? depositPaymentIntentId,
  }) {
    return _remoteDataSource.prepay(
      loanId: loanId,
      platformTipCents: platformTipCents,
      contributionPaymentIntentId: contributionPaymentIntentId,
      depositPaymentIntentId: depositPaymentIntentId,
    );
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

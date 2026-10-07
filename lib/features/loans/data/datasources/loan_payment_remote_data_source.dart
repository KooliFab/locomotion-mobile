import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../domain/entities/invoice_summary.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/payment_method_model.dart';

/// Payment calls reused from the web app: balance top-up with a saved card,
/// then `/prepay` (accepted loan) or `/pay` (validated loan).
abstract class LoanPaymentRemoteDataSource {
  /// Borrower invoice recomputed by the server for a given contribution.
  Future<InvoiceSummary?> estimateBorrowerInvoice({
    required int loanId,
    required double platformTip,
  });

  /// Charges a saved card and credits the balance (`PUT /auth/user/balance`).
  /// Stripe fees are added by the server. Returns the new balance.
  Future<double> addToBalance({required double amount, int? paymentMethodId});

  Future<Loan> prepay({required int loanId, required double platformTip});

  Future<Loan> pay({required int loanId, required double platformTip});

  Future<List<PaymentMethodModel>> getPaymentMethods();

  Future<void> deletePaymentMethod(int id);
}

class LoanPaymentRemoteDataSourceImpl implements LoanPaymentRemoteDataSource {
  final ApiClient _apiClient;

  const LoanPaymentRemoteDataSourceImpl(this._apiClient);

  @override
  Future<InvoiceSummary?> estimateBorrowerInvoice({
    required int loanId,
    required double platformTip,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.loanEstimate(loanId),
      queryParameters: {'platform_tip': platformTip},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw FormatException(
        'Format de réponse invalide pour l\'estimation du prêt #$loanId',
      );
    }
    // The server omits the invoice when it has no non-zero item.
    return InvoiceSummary.tryParse(data['borrower_invoice']);
  }

  @override
  Future<double> addToBalance({
    required double amount,
    int? paymentMethodId,
  }) async {
    final response = await _apiClient.put(
      ApiEndpoints.userBalance,
      data: {'amount': amount, 'payment_method_id': ?paymentMethodId},
    );
    return UserBalanceController.parseBalance(response.data);
  }

  @override
  Future<Loan> prepay({required int loanId, required double platformTip}) {
    return _putLoanAction(ApiEndpoints.loanPrepay(loanId), platformTip);
  }

  @override
  Future<Loan> pay({required int loanId, required double platformTip}) {
    return _putLoanAction(ApiEndpoints.loanPay(loanId), platformTip);
  }

  Future<Loan> _putLoanAction(String endpoint, double platformTip) async {
    final response = await _apiClient.put(
      endpoint,
      data: {'platform_tip': platformTip},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final item = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
      return Loan.fromJson(item);
    }
    throw const FormatException('Format de réponse invalide pour le paiement');
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final response = await _apiClient.get(ApiEndpoints.paymentMethods);
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final list = data['data'] is List ? data['data'] as List : <dynamic>[];
      return list
          .whereType<Map<String, dynamic>>()
          .map((item) => PaymentMethodModel.fromJson(item))
          .toList();
    } else if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map((item) => PaymentMethodModel.fromJson(item))
          .toList();
    }
    return [];
  }

  @override
  Future<void> deletePaymentMethod(int id) async {
    await _apiClient.delete(ApiEndpoints.paymentMethodDetail(id));
  }
}

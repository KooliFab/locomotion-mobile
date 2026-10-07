import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/payment_intent_response.dart';
import '../../domain/entities/payment_method_model.dart';

abstract class LoanPaymentRemoteDataSource {
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

class LoanPaymentRemoteDataSourceImpl implements LoanPaymentRemoteDataSource {
  final ApiClient _apiClient;

  const LoanPaymentRemoteDataSourceImpl(this._apiClient);

  @override
  Future<PaymentIntentResponse> createPaymentIntent({
    required int loanId,
    int? platformTipCents,
    bool useBalance = true,
  }) async {
    final payload = <String, dynamic>{'use_balance_if_available': useBalance};
    if (platformTipCents != null) {
      payload['platform_tip_cents'] = platformTipCents;
    }

    final response = await _apiClient.post(
      ApiEndpoints.loanPaymentIntent(loanId),
      data: payload,
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
      return PaymentIntentResponse.fromJson(inner);
    }
    throw const FormatException(
      'Format de réponse invalide pour l\'initialisation du paiement Stripe',
    );
  }

  @override
  Future<Loan> prepay({
    required int loanId,
    int? platformTipCents,
    String? contributionPaymentIntentId,
    String? depositPaymentIntentId,
  }) async {
    final payload = <String, dynamic>{};
    if (platformTipCents != null) {
      payload['platform_tip_cents'] = platformTipCents;
    }
    if (contributionPaymentIntentId != null) {
      payload['stripe_contribution_payment_intent_id'] =
          contributionPaymentIntentId;
    }
    if (depositPaymentIntentId != null) {
      payload['stripe_deposit_payment_intent_id'] = depositPaymentIntentId;
    }

    final response = await _apiClient.put(
      ApiEndpoints.loanPrepay(loanId),
      data: payload,
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final item = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : (data['loan'] is Map<String, dynamic>
                ? data['loan'] as Map<String, dynamic>
                : data);
      return Loan.fromJson(item);
    }
    throw const FormatException(
      'Format de réponse invalide pour la confirmation du prépaiement',
    );
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

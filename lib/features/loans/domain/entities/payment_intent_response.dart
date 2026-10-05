import 'package:freezed_annotation/freezed_annotation.dart';
import 'payment_breakdown.dart';

part 'payment_intent_response.freezed.dart';
part 'payment_intent_response.g.dart';

@freezed
abstract class StripePaymentParams with _$StripePaymentParams {
  const factory StripePaymentParams({
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'ephemeral_key_secret') required String ephemeralKeySecret,
    @JsonKey(name: 'contribution_payment_intent_client_secret')
    String? contributionPaymentIntentClientSecret,
    @JsonKey(name: 'deposit_payment_intent_client_secret')
    String? depositPaymentIntentClientSecret,
    @JsonKey(name: 'contribution_payment_intent_id')
    String? contributionPaymentIntentId,
    @JsonKey(name: 'deposit_payment_intent_id')
    String? depositPaymentIntentId,
    @JsonKey(name: 'contribution_already_paid')
    @Default(false)
    bool contributionAlreadyPaid,
    @JsonKey(name: 'deposit_already_authorized')
    @Default(false)
    bool depositAlreadyAuthorized,
    @JsonKey(name: 'publishable_key') String? publishableKey,
  }) = _StripePaymentParams;

  factory StripePaymentParams.fromJson(Map<String, dynamic> json) =>
      _$StripePaymentParamsFromJson(json);
}

@freezed
abstract class PaymentIntentResponse with _$PaymentIntentResponse {
  const PaymentIntentResponse._();

  const factory PaymentIntentResponse({
    @JsonKey(name: 'loan_id') required int loanId,
    @JsonKey(name: 'currency') @Default('CAD') String currency,
    @JsonKey(name: 'financial_breakdown')
    required PaymentBreakdown financialBreakdown,
    @JsonKey(name: 'requires_stripe_action')
    @Default(false)
    bool requiresStripeAction,
    @JsonKey(name: 'stripe') StripePaymentParams? stripe,
  }) = _PaymentIntentResponse;

  factory PaymentIntentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentResponseFromJson(json);
}

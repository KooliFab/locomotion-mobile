// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_intent_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StripePaymentParams _$StripePaymentParamsFromJson(Map<String, dynamic> json) =>
    _StripePaymentParams(
      customerId: json['customer_id'] as String,
      ephemeralKeySecret: json['ephemeral_key_secret'] as String,
      contributionPaymentIntentClientSecret:
          json['contribution_payment_intent_client_secret'] as String?,
      depositPaymentIntentClientSecret:
          json['deposit_payment_intent_client_secret'] as String?,
      contributionPaymentIntentId:
          json['contribution_payment_intent_id'] as String?,
      depositPaymentIntentId: json['deposit_payment_intent_id'] as String?,
      contributionAlreadyPaid:
          json['contribution_already_paid'] as bool? ?? false,
      depositAlreadyAuthorized:
          json['deposit_already_authorized'] as bool? ?? false,
      publishableKey: json['publishable_key'] as String?,
    );

Map<String, dynamic> _$StripePaymentParamsToJson(
  _StripePaymentParams instance,
) => <String, dynamic>{
  'customer_id': instance.customerId,
  'ephemeral_key_secret': instance.ephemeralKeySecret,
  'contribution_payment_intent_client_secret':
      instance.contributionPaymentIntentClientSecret,
  'deposit_payment_intent_client_secret':
      instance.depositPaymentIntentClientSecret,
  'contribution_payment_intent_id': instance.contributionPaymentIntentId,
  'deposit_payment_intent_id': instance.depositPaymentIntentId,
  'contribution_already_paid': instance.contributionAlreadyPaid,
  'deposit_already_authorized': instance.depositAlreadyAuthorized,
  'publishable_key': instance.publishableKey,
};

_PaymentIntentResponse _$PaymentIntentResponseFromJson(
  Map<String, dynamic> json,
) => _PaymentIntentResponse(
  loanId: (json['loan_id'] as num).toInt(),
  currency: json['currency'] as String? ?? 'CAD',
  financialBreakdown: PaymentBreakdown.fromJson(
    json['financial_breakdown'] as Map<String, dynamic>,
  ),
  requiresStripeAction: json['requires_stripe_action'] as bool? ?? false,
  stripe: json['stripe'] == null
      ? null
      : StripePaymentParams.fromJson(json['stripe'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaymentIntentResponseToJson(
  _PaymentIntentResponse instance,
) => <String, dynamic>{
  'loan_id': instance.loanId,
  'currency': instance.currency,
  'financial_breakdown': instance.financialBreakdown,
  'requires_stripe_action': instance.requiresStripeAction,
  'stripe': instance.stripe,
};

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../config/env.dart';

enum StripeSheetStatus { success, canceled, failed }

class StripeSheetResponse {
  final StripeSheetStatus status;
  final String? errorMessage;

  const StripeSheetResponse({required this.status, this.errorMessage});

  bool get isSuccess => status == StripeSheetStatus.success;
  bool get isCanceled => status == StripeSheetStatus.canceled;
  bool get isFailed => status == StripeSheetStatus.failed;
}

abstract class StripePaymentService {
  Future<void> initialize();

  Future<void> initPaymentSheet({
    required String paymentIntentClientSecret,
    required String customerId,
    required String customerEphemeralKeySecret,
    String? merchantDisplayName,
  });

  Future<StripeSheetResponse> presentPaymentSheet();
}

class StripePaymentServiceImpl implements StripePaymentService {
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      Stripe.publishableKey = AppConfig.stripePublishableKey;
      Stripe.merchantIdentifier = 'merchant.com.locomotion.app';
      await Stripe.instance.applySettings();
      _initialized = true;
    } catch (e) {
      debugPrint('Stripe initialization note: $e');
    }
  }

  @override
  Future<void> initPaymentSheet({
    required String paymentIntentClientSecret,
    required String customerId,
    required String customerEphemeralKeySecret,
    String? merchantDisplayName,
  }) async {
    await initialize();

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        customerId: customerId,
        customerEphemeralKeySecret: customerEphemeralKeySecret,
        merchantDisplayName:
            merchantDisplayName ?? AppConfig.stripeMerchantDisplayName,
        allowsDelayedPaymentMethods: false,
      ),
    );
  }

  @override
  Future<StripeSheetResponse> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return const StripeSheetResponse(status: StripeSheetStatus.success);
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        return const StripeSheetResponse(status: StripeSheetStatus.canceled);
      }
      return StripeSheetResponse(
        status: StripeSheetStatus.failed,
        errorMessage: e.error.localizedMessage ?? e.error.message,
      );
    } catch (e) {
      return StripeSheetResponse(
        status: StripeSheetStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }
}

final stripePaymentServiceProvider = Provider<StripePaymentService>((ref) {
  return StripePaymentServiceImpl();
});

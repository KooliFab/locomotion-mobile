import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'env.g.dart';

enum Environment { dev, staging, prod }

class AppConfig {
  static const Environment environment = Environment.dev;

  /// Default predefined host URLs for local development
  static const String macLocalIpUrl = 'http://192.168.0.198:8000/api/v1';
  static const String usbReverseUrl = 'http://127.0.0.1:8000/api/v1';
  static const String androidEmulatorUrl = 'http://10.0.2.2:8000/api/v1';
  static const String iosSimulatorUrl = 'http://localhost:8000/api/v1';

  /// Default API base URL depending on environment
  static String get defaultBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api/v1';
    }
    if (Platform.isAndroid) {
      // Default to Mac local IP which works on real physical devices over Wi-Fi
      // and can also use 127.0.0.1 with `adb reverse tcp:8000 tcp:8000`
      return macLocalIpUrl;
    }
    // iOS simulator & desktop connect via localhost
    return iosSimulatorUrl;
  }

  /// Active base URL
  static String baseUrl = defaultBaseUrl;

  /// Stripe configuration
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'pk_test_locomotion_demo',
  );
  static const String stripeMerchantDisplayName = 'LocoMotion';

  /// Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}

@Riverpod(keepAlive: true)
class ApiBaseUrl extends _$ApiBaseUrl {
  @override
  String build() {
    return AppConfig.baseUrl;
  }

  void setBaseUrl(String url) {
    AppConfig.baseUrl = url;
    state = url;
  }
}

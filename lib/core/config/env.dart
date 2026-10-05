import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'env.g.dart';

enum Environment { dev, staging, prod }

class AppConfig {
  static const String _rawEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: '',
  );

  static Environment? _manualEnvironment;

  /// Active environment, resolved from explicit setter or compile-time `APP_ENV`
  static Environment get environment {
    if (_manualEnvironment != null) {
      return _manualEnvironment!;
    }
    switch (_rawEnv.toLowerCase()) {
      case 'staging':
        return Environment.staging;
      case 'prod':
      case 'production':
        return Environment.prod;
      case 'dev':
      case 'development':
      default:
        return Environment.dev;
    }
  }

  /// Sets the environment programmatically (used by entrypoints & tests)
  static void setEnvironment(Environment env) {
    _manualEnvironment = env;
    baseUrl = defaultBaseUrl;
  }

  /// Default predefined host URLs for local development
  static const String macLocalIpUrl = 'http://192.168.0.198:8000/api/v1';
  static const String usbReverseUrl = 'http://127.0.0.1:8000/api/v1';
  static const String androidEmulatorUrl = 'http://10.0.2.2:8000/api/v1';
  static const String iosSimulatorUrl = 'http://localhost:8000/api/v1';

  /// Predefined URLs for remote environments
  static const String stagingUrl = 'https://staging.locomotion.app/api/v1';
  static const String prodUrl = 'https://api.locomotion.app/api/v1';

  static const String customBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// Default API base URL depending on environment
  static String get defaultBaseUrl {
    if (customBaseUrl.isNotEmpty) {
      return customBaseUrl;
    }
    switch (environment) {
      case Environment.staging:
        return stagingUrl;
      case Environment.prod:
        return prodUrl;
      case Environment.dev:
        if (kIsWeb) {
          return 'http://localhost:8000/api/v1';
        }
        try {
          if (Platform.isAndroid) {
            // Default to Mac local IP which works on real physical devices over Wi-Fi
            // and can also use 127.0.0.1 with `adb reverse tcp:8000 tcp:8000`
            return macLocalIpUrl;
          }
        } catch (_) {}
        // iOS simulator & desktop connect via localhost
        return iosSimulatorUrl;
    }
  }

  /// Active base URL
  static String baseUrl = defaultBaseUrl;

  /// Stripe configuration
  static const String _defaultStripeKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue: 'pk_test_locomotion_demo',
  );
  static String? _manualStripeKey;
  static String get stripePublishableKey =>
      _manualStripeKey ?? _defaultStripeKey;
  static set stripePublishableKey(String value) => _manualStripeKey = value;

  static const String stripeMerchantDisplayName = 'LocoMotion';

  /// Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Validates the configuration for the active environment.
  /// Throws a [StateError] if any requirement is violated.
  static void validate() {
    final activeBaseUrl = baseUrl;
    final activeKey = stripePublishableKey;

    if (environment == Environment.prod) {
      // 1. Production API must use HTTPS
      if (!activeBaseUrl.startsWith('https://')) {
        throw StateError(
          'Production API URL must use HTTPS. Current: $activeBaseUrl',
        );
      }

      // 2. Production API must not point to localhost or private local IP ranges
      final uri = Uri.tryParse(activeBaseUrl);
      if (uri == null ||
          uri.host.isEmpty ||
          uri.host == 'localhost' ||
          uri.host == '127.0.0.1' ||
          uri.host == '10.0.2.2' ||
          uri.host.startsWith('192.168.') ||
          uri.host.startsWith('10.') ||
          uri.host.startsWith('172.16.') ||
          uri.host.startsWith('172.17.') ||
          uri.host.startsWith('172.18.') ||
          uri.host.startsWith('172.19.') ||
          uri.host.startsWith('172.20.') ||
          uri.host.startsWith('172.21.') ||
          uri.host.startsWith('172.22.') ||
          uri.host.startsWith('172.23.') ||
          uri.host.startsWith('172.24.') ||
          uri.host.startsWith('172.25.') ||
          uri.host.startsWith('172.26.') ||
          uri.host.startsWith('172.27.') ||
          uri.host.startsWith('172.28.') ||
          uri.host.startsWith('172.29.') ||
          uri.host.startsWith('172.30.') ||
          uri.host.startsWith('172.31.')) {
        throw StateError(
          'Production API URL must not use localhost or private local IP. Current: $activeBaseUrl',
        );
      }

      // 3. Production Stripe key must be provided and must be a live key
      if (activeKey.isEmpty || activeKey == 'pk_test_locomotion_demo') {
        throw StateError(
          'Production requires a valid live Stripe publishable key (cannot be demo test key).',
        );
      }
      if (!activeKey.startsWith('pk_live_')) {
        throw StateError(
          'Production Stripe key must start with "pk_live_". Current: $activeKey',
        );
      }
    } else if (environment == Environment.staging) {
      if (!activeBaseUrl.startsWith('https://')) {
        throw StateError(
          'Staging API URL must use HTTPS. Current: $activeBaseUrl',
        );
      }
      if (activeKey.isEmpty) {
        throw StateError('Staging requires a non-empty Stripe key.');
      }
    } else {
      if (activeBaseUrl.isEmpty) {
        throw StateError('API base URL cannot be empty.');
      }
    }
  }

  /// Resets state overrides (useful in testing)
  @visibleForTesting
  static void resetForTesting() {
    _manualEnvironment = null;
    _manualStripeKey = null;
    baseUrl = defaultBaseUrl;
  }
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

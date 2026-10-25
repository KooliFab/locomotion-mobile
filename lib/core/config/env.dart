import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
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
  static Environment get environment =>
      _manualEnvironment ?? _compileTimeEnvironment ?? Environment.dev;

  /// Environment named by `APP_ENV`, or null when it is absent or unknown.
  static Environment? get _compileTimeEnvironment =>
      switch (_rawEnv.toLowerCase()) {
        'staging' => Environment.staging,
        'prod' || 'production' => Environment.prod,
        'dev' || 'development' => Environment.dev,
        _ => null,
      };

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

  /// Firebase configuration via compile-time --dart-define
  static const String firebaseApiKey = String.fromEnvironment(
    'FIREBASE_API_KEY',
    defaultValue: '',
  );
  static const String firebaseAppId = String.fromEnvironment(
    'FIREBASE_APP_ID',
    defaultValue: '',
  );
  static const String firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '',
  );
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: '',
  );
  static const String firebaseStorageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: '',
  );

  /// Explicit FirebaseOptions configured for this environment, or null if relying on native files
  static FirebaseOptions? get firebaseOptions {
    if (firebaseApiKey.isNotEmpty &&
        firebaseAppId.isNotEmpty &&
        firebaseMessagingSenderId.isNotEmpty &&
        firebaseProjectId.isNotEmpty) {
      return FirebaseOptions(
        apiKey: firebaseApiKey,
        appId: firebaseAppId,
        messagingSenderId: firebaseMessagingSenderId,
        projectId: firebaseProjectId,
        storageBucket: firebaseStorageBucket.isNotEmpty
            ? firebaseStorageBucket
            : null,
      );
    }
    return null;
  }

  /// Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Validates the configuration for the active environment.
  /// Throws a [StateError] if any requirement is violated.
  ///
  /// A release build must name its environment: falling back to dev there
  /// would ship an app pointing at a developer machine over plain HTTP.
  static void validate({bool isReleaseBuild = kReleaseMode}) {
    if (_manualEnvironment == null) {
      if (_rawEnv.isNotEmpty && _compileTimeEnvironment == null) {
        throw StateError(
          'Unknown APP_ENV "$_rawEnv". Use dev, staging or prod.',
        );
      }
      if (isReleaseBuild && _compileTimeEnvironment == null) {
        throw StateError(
          'A release build must select its environment: build from '
          'lib/main_<env>.dart or pass --dart-define=APP_ENV=<env>.',
        );
      }
    }

    final activeBaseUrl = baseUrl;

    if (environment == Environment.prod) {
      // 1. Production API must use HTTPS
      if (!activeBaseUrl.startsWith('https://')) {
        throw StateError(
          'Production API URL must use HTTPS. Current: $activeBaseUrl',
        );
      }

      // 2. Production API must not point to localhost or private local IP ranges
      final uri = Uri.tryParse(activeBaseUrl);
      if (uri == null || isLocalOrPrivateHost(uri.host)) {
        throw StateError(
          'Production API URL must not use localhost or private local IP. Current: $activeBaseUrl',
        );
      }
    } else if (environment == Environment.staging) {
      if (!activeBaseUrl.startsWith('https://')) {
        throw StateError(
          'Staging API URL must use HTTPS. Current: $activeBaseUrl',
        );
      }
    } else {
      if (activeBaseUrl.isEmpty) {
        throw StateError('API base URL cannot be empty.');
      }
    }
  }

  /// Whether [host] is loopback, link-local or in a private range: a
  /// developer machine or emulator rather than a public API server.
  @visibleForTesting
  static bool isLocalOrPrivateHost(String host) {
    final h = host.toLowerCase();
    if (h.isEmpty || h == 'localhost' || h.endsWith('.local')) return true;

    final octets = h.split('.').map(int.tryParse).toList();
    if (octets.length == 4 &&
        octets.every((o) => o != null && o >= 0 && o <= 255)) {
      final a = octets[0]!;
      final b = octets[1]!;
      return a == 0 ||
          a == 10 ||
          a == 127 ||
          (a == 169 && b == 254) ||
          (a == 172 && b >= 16 && b <= 31) ||
          (a == 192 && b == 168);
    }

    // IPv6 (Uri.host drops the brackets): loopback, unique local, link-local.
    if (h.contains(':')) {
      return h == '::1' ||
          h.startsWith('fc') ||
          h.startsWith('fd') ||
          h.startsWith('fe80');
    }
    return false;
  }

  /// Resets state overrides (useful in testing)
  @visibleForTesting
  static void resetForTesting() {
    _manualEnvironment = null;
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

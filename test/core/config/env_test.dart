import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/config/env.dart';

void main() {
  tearDown(() {
    AppConfig.resetForTesting();
  });

  group('AppConfig Environment and URLs', () {
    test('defaults to dev environment with local baseUrl', () {
      expect(AppConfig.environment, Environment.dev);
      expect(AppConfig.baseUrl, isNotEmpty);
      expect(AppConfig.baseUrl, contains('8000'));
    });

    test('setting staging environment updates baseUrl to stagingUrl', () {
      AppConfig.setEnvironment(Environment.staging);
      expect(AppConfig.environment, Environment.staging);
      expect(AppConfig.baseUrl, AppConfig.stagingUrl);
      expect(AppConfig.baseUrl, 'https://staging.locomotion.app/api/v1');
    });

    test('setting prod environment updates baseUrl to prodUrl', () {
      AppConfig.setEnvironment(Environment.prod);
      expect(AppConfig.environment, Environment.prod);
      expect(AppConfig.baseUrl, AppConfig.prodUrl);
      expect(AppConfig.baseUrl, 'https://api.locomotion.app/api/v1');
    });

    test('customBaseUrl override works across environments', () {
      AppConfig.setEnvironment(Environment.staging);
      AppConfig.baseUrl = 'https://custom-staging.example.com/api/v1';
      expect(AppConfig.baseUrl, 'https://custom-staging.example.com/api/v1');
    });
  });

  group('AppConfig Validation', () {
    test('passes in dev mode with local URL', () {
      AppConfig.setEnvironment(Environment.dev);
      expect(() => AppConfig.validate(), returnsNormally);
    });

    test('fails in dev mode if baseUrl is empty', () {
      AppConfig.setEnvironment(Environment.dev);
      AppConfig.baseUrl = '';
      expect(
        () => AppConfig.validate(),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('cannot be empty'),
          ),
        ),
      );
    });

    test('passes in staging mode with HTTPS URL', () {
      AppConfig.setEnvironment(Environment.staging);
      expect(() => AppConfig.validate(), returnsNormally);
    });

    test('fails in staging mode if baseUrl is not HTTPS', () {
      AppConfig.setEnvironment(Environment.staging);
      AppConfig.baseUrl = 'http://staging.locomotion.app/api/v1';
      expect(
        () => AppConfig.validate(),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('must use HTTPS'),
          ),
        ),
      );
    });

    test('fails in prod mode if baseUrl points to localhost', () {
      AppConfig.setEnvironment(Environment.prod);
      AppConfig.baseUrl = 'https://localhost:8000/api/v1';
      expect(
        () => AppConfig.validate(),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('must not use localhost or private local IP'),
          ),
        ),
      );
    });

    test('fails in prod mode if baseUrl points to private LAN IP', () {
      AppConfig.setEnvironment(Environment.prod);
      AppConfig.baseUrl = 'https://192.168.1.100/api/v1';
      expect(
        () => AppConfig.validate(),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('must not use localhost or private local IP'),
          ),
        ),
      );
    });

    test('fails in prod mode if baseUrl is HTTP', () {
      AppConfig.setEnvironment(Environment.prod);
      AppConfig.baseUrl = 'http://api.locomotion.app/api/v1';
      expect(
        () => AppConfig.validate(),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('must use HTTPS'),
          ),
        ),
      );
    });

    test('passes in prod mode with valid HTTPS remote URL', () {
      AppConfig.setEnvironment(Environment.prod);
      expect(() => AppConfig.validate(), returnsNormally);
    });
  });

  group('Riverpod ApiBaseUrl notifier', () {
    test('exposes AppConfig.baseUrl and updates state on setBaseUrl', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(apiBaseUrlProvider), AppConfig.baseUrl);

      container
          .read(apiBaseUrlProvider.notifier)
          .setBaseUrl('https://custom.api/v1');
      expect(container.read(apiBaseUrlProvider), 'https://custom.api/v1');
      expect(AppConfig.baseUrl, 'https://custom.api/v1');
    });
  });
}

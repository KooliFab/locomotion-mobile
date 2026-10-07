import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/config/env.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/notifications/data/services/disabled_push_notification_service.dart';
import 'package:mobile/features/notifications/data/services/fake_push_notification_service.dart';
import 'package:mobile/features/notifications/domain/entities/push_token.dart';
import 'package:mobile/features/notifications/domain/repositories/push_tokens_repository.dart';
import 'package:mobile/features/notifications/presentation/controllers/notifications_controller.dart';

class _MockPushTokensRepository implements PushTokensRepository {
  bool registerCalled = false;
  String? registeredToken;

  @override
  Future<String> getOrCreateInstallationId() async => 'test_install_id';

  @override
  Future<PushToken> registerToken({
    required String token,
    required String platform,
    String? appVersion,
  }) async {
    registerCalled = true;
    registeredToken = token;
    return PushToken(
      id: 1,
      token: token,
      platform: platform,
      installationId: 'test_install_id',
    );
  }

  @override
  Future<void> revokeCurrentInstallationToken() async {}
}

class _TestAuthController extends AuthController {
  final User? user;
  _TestAuthController(this.user);

  @override
  Future<User?> build() async => user;
}

void main() {
  const testUser = User(
    id: 15,
    email: 'user@example.com',
    firstName: 'Pierre',
    lastName: 'Gagnon',
  );

  group('R18: Push notification service fallback behavior', () {
    test(
      'Default pushNotificationServiceProvider returns DisabledPushNotificationService when Firebase is not initialized',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final service = container.read(pushNotificationServiceProvider);
        expect(service, isA<DisabledPushNotificationService>());
        expect(service, isNot(isA<FakePushNotificationService>()));
      },
    );

    test(
      'DisabledPushNotificationService safely returns false/null without generating fake tokens',
      () async {
        final service = DisabledPushNotificationService();

        await service.initialize();
        expect(await service.isPermissionGranted(), isFalse);
        expect(await service.requestPermission(), isFalse);
        expect(await service.getToken(), isNull);
        expect(await service.getInitialMessage(), isNull);
      },
    );

    test(
      'NotificationsController with unconfigured Firebase does NOT register fake device or grant permission',
      () async {
        final mockRepo = _MockPushTokensRepository();
        final container = ProviderContainer(
          overrides: [
            authControllerProvider.overrideWith(
              () => _TestAuthController(testUser),
            ),
            pushTokensRepositoryProvider.overrideWithValue(mockRepo),
          ],
        );
        addTearDown(container.dispose);

        // Ensure the user is authenticated so we exercise the Firebase-unavailable path
        await container.read(authControllerProvider.future);

        // Trigger initialization
        final controller = container.read(
          notificationsControllerProvider.notifier,
        );
        await controller.initialize();

        final state = container.read(notificationsControllerProvider);
        expect(state.isPermissionGranted, isFalse);
        expect(state.registeredTokenPrefix, isNull);
        expect(mockRepo.registerCalled, isFalse);

        // Attempt to sync token
        await controller.syncPushToken();

        expect(mockRepo.registerCalled, isFalse);
        expect(mockRepo.registeredToken, isNull);
        expect(state.registeredTokenPrefix, isNull);
      },
    );

    test(
      'FakePushNotificationService is only active when explicitly injected in tests',
      () async {
        final fakeService = FakePushNotificationService();
        final mockRepo = _MockPushTokensRepository();

        final container = ProviderContainer(
          overrides: [
            authControllerProvider.overrideWith(
              () => _TestAuthController(testUser),
            ),
            pushNotificationServiceProvider.overrideWithValue(fakeService),
            pushTokensRepositoryProvider.overrideWithValue(mockRepo),
          ],
        );
        addTearDown(container.dispose);

        final service = container.read(pushNotificationServiceProvider);
        expect(service, isA<FakePushNotificationService>());

        await container.read(authControllerProvider.future);

        final controller = container.read(
          notificationsControllerProvider.notifier,
        );
        await controller.initialize();
        await controller.syncPushToken();

        expect(mockRepo.registerCalled, isTrue);
        expect(mockRepo.registeredToken, 'fake_fcm_token_123456');
      },
    );

    test(
      'AppConfig.firebaseOptions returns null when environment defines are not set',
      () {
        expect(AppConfig.firebaseOptions, isNull);
      },
    );
  });
}

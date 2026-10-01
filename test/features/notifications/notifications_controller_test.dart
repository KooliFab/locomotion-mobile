import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/notifications/data/services/fake_push_notification_service.dart';
import 'package:mobile/features/notifications/domain/entities/push_payload.dart';
import 'package:mobile/features/notifications/domain/entities/push_token.dart';
import 'package:mobile/features/notifications/domain/repositories/push_tokens_repository.dart';
import 'package:mobile/features/notifications/presentation/controllers/notifications_controller.dart';

class FakePushTokensRepository implements PushTokensRepository {
  String storedInstallationId = 'fake_install_uuid';
  String? registeredToken;
  String? registeredPlatform;
  String? registeredAppVersion;
  bool isRevoked = false;

  @override
  Future<String> getOrCreateInstallationId() async => storedInstallationId;

  @override
  Future<PushToken> registerToken({
    required String token,
    required String platform,
    String? appVersion,
  }) async {
    registeredToken = token;
    registeredPlatform = platform;
    registeredAppVersion = appVersion;
    return PushToken(
      id: 1,
      token: token,
      platform: platform,
      installationId: storedInstallationId,
      appVersion: appVersion,
    );
  }

  @override
  Future<void> revokeCurrentInstallationToken() async {
    isRevoked = true;
    registeredToken = null;
  }
}

class _TestAuthController extends AuthController {
  final User? user;
  _TestAuthController(this.user);

  @override
  FutureOr<User?> build() => user;
}

void main() {
  late FakePushNotificationService fakeService;
  late FakePushTokensRepository fakeRepo;

  const testUser = User(
    id: 12,
    email: 'test@locomotion.app',
    firstName: 'Jean',
    lastName: 'Tremblay',
    emailVerifiedAt: null,
  );

  ProviderContainer createContainer({User? user}) {
    return ProviderContainer(
      overrides: [
        pushNotificationServiceProvider.overrideWithValue(fakeService),
        pushTokensRepositoryProvider.overrideWithValue(fakeRepo),
        authControllerProvider.overrideWith(() => _TestAuthController(user)),
      ],
    );
  }

  setUp(() {
    fakeService = FakePushNotificationService();
    fakeRepo = FakePushTokensRepository();
  });

  tearDown(() {
    fakeService.dispose();
  });

  group('NotificationsController Lifecycle & Permissions', () {
    test('initial state has default values', () {
      final container = createContainer();
      addTearDown(container.dispose);

      final state = container.read(notificationsControllerProvider);
      expect(state.isPermissionGranted, isFalse);
      expect(state.isRegistering, isFalse);
      expect(state.registeredTokenPrefix, isNull);
      expect(state.pendingRedirectPath, isNull);
    });

    test('initialize updates permission state and attaches streams', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      fakeService.permissionGranted = true;
      final controller = container.read(
        notificationsControllerProvider.notifier,
      );

      await controller.initialize();

      expect(
        container.read(notificationsControllerProvider).isPermissionGranted,
        isTrue,
      );
      expect(fakeService.isInitialized, isTrue);
    });

    test(
      'requestPermission updates state and syncs token if granted',
      () async {
        final container = createContainer(user: testUser);
        addTearDown(container.dispose);

        fakeService.permissionGranted = true;
        fakeService.currentToken = 'fcm_token_1234567890';

        final controller = container.read(
          notificationsControllerProvider.notifier,
        );
        final granted = await controller.requestPermission();

        expect(granted, isTrue);
        expect(
          container.read(notificationsControllerProvider).isPermissionGranted,
          isTrue,
        );
        expect(fakeRepo.registeredToken, 'fcm_token_1234567890');
        // Token prefix should be 6 characters max
        expect(
          container.read(notificationsControllerProvider).registeredTokenPrefix,
          'fcm_to',
        );
      },
    );
  });

  group('NotificationsController Token Sync & Revocation', () {
    test('syncPushToken does nothing if user is unauthenticated', () async {
      final container = createContainer(user: null);
      addTearDown(container.dispose);

      final controller = container.read(
        notificationsControllerProvider.notifier,
      );
      await controller.syncPushToken();

      expect(fakeRepo.registeredToken, isNull);
      expect(
        container.read(notificationsControllerProvider).registeredTokenPrefix,
        isNull,
      );
    });

    test('syncPushToken registers token when user is authenticated', () async {
      final container = createContainer(user: testUser);
      addTearDown(container.dispose);

      fakeService.currentToken = 'my_super_token_987';

      final controller = container.read(
        notificationsControllerProvider.notifier,
      );
      await controller.syncPushToken();

      expect(fakeRepo.registeredToken, 'my_super_token_987');
      expect(
        container.read(notificationsControllerProvider).registeredTokenPrefix,
        'my_sup',
      );
      expect(
        container.read(notificationsControllerProvider).isRegistering,
        isFalse,
      );
    });

    test('onTokenRefresh stream triggers token synchronization', () async {
      final container = createContainer(user: testUser);
      addTearDown(container.dispose);

      final controller = container.read(
        notificationsControllerProvider.notifier,
      );
      await controller.initialize();

      fakeService.emitTokenRefresh('refreshed_token_55555');
      // Allow microtask to process
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(fakeRepo.registeredToken, 'refreshed_token_55555');
      expect(
        container.read(notificationsControllerProvider).registeredTokenPrefix,
        'refres',
      );
    });

    test('revokeAndCleanupToken calls backend and local deleteToken', () async {
      final container = createContainer(user: testUser);
      addTearDown(container.dispose);

      final controller = container.read(
        notificationsControllerProvider.notifier,
      );
      await controller.syncPushToken();
      expect(
        container.read(notificationsControllerProvider).registeredTokenPrefix,
        isNotNull,
      );

      await controller.revokeAndCleanupToken();

      expect(fakeRepo.isRevoked, isTrue);
      expect(fakeService.isTokenDeleted, isTrue);
      expect(
        container.read(notificationsControllerProvider).registeredTokenPrefix,
        isNull,
      );
    });
  });

  group('NotificationsController Foreground & Opened Messages', () {
    test(
      'foreground message invokes onForegroundPayload without navigating',
      () async {
        final container = createContainer(user: testUser);
        addTearDown(container.dispose);

        PushPayload? receivedForegroundPayload;
        final controller = container.read(
          notificationsControllerProvider.notifier,
        );

        await controller.initialize(
          onForegroundPayload: (payload) {
            receivedForegroundPayload = payload;
          },
        );

        const payload = PushPayload(
          schemaVersion: '1',
          eventType: PushEventType.loanCreated,
          loanId: 42,
          messageId: 'msg_fg_1',
          title: 'LocoMotion',
          body: 'Nouvelle demande reçue',
        );

        fakeService.emitForegroundMessage(payload);
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(receivedForegroundPayload, isNotNull);
        expect(receivedForegroundPayload!.loanId, 42);
        expect(receivedForegroundPayload!.eventType, PushEventType.loanCreated);
      },
    );

    test(
      'opened app notification invokes onOpenPayload when authenticated',
      () async {
        final container = createContainer(user: testUser);
        addTearDown(container.dispose);

        PushPayload? openedPayload;
        final controller = container.read(
          notificationsControllerProvider.notifier,
        );

        await controller.initialize(
          onOpenPayload: (payload) {
            openedPayload = payload;
          },
        );

        const payload = PushPayload(
          schemaVersion: '1',
          eventType: PushEventType.loanAccepted,
          loanId: 88,
          messageId: 'msg_open_1',
        );

        fakeService.emitMessageOpenedApp(payload);
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(openedPayload, isNotNull);
        expect(openedPayload!.loanId, 88);
        // Authenticated user should NOT have pendingRedirectPath populated
        expect(
          container.read(notificationsControllerProvider).pendingRedirectPath,
          isNull,
        );
      },
    );

    test('opened app notification deduplicates duplicate messageId', () async {
      final container = createContainer(user: testUser);
      addTearDown(container.dispose);

      int openCount = 0;
      final controller = container.read(
        notificationsControllerProvider.notifier,
      );

      await controller.initialize(
        onOpenPayload: (payload) {
          openCount++;
        },
      );

      const payload = PushPayload(
        schemaVersion: '1',
        eventType: PushEventType.loanAccepted,
        loanId: 88,
        messageId: 'msg_duplicate_test',
      );

      // First open
      fakeService.emitMessageOpenedApp(payload);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(openCount, 1);

      // Duplicate open with same messageId
      fakeService.emitMessageOpenedApp(payload);
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(openCount, 1); // Should not increase
    });

    test(
      'opened notification when unauthenticated saves pendingRedirectPath for post-login',
      () async {
        final container = createContainer(user: null);
        addTearDown(container.dispose);

        int openCount = 0;
        final controller = container.read(
          notificationsControllerProvider.notifier,
        );

        await controller.initialize(
          onOpenPayload: (_) {
            openCount++;
          },
        );

        const payload = PushPayload(
          schemaVersion: '1',
          eventType: PushEventType.loanCommentAdded,
          loanId: 99,
          messageId: 'msg_unauth_1',
        );

        fakeService.emitMessageOpenedApp(payload);
        await Future<void>.delayed(const Duration(milliseconds: 20));

        // onOpenPayload was not invoked directly
        expect(openCount, 0);
        // but pending redirect path was recorded
        expect(
          container.read(notificationsControllerProvider).pendingRedirectPath,
          '/loans/99',
        );

        // Now consumed
        controller.consumePendingRedirect();
        expect(
          container.read(notificationsControllerProvider).pendingRedirectPath,
          isNull,
        );
      },
    );

    test(
      'terminated cold start initial message is processed on initialize',
      () async {
        final container = createContainer(user: testUser);
        addTearDown(container.dispose);

        PushPayload? openedPayload;

        fakeService.setInitialMessage(
          const PushPayload(
            schemaVersion: '1',
            eventType: PushEventType.loanRejected,
            loanId: 77,
            messageId: 'cold_start_msg_1',
          ),
        );

        final controller = container.read(
          notificationsControllerProvider.notifier,
        );
        await controller.initialize(
          onOpenPayload: (payload) {
            openedPayload = payload;
          },
        );

        expect(openedPayload, isNotNull);
        expect(openedPayload!.loanId, 77);
        // Authenticated user should NOT have pendingRedirectPath populated
        expect(
          container.read(notificationsControllerProvider).pendingRedirectPath,
          isNull,
        );
      },
    );

    test(
      'revokeAndCleanupToken clears pendingRedirectPath and registered token',
      () async {
        final container = createContainer(user: null);
        addTearDown(container.dispose);

        final controller = container.read(
          notificationsControllerProvider.notifier,
        );
        await controller.initialize();

        const payload = PushPayload(
          schemaVersion: '1',
          eventType: PushEventType.loanCreated,
          loanId: 101,
          messageId: 'msg_revoke_test',
        );

        fakeService.emitMessageOpenedApp(payload);
        await Future<void>.delayed(const Duration(milliseconds: 20));
        expect(
          container.read(notificationsControllerProvider).pendingRedirectPath,
          '/loans/101',
        );

        await controller.revokeAndCleanupToken();
        expect(
          container.read(notificationsControllerProvider).pendingRedirectPath,
          isNull,
        );
      },
    );
  });
}

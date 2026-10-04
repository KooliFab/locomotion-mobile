import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/network_providers.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/storage/storage_providers.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../loans/presentation/controllers/loans_controller.dart';
import '../../data/datasources/push_tokens_remote_data_source.dart';
import '../../data/repositories/push_tokens_repository_impl.dart';
import '../../data/services/fake_push_notification_service.dart';
import '../../data/services/firebase_push_notification_service.dart';
import '../../domain/entities/push_payload.dart';
import '../../domain/repositories/push_tokens_repository.dart';
import '../../domain/services/push_notification_service.dart';

part 'notifications_controller.g.dart';

@Riverpod(keepAlive: true)
PushNotificationService pushNotificationService(Ref ref) {
  try {
    return FirebasePushNotificationService();
  } catch (e) {
    debugPrint(
      '[PushNotification] Firebase unavailable, fallback to FakePushNotificationService: $e',
    );
    return FakePushNotificationService();
  }
}

@Riverpod(keepAlive: true)
PushTokensRemoteDataSource pushTokensRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PushTokensRemoteDataSourceImpl(apiClient);
}

@Riverpod(keepAlive: true)
PushTokensRepository pushTokensRepository(Ref ref) {
  final remoteDataSource = ref.watch(pushTokensRemoteDataSourceProvider);
  final storageService = ref.watch(secureStorageServiceProvider);
  return PushTokensRepositoryImpl(remoteDataSource, storageService);
}

class NotificationsState {
  final bool isPermissionGranted;
  final bool isRegistering;
  final String? registeredTokenPrefix;
  final String? lastError;
  final String? pendingRedirectPath;

  const NotificationsState({
    this.isPermissionGranted = false,
    this.isRegistering = false,
    this.registeredTokenPrefix,
    this.lastError,
    this.pendingRedirectPath,
  });

  NotificationsState copyWith({
    bool? isPermissionGranted,
    bool? isRegistering,
    String? registeredTokenPrefix,
    bool clearRegisteredToken = false,
    String? lastError,
    String? pendingRedirectPath,
    bool clearPendingRedirect = false,
  }) {
    return NotificationsState(
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      isRegistering: isRegistering ?? this.isRegistering,
      registeredTokenPrefix: clearRegisteredToken
          ? null
          : (registeredTokenPrefix ?? this.registeredTokenPrefix),
      lastError: lastError,
      pendingRedirectPath: clearPendingRedirect
          ? null
          : (pendingRedirectPath ?? this.pendingRedirectPath),
    );
  }
}

@Riverpod(keepAlive: true)
class NotificationsController extends _$NotificationsController {
  final Set<String> _processedMessageIds = {};
  String? _queuedToken;
  StreamSubscription<PushPayload>? _foregroundSub;
  StreamSubscription<PushPayload>? _openedAppSub;
  StreamSubscription<String>? _tokenRefreshSub;

  @override
  NotificationsState build() {
    ref.onDispose(() {
      _foregroundSub?.cancel();
      _openedAppSub?.cancel();
      _tokenRefreshSub?.cancel();
    });

    return const NotificationsState();
  }

  /// Initialize listeners for FCM streams
  Future<void> initialize({
    Function(PushPayload payload)? onForegroundPayload,
    Function(PushPayload payload)? onOpenPayload,
  }) async {
    final service = ref.read(pushNotificationServiceProvider);
    await service.initialize();

    final isGranted = await service.isPermissionGranted();
    state = state.copyWith(isPermissionGranted: isGranted);

    // Cancel any existing stream subscriptions
    await _foregroundSub?.cancel();
    await _openedAppSub?.cancel();
    await _tokenRefreshSub?.cancel();

    // 1. Foreground message stream
    _foregroundSub = service.onForegroundMessage.listen((payload) {
      debugPrint(
        '[PushNotification] Foreground payload received: ${payload.toSafeLogString()}',
      );
      // Invalidate loan views central helper from Lot 4
      invalidateLoanViews(ref, loanId: payload.loanId);

      onForegroundPayload?.call(payload);
    });

    // 2. Message opened app (background)
    _openedAppSub = service.onMessageOpenedApp.listen((payload) {
      debugPrint(
        '[PushNotification] Opened from background: ${payload.toSafeLogString()}',
      );
      handleOpenedNotification(payload, onOpenPayload: onOpenPayload);
    });

    // 3. Token refresh stream
    _tokenRefreshSub = service.onTokenRefresh.listen((newToken) {
      debugPrint('[PushNotification] Token refresh stream emitted');
      syncPushToken(newToken: newToken);
    });

    // 4. Check initial message (terminated state cold start)
    final initialMessage = await service.getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
        '[PushNotification] Opened from terminated cold start: ${initialMessage.toSafeLogString()}',
      );
      handleOpenedNotification(initialMessage, onOpenPayload: onOpenPayload);
    }
  }

  /// Request push notifications permission
  Future<bool> requestPermission() async {
    final service = ref.read(pushNotificationServiceProvider);
    final granted = await service.requestPermission();
    state = state.copyWith(isPermissionGranted: granted);

    if (granted) {
      await syncPushToken();
    }
    return granted;
  }

  /// Contextual permission prompt after first successful login (§7.6)
  Future<void> requestPermissionContextual() async {
    final service = ref.read(pushNotificationServiceProvider);
    final isAlreadyGranted = await service.isPermissionGranted();
    if (!isAlreadyGranted) {
      final granted = await service.requestPermission();
      state = state.copyWith(isPermissionGranted: granted);
      if (granted) {
        await syncPushToken();
      }
    } else {
      state = state.copyWith(isPermissionGranted: true);
      await syncPushToken();
    }
  }

  /// Check and refresh permission status (e.g. when app resumes from settings)
  Future<bool> refreshPermissionStatus() async {
    final service = ref.read(pushNotificationServiceProvider);
    final granted = await service.isPermissionGranted();
    state = state.copyWith(isPermissionGranted: granted);
    if (granted && state.registeredTokenPrefix == null) {
      await syncPushToken();
    }
    return granted;
  }

  /// Register push token to backend for the currently authenticated user
  /// Strictly non-reentrant with queue fallback and anonymized logging.
  Future<void> syncPushToken({String? newToken}) async {
    // Only register if user is authenticated
    final authState = ref.read(authControllerProvider);
    final user = authState.value;
    if (user == null) {
      debugPrint(
        '[PushNotification] User not authenticated, skipping token registration',
      );
      return;
    }

    if (state.isRegistering) {
      debugPrint(
        '[PushNotification] Registration already in flight, queueing token',
      );
      _queuedToken = newToken ?? _queuedToken;
      return;
    }

    state = state.copyWith(isRegistering: true);

    try {
      if (kIsWeb) {
        debugPrint(
          '[PushNotification] Web platform does not support mobile push tokens',
        );
        state = state.copyWith(isRegistering: false);
        return;
      }

      final service = ref.read(pushNotificationServiceProvider);
      final token = newToken ?? await service.getToken();

      if (token == null || token.isEmpty) {
        debugPrint('[PushNotification] No push token available from service');
        state = state.copyWith(isRegistering: false);
        return;
      }

      // Safe anonymized log (max 6 characters)
      final prefix = token.substring(0, min(6, token.length));
      debugPrint('[PushNotification] Registering token prefix: $prefix...');

      final repository = ref.read(pushTokensRepositoryProvider);
      final platform = Platform.isIOS ? 'ios' : 'android';

      await repository.registerToken(
        token: token,
        platform: platform,
        appVersion: '1.0.0+1',
      );

      debugPrint(
        '[PushNotification] Token successfully registered for user ID ${user.id}',
      );
      state = state.copyWith(
        isRegistering: false,
        registeredTokenPrefix: prefix,
        lastError: null,
      );
    } catch (e) {
      debugPrint('[PushNotification] Token registration failed: $e');
      state = state.copyWith(isRegistering: false, lastError: e.toString());
    } finally {
      if (_queuedToken != null) {
        final next = _queuedToken;
        _queuedToken = null;
        unawaited(syncPushToken(newToken: next));
      }
    }
  }

  /// Revoke token on backend and delete token locally upon logout
  Future<void> revokeAndCleanupToken() async {
    debugPrint(
      '[PushNotification] Initiating push token revocation before logout',
    );

    // 1. Revoke on backend with short timeout to prevent hanging offline
    try {
      final repository = ref.read(pushTokensRepositoryProvider);
      await repository.revokeCurrentInstallationToken().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          debugPrint(
            '[PushNotification] Backend revocation timed out (offline logout)',
          );
        },
      );
    } catch (e) {
      debugPrint('[PushNotification] Backend revocation ignored: $e');
    }

    // 2. Delete token locally with Firebase (token becomes UNREGISTERED on FCM servers)
    try {
      final service = ref.read(pushNotificationServiceProvider);
      await service.deleteToken();
    } catch (e) {
      debugPrint('[PushNotification] Local deleteToken error: $e');
    }

    state = state.copyWith(
      clearRegisteredToken: true,
      clearPendingRedirect: true,
    );
  }

  /// Handle opening of a notification with deduplication (60s cache TTL)
  void handleOpenedNotification(
    PushPayload payload, {
    Function(PushPayload payload)? onOpenPayload,
  }) {
    // Deduplication by messageId (must only open once per message within 60s)
    if (payload.messageId != null && payload.messageId!.isNotEmpty) {
      final messageId = payload.messageId!;
      if (_processedMessageIds.contains(messageId)) {
        debugPrint(
          '[PushNotification] Message $messageId already processed, skipping duplicate navigation',
        );
        return;
      }
      _processedMessageIds.add(messageId);
      Timer(const Duration(seconds: 60), () {
        _processedMessageIds.remove(messageId);
      });
    }

    // Target route
    final String targetPath;
    if (payload.eventType == PushEventType.incidentCreated &&
        payload.incidentId != null) {
      targetPath = AppRoutes.incidentDetailPath(payload.incidentId!);
    } else {
      targetPath = '/loans/${payload.loanId}';
    }

    final authState = ref.read(authControllerProvider);
    final isLoggedIn = authState.value != null;

    if (!isLoggedIn) {
      debugPrint(
        '[PushNotification] User not logged in, saving pending redirect to $targetPath',
      );
      state = state.copyWith(pendingRedirectPath: targetPath);
    } else {
      // User is already logged in: do NOT save pending redirect path to prevent stale redirects on subsequent sessions
      onOpenPayload?.call(payload);
    }
  }

  void consumePendingRedirect() {
    state = state.copyWith(clearPendingRedirect: true);
  }
}

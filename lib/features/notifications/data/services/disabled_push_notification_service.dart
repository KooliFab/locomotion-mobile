import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/entities/push_payload.dart';
import '../../domain/services/push_notification_service.dart';

/// Real execution fallback when Firebase is not configured or unavailable.
/// Explicitly disables push notifications without generating fake tokens or permissions.
class DisabledPushNotificationService implements PushNotificationService {
  final String reason;

  DisabledPushNotificationService({
    this.reason = 'Firebase non initialisé ou non configuré.',
  });

  @override
  Future<void> initialize() async {
    debugPrint(
      '[PushNotificationService] Push notifications désactivées ($reason)',
    );
  }

  @override
  Future<bool> requestPermission() async {
    debugPrint(
      '[PushNotificationService] Demande de permission refusée ($reason)',
    );
    return false;
  }

  @override
  Future<bool> isPermissionGranted() async => false;

  @override
  Future<String?> getToken() async => null;

  @override
  Stream<String> get onTokenRefresh => const Stream.empty();

  @override
  Stream<PushPayload> get onForegroundMessage => const Stream.empty();

  @override
  Stream<PushPayload> get onMessageOpenedApp => const Stream.empty();

  @override
  Future<PushPayload?> getInitialMessage() async => null;

  @override
  Future<void> deleteToken() async {}
}

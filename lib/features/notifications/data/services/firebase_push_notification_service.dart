import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/push_payload.dart';
import '../../domain/services/push_notification_service.dart';

class FirebasePushNotificationService implements PushNotificationService {
  final FirebaseMessaging _messaging;

  FirebasePushNotificationService({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseMessaging.instance;

  @override
  Future<void> initialize() async {
    // Disable native system alert banner on iOS when in foreground
    // so it doesn't duplicate the in-app SnackBar notification
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: false,
    );
  }

  @override
  Future<bool> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<bool> isPermissionGranted() async {
    final settings = await _messaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e, stack) {
      debugPrint('[PushNotificationService] Failed to obtain FCM token: $e\n$stack');
      return null;
    }
  }

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  @override
  Stream<PushPayload> get onForegroundMessage {
    return FirebaseMessaging.onMessage
        .map(_mapRemoteMessage)
        .where((payload) => payload != null)
        .cast<PushPayload>();
  }

  @override
  Stream<PushPayload> get onMessageOpenedApp {
    return FirebaseMessaging.onMessageOpenedApp
        .map(_mapRemoteMessage)
        .where((payload) => payload != null)
        .cast<PushPayload>();
  }

  @override
  Future<PushPayload?> getInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message == null) return null;
    return _mapRemoteMessage(message);
  }

  @override
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
    } catch (_) {
      // Ignore errors if token already deleted or network offline
    }
  }

  PushPayload? _mapRemoteMessage(RemoteMessage message) {
    return PushPayload.tryParse(
      data: message.data,
      messageId: message.messageId,
      title: message.notification?.title,
      body: message.notification?.body,
    );
  }
}

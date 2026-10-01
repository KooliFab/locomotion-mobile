import '../entities/push_payload.dart';

abstract class PushNotificationService {
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<bool> isPermissionGranted();
  Future<String?> getToken();
  Stream<String> get onTokenRefresh;
  Stream<PushPayload> get onForegroundMessage;
  Stream<PushPayload> get onMessageOpenedApp;
  Future<PushPayload?> getInitialMessage();
  Future<void> deleteToken();
}

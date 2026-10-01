import 'dart:async';
import '../../domain/entities/push_payload.dart';
import '../../domain/services/push_notification_service.dart';

class FakePushNotificationService implements PushNotificationService {
  String? currentToken = 'fake_fcm_token_123456';
  bool permissionGranted = true;
  PushPayload? initialMessage;

  final _tokenRefreshController = StreamController<String>.broadcast();
  final _foregroundMessageController = StreamController<PushPayload>.broadcast();
  final _messageOpenedAppController = StreamController<PushPayload>.broadcast();

  bool isInitialized = false;
  bool isTokenDeleted = false;

  @override
  Future<void> initialize() async {
    isInitialized = true;
  }

  @override
  Future<bool> requestPermission() async {
    return permissionGranted;
  }

  @override
  Future<bool> isPermissionGranted() async {
    return permissionGranted;
  }

  @override
  Future<String?> getToken() async {
    return currentToken;
  }

  @override
  Stream<String> get onTokenRefresh => _tokenRefreshController.stream;

  @override
  Stream<PushPayload> get onForegroundMessage => _foregroundMessageController.stream;

  @override
  Stream<PushPayload> get onMessageOpenedApp => _messageOpenedAppController.stream;

  @override
  Future<PushPayload?> getInitialMessage() async {
    final msg = initialMessage;
    initialMessage = null;
    return msg;
  }

  @override
  Future<void> deleteToken() async {
    isTokenDeleted = true;
    currentToken = null;
  }

  // --- Test Simulation Methods ---

  void emitTokenRefresh(String newToken) {
    currentToken = newToken;
    _tokenRefreshController.add(newToken);
  }

  void emitForegroundMessage(PushPayload payload) {
    _foregroundMessageController.add(payload);
  }

  void emitMessageOpenedApp(PushPayload payload) {
    _messageOpenedAppController.add(payload);
  }

  void setInitialMessage(PushPayload? payload) {
    initialMessage = payload;
  }

  void dispose() {
    _tokenRefreshController.close();
    _foregroundMessageController.close();
    _messageOpenedAppController.close();
  }
}

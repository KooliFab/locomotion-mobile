import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/notifications/domain/entities/push_payload.dart';
import 'package:mobile/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:mobile/features/notifications/presentation/widgets/foreground_notification_banner.dart';
import 'package:mobile/features/profile/presentation/controllers/profile_controller.dart';
import 'package:mobile/features/profile/presentation/screens/profile_screen.dart';

class _FakeAuthController extends AuthController {
  final User? user;
  _FakeAuthController(this.user);

  @override
  FutureOr<User?> build() => user;
}

class _FakeUserBalanceController extends UserBalanceController {
  final double balance;
  _FakeUserBalanceController(this.balance);

  @override
  FutureOr<double> build() => balance;
}

class _TestNotificationsController extends NotificationsController {
  final NotificationsState initialState;
  bool requestPermissionCalled = false;

  _TestNotificationsController(this.initialState);

  @override
  NotificationsState build() => initialState;

  @override
  Future<bool> requestPermission() async {
    requestPermissionCalled = true;
    return true;
  }
}

void main() {
  const testUser = User(
    id: 10,
    email: 'user@example.com',
    firstName: 'Alice',
    lastName: 'Leduc',
  );

  group('ForegroundNotificationBanner Widget Test', () {
    testWidgets('displays SnackBar with title, body, and Voir action', (
      tester,
    ) async {
      String? navigatedPath;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    ForegroundNotificationBanner.show(
                      context,
                      payload: const PushPayload(
                        schemaVersion: '1',
                        eventType: PushEventType.loanCreated,
                        loanId: 42,
                        title: 'LocoMotion',
                        body: 'Nouvelle demande reçue',
                      ),
                    );
                  },
                  child: const Text('Show Banner'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/loans/:id',
            builder: (context, state) {
              navigatedPath = state.uri.toString();
              return Scaffold(
                body: Text('Loan Details ${state.pathParameters['id']}'),
              );
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      // Tap button to show banner
      await tester.tap(find.text('Show Banner'));
      await tester.pumpAndSettle();

      expect(find.text('LocoMotion'), findsOneWidget);
      expect(find.text('Nouvelle demande reçue'), findsOneWidget);
      expect(find.text('Voir'), findsOneWidget);

      // Tap "Voir" button
      await tester.tap(find.text('Voir'));
      await tester.pumpAndSettle();

      expect(navigatedPath, '/loans/42');
      expect(find.text('Loan Details 42'), findsOneWidget);
    });
  });

  group('ProfileScreen Notifications Status', () {
    testWidgets(
      'displays "Activées" when notifications permission is granted',
      (tester) async {
        final notifController = _TestNotificationsController(
          const NotificationsState(isPermissionGranted: true),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authControllerProvider.overrideWith(
                () => _FakeAuthController(testUser),
              ),
              userBalanceControllerProvider.overrideWith(
                () => _FakeUserBalanceController(15.0),
              ),
              notificationsControllerProvider.overrideWith(
                () => notifController,
              ),
            ],
            child: const MaterialApp(home: ProfileScreen()),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Notifications push'), findsOneWidget);
        expect(find.text('Activées'), findsOneWidget);
      },
    );

    testWidgets(
      'displays "Notifications désactivées" and requests permission when tapped',
      (tester) async {
        final notifController = _TestNotificationsController(
          const NotificationsState(isPermissionGranted: false),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authControllerProvider.overrideWith(
                () => _FakeAuthController(testUser),
              ),
              userBalanceControllerProvider.overrideWith(
                () => _FakeUserBalanceController(0.0),
              ),
              notificationsControllerProvider.overrideWith(
                () => notifController,
              ),
            ],
            child: const MaterialApp(home: ProfileScreen()),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Notifications push'), findsOneWidget);
        expect(find.text('Notifications désactivées'), findsOneWidget);

        // Tap on the Notifications tile
        await tester.tap(find.text('Notifications push'));
        await tester.pumpAndSettle();

        expect(notifController.requestPermissionCalled, isTrue);
      },
    );
  });
}

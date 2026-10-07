import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/network_providers.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:mobile/features/profile/presentation/controllers/profile_controller.dart';
import 'package:mobile/features/profile/presentation/screens/profile_screen.dart';

class _FakeAuthController extends AuthController {
  final User? _user;
  _FakeAuthController(this._user);

  @override
  User? build() => _user;
}

class _FakeAuthRepository implements AuthRepository {
  bool authenticated;
  _FakeAuthRepository({this.authenticated = true});

  @override
  Future<bool> isAuthenticated() async => authenticated;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestNotificationsController extends NotificationsController {
  @override
  NotificationsState build() =>
      const NotificationsState(isPermissionGranted: true);
}

class _FakeApiClient extends ApiClient {
  dynamic responseData;
  Exception? errorToThrow;
  int callCount = 0;

  _FakeApiClient({this.responseData = 0.0, this.errorToThrow})
    : super.withDio(Dio());

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    callCount++;
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data: responseData as T?,
      statusCode: 200,
    );
  }
}

void main() {
  const testUser = User(
    id: 1,
    email: 'test@locomotion.app',
    firstName: 'Jean',
    lastName: 'Tremblay',
  );

  group('R15 - UserBalanceController.parseBalance Unit Tests', () {
    test('parses numeric scalar (int, double, zero)', () {
      expect(UserBalanceController.parseBalance(42.5), equals(42.5));
      expect(UserBalanceController.parseBalance(100), equals(100.0));
      expect(UserBalanceController.parseBalance(0), equals(0.0));
      expect(UserBalanceController.parseBalance(-12.5), equals(-12.5));
    });

    test('parses numeric string (decimal, integer, whitespace)', () {
      expect(UserBalanceController.parseBalance('42.50'), equals(42.5));
      expect(UserBalanceController.parseBalance('0'), equals(0.0));
      expect(UserBalanceController.parseBalance('  15.75  '), equals(15.75));
    });

    test('parses legacy wrapped map payload', () {
      expect(
        UserBalanceController.parseBalance({'balance': 24.5}),
        equals(24.5),
      );
      expect(
        UserBalanceController.parseBalance({'balance': '24.5'}),
        equals(24.5),
      );
      expect(
        UserBalanceController.parseBalance({'user_balance': 50}),
        equals(50.0),
      );
      expect(
        UserBalanceController.parseBalance({'amount': 12.0}),
        equals(12.0),
      );
    });

    test('throws FormatException on unparseable payloads', () {
      expect(
        () => UserBalanceController.parseBalance(null),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => UserBalanceController.parseBalance('invalid_string'),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => UserBalanceController.parseBalance({'status': 'unknown'}),
        throwsA(isA<FormatException>()),
      );
      expect(
        () => UserBalanceController.parseBalance([1, 2, 3]),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('R15 - UserBalanceController Integration Tests', () {
    test(
      'returns 0.0 when user is not authenticated without making API calls',
      () async {
        final fakeApi = _FakeApiClient(responseData: 100.0);
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              _FakeAuthRepository(authenticated: false),
            ),
            authControllerProvider.overrideWith(
              () => _FakeAuthController(null),
            ),
            apiClientProvider.overrideWithValue(fakeApi),
          ],
        );
        addTearDown(container.dispose);

        final balance = await container.read(
          userBalanceControllerProvider.future,
        );
        expect(balance, equals(0.0));
        expect(fakeApi.callCount, equals(0));
      },
    );

    test('fetches and parses scalar numeric balance from server', () async {
      final fakeApi = _FakeApiClient(responseData: 55.75);
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository(authenticated: true),
          ),
          authControllerProvider.overrideWith(
            () => _FakeAuthController(testUser),
          ),
          apiClientProvider.overrideWithValue(fakeApi),
        ],
      );
      addTearDown(container.dispose);

      final balance = await container.read(
        userBalanceControllerProvider.future,
      );
      expect(balance, equals(55.75));
      expect(fakeApi.callCount, equals(1));
    });

    test('fetches and parses numeric string balance from server', () async {
      final fakeApi = _FakeApiClient(responseData: '89.20');
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            _FakeAuthRepository(authenticated: true),
          ),
          authControllerProvider.overrideWith(
            () => _FakeAuthController(testUser),
          ),
          apiClientProvider.overrideWithValue(fakeApi),
        ],
      );
      addTearDown(container.dispose);

      final balance = await container.read(
        userBalanceControllerProvider.future,
      );
      expect(balance, equals(89.20));
      expect(fakeApi.callCount, equals(1));
    });

    test(
      'propagates network failure as AsyncError instead of inventing 0.0',
      () async {
        final fakeApi = _FakeApiClient(
          errorToThrow: const NetworkException(
            message: 'Impossible de joindre le serveur LocoMotion.',
            statusCode: 503,
          ),
        );
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              _FakeAuthRepository(authenticated: true),
            ),
            authControllerProvider.overrideWith(
              () => _FakeAuthController(testUser),
            ),
            apiClientProvider.overrideWithValue(fakeApi),
          ],
        );
        addTearDown(container.dispose);

        container.listen(userBalanceControllerProvider, (_, _) {});
        await Future<void>.delayed(const Duration(milliseconds: 20));

        final state = container.read(userBalanceControllerProvider);
        expect(state.hasError, isTrue);
        expect(state.error, isA<NetworkException>());
        expect(state.value, isNull);
      },
    );
  });

  group('R15 - ProfileScreen Balance Display Widget Tests', () {
    testWidgets('displays actual scalar balance formatted in currency', (
      tester,
    ) async {
      final fakeApi = _FakeApiClient(responseData: 42.50);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              _FakeAuthRepository(authenticated: true),
            ),
            authControllerProvider.overrideWith(
              () => _FakeAuthController(testUser),
            ),
            apiClientProvider.overrideWithValue(fakeApi),
            notificationsControllerProvider.overrideWith(
              () => _TestNotificationsController(),
            ),
          ],
          child: const MaterialApp(home: ProfileScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_balance_text')), findsOneWidget);
      expect(find.text('42.50 \$'), findsOneWidget);
      expect(find.byKey(const Key('profile_balance_error')), findsNothing);
    });

    testWidgets('displays numeric string balance correctly', (tester) async {
      final fakeApi = _FakeApiClient(responseData: '105.00');
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(
              _FakeAuthRepository(authenticated: true),
            ),
            authControllerProvider.overrideWith(
              () => _FakeAuthController(testUser),
            ),
            apiClientProvider.overrideWithValue(fakeApi),
            notificationsControllerProvider.overrideWith(
              () => _TestNotificationsController(),
            ),
          ],
          child: const MaterialApp(home: ProfileScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('profile_balance_text')), findsOneWidget);
      expect(find.text('105.00 \$'), findsOneWidget);
    });

    testWidgets(
      'displays error and retry button on network failure without displaying 0.00 \$',
      (tester) async {
        final fakeApi = _FakeApiClient(
          errorToThrow: const NetworkException(
            message: 'Délai d\'attente dépassé.',
            statusCode: 408,
          ),
        );
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authRepositoryProvider.overrideWithValue(
                _FakeAuthRepository(authenticated: true),
              ),
              authControllerProvider.overrideWith(
                () => _FakeAuthController(testUser),
              ),
              apiClientProvider.overrideWithValue(fakeApi),
              notificationsControllerProvider.overrideWith(
                () => _TestNotificationsController(),
              ),
            ],
            child: const MaterialApp(home: ProfileScreen()),
          ),
        );

        await tester.pumpAndSettle();

        // Error UI must be shown
        expect(find.byKey(const Key('profile_balance_error')), findsOneWidget);
        expect(find.text('Erreur'), findsOneWidget);
        expect(find.byKey(const Key('retry_balance_button')), findsOneWidget);

        // Must NOT invent 0.00 $
        expect(find.text('0.00 \$'), findsNothing);

        // Now recover network: next call succeeds with 65.0
        fakeApi.errorToThrow = null;
        fakeApi.responseData = 65.0;

        await tester.tap(find.byKey(const Key('retry_balance_button')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('profile_balance_error')), findsNothing);
        expect(find.byKey(const Key('profile_balance_text')), findsOneWidget);
        expect(find.text('65.00 \$'), findsOneWidget);
      },
    );
  });
}

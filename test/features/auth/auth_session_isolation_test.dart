import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/network_providers.dart';
import 'package:mobile/core/session/session_manager.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/auth/domain/entities/auth_tokens.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/fleet/domain/entities/fleet_vehicle.dart';
import 'package:mobile/features/fleet/domain/repositories/fleet_repository.dart';
import 'package:mobile/features/fleet/presentation/controllers/fleet_controller.dart';
import 'package:mobile/features/loans/domain/entities/extension_estimate.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_comment.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_dates_update_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_pagination.dart';
import 'package:mobile/features/loans/domain/entities/loans_dashboard.dart';
import 'package:mobile/features/loans/domain/repositories/loans_repository.dart';
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';
import 'package:mobile/features/notifications/domain/entities/push_payload.dart';
import 'package:mobile/features/notifications/domain/entities/push_token.dart';
import 'package:mobile/features/notifications/domain/repositories/push_tokens_repository.dart';
import 'package:mobile/features/notifications/domain/services/push_notification_service.dart';
import 'package:mobile/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:mobile/features/profile/presentation/controllers/profile_controller.dart';

import '../../helpers/mock_api_client.dart';

class _FakeAuthRepository implements AuthRepository {
  User? currentUser;

  _FakeAuthRepository([this.currentUser]);

  @override
  Future<bool> isAuthenticated() async => currentUser != null;

  @override
  Future<User> getCurrentUser() async {
    if (currentUser == null) throw Exception('Non authentifié');
    return currentUser!;
  }

  @override
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    if (email.contains('user_a')) {
      currentUser = const User(
        id: 101,
        email: 'user_a@example.com',
        firstName: 'Alice',
        lastName: 'A',
      );
    } else if (email.contains('user_b')) {
      currentUser = const User(
        id: 202,
        email: 'user_b@example.com',
        firstName: 'Bob',
        lastName: 'B',
      );
    } else {
      currentUser = User(
        id: 999,
        email: email,
        firstName: 'Test',
        lastName: 'User',
      );
    }
    return const AuthTokens(
      accessToken: 'fake_access',
      refreshToken: 'fake_refresh',
    );
  }

  @override
  Future<void> logout() async {
    currentUser = null;
  }

  @override
  Future<AuthTokens> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    currentUser = User(
      id: 303,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
    return const AuthTokens(
      accessToken: 'fake_access',
      refreshToken: 'fake_refresh',
    );
  }
}

class _FakeLoansRepository implements LoansRepository {
  final _FakeAuthRepository authRepo;

  _FakeLoansRepository(this.authRepo);

  @override
  Future<LoansDashboard> getDashboard() async {
    final user = authRepo.currentUser;
    if (user?.id == 101) {
      return LoansDashboard(
        started: LoansDashboardCategory(
          total: 1,
          loans: [
            Loan(
              id: 1001,
              departureAt: DateTime.parse('2026-10-05T10:00:00'),
              durationInMinutes: 120,
              status: 'started',
              borrowerUserName: 'Alice A',
            ),
          ],
        ),
      );
    } else if (user?.id == 202) {
      return LoansDashboard(
        started: LoansDashboardCategory(
          total: 1,
          loans: [
            Loan(
              id: 2002,
              departureAt: DateTime.parse('2026-10-06T14:00:00'),
              durationInMinutes: 60,
              status: 'started',
              borrowerUserName: 'Bob B',
            ),
          ],
        ),
      );
    }
    return const LoansDashboard();
  }

  @override
  Future<List<Loan>> getMyLoans() async {
    final user = authRepo.currentUser;
    if (user?.id == 101) {
      return [
        Loan(
          id: 1001,
          departureAt: DateTime.parse('2026-10-05T10:00:00'),
          durationInMinutes: 120,
          status: 'started',
          borrowerUserName: 'Alice A',
        ),
      ];
    } else if (user?.id == 202) {
      return [
        Loan(
          id: 2002,
          departureAt: DateTime.parse('2026-10-06T14:00:00'),
          durationInMinutes: 60,
          status: 'started',
          borrowerUserName: 'Bob B',
        ),
      ];
    }
    return const [];
  }

  @override
  Future<LoanPagination> getLoansPage({
    int page = 1,
    int perPage = 10,
    String? status,
    int? borrowerUserId,
  }) async {
    return const LoanPagination();
  }

  @override
  Future<Loan> getLoanDetail(int id) async => throw UnimplementedError();

  @override
  Future<Loan> createLoan(LoanCreationRequest request) async =>
      throw UnimplementedError();

  @override
  Future<Loan> cancelLoan(int id) async => throw UnimplementedError();

  @override
  Future<Loan> acceptLoan(int id, {String? comment}) async =>
      throw UnimplementedError();

  @override
  Future<Loan> rejectLoan(int id, {String? comment}) async =>
      throw UnimplementedError();

  @override
  Future<Loan> updateLoanDates(int id, LoanDatesUpdateRequest request) async =>
      throw UnimplementedError();

  @override
  Future<LoanComment> addComment(int id, String text) async =>
      throw UnimplementedError();

  @override
  Future<Loan> validateLoan(int id) async => throw UnimplementedError();

  @override
  Future<Loan> requestExtension(int id, int extensionDurationInMinutes) =>
      throw UnimplementedError();

  @override
  Future<Loan> acceptExtension(int id) => throw UnimplementedError();

  @override
  Future<Loan> rejectExtension(int id) => throw UnimplementedError();

  @override
  Future<Loan> cancelExtension(int id) => throw UnimplementedError();

  @override
  Future<ExtensionEstimate> getExtensionEstimate(
    int id,
    int durationInMinutes,
  ) =>
      throw UnimplementedError();
}

class _FakeFleetRepository implements FleetRepository {
  final _FakeAuthRepository authRepo;

  _FakeFleetRepository(this.authRepo);

  @override
  Future<List<FleetVehicle>> getOwnerFleet() async {
    final user = authRepo.currentUser;
    if (user?.id == 101) {
      return [
        const FleetVehicle(
          id: 501,
          name: 'Vélo Alice',
          type: 'bike',
          availabilityStatus: 'available',
        ),
      ];
    } else if (user?.id == 202) {
      return [
        const FleetVehicle(
          id: 602,
          name: 'Auto Bob',
          type: 'car',
          availabilityStatus: 'available',
        ),
      ];
    }
    return const [];
  }

  @override
  Future<FleetVehicle> createVehicle(
    Map<String, dynamic> data, {
    String? idempotencyKey,
  }) async =>
      throw UnimplementedError();

  @override
  Future<FleetVehicle> updateVehicle(
    int id,
    Map<String, dynamic> data, {
    String? lockVersion,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> publishVehicle(int id) async => throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> suspendVehicle(
    int id, {
    String? reason,
    bool preserveFuture = true,
  }) async =>
      throw UnimplementedError();

  @override
  Future<FleetVehicle> unsuspendVehicle(int id) async =>
      throw UnimplementedError();
}

class _FakePushService implements PushNotificationService {
  @override
  Future<void> initialize() async {}
  @override
  Future<String?> getToken() async => 'fake_token';
  @override
  Future<void> deleteToken() async {}
  @override
  Future<bool> isPermissionGranted() async => true;
  @override
  Future<bool> requestPermission() async => true;
  @override
  Stream<String> get onTokenRefresh => const Stream.empty();
  @override
  Stream<PushPayload> get onForegroundMessage => const Stream.empty();
  @override
  Stream<PushPayload> get onMessageOpenedApp => const Stream.empty();
  @override
  Future<PushPayload?> getInitialMessage() async => null;
}

class _FakePushTokensRepo implements PushTokensRepository {
  @override
  Future<String> getOrCreateInstallationId() async => 'test-install-id';

  @override
  Future<PushToken> registerToken({
    required String token,
    required String platform,
    String? appVersion,
  }) async {
    return PushToken(
      id: 1,
      token: token,
      platform: platform,
      installationId: 'test-install-id',
      appVersion: appVersion,
    );
  }

  @override
  Future<void> revokeCurrentInstallationToken() async {}

  @override
  Future<void> saveTokenLocally(String token) async {}

  @override
  Future<String?> getSavedToken() async => 'fake_token';

  @override
  Future<void> deleteSavedToken() async {}
}

void main() {
  late _FakeAuthRepository fakeAuthRepo;
  late _FakeLoansRepository fakeLoansRepo;
  late _FakeFleetRepository fakeFleetRepo;
  late ProviderContainer container;

  setUp(() {
    fakeAuthRepo = _FakeAuthRepository();
    fakeLoansRepo = _FakeLoansRepository(fakeAuthRepo);
    fakeFleetRepo = _FakeFleetRepository(fakeAuthRepo);

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(fakeAuthRepo),
        loansRepositoryProvider.overrideWithValue(fakeLoansRepo),
        fleetRepositoryProvider.overrideWithValue(fakeFleetRepo),
        secureStorageServiceProvider.overrideWithValue(
          FakeSecureStorageService(),
        ),
        pushNotificationServiceProvider.overrideWithValue(_FakePushService()),
        pushTokensRepositoryProvider.overrideWithValue(_FakePushTokensRepo()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('R01 - Cross-User Session Isolation (A -> Déconnexion -> B)', () {
    test(
      'User A data does not persist after logout; User B sees ONLY User B data in same container',
      () async {
        // 1. User A logs in
        final authController = container.read(authControllerProvider.notifier);
        await authController.login(
          email: 'user_a@example.com',
          password: 'passwordA',
        );

        final authUserA = container.read(authControllerProvider).value;
        expect(authUserA, isNotNull);
        expect(authUserA!.id, equals(101));
        expect(authUserA.firstName, equals('Alice'));

        // 2. User A loads loans dashboard, my loans, fleet
        final dashboardA = await container.read(
          loansDashboardControllerProvider.future,
        );
        expect(dashboardA.started.total, equals(1));
        expect(dashboardA.started.loans.first.id, equals(1001));
        expect(
          dashboardA.started.loans.first.borrowerUserName,
          equals('Alice A'),
        );

        final myLoansA = await container.read(myLoansControllerProvider.future);
        expect(myLoansA.length, equals(1));
        expect(myLoansA.first.id, equals(1001));

        final fleetA = await container.read(
          ownerFleetControllerProvider.future,
        );
        expect(fleetA.length, equals(1));
        expect(fleetA.first.name, equals('Vélo Alice'));

        // 3. User A logs out
        await authController.logout();
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // 4. Verify in the SAME container: User A private data is completely cleared
        final authLoggedOut = container.read(authControllerProvider).value;
        expect(authLoggedOut, isNull);

        final dashboardAfterLogout = await container.read(
          loansDashboardControllerProvider.future,
        );
        expect(dashboardAfterLogout.started.total, equals(0));
        expect(dashboardAfterLogout.started.loans, isEmpty);

        final fleetAfterLogout = await container.read(
          ownerFleetControllerProvider.future,
        );
        expect(fleetAfterLogout, isEmpty);

        final myLoansAfterLogout = await container.read(
          myLoansControllerProvider.future,
        );
        expect(myLoansAfterLogout, isEmpty);

        final balanceAfterLogout = await container.read(
          userBalanceControllerProvider.future,
        );
        expect(balanceAfterLogout, equals(0.0));

        // 5. User B logs in within the SAME container
        await authController.login(
          email: 'user_b@example.com',
          password: 'passwordB',
        );
        await Future<void>.delayed(const Duration(milliseconds: 50));

        final authUserB = container.read(authControllerProvider).value;
        expect(authUserB, isNotNull);
        expect(authUserB!.id, equals(202));
        expect(authUserB.firstName, equals('Bob'));

        // 6. User B loads dashboard and fleet in the SAME container
        final dashboardB = await container.read(
          loansDashboardControllerProvider.future,
        );
        // Verify User B sees Bob's loan (2002) and ZERO trace of Alice's loan (1001)
        expect(dashboardB.started.total, equals(1));
        expect(dashboardB.started.loans.first.id, equals(2002));
        expect(
          dashboardB.started.loans.first.borrowerUserName,
          equals('Bob B'),
        );
        expect(
          dashboardB.started.loans.any((l) => l.id == 1001),
          isFalse,
          reason: "User A's loan 1001 must not leak to User B",
        );

        final myLoansB = await container.read(myLoansControllerProvider.future);
        expect(myLoansB.length, equals(1));
        expect(myLoansB.first.id, equals(2002));
        expect(
          myLoansB.any((l) => l.id == 1001),
          isFalse,
          reason: "User A's loan 1001 must not leak into User B's loans",
        );

        final fleetB = await container.read(
          ownerFleetControllerProvider.future,
        );
        expect(fleetB.length, equals(1));
        expect(fleetB.first.name, equals('Auto Bob'));
        expect(
          fleetB.any((v) => v.id == 501),
          isFalse,
          reason: "User A's vehicle 501 must not leak to User B's fleet",
        );
      },
    );

    test(
      'Direct account switch A -> B in same container invalidates and isolates private data',
      () async {
        final authController = container.read(authControllerProvider.notifier);

        // Login as Alice
        await authController.login(
          email: 'user_a@example.com',
          password: 'passwordA',
        );
        final fleetA = await container.read(
          ownerFleetControllerProvider.future,
        );
        expect(fleetA.first.name, equals('Vélo Alice'));

        // Direct switch to Bob without explicit logout step
        await authController.login(
          email: 'user_b@example.com',
          password: 'passwordB',
        );
        await Future<void>.delayed(const Duration(milliseconds: 50));

        final fleetB = await container.read(
          ownerFleetControllerProvider.future,
        );
        expect(fleetB.first.name, equals('Auto Bob'));
        expect(fleetB.any((v) => v.name == 'Vélo Alice'), isFalse);
      },
    );

    test(
      'resetUserSessionState explicitly resets all user-scoped controllers',
      () async {
        final authController = container.read(authControllerProvider.notifier);
        await authController.login(
          email: 'user_a@example.com',
          password: 'passwordA',
        );

        await container.read(loansDashboardControllerProvider.future);
        await container.read(ownerFleetControllerProvider.future);

        expect(
          container.read(loansDashboardControllerProvider).hasValue,
          isTrue,
        );
        expect(container.read(ownerFleetControllerProvider).hasValue, isTrue);

        // Call central reset helper
        resetUserSessionState(container);

        // Providers are invalidated
        // Upon next read after logout, they return empty unauthenticated states
        await authController.logout();
        await Future<void>.delayed(const Duration(milliseconds: 50));

        final fleet = await container.read(ownerFleetControllerProvider.future);
        expect(fleet, isEmpty);
      },
    );
  });
}

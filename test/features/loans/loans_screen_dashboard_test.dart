import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_comment.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_dates_update_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_pagination.dart';
import 'package:mobile/features/loans/domain/entities/loans_dashboard.dart';
import 'package:mobile/features/loans/domain/repositories/loans_repository.dart';
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';
import 'package:mobile/features/loans/presentation/screens/loan_detail_screen.dart';
import 'package:mobile/features/loans/presentation/screens/loans_screen.dart';
import '../../fixtures/loans_fixtures.dart';

class _MockLoansRepo implements LoansRepository {
  LoansDashboard dashboardToReturn;
  List<Loan> cancelledLoansToReturn;
  int dashboardCalls = 0;

  _MockLoansRepo({LoansDashboard? dashboard, List<Loan>? cancelledLoans})
    : dashboardToReturn =
          dashboard ?? LoansDashboard.fromJson(laravelLoansDashboardJson),
      cancelledLoansToReturn = cancelledLoans ?? [];

  @override
  Future<LoansDashboard> getDashboard() async {
    dashboardCalls++;
    return dashboardToReturn;
  }

  @override
  Future<LoanPagination> getLoansPage({
    int page = 1,
    int perPage = 10,
    String? status,
    int? borrowerUserId,
  }) async {
    if (status == 'canceled,rejected') {
      return LoanPagination(data: cancelledLoansToReturn);
    }
    return const LoanPagination();
  }

  Loan? loanDetailToReturn;
  int cancelCalls = 0;

  @override
  Future<Loan> getLoanDetail(int id) async =>
      loanDetailToReturn ?? Loan.fromJson(laravelLoanDetailJson);

  @override
  Future<List<Loan>> getMyLoans() async => [];

  @override
  Future<Loan> cancelLoan(int id) async {
    cancelCalls++;
    return (loanDetailToReturn ?? Loan.fromJson(laravelLoanDetailJson))
        .copyWith(status: 'canceled', canceledAt: DateTime.now());
  }

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
  Future<Loan> createLoan(LoanCreationRequest request) async =>
      throw UnimplementedError();
}

class _TestAuthController extends AuthController {
  final User? _user;
  _TestAuthController(this._user);

  @override
  User? build() => _user;
}

void main() {
  group('LoansScreen Borrower Dashboard Tests', () {
    const borrowerUser = User(
      id: 100,
      email: 'jean.dupont@example.com',
      firstName: 'Jean',
      lastName: 'Dupont',
    );

    testWidgets(
      'renders all 5 borrower sections and excludes owner loans from borrower view',
      (tester) async {
        // Modify dashboard: add a loan in 'future' where user is NOT borrower (owner role)
        final dashboardMap = Map<String, dynamic>.from(
          laravelLoansDashboardJson,
        );
        final futureCategory = Map<String, dynamic>.from(
          dashboardMap['future'] as Map<String, dynamic>,
        );
        final futureLoansList = List<Map<String, dynamic>>.from(
          futureCategory['loans'] as List,
        );

        // Add a loan belonging to another borrower (where current user 100 would be owner)
        futureLoansList.add({
          "id": 88,
          "departure_at": "2026-10-12 10:00:00",
          "duration_in_minutes": 120,
          "status": "confirmed",
          "borrower_user": {"id": 999, "full_name": "Autre Emprunteur"},
          "loanable": {"id": 1, "name": "Toyota Prius Hybride", "type": "car"},
        });
        futureCategory['loans'] = futureLoansList;
        futureCategory['total'] = 2;
        dashboardMap['future'] = futureCategory;

        final testDashboard = LoansDashboard.fromJson(dashboardMap);

        final canceledLoan = Loan(
          id: 77,
          departureAt: DateTime.parse('2026-09-01T10:00:00'),
          durationInMinutes: 60,
          status: 'canceled',
          borrowerUserId: 100,
          loanableName: 'Vélo Cargo',
        );

        final mockRepo = _MockLoansRepo(
          dashboard: testDashboard,
          cancelledLoans: [canceledLoan],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              loansRepositoryProvider.overrideWithValue(mockRepo),
              authControllerProvider.overrideWith(
                () => _TestAuthController(borrowerUser),
              ),
            ],
            child: const MaterialApp(home: LoansScreen()),
          ),
        );

        await tester.pumpAndSettle();

        // Check top section headers
        expect(find.textContaining('En attente'), findsWidgets);
        expect(find.textContaining('Acceptées / Confirmées'), findsWidgets);
        expect(find.textContaining('En cours'), findsWidgets);

        // Verify that owner loan (Autre Emprunteur) is excluded from borrower future list
        expect(find.text('Autre Emprunteur'), findsNothing);

        // Scroll to bottom to view completed and canceled sections
        await tester.drag(find.byType(ListView).first, const Offset(0, -600));
        await tester.pumpAndSettle();

        expect(find.textContaining('Terminées'), findsWidgets);
        expect(find.textContaining('Annulées / Refusées'), findsWidgets);

        // Verify canceled loan is visible
        expect(find.text('Vélo Cargo'), findsOneWidget);
      },
    );

    testWidgets('shows Voir tout when total > 5', (tester) async {
      final dashboardMap = Map<String, dynamic>.from(laravelLoansDashboardJson);
      final waitingCategory = Map<String, dynamic>.from(
        dashboardMap['waiting'] as Map<String, dynamic>,
      );
      waitingCategory['total'] = 7; // total > 5
      dashboardMap['waiting'] = waitingCategory;

      final testDashboard = LoansDashboard.fromJson(dashboardMap);
      final mockRepo = _MockLoansRepo(dashboard: testDashboard);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider.overrideWith(
              () => _TestAuthController(borrowerUser),
            ),
          ],
          child: const MaterialApp(home: LoansScreen()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('view_all_requested')), findsOneWidget);
    });

    testWidgets('refreshes dashboard when app lifecycle changes to resumed', (
      tester,
    ) async {
      final mockRepo = _MockLoansRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider.overrideWith(
              () => _TestAuthController(borrowerUser),
            ),
          ],
          child: const MaterialApp(home: LoansScreen()),
        ),
      );

      await tester.pumpAndSettle();
      final initialCalls = mockRepo.dashboardCalls;
      expect(initialCalls, greaterThanOrEqualTo(1));

      // Simulate AppLifecycleState.resumed
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      expect(mockRepo.dashboardCalls, greaterThan(initialCalls));
    });

    testWidgets(
      'complete flow: dashboard -> detail -> cancel -> returns and refreshes',
      (tester) async {
        final mockRepo = _MockLoansRepo();
        mockRepo.loanDetailToReturn = Loan.fromJson(
          laravelLoanDetailJson,
        ).copyWith(id: 11);

        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const LoansScreen(),
            ),
            GoRoute(
              path: '/loans/:id',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                return LoanDetailScreen(loanId: id);
              },
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              loansRepositoryProvider.overrideWithValue(mockRepo),
              authControllerProvider.overrideWith(
                () => _TestAuthController(borrowerUser),
              ),
            ],
            child: MaterialApp.router(routerConfig: router),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('En attente (1)'), findsOneWidget);

        // Tap on the requested loan card to go to detail
        await tester.tap(find.text('Vélo Cargo Babboe'));
        await tester.pumpAndSettle();

        // Detail screen is shown
        expect(find.text('Réservation #11'), findsOneWidget);
        expect(find.byKey(const Key('action_cancel_button')), findsOneWidget);

        // Perform cancellation
        await tester.tap(find.byKey(const Key('action_cancel_button')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('confirm_cancel_button')));
        await tester.pumpAndSettle();

        expect(mockRepo.cancelCalls, 1);
      },
    );

    testWidgets(
      'displays "Demandes à traiter" section when need_approval has loans',
      (tester) async {
        final mockRepo = _MockLoansRepo();
        // laravelLoansDashboardJson has need_approval with 1 loan
        mockRepo.dashboardToReturn = LoansDashboard.fromJson(
          laravelLoansDashboardJson,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              loansRepositoryProvider.overrideWithValue(mockRepo),
              authControllerProvider.overrideWith(
                () => _TestAuthController(borrowerUser),
              ),
            ],
            child: const MaterialApp(home: LoansScreen()),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Demandes à traiter (1)'), findsOneWidget);
      },
    );

    testWidgets(
      'hides "Demandes à traiter" section when need_approval.total is 0',
      (tester) async {
        final mockRepo = _MockLoansRepo();
        final noApprovalDashboard = Map<String, dynamic>.from(
          laravelLoansDashboardJson,
        );
        noApprovalDashboard['need_approval'] = {'total': 0, 'loans': []};
        mockRepo.dashboardToReturn = LoansDashboard.fromJson(
          noApprovalDashboard,
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              loansRepositoryProvider.overrideWithValue(mockRepo),
              authControllerProvider.overrideWith(
                () => _TestAuthController(borrowerUser),
              ),
            ],
            child: const MaterialApp(home: LoansScreen()),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.textContaining('Demandes à traiter'), findsNothing);
      },
    );

    testWidgets(
      'taps "Voir tout" on Demandes à traiter navigates to /loans/all?status=requested',
      (tester) async {
        final mockRepo = _MockLoansRepo();
        final multipleApprovalDashboard = Map<String, dynamic>.from(
          laravelLoansDashboardJson,
        );
        multipleApprovalDashboard['need_approval'] = {
          'total': 7,
          'loans': [
            {
              "id": 12,
              "departure_at": "2026-10-06 10:00:00",
              "duration_in_minutes": 240,
              "status": "requested",
              "owner_action_required": true,
              "borrower_user": {"id": 105, "full_name": "Marie Curie"},
              "loanable": {
                "id": 1,
                "name": "Toyota Prius Hybride",
                "type": "car",
              },
            },
          ],
        };
        mockRepo.dashboardToReturn = LoansDashboard.fromJson(
          multipleApprovalDashboard,
        );

        String? capturedRoute;
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const LoansScreen(),
            ),
            GoRoute(
              path: '/loans/all',
              builder: (context, state) {
                capturedRoute = state.uri.toString();
                return const Scaffold(body: Text('All Loans Screen'));
              },
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              loansRepositoryProvider.overrideWithValue(mockRepo),
              authControllerProvider.overrideWith(
                () => _TestAuthController(borrowerUser),
              ),
            ],
            child: MaterialApp.router(routerConfig: router),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byKey(const Key('view_all_need_approval')), findsOneWidget);
        await tester.tap(find.byKey(const Key('view_all_need_approval')));
        await tester.pumpAndSettle();

        expect(capturedRoute, '/loans/all?status=requested');
        expect(find.text('All Loans Screen'), findsOneWidget);
      },
    );

    testWidgets(
      'loan canceled by owner appears in borrower canceled/rejected section upon refresh',
      (tester) async {
        final initialDashboard = Map<String, dynamic>.from(
          laravelLoansDashboardJson,
        );
        final mockRepo = _MockLoansRepo(
          dashboard: LoansDashboard.fromJson(initialDashboard),
          cancelledLoans: [],
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              loansRepositoryProvider.overrideWithValue(mockRepo),
              authControllerProvider.overrideWith(
                () => _TestAuthController(borrowerUser),
              ),
            ],
            child: const MaterialApp(home: LoansScreen()),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('En attente (1)'), findsOneWidget);

        // Now simulate owner canceled loan #11:
        // In updated dashboard, loan #11 is no longer in waiting, and is in canceledLoans
        final updatedDashboard = Map<String, dynamic>.from(
          laravelLoansDashboardJson,
        );
        updatedDashboard['waiting'] = {'total': 0, 'loans': []};
        mockRepo.dashboardToReturn = LoansDashboard.fromJson(updatedDashboard);
        mockRepo.cancelledLoansToReturn = [
          Loan(
            id: 11,
            departureAt: DateTime.parse('2026-10-05 14:00:00'),
            durationInMinutes: 120,
            status: 'canceled',
            borrowerUserId: 100,
            loanableName: 'Vélo Cargo Babboe',
          ),
        ];

        // Tap refresh action in AppBar
        await tester.tap(find.byTooltip('Actualiser'));
        await tester.pumpAndSettle();

        // Scroll to bottom to view canceled section if needed
        await tester.drag(find.byType(ListView).first, const Offset(0, -600));
        await tester.pumpAndSettle();

        // Canceled section now has loan #11
        expect(find.text('Annulées / Refusées (1)'), findsOneWidget);
        expect(find.text('Vélo Cargo Babboe'), findsOneWidget);
      },
    );
  });
}

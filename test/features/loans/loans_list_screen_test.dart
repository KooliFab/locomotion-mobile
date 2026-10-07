import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/loans/domain/entities/extension_estimate.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_comment.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_dates_update_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_pagination.dart';
import 'package:mobile/features/loans/domain/entities/loans_dashboard.dart';
import 'package:mobile/features/loans/domain/repositories/loans_repository.dart';
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';
import 'package:mobile/features/loans/presentation/screens/loans_list_screen.dart';
import '../../fixtures/loans_fixtures.dart';

class _ControllableMockLoansRepo implements LoansRepository {  final List<Completer<LoanPagination>> completers = [];
  final List<Map<String, dynamic>> requests = [];

  @override
  Future<LoanPagination> getLoansPage({
    int page = 1,
    int perPage = 10,
    String? status,
    int? borrowerUserId,
  }) {
    final completer = Completer<LoanPagination>();
    completers.add(completer);
    requests.add({
      'page': page,
      'perPage': perPage,
      'status': status,
      'borrowerUserId': borrowerUserId,
    });
    return completer.future;
  }

  @override
  Future<LoansDashboard> getDashboard() async => const LoansDashboard();
  @override
  Future<List<Loan>> getMyLoans() async => [];
  @override
  Future<Loan> getLoanDetail(int id) async => throw UnimplementedError();
  @override
  Future<Loan> cancelLoan(int id) async => throw UnimplementedError();
  @override
  Future<Loan> validateLoan(int id) async => throw UnimplementedError();
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
  ) => throw UnimplementedError();
}

class _MockLoansRepo implements LoansRepository {  final Map<int, LoanPagination> pages;
  final List<Map<String, dynamic>> requestedPages = [];

  _MockLoansRepo({required this.pages});

  @override
  Future<LoanPagination> getLoansPage({
    int page = 1,
    int perPage = 10,
    String? status,
    int? borrowerUserId,
  }) async {
    requestedPages.add({
      'page': page,
      'perPage': perPage,
      'status': status,
      'borrowerUserId': borrowerUserId,
    });
    return pages[page] ?? const LoanPagination();
  }

  @override
  Future<LoansDashboard> getDashboard() async => const LoansDashboard();
  @override
  Future<List<Loan>> getMyLoans() async => [];
  @override
  Future<Loan> getLoanDetail(int id) async => throw UnimplementedError();
  @override
  Future<Loan> cancelLoan(int id) async => throw UnimplementedError();
  @override
  Future<Loan> validateLoan(int id) async => throw UnimplementedError();
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
  ) => throw UnimplementedError();
}

class _TestAuthController extends AuthController {
  final User? _user;
  _TestAuthController(this._user);

  @override
  User? build() => _user;
}

void main() {
  const testUser = User(
    id: 100,
    email: 'borrower@example.com',
    firstName: 'Jean',
    lastName: 'Emprunteur',
  );

  final baseLoan = Loan.fromJson(laravelLoanDetailJson);

  testWidgets(
    'LoansListScreen displays page 1, loads page 2, and hides button at end',
    (tester) async {
      final loan1 = baseLoan.copyWith(id: 101, loanableName: 'Vélo Babboe P1');
      final loan2 = baseLoan.copyWith(id: 102, loanableName: 'Vélo Babboe P2');

      final mockRepo = _MockLoansRepo(
        pages: {
          1: LoanPagination(
            data: [loan1],
            currentPage: 1,
            lastPage: 2,
            total: 2,
            perPage: 1,
          ),
          2: LoanPagination(
            data: [loan2],
            currentPage: 2,
            lastPage: 2,
            total: 2,
            perPage: 1,
          ),
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider.overrideWith(
              () => _TestAuthController(testUser),
            ),
          ],
          child: const MaterialApp(home: LoansListScreen()),
        ),
      );

      // Initial loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();

      // Page 1 is displayed
      expect(find.text('Vélo Babboe P1'), findsOneWidget);
      expect(find.text('Vélo Babboe P2'), findsNothing);

      // Load more button should be present because currentPage (1) < lastPage (2)
      final loadMoreFinder = find.byKey(const Key('load_more_button'));
      expect(loadMoreFinder, findsOneWidget);
      expect(find.text('Charger plus'), findsOneWidget);

      // Click on Charger plus
      await tester.tap(loadMoreFinder);
      await tester.pump(); // Start loading more
      await tester.pumpAndSettle(); // Finished loading page 2

      // Both items from page 1 and page 2 are now in list
      expect(find.text('Vélo Babboe P1'), findsOneWidget);
      expect(find.text('Vélo Babboe P2'), findsOneWidget);

      // Button "Charger plus" is gone because currentPage (2) == lastPage (2)
      expect(find.byKey(const Key('load_more_button')), findsNothing);

      // Verify params passed to repository
      expect(mockRepo.requestedPages.length, 2);
      expect(mockRepo.requestedPages[0]['page'], 1);
      expect(mockRepo.requestedPages[0]['borrowerUserId'], 100);
      expect(mockRepo.requestedPages[1]['page'], 2);
      expect(mockRepo.requestedPages[1]['borrowerUserId'], 100);
    },
  );

  testWidgets(
    'R23: Out-of-order network responses reject stale filters and prevent race conditions',
    (tester) async {
      final controlledRepo = _ControllableMockLoansRepo();
      final loanWaiting = baseLoan.copyWith(
        id: 201,
        loanableName: 'Vélo En Attente',
      );
      final loanCompleted = baseLoan.copyWith(
        id: 202,
        loanableName: 'Vélo Terminé',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(controlledRepo),
            authControllerProvider.overrideWith(
              () => _TestAuthController(testUser),
            ),
          ],
          child: const MaterialApp(
            home: LoansListScreen(initialStatus: 'requested'),
          ),
        ),
      );

      // Request 1 is in-flight for 'requested'
      expect(controlledRepo.requests.length, 1);
      expect(controlledRepo.requests[0]['status'], 'requested');

      // Now switch filter to 'Tous' (null status)
      await tester.tap(find.text('Tous'));
      await tester.pump();

      // Request 2 is now in-flight for null status
      expect(controlledRepo.requests.length, 2);
      expect(controlledRepo.requests[1]['status'], isNull);

      // Response 2 arrives FIRST (completed filter returns first)
      controlledRepo.completers[1].complete(
        LoanPagination(
          data: [loanCompleted],
          currentPage: 1,
          lastPage: 1,
          total: 1,
          perPage: 10,
        ),
      );
      await tester.pumpAndSettle();

      // Only the completed loan is shown
      expect(find.text('Vélo Terminé'), findsOneWidget);
      expect(find.text('Vélo En Attente'), findsNothing);

      // Now stale Response 1 arrives LATER (requested filter arrives out-of-order)
      controlledRepo.completers[0].complete(
        LoanPagination(
          data: [loanWaiting],
          currentPage: 1,
          lastPage: 1,
          total: 1,
          perPage: 10,
        ),
      );
      await tester.pumpAndSettle();

      // Stale response MUST be rejected: 'Vélo Terminé' stays displayed, 'Vélo En Attente' never appears
      expect(find.text('Vélo Terminé'), findsOneWidget);
      expect(find.text('Vélo En Attente'), findsNothing);
    },
  );

  testWidgets(
    'R23: Stale request error is ignored when a newer request succeeded',
    (tester) async {
      final controlledRepo = _ControllableMockLoansRepo();
      final loanCompleted = baseLoan.copyWith(
        id: 202,
        loanableName: 'Vélo Terminé',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(controlledRepo),
            authControllerProvider.overrideWith(
              () => _TestAuthController(testUser),
            ),
          ],
          child: const MaterialApp(
            home: LoansListScreen(initialStatus: 'requested'),
          ),
        ),
      );

      // Switch to 'Tous'
      await tester.tap(find.text('Tous'));
      await tester.pump();

      // Complete request 2 successfully
      controlledRepo.completers[1].complete(
        LoanPagination(
          data: [loanCompleted],
          currentPage: 1,
          lastPage: 1,
          total: 1,
          perPage: 10,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Vélo Terminé'), findsOneWidget);

      // Stale request 1 fails with an error
      controlledRepo.completers[0].completeError(Exception('Network timeout'));
      await tester.pumpAndSettle();

      // Screen remains on 'Vélo Terminé' without showing error
      expect(find.text('Vélo Terminé'), findsOneWidget);
      expect(find.textContaining('Network timeout'), findsNothing);
    },
  );
}

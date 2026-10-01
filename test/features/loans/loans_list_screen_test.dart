import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
import 'package:mobile/features/loans/presentation/screens/loans_list_screen.dart';
import '../../fixtures/loans_fixtures.dart';

class _MockLoansRepo implements LoansRepository {
  final Map<int, LoanPagination> pages;
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
}

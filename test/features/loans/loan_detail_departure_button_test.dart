import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/loanables/domain/entities/loanable.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_comment.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_dates_update_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_pagination.dart';
import 'package:mobile/features/loans/domain/entities/loans_dashboard.dart';
import 'package:mobile/features/loans/domain/repositories/loans_repository.dart';
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';
import 'package:mobile/features/loans/presentation/screens/loan_detail_screen.dart';

class _FakeAuthController extends AuthController {
  final User? _user;
  _FakeAuthController(this._user);

  @override
  User? build() => _user;
}

class _StubLoansRepo implements LoansRepository {
  Loan? loanDetail;

  @override
  Future<Loan> getLoanDetail(int id) async => loanDetail!;

  @override
  Future<Loan> acceptLoan(int id, {String? comment}) => throw UnimplementedError();

  @override
  Future<LoanComment> addComment(int id, String text) => throw UnimplementedError();

  @override
  Future<Loan> cancelLoan(int id) => throw UnimplementedError();

  @override
  Future<Loan> validateLoan(int id) => throw UnimplementedError();

  @override
  Future<Loan> createLoan(LoanCreationRequest request) => throw UnimplementedError();

  @override
  Future<LoansDashboard> getDashboard() => throw UnimplementedError();

  @override
  Future<List<Loan>> getMyLoans() => throw UnimplementedError();

  @override
  Future<LoanPagination> getLoansPage({
    int page = 1,
    int perPage = 10,
    String? status,
    int? borrowerUserId,
  }) => throw UnimplementedError();

  @override
  Future<Loan> rejectLoan(int id, {String? comment}) => throw UnimplementedError();

  @override
  Future<Loan> updateLoanDates(int id, LoanDatesUpdateRequest request) => throw UnimplementedError();
}

void main() {
  const borrower = User(
    id: 10,
    email: 'borrower@example.com',
    firstName: 'Benoit',
    lastName: 'Caron',
  );

  const stranger = User(
    id: 99,
    email: 'stranger@example.com',
    firstName: 'Inconnu',
    lastName: 'Test',
  );

  final baseLoan = Loan(
    id: 42,
    departureAt: DateTime.now().add(const Duration(hours: 1)),
    durationInMinutes: 120,
    status: 'confirmed',
    borrowerUserId: 10,
    loanableName: 'Nissan Leaf',
    loanable: const Loanable(
      id: 7,
      name: 'Nissan Leaf',
      type: 'car',
    ),
  );

  group('LoanDetailScreen Take-Over & Certified Inspection Badge Tests', () {
    testWidgets('shows Take-Over button when loan is confirmed and user is borrower', (
      tester,
    ) async {
      final repo = _StubLoansRepo()..loanDetail = baseLoan;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(borrower)),
            loansRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 42),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('action_take_over_button')), findsOneWidget);
      expect(find.text('Prendre en charge le véhicule'), findsOneWidget);
      expect(find.byKey(const Key('departure_inspection_completed_badge')), findsNothing);
    });

    testWidgets('shows certified badge and hides button when departure is completed', (
      tester,
    ) async {
      final completedInspectionLoan = baseLoan.copyWith(
        status: 'ongoing',
        departureInspectionCompleted: true,
      );
      final repo = _StubLoansRepo()..loanDetail = completedInspectionLoan;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(borrower)),
            loansRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 42),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('action_take_over_button')), findsNothing);
      expect(find.byKey(const Key('departure_inspection_completed_badge')), findsOneWidget);
      expect(find.text('État des lieux de départ certifié'), findsOneWidget);
    });

    testWidgets('hides Take-Over button for stranger', (tester) async {
      final repo = _StubLoansRepo()..loanDetail = baseLoan;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(stranger)),
            loansRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 42),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('action_take_over_button')), findsNothing);
    });

    testWidgets('hides Take-Over button when status is pending or canceled', (tester) async {
      final pendingLoan = baseLoan.copyWith(status: 'pending');
      final repo = _StubLoansRepo()..loanDetail = pendingLoan;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(borrower)),
            loansRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 42),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('action_take_over_button')), findsNothing);
    });

    testWidgets('shows upcoming window card and hides Take-Over button when departure is more than 1 hour away', (tester) async {
      final futureLoan = baseLoan.copyWith(
        departureAt: DateTime.now().add(const Duration(hours: 3)),
      );
      final repo = _StubLoansRepo()..loanDetail = futureLoan;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(borrower)),
            loansRepositoryProvider.overrideWithValue(repo),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 42),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('action_take_over_button')), findsNothing);
      expect(find.byKey(const Key('take_over_window_upcoming_card')), findsOneWidget);
      expect(find.textContaining('disponible 1 heure avant le départ'), findsOneWidget);
    });
  });
}

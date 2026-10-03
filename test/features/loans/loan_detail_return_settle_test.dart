import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/loanables/domain/entities/loanable.dart';
import 'package:mobile/features/loans/domain/entities/extension_estimate.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_comment.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_dates_update_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_inspection.dart';
import 'package:mobile/features/loans/domain/entities/loan_pagination.dart';
import 'package:mobile/features/loans/domain/entities/loans_dashboard.dart';
import 'package:mobile/features/loans/domain/repositories/loan_inspection_repository.dart';
import 'package:mobile/features/loans/domain/repositories/loans_repository.dart';
import 'package:mobile/features/loans/presentation/controllers/loan_inspection_providers.dart';
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';
import 'package:mobile/features/loans/presentation/screens/loan_detail_screen.dart';
import 'dart:io';

class _MockLoansRepo implements LoansRepository {
  Loan loanDetail;
  bool validateCalled = false;

  _MockLoansRepo(this.loanDetail);

  @override
  Future<Loan> getLoanDetail(int id) async => loanDetail;

  @override
  Future<Loan> validateLoan(int id) async {
    validateCalled = true;
    loanDetail = loanDetail.copyWith(
      ownerValidatedAt: DateTime.now(),
      status: 'validated',
    );
    return loanDetail;
  }

  @override
  Future<Loan> acceptLoan(int id, {String? comment}) => throw UnimplementedError();
  @override
  Future<LoanComment> addComment(int id, String text) => throw UnimplementedError();
  @override
  Future<Loan> cancelLoan(int id) => throw UnimplementedError();
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

  @override
  Future<Loan> requestExtension(int id, int extensionDurationInMinutes) => throw UnimplementedError();

  @override
  Future<Loan> acceptExtension(int id) => throw UnimplementedError();

  @override
  Future<Loan> rejectExtension(int id) => throw UnimplementedError();

  @override
  Future<Loan> cancelExtension(int id) => throw UnimplementedError();

  @override
  Future<ExtensionEstimate> getExtensionEstimate(int id, int durationInMinutes) => throw UnimplementedError();
}

class _MockInspectionRepo implements LoanInspectionRepository {
  bool settleCalled = false;

  @override
  Future<Map<String, dynamic>> settleLoan({
    required int loanId,
    bool releaseDeposit = true,
    int incidentClaimCents = 0,
  }) async {
    settleCalled = true;
    return {'status': 'completed', 'paid_at': DateTime.now().toIso8601String()};
  }

  @override
  Future<LoanInspection?> getDepartureInspection(int loanId) async => null;
  @override
  Future<LoanInspection?> getReturnInspection(int loanId) async => null;
  @override
  Future<LoanInspection> submitDepartureInspection({
    required int loanId,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  }) => throw UnimplementedError();
  @override
  Future<LoanInspection> submitReturnInspection({
    required int loanId,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  }) => throw UnimplementedError();
  @override
  Future<int> uploadInspectionPhoto({required File file, required String field}) => throw UnimplementedError();
}

class _FakeAuthController extends AuthController {
  final User? _user;
  _FakeAuthController(this._user);

  @override
  User? build() => _user;
}

void main() {
  const currentUser = User(
    id: 10,
    email: 'borrower@test.com',
    firstName: 'Jean',
    lastName: 'Borrower',
  );

  const ownerUser = User(
    id: 99,
    email: 'owner@test.com',
    firstName: 'Paul',
    lastName: 'Owner',
  );

  final baseOngoingLoan = Loan(
    id: 301,
    departureAt: DateTime.now().subtract(const Duration(hours: 1)),
    durationInMinutes: 120,
    status: 'ongoing',
    borrowerUserId: 10,
    departureInspectionCompleted: true,
    returnInspectionCompleted: false,
    loanable: const Loanable(
      id: 1,
      name: 'Vélo Partagé',
      type: 'bike',
      mergedUserRoles: [
        {'user_id': 99, 'role': 'owner'},
      ],
    ),
  );

  group('LoanDetailScreen - Lot 11 Return & Settle Actions', () {
    testWidgets('renders "Restituer le véhicule" button when loan is ongoing and not returned', (
      tester,
    ) async {
      final loansRepo = _MockLoansRepo(baseOngoingLoan);
      final inspectionRepo = _MockInspectionRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(currentUser)),
            loansRepositoryProvider.overrideWithValue(loansRepo),
            loanInspectionRepositoryProvider.overrideWithValue(inspectionRepo),
            loanDetailProvider(301).overrideWith((ref) => baseOngoingLoan),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 301),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('action_return_vehicle_button')), findsOneWidget);
      expect(find.text('Restituer le véhicule'), findsOneWidget);
    });

    testWidgets('renders certified return inspection badge when returnInspectionCompleted is true', (
      tester,
    ) async {
      final returnedLoan = baseOngoingLoan.copyWith(
        status: 'ended',
        returnInspectionCompleted: true,
      );
      final loansRepo = _MockLoansRepo(returnedLoan);
      final inspectionRepo = _MockInspectionRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(currentUser)),
            loansRepositoryProvider.overrideWithValue(loansRepo),
            loanInspectionRepositoryProvider.overrideWithValue(inspectionRepo),
            loanDetailProvider(301).overrideWith((ref) => returnedLoan),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 301),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('return_inspection_completed_badge')), findsOneWidget);
      expect(find.text('État des lieux de retour certifié'), findsOneWidget);
    });

    testWidgets('renders contradictory validation card for owner and triggers validation', (
      tester,
    ) async {
      final endedLoan = baseOngoingLoan.copyWith(
        status: 'ended',
        returnInspectionCompleted: true,
        ownerValidatedAt: null,
      );
      final loansRepo = _MockLoansRepo(endedLoan);
      final inspectionRepo = _MockInspectionRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(ownerUser)),
            loansRepositoryProvider.overrideWithValue(loansRepo),
            loanInspectionRepositoryProvider.overrideWithValue(inspectionRepo),
            loanDetailProvider(301).overrideWith((ref) => endedLoan),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 301),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('owner_contradictory_validation_card')), findsOneWidget);
      expect(find.byKey(const Key('action_owner_validate_return_button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('action_owner_validate_return_button')));
      await tester.pumpAndSettle();

      expect(loansRepo.validateCalled, isTrue);
    });

    testWidgets('renders "Régler & clôturer le prêt" button and confirms settlement', (
      tester,
    ) async {
      final endedValidatedLoan = baseOngoingLoan.copyWith(
        status: 'ended',
        returnInspectionCompleted: true,
        ownerValidatedAt: DateTime.now(),
        borrowerValidatedAt: DateTime.now(),
        paidAt: null,
      );
      final loansRepo = _MockLoansRepo(endedValidatedLoan);
      final inspectionRepo = _MockInspectionRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(currentUser)),
            loansRepositoryProvider.overrideWithValue(loansRepo),
            loanInspectionRepositoryProvider.overrideWithValue(inspectionRepo),
            loanDetailProvider(301).overrideWith((ref) => endedValidatedLoan),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 301),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final settleButton = find.byKey(const Key('action_settle_loan_button'));
      expect(settleButton, findsOneWidget);

      // Tap settle button
      await tester.tap(settleButton);
      await tester.pumpAndSettle();

      // Dialog opens
      expect(find.text('Règlement final'), findsOneWidget);
      final confirmButton = find.byKey(const Key('confirm_settle_button'));
      expect(confirmButton, findsOneWidget);

      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(inspectionRepo.settleCalled, isTrue);
    });

    testWidgets('renders "Règlement finalisé et caution libérée" badge when paidAt is set', (
      tester,
    ) async {
      final settledLoan = baseOngoingLoan.copyWith(
        status: 'completed',
        returnInspectionCompleted: true,
        paidAt: DateTime.now(),
      );
      final loansRepo = _MockLoansRepo(settledLoan);
      final inspectionRepo = _MockInspectionRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(currentUser)),
            loansRepositoryProvider.overrideWithValue(loansRepo),
            loanInspectionRepositoryProvider.overrideWithValue(inspectionRepo),
            loanDetailProvider(301).overrideWith((ref) => settledLoan),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 301),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('loan_settled_badge')), findsOneWidget);
      expect(find.text('Règlement finalisé et caution libérée'), findsOneWidget);
    });
  });
}

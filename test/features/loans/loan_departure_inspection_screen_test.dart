import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/loanables/domain/entities/loanable.dart';
import 'package:mobile/features/loans/domain/entities/departure_draft.dart';
import 'package:mobile/features/loans/domain/entities/extension_estimate.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_comment.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_dates_update_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_inspection.dart';
import 'package:mobile/features/loans/domain/entities/loan_pagination.dart';
import 'package:mobile/features/loans/domain/entities/loans_dashboard.dart';
import 'package:mobile/features/loans/domain/repositories/departure_draft_repository.dart';
import 'package:mobile/features/loans/domain/repositories/loan_inspection_repository.dart';
import 'package:mobile/features/loans/domain/repositories/loans_repository.dart';
import 'package:mobile/features/loans/presentation/controllers/loan_inspection_providers.dart';
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';
import 'package:mobile/features/loans/presentation/screens/loan_departure_inspection_screen.dart';

class _FakeAuthController extends AuthController {
  final User? _user;
  _FakeAuthController(this._user);

  @override
  User? build() => _user;
}

class _FakeDraftRepo implements DepartureDraftRepository {
  DepartureDraft? stored;

  @override
  Future<void> saveDraft(DepartureDraft draft) async {
    stored = draft;
  }

  @override
  Future<DepartureDraft?> getDraft({required int userId, required int loanId}) async {
    return stored;
  }

  @override
  Future<void> clearDraft({required int userId, required int loanId}) async {
    stored = null;
  }
}

class _FakeInspectionRepo implements LoanInspectionRepository {
  @override
  Future<int> uploadInspectionPhoto({required File file, required String field}) async => 123;

  @override
  Future<LoanInspection> submitDepartureInspection({
    required int loanId,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  }) async {
    return LoanInspection(
      loanId: loanId,
      inspectionType: 'departure',
      sealedHash: 'sealed_123',
    );
  }

  @override
  Future<LoanInspection?> getDepartureInspection(int loanId) async => null;

  @override
  Future<LoanInspection> submitReturnInspection({
    required int loanId,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  }) async {
    return LoanInspection(
      loanId: loanId,
      inspectionType: 'return',
      sealedHash: 'sealed_123',
    );
  }

  @override
  Future<LoanInspection?> getReturnInspection(int loanId) async => null;

  @override
  Future<Map<String, dynamic>> settleLoan({
    required int loanId,
    bool releaseDeposit = true,
    int incidentClaimCents = 0,
  }) async => {'status': 'completed'};
}

class _FakeLoansRepo implements LoansRepository {
  @override
  Future<Loan> getLoanDetail(int id) async => throw UnimplementedError();

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

void main() {
  const testUser = User(
    id: 10,
    email: 'alice@example.com',
    firstName: 'Alice',
    lastName: 'Tremblay',
  );

  final carLoan = Loan(
    id: 101,
    departureAt: DateTime.now(),
    durationInMinutes: 120,
    status: 'confirmed',
    borrowerUserId: 10,
    loanableName: 'Toyota Prius',
    mileageStart: 85200,
    loanable: const Loanable(
      id: 50,
      name: 'Toyota Prius',
      type: 'car',
    ),
  );

  final bikeLoan = Loan(
    id: 102,
    departureAt: DateTime.now(),
    durationInMinutes: 60,
    status: 'confirmed',
    borrowerUserId: 10,
    loanableName: 'Vélo Cargo',
    loanable: const Loanable(
      id: 51,
      name: 'Vélo Cargo',
      type: 'bike',
    ),
  );

  group('LoanDepartureInspectionScreen Widget Tests', () {
    testWidgets('renders motorized vehicle inspection form with odometer and 5 photos', (
      tester,
    ) async {
      final draftRepo = _FakeDraftRepo();
      final inspectionRepo = _FakeInspectionRepo();
      final loansRepo = _FakeLoansRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(testUser)),
            departureDraftRepositoryProvider.overrideWithValue(draftRepo),
            loanInspectionRepositoryProvider.overrideWithValue(inspectionRepo),
            loansRepositoryProvider.overrideWithValue(loansRepo),
            loanDetailProvider(101).overrideWith((ref) => carLoan),
          ],
          child: MaterialApp(
            home: LoanDepartureInspectionScreen(
              loanId: 101,
              initialLoan: carLoan,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Title and Instructions
      expect(find.text('État des lieux de départ'), findsOneWidget);
      expect(find.text('Toyota Prius'), findsOneWidget);

      // Verify Motorized Sections
      expect(find.text('Compteur kilométrique (KM) *'), findsOneWidget);
      expect(find.text('Niveau de carburant / batterie :'), findsOneWidget);

      // Verify Motorized Checklist
      expect(find.text('Clé physique du véhicule présente'), findsOneWidget);
      expect(find.text('Documents d\'assurance à bord'), findsOneWidget);

      // Verify Mandatory Photos (5 for car)
      expect(find.text('Tableau de bord (Compteur) *'), findsOneWidget);
      expect(find.text('Face avant *'), findsOneWidget);
      expect(find.text('Face arrière *'), findsOneWidget);
      expect(find.text('Côté gauche *'), findsOneWidget);
      expect(find.text('Côté droit *'), findsOneWidget);

      // Verify Submission button is disabled when photos are missing
      final submitButtonFinder = find.byKey(const Key('submit_departure_button'));
      expect(submitButtonFinder, findsOneWidget);
      final submitButton = tester.widget<ElevatedButton>(submitButtonFinder);
      expect(submitButton.onPressed, isNull);
    });

    testWidgets('renders non-motorized vehicle form without odometer and 1 photo', (
      tester,
    ) async {
      final draftRepo = _FakeDraftRepo();
      final inspectionRepo = _FakeInspectionRepo();
      final loansRepo = _FakeLoansRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(testUser)),
            departureDraftRepositoryProvider.overrideWithValue(draftRepo),
            loanInspectionRepositoryProvider.overrideWithValue(inspectionRepo),
            loansRepositoryProvider.overrideWithValue(loansRepo),
            loanDetailProvider(102).overrideWith((ref) => bikeLoan),
          ],
          child: MaterialApp(
            home: LoanDepartureInspectionScreen(
              loanId: 102,
              initialLoan: bikeLoan,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Title & vehicle name
      expect(find.text('État des lieux de départ'), findsOneWidget);
      expect(find.text('Vélo Cargo'), findsOneWidget);

      // Odometer field should NOT be shown for bike
      expect(find.text('Compteur kilométrique (KM) *'), findsNothing);

      // Non-motorized checklist
      expect(find.text('Antivol présent et fonctionnel'), findsOneWidget);
      expect(find.text('Clé d\'antivol présente'), findsOneWidget);

      // Photo slots: 1 mandatory photo for bike (Vue générale du véhicule *)
      expect(find.text('Vue générale du véhicule *'), findsOneWidget);
      expect(find.text('Tableau de bord (Compteur) *'), findsNothing);
    });
  });
}

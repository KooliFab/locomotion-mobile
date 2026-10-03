import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/loanables/domain/entities/loanable.dart';
import 'package:mobile/features/loans/domain/entities/departure_draft.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_comment.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_dates_update_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_inspection.dart';
import 'package:mobile/features/loans/domain/entities/loan_pagination.dart';
import 'package:mobile/features/loans/domain/entities/loans_dashboard.dart';
import 'package:mobile/features/loans/domain/entities/return_draft.dart';
import 'package:mobile/features/loans/domain/repositories/loan_inspection_repository.dart';
import 'package:mobile/features/loans/domain/repositories/loans_repository.dart';
import 'package:mobile/features/loans/domain/repositories/return_draft_repository.dart';
import 'package:mobile/features/loans/presentation/controllers/loan_inspection_providers.dart';
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';
import 'package:mobile/features/loans/presentation/screens/loan_return_inspection_screen.dart';

class _FakeReturnDraftRepo implements ReturnDraftRepository {
  ReturnDraft? stored;

  @override
  Future<ReturnDraft?> getDraft({required int userId, required int loanId}) async => stored;

  @override
  Future<void> saveDraft(ReturnDraft draft) async {
    stored = draft;
  }

  @override
  Future<void> clearDraft({required int userId, required int loanId}) async {
    stored = null;
  }
}

class _FakeReturnInspectionRepo implements LoanInspectionRepository {
  @override
  Future<int> uploadInspectionPhoto({required File file, required String field}) async => 555;

  @override
  Future<LoanInspection> submitDepartureInspection({
    required int loanId,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  }) async => throw UnimplementedError();

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
      sealedHash: 'sha256_mock_hash_for_return_inspection',
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
}

class _FakeAuthController extends AuthController {
  final User? _user;
  _FakeAuthController(this._user);

  @override
  User? build() => _user;
}

void main() {
  const testUser = User(
    id: 10,
    email: 'charlie@example.com',
    firstName: 'Charlie',
    lastName: 'Gagnon',
  );

  final carLoan = Loan(
    id: 201,
    departureAt: DateTime.now().subtract(const Duration(hours: 2)),
    durationInMinutes: 120,
    status: 'ongoing',
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
    id: 202,
    departureAt: DateTime.now().subtract(const Duration(hours: 1)),
    durationInMinutes: 60,
    status: 'ongoing',
    borrowerUserId: 10,
    loanableName: 'Vélo Cargo',
    loanable: const Loanable(
      id: 51,
      name: 'Vélo Cargo',
      type: 'bike',
    ),
  );

  group('LoanReturnInspectionScreen Widget Tests', () {
    testWidgets('renders motorized vehicle return inspection form with odometer and 5 photos', (
      tester,
    ) async {
      final draftRepo = _FakeReturnDraftRepo();
      final inspectionRepo = _FakeReturnInspectionRepo();
      final loansRepo = _FakeLoansRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(testUser)),
            returnDraftRepositoryProvider.overrideWithValue(draftRepo),
            loanInspectionRepositoryProvider.overrideWithValue(inspectionRepo),
            loansRepositoryProvider.overrideWithValue(loansRepo),
            loanDetailProvider(201).overrideWith((ref) => carLoan),
          ],
          child: MaterialApp(
            home: LoanReturnInspectionScreen(
              loanId: 201,
              initialLoan: carLoan,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Title and Instructions
      expect(find.text('État des lieux de retour'), findsOneWidget);
      expect(find.textContaining('Restitution : Toyota Prius'), findsOneWidget);

      // Verify Motorized Sections
      expect(find.text('Compteur kilométrique de retour (KM) *'), findsOneWidget);
      expect(find.text('Niveau de carburant / batterie restant :'), findsOneWidget);

      // Verify Checklist items
      expect(find.text('Clés du véhicule remises au propriétaire / coffre'), findsOneWidget);
      expect(find.text('Habitacle nettoyé et débarrassé de tout déchet'), findsOneWidget);

      // Verify 5 Photos
      expect(find.text('Tableau de bord (Compteur) *'), findsOneWidget);
      expect(find.text('Face avant *'), findsOneWidget);
      expect(find.text('Face arrière *'), findsOneWidget);
      expect(find.text('Côté gauche *'), findsOneWidget);
      expect(find.text('Côté droit *'), findsOneWidget);

      // Verify New Damages & Signature
      expect(find.text('Signaler de nouveaux dommages ou incidents'), findsOneWidget);
      expect(find.text('5. Signature contradictoire de retour'), findsOneWidget);

      // Verify Submit Button is disabled
      final submitFinder = find.byKey(const Key('submit_return_button'));
      expect(submitFinder, findsOneWidget);
      final submitButton = tester.widget<ElevatedButton>(submitFinder);
      expect(submitButton.onPressed, isNull);
    });

    testWidgets('renders non-motorized vehicle return form without odometer', (
      tester,
    ) async {
      final draftRepo = _FakeReturnDraftRepo();
      final inspectionRepo = _FakeReturnInspectionRepo();
      final loansRepo = _FakeLoansRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(testUser)),
            returnDraftRepositoryProvider.overrideWithValue(draftRepo),
            loanInspectionRepositoryProvider.overrideWithValue(inspectionRepo),
            loansRepositoryProvider.overrideWithValue(loansRepo),
            loanDetailProvider(202).overrideWith((ref) => bikeLoan),
          ],
          child: MaterialApp(
            home: LoanReturnInspectionScreen(
              loanId: 202,
              initialLoan: bikeLoan,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('État des lieux de retour'), findsOneWidget);
      expect(find.textContaining('Restitution : Vélo Cargo'), findsOneWidget);

      // Odometer must NOT be displayed
      expect(find.text('Compteur kilométrique de retour (KM) *'), findsNothing);

      // Bike checklist
      expect(find.text('Antivol remis et attaché en lieu sûr'), findsOneWidget);

      // Bike photos
      expect(find.text('Vue générale du véhicule *'), findsOneWidget);
      expect(find.text('Détail antivol / accessoires'), findsOneWidget);
    });

    testWidgets('enables submit button when valid draft is loaded and submission shows dialog', (
      tester,
    ) async {
      final draftRepo = _FakeReturnDraftRepo();
      final inspectionRepo = _FakeReturnInspectionRepo();
      final loansRepo = _FakeLoansRepo();

      // Pre-save fully completed draft
      draftRepo.stored = const ReturnDraft(
        userId: 10,
        loanId: 201,
        odometerKm: 85250,
        fuelBatteryLevelPercent: 85,
        cleanlinessRating: 4,
        photos: {
          'dashboard_odometer': DraftPhotoEntry(
            field: 'dashboard_odometer',
            status: DraftPhotoStatus.uploaded,
            imageId: 1,
          ),
          'front': DraftPhotoEntry(
            field: 'front',
            status: DraftPhotoStatus.uploaded,
            imageId: 2,
          ),
          'back': DraftPhotoEntry(
            field: 'back',
            status: DraftPhotoStatus.uploaded,
            imageId: 3,
          ),
          'left_side': DraftPhotoEntry(
            field: 'left_side',
            status: DraftPhotoStatus.uploaded,
            imageId: 4,
          ),
          'right_side': DraftPhotoEntry(
            field: 'right_side',
            status: DraftPhotoStatus.uploaded,
            imageId: 5,
          ),
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(() => _FakeAuthController(testUser)),
            returnDraftRepositoryProvider.overrideWithValue(draftRepo),
            loanInspectionRepositoryProvider.overrideWithValue(inspectionRepo),
            loansRepositoryProvider.overrideWithValue(loansRepo),
            loanDetailProvider(201).overrideWith((ref) => carLoan),
          ],
          child: MaterialApp(
            home: LoanReturnInspectionScreen(
              loanId: 201,
              initialLoan: carLoan,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Button should now be active
      final submitFinder = find.byKey(const Key('submit_return_button'));
      expect(submitFinder, findsOneWidget);
      final submitButton = tester.widget<ElevatedButton>(submitFinder);
      expect(submitButton.onPressed, isNotNull);

      // Tap submit
      await tester.ensureVisible(submitFinder);
      await tester.tap(submitFinder);
      await tester.pumpAndSettle();

      // Verify success dialog appears with sealed hash
      expect(find.byKey(const Key('return_inspection_success_dialog')), findsOneWidget);
      expect(find.text('Véhicule restitué !'), findsOneWidget);
      expect(find.text('sha256_mock_hash_for_return_inspection'), findsOneWidget);
    });
  });
}

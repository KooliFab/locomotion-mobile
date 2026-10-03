import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
import 'package:mobile/features/loans/presentation/controllers/loan_settle_controller.dart';
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';
import 'dart:io';

class FakeSettleInspectionRepository implements LoanInspectionRepository {
  bool shouldThrow = false;
  int? settledLoanId;
  bool? settledReleaseDeposit;
  int? settledIncidentClaimCents;

  @override
  Future<Map<String, dynamic>> settleLoan({
    required int loanId,
    bool releaseDeposit = true,
    int incidentClaimCents = 0,
  }) async {
    if (shouldThrow) {
      throw Exception('Stripe caution release error');
    }
    settledLoanId = loanId;
    settledReleaseDeposit = releaseDeposit;
    settledIncidentClaimCents = incidentClaimCents;

    return {
      'status': 'completed',
      'paid_at': '2026-10-03T18:00:00Z',
      'deposit_released': releaseDeposit,
    };
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

class FakeSettleLoansRepository implements LoansRepository {
  Loan? refreshedLoan;

  @override
  Future<Loan> getLoanDetail(int id) async {
    return refreshedLoan ??
        Loan(
          id: id,
          departureAt: DateTime.now(),
          durationInMinutes: 60,
          status: 'ended',
        );
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
  Future<Loan> validateLoan(int id) => throw UnimplementedError();
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
  late ProviderContainer container;
  late FakeSettleInspectionRepository fakeInspectionRepo;
  late FakeSettleLoansRepository fakeLoansRepo;

  setUp(() {
    fakeInspectionRepo = FakeSettleInspectionRepository();
    fakeLoansRepo = FakeSettleLoansRepository();

    container = ProviderContainer(
      overrides: [
        loanInspectionRepositoryProvider.overrideWithValue(fakeInspectionRepo),
        loansRepositoryProvider.overrideWithValue(fakeLoansRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('LoanSettleController', () {
    test('settleLoan succeeds, releases deposit, and updates state to LoanSettleSuccess', () async {
      final controller =
          container.read(loanSettleControllerProvider.notifier);

      final success = await controller.settleLoan(
        loanId: 101,
        releaseDeposit: true,
        incidentClaimCents: 0,
      );

      expect(success, isTrue);
      expect(fakeInspectionRepo.settledLoanId, 101);
      expect(fakeInspectionRepo.settledReleaseDeposit, isTrue);

      final state = container.read(loanSettleControllerProvider);
      expect(state, isA<LoanSettleSuccess>());
      final successState = state as LoanSettleSuccess;
      expect(successState.responseData['status'], 'completed');
    });

    test('settleLoan recovers if network fails but server completed payment', () async {
      fakeInspectionRepo.shouldThrow = true;
      fakeLoansRepo.refreshedLoan = Loan(
        id: 102,
        departureAt: DateTime.now(),
        durationInMinutes: 60,
        status: 'completed',
        paidAt: DateTime.now(),
      );

      final controller =
          container.read(loanSettleControllerProvider.notifier);

      final success = await controller.settleLoan(loanId: 102);

      expect(success, isTrue);
      final state = container.read(loanSettleControllerProvider);
      expect(state, isA<LoanSettleSuccess>());
    });

    test('settleLoan reports error when both settle and recovery fail', () async {
      fakeInspectionRepo.shouldThrow = true;
      fakeLoansRepo.refreshedLoan = Loan(
        id: 103,
        departureAt: DateTime.now(),
        durationInMinutes: 60,
        status: 'ended',
        paidAt: null,
      );

      final controller =
          container.read(loanSettleControllerProvider.notifier);

      final success = await controller.settleLoan(loanId: 103);

      expect(success, isFalse);
      final state = container.read(loanSettleControllerProvider);
      expect(state, isA<LoanSettleError>());
      expect((state as LoanSettleError).message, contains('Erreur lors du règlement final'));
    });
  });
}

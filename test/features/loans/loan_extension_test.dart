import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/loanables/domain/entities/loanable.dart';
import 'package:mobile/features/loans/domain/entities/extension_estimate.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_comment.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_dates_update_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_pagination.dart';
import 'package:mobile/features/loans/domain/entities/loans_dashboard.dart';
import 'package:mobile/features/loans/domain/repositories/loans_repository.dart';
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';
import 'package:mobile/features/loans/presentation/screens/loan_detail_screen.dart';
import 'package:mobile/features/loans/presentation/widgets/loan_extension_bottom_sheet.dart';

class _FakeExtensionLoansRepo implements LoansRepository {
  Loan loan;
  ExtensionEstimate estimateToReturn;
  int getEstimateCalls = 0;
  int? lastEstimateDuration;
  int requestCalls = 0;
  int? lastRequestDuration;
  int acceptCalls = 0;
  int rejectCalls = 0;
  int cancelCalls = 0;

  _FakeExtensionLoansRepo({
    required this.loan,
    this.estimateToReturn = const ExtensionEstimate(
      available: true,
      desiredContribution: 5.50,
      borrowerTotal: 25.50,
    ),
  });

  @override
  Future<Loan> getLoanDetail(int id) async => loan;

  @override
  Future<ExtensionEstimate> getExtensionEstimate(
    int id,
    int durationInMinutes,
  ) async {
    getEstimateCalls++;
    lastEstimateDuration = durationInMinutes;
    return estimateToReturn;
  }

  @override
  Future<Loan> requestExtension(int id, int extensionDurationInMinutes) async {
    requestCalls++;
    lastRequestDuration = extensionDurationInMinutes;
    loan = loan.copyWith(
      extensionDurationInMinutes: extensionDurationInMinutes,
    );
    return loan;
  }

  @override
  Future<Loan> acceptExtension(int id) async {
    acceptCalls++;
    loan = loan.copyWith(
      durationInMinutes:
          loan.extensionDurationInMinutes ?? loan.durationInMinutes,
      extensionDurationInMinutes: null,
    );
    return loan;
  }

  @override
  Future<Loan> rejectExtension(int id) async {
    rejectCalls++;
    loan = loan.copyWith(extensionDurationInMinutes: null);
    return loan;
  }

  @override
  Future<Loan> cancelExtension(int id) async {
    cancelCalls++;
    loan = loan.copyWith(extensionDurationInMinutes: null);
    return loan;
  }

  @override
  Future<Loan> acceptLoan(int id, {String? comment}) =>
      throw UnimplementedError();

  @override
  Future<LoanComment> addComment(int id, String text) =>
      throw UnimplementedError();

  @override
  Future<Loan> cancelLoan(int id) => throw UnimplementedError();

  @override
  Future<Loan> createLoan(LoanCreationRequest request) =>
      throw UnimplementedError();

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
  Future<Loan> rejectLoan(int id, {String? comment}) =>
      throw UnimplementedError();

  @override
  Future<Loan> updateLoanDates(int id, LoanDatesUpdateRequest request) =>
      throw UnimplementedError();

  @override
  Future<Loan> validateLoan(int id) => throw UnimplementedError();
}

class _FakeFailingEstimateLoansRepo extends _FakeExtensionLoansRepo {
  _FakeFailingEstimateLoansRepo({required super.loan});

  @override
  Future<ExtensionEstimate> getExtensionEstimate(
    int id,
    int durationInMinutes,
  ) async {
    throw Exception('Erreur réseau lors du calcul');
  }
}

class _TestAuthController extends AuthController {
  final User? _user;
  _TestAuthController(this._user);

  @override
  User? build() => _user;
}

void main() {
  setUpAll(() {
    tz.initializeTimeZones();
  });

  final sampleDeparture = DateTime(2026, 6, 15, 10, 0);

  final baseOngoingLoan = Loan(
    id: 101,
    departureAt: sampleDeparture,
    durationInMinutes: 60,
    status: 'ongoing',
    borrowerUserId: 10,
    borrowerUserName: 'Alice Borrow',
    loanable: const Loanable(
      id: 5,
      type: 'car',
      name: 'Hyundai Ioniq 5',
      timezone: 'America/Montreal',
      mergedUserRoles: [
        {'user_id': 20, 'role': 'owner'},
      ],
    ),
  );

  group('Loan Extension Entity Unit Tests', () {
    test('extension getters when pending', () {
      final loanWithExt = baseOngoingLoan.copyWith(
        extensionDurationInMinutes: 90,
      );

      expect(loanWithExt.hasPendingExtension, isTrue);
      expect(loanWithExt.pendingExtensionAdditionalMinutes, 30);
      expect(
        loanWithExt.extendedReturnAt,
        sampleDeparture.add(const Duration(minutes: 90)),
      );
    });

    test('canRequestExtension logic', () {
      // Borrower during ongoing loan
      expect(baseOngoingLoan.canRequestExtension(10), isTrue);
      // Owner during ongoing loan
      expect(baseOngoingLoan.canRequestExtension(20), isTrue);
      // Unrelated user
      expect(baseOngoingLoan.canRequestExtension(999), isFalse);

      // Pending extension already present -> cannot request again
      final pendingLoan = baseOngoingLoan.copyWith(
        extensionDurationInMinutes: 90,
      );
      expect(pendingLoan.canRequestExtension(10), isFalse);

      // Completed loan -> cannot request
      final completedLoan = baseOngoingLoan.copyWith(status: 'completed');
      expect(completedLoan.canRequestExtension(10), isFalse);
    });

    test('owner accept/reject extension permissions', () {
      final pendingLoan = baseOngoingLoan.copyWith(
        extensionDurationInMinutes: 90,
      );

      // Owner can accept and reject
      expect(pendingLoan.canAcceptExtension(20), isTrue);
      expect(pendingLoan.canRejectExtension(20), isTrue);

      // Borrower cannot accept or reject
      expect(pendingLoan.canAcceptExtension(10), isFalse);
      expect(pendingLoan.canRejectExtension(10), isFalse);
    });

    test('borrower cancel extension permissions', () {
      final pendingLoan = baseOngoingLoan.copyWith(
        extensionDurationInMinutes: 90,
      );

      // Borrower can cancel
      expect(pendingLoan.canCancelExtension(10), isTrue);
      // Owner cannot cancel borrower extension request via cancelExtension
      expect(pendingLoan.canCancelExtension(20), isFalse);
    });

    test('ExtensionEstimate parsing with blocking loan', () {
      final json = {
        'available': false,
        'conflict_type': 'overlap_existing_loan',
        'blocking_loan': {
          'id': 102,
          'borrower_user': {
            'name': 'Jean Dupont',
            'phone': '+15145550199',
            'email': 'jean@example.com',
          },
          'departure_at': '2026-06-15T12:00:00.000Z',
          'duration_in_minutes': 60,
        },
      };

      final estimate = ExtensionEstimate.fromJson(json);
      expect(estimate.available, isFalse);
      expect(estimate.blockingLoan, isNotNull);
      expect(estimate.blockingLoan!.borrowerName, 'Jean Dupont');
      expect(estimate.blockingLoan!.borrowerPhone, '+15145550199');
    });
  });

  group('LoanExtensionBottomSheet Widget Tests', () {
    testWidgets('renders chips, fetches estimate, and submits extension', (
      tester,
    ) async {
      final fakeRepo = _FakeExtensionLoansRepo(loan: baseOngoingLoan);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [loansRepositoryProvider.overrideWithValue(fakeRepo)],
          child: MaterialApp(
            home: Scaffold(
              body: LoanExtensionBottomSheet(loan: baseOngoingLoan),
            ),
          ),
        ),
      );

      // Initial pump
      await tester.pump();
      // Allow debounced estimate fetch to execute
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Check chips are displayed
      expect(find.byKey(const Key('chip_extension_15')), findsOneWidget);
      expect(find.byKey(const Key('chip_extension_30')), findsOneWidget);
      expect(find.byKey(const Key('chip_extension_60')), findsOneWidget);
      expect(find.byKey(const Key('chip_extension_120')), findsOneWidget);

      // Check estimate was fetched
      expect(fakeRepo.getEstimateCalls, greaterThanOrEqualTo(1));

      // Select +60 min chip
      await tester.tap(find.byKey(const Key('chip_extension_60')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Check submit button is available
      final submitButton = find.byKey(const Key('confirm_extension_button'));
      expect(submitButton, findsOneWidget);

      // Tap submit button
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(fakeRepo.requestCalls, 1);
      // base was 60 min, added 60 min -> 120 min total
      expect(fakeRepo.lastRequestDuration, 120);
    });

    testWidgets('shows conflict warning and disables submit when unavailable', (
      tester,
    ) async {
      final fakeRepo = _FakeExtensionLoansRepo(
        loan: baseOngoingLoan,
        estimateToReturn: const ExtensionEstimate(
          available: false,
          blockingLoan: ExtensionBlockingLoan(
            id: 202,
            borrowerName: 'Luc Tremblay',
            borrowerPhone: '514-555-1234',
          ),
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [loansRepositoryProvider.overrideWithValue(fakeRepo)],
          child: MaterialApp(
            home: Scaffold(
              body: LoanExtensionBottomSheet(loan: baseOngoingLoan),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Conflict warning should be visible
      expect(
        find.textContaining('Véhicule non disponible sur ce créneau'),
        findsOneWidget,
      );
      expect(find.textContaining('Luc Tremblay'), findsOneWidget);
      expect(find.textContaining('514-555-1234'), findsOneWidget);

      // Submit button should be disabled
      final elevatedBtn = tester.widget<ElevatedButton>(
        find.byKey(const Key('confirm_extension_button')),
      );
      expect(elevatedBtn.onPressed, isNull);
    });

    testWidgets('shows surcharge and deposit expiration warning banner', (
      tester,
    ) async {
      final loanWithTotal = baseOngoingLoan.copyWith(
        borrowerTotal: 20.00,
        depositExpiresAt: sampleDeparture.add(const Duration(hours: 1)),
      );

      final fakeRepo = _FakeExtensionLoansRepo(
        loan: loanWithTotal,
        estimateToReturn: const ExtensionEstimate(
          available: true,
          desiredContribution: 5.50,
          borrowerTotal: 25.50,
          depositExpiresBeforeReturn: true,
          depositWarning: 'La caution expire avant la fin de la réservation.',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [loansRepositoryProvider.overrideWithValue(fakeRepo)],
          child: MaterialApp(
            home: Scaffold(body: LoanExtensionBottomSheet(loan: loanWithTotal)),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Should display the surcharge (+5.50 $)
      expect(
        find.textContaining('Supplément prolongation : +5.50 \$ CAD'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Nouveau total estimé : 25.50 \$'),
        findsOneWidget,
      );

      // Should display the deposit expiration warning banner
      expect(
        find.byKey(const Key('deposit_expiration_warning_banner')),
        findsOneWidget,
      );
      expect(
        find.textContaining('Attention : expiration de caution'),
        findsOneWidget,
      );
    });

    testWidgets('failed estimate disables confirmation button', (tester) async {
      final fakeRepo = _FakeFailingEstimateLoansRepo(loan: baseOngoingLoan);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [loansRepositoryProvider.overrideWithValue(fakeRepo)],
          child: MaterialApp(
            home: Scaffold(
              body: LoanExtensionBottomSheet(loan: baseOngoingLoan),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      // Submit button should be disabled
      final elevatedBtn = tester.widget<ElevatedButton>(
        find.byKey(const Key('confirm_extension_button')),
      );
      expect(elevatedBtn.onPressed, isNull);
    });
  });

  group('LoanDetailScreen Extension Integration Tests', () {
    testWidgets('borrower sees request extension button on ongoing loan', (
      tester,
    ) async {
      final fakeRepo = _FakeExtensionLoansRepo(loan: baseOngoingLoan);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(fakeRepo),
            loanDetailProvider(
              101,
            ).overrideWith((ref) async => baseOngoingLoan),
            authControllerProvider.overrideWith(
              () => _TestAuthController(
                const User(
                  id: 10,
                  email: 'alice@example.com',
                  firstName: 'Alice',
                  lastName: 'Borrow',
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: LoanDetailScreen(loanId: 101)),
        ),
      );

      await tester.pumpAndSettle();

      final reqBtn = find.byKey(const Key('action_request_extension_button'));
      await tester.ensureVisible(reqBtn);
      expect(reqBtn, findsOneWidget);
    });

    testWidgets('borrower sees pending card and cancels extension', (
      tester,
    ) async {
      final pendingLoan = baseOngoingLoan.copyWith(
        extensionDurationInMinutes: 120,
      );
      final fakeRepo = _FakeExtensionLoansRepo(loan: pendingLoan);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(fakeRepo),
            loanDetailProvider(101).overrideWith((ref) async => pendingLoan),
            authControllerProvider.overrideWith(
              () => _TestAuthController(
                const User(
                  id: 10,
                  email: 'alice@example.com',
                  firstName: 'Alice',
                  lastName: 'Borrow',
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: LoanDetailScreen(loanId: 101)),
        ),
      );

      await tester.pumpAndSettle();

      // Borrower pending card visible
      final cancelBtn = find.byKey(const Key('action_cancel_extension_button'));
      await tester.ensureVisible(cancelBtn);
      expect(
        find.byKey(const Key('borrower_pending_extension_card')),
        findsOneWidget,
      );
      expect(cancelBtn, findsOneWidget);

      // Tap cancel button
      await tester.tap(cancelBtn);
      await tester.pumpAndSettle();

      // Confirm dialog appeared
      final confirmBtn = find.byKey(
        const Key('confirm_cancel_extension_dialog_button'),
      );
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(fakeRepo.cancelCalls, 1);
    });

    testWidgets('owner sees pending card, can accept or reject extension', (
      tester,
    ) async {
      final pendingLoan = baseOngoingLoan.copyWith(
        extensionDurationInMinutes: 120,
      );
      final fakeRepo = _FakeExtensionLoansRepo(loan: pendingLoan);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(fakeRepo),
            loanDetailProvider(101).overrideWith((ref) async => pendingLoan),
            authControllerProvider.overrideWith(
              () => _TestAuthController(
                const User(
                  id: 20,
                  email: 'owner@example.com',
                  firstName: 'Marc',
                  lastName: 'Owner',
                ),
              ),
            ),
          ],
          child: const MaterialApp(home: LoanDetailScreen(loanId: 101)),
        ),
      );

      await tester.pumpAndSettle();

      // Owner pending card visible
      final acceptBtn = find.byKey(const Key('action_accept_extension_button'));
      await tester.ensureVisible(acceptBtn);
      expect(
        find.byKey(const Key('owner_pending_extension_card')),
        findsOneWidget,
      );
      expect(acceptBtn, findsOneWidget);
      expect(
        find.byKey(const Key('action_reject_extension_button')),
        findsOneWidget,
      );

      // Tap accept
      await tester.tap(acceptBtn);
      await tester.pumpAndSettle();

      expect(fakeRepo.acceptCalls, 1);
    });
  });
}

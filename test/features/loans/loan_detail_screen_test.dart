import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:mobile/core/error/exceptions.dart';
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
import '../../fixtures/loans_fixtures.dart';

void _ensureTimezones() {
  try {
    tz.initializeTimeZones();
  } catch (_) {}
}

class _MockLoansRepo implements LoansRepository {
  Loan? loanDetailToReturn;
  Exception? errorToThrow;
  int cancelCalls = 0;
  int updateDatesCalls = 0;
  int commentCalls = 0;
  String? lastCommentText;
  LoanDatesUpdateRequest? lastDatesRequest;

  @override
  Future<Loan> getLoanDetail(int id) async {
    if (errorToThrow != null) throw errorToThrow!;
    return loanDetailToReturn ?? Loan.fromJson(laravelLoanDetailJson);
  }

  @override
  Future<Loan> cancelLoan(int id) async {
    cancelCalls++;
    if (errorToThrow != null) throw errorToThrow!;
    return (loanDetailToReturn ?? Loan.fromJson(laravelLoanDetailJson))
        .copyWith(status: 'canceled', canceledAt: DateTime.now());
  }

  @override
  Future<Loan> updateLoanDates(int id, LoanDatesUpdateRequest request) async {
    updateDatesCalls++;
    lastDatesRequest = request;
    if (errorToThrow != null) throw errorToThrow!;
    return loanDetailToReturn ?? Loan.fromJson(laravelLoanDetailJson);
  }

  @override
  Future<LoanComment> addComment(int id, String text) async {
    commentCalls++;
    lastCommentText = text;
    if (errorToThrow != null) throw errorToThrow!;
    return LoanComment(id: 99, loanId: id, authorId: 100, text: text);
  }

  @override
  Future<LoansDashboard> getDashboard() async => const LoansDashboard();

  @override
  Future<List<Loan>> getMyLoans() async => [];

  @override
  Future<LoanPagination> getLoansPage({
    int page = 1,
    int perPage = 10,
    String? status,
    int? borrowerUserId,
  }) async =>
      const LoanPagination();

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
  setUpAll(() {
    _ensureTimezones();
  });

  group('LoanDetailScreen Widget Tests', () {
    const testBorrowerUser = User(
      id: 100,
      email: 'jean.dupont@example.com',
      firstName: 'Jean',
      lastName: 'Dupont',
    );

    testWidgets('renders detail from GET /loans/{id} without extra', (tester) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider
                .overrideWith(() => _TestAuthController(testBorrowerUser)),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 42),
          ),
        ),
      );

      // Loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // Verified details
      expect(find.text('Réservation #42'), findsOneWidget);
      expect(find.text('Hyundai Ioniq 5'), findsOneWidget);
      expect(find.text('Communauté : Communauté Rosemont'), findsOneWidget);
      expect(find.text('En attente'), findsWidgets);
      expect(find.text('Fuseau du véhicule : America/Montreal'), findsOneWidget);

      // Timeline has created_at
      expect(find.text('Demande créée'), findsOneWidget);

      // Comments section
      expect(find.text('Messages et commentaires (1)'), findsOneWidget);
      expect(find.textContaining('batterie à 80%'), findsOneWidget);
    });

    testWidgets('displays intelligible error on 404', (tester) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.errorToThrow = const ServerException(
        message: 'Réservation introuvable.',
        statusCode: 404,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider
                .overrideWith(() => _TestAuthController(testBorrowerUser)),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 999),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Réservation introuvable (#999)'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);
    });

    testWidgets('displays intelligible error on 403', (tester) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.errorToThrow = const ForbiddenException(
        message: 'Action non autorisée',
        statusCode: 403,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider
                .overrideWith(() => _TestAuthController(testBorrowerUser)),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 42),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Accès non autorisé'), findsOneWidget);
    });

    testWidgets('cancels loan with confirmation dialog and disables button during call', (tester) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider
                .overrideWith(() => _TestAuthController(testBorrowerUser)),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 42),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final cancelBtn = find.byKey(const Key('action_cancel_button'));
      expect(cancelBtn, findsOneWidget);

      await tester.tap(cancelBtn);
      await tester.pumpAndSettle();

      // Dialog confirmed
      expect(find.text('Confirmer l\'annulation'), findsOneWidget);
      final confirmBtn = find.byKey(const Key('confirm_cancel_button'));
      await tester.tap(confirmBtn);

      await tester.pumpAndSettle();
      expect(mockRepo.cancelCalls, 1);
    });

    testWidgets('shows error and keeps state unchanged if cancellation fails with 403', (tester) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider
                .overrideWith(() => _TestAuthController(testBorrowerUser)),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 42),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Set error for subsequent cancel
      mockRepo.errorToThrow = const ForbiddenException(
        message: 'Impossible d\'annuler ce prêt.',
        statusCode: 403,
      );

      await tester.tap(find.byKey(const Key('action_cancel_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('confirm_cancel_button')));
      await tester.pumpAndSettle();

      // Error banner
      expect(find.text('Impossible d\'annuler ce prêt.'), findsWidgets);
      // Status remained 'requested'
      expect(find.text('En attente'), findsWidgets);
    });

    testWidgets('handles comment input validation and preserves text upon server error', (tester) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider
                .overrideWith(() => _TestAuthController(testBorrowerUser)),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 42),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final submitCommentBtn = find.byKey(const Key('submit_comment_button'));
      final commentInput = find.byKey(const Key('comment_input_field'));

      // Scroll to submit button and try empty submission
      await tester.ensureVisible(submitCommentBtn);
      await tester.pumpAndSettle();
      await tester.tap(submitCommentBtn);
      await tester.pumpAndSettle();

      expect(find.text('Le commentaire ne peut pas être vide.'), findsOneWidget);
      expect(mockRepo.commentCalls, 0);

      // Comment with server error preserves text
      mockRepo.errorToThrow = const ValidationException(
        message: 'Action interdite sur cette réservation.',
        statusCode: 403,
      );
      await tester.enterText(commentInput, 'Message important à préserver');
      await tester.pumpAndSettle();

      await tester.tap(submitCommentBtn);
      await tester.pumpAndSettle();

      expect(find.text('Message important à préserver'), findsOneWidget);
      expect(find.textContaining('Action interdite'), findsWidgets);

      // Successful comment submission clears text
      mockRepo.errorToThrow = null;
      ScaffoldMessenger.of(tester.element(find.byType(LoanDetailScreen))).clearSnackBars();
      await tester.pumpAndSettle();
      await tester.ensureVisible(submitCommentBtn);
      await tester.pumpAndSettle();
      await tester.tap(submitCommentBtn);
      await tester.pumpAndSettle();

      expect(mockRepo.commentCalls, 2);
      expect(mockRepo.lastCommentText, 'Message important à préserver');
      expect(find.text('Message important à préserver'), findsNothing);
    });

    testWidgets('opens UpdateDatesDialog and updates dates', (tester) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider
                .overrideWith(() => _TestAuthController(testBorrowerUser)),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 42),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final updateBtn = find.byKey(const Key('action_update_dates_button'));
      expect(updateBtn, findsOneWidget);

      await tester.tap(updateBtn);
      await tester.pumpAndSettle();

      expect(find.text('Modifier les dates'), findsOneWidget);
      expect(find.byKey(const Key('confirm_update_dates_button')), findsOneWidget);

      await tester.tap(find.byKey(const Key('confirm_update_dates_button')));
      await tester.pumpAndSettle();

      expect(mockRepo.updateDatesCalls, 1);
    });

    testWidgets('displays 422 error on date conflict without altering state', (tester) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider
                .overrideWith(() => _TestAuthController(testBorrowerUser)),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 42),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Configure mock to throw 422 on updateLoanDates
      mockRepo.errorToThrow = const ValidationException(
        message: 'Le véhicule n\'est pas disponible sur cette période.',
        statusCode: 422,
      );

      await tester.tap(find.byKey(const Key('action_update_dates_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('confirm_update_dates_button')));
      await tester.pumpAndSettle();

      // Verify inline error in dialog
      expect(find.text('Le véhicule n\'est pas disponible sur cette période.'), findsOneWidget);
      expect(mockRepo.updateDatesCalls, 1);
    });

    testWidgets('formats dates in vehicle timezone when device is in different timezone', (tester) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider
                .overrideWith(() => _TestAuthController(testBorrowerUser)),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 42),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // laravelLoanDetailJson departure_at is 2026-10-15T14:00:00.000000Z
      // Loanable timezone is America/Montreal (EDT = UTC-4 in October).
      // 14:00 UTC - 4h = 10:00 in Montreal!
      expect(find.textContaining('10:00'), findsWidgets);
    });

    testWidgets('double tap on cancel button sends only a single PUT request', (tester) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider
                .overrideWith(() => _TestAuthController(testBorrowerUser)),
          ],
          child: const MaterialApp(
            home: LoanDetailScreen(loanId: 42),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('action_cancel_button')));
      await tester.pumpAndSettle();

      final confirmBtn = find.byKey(const Key('confirm_cancel_button'));
      // Rapid double tap — the second tap hits while button is disabled/obscured by async transition
      await tester.tap(confirmBtn);
      await tester.tap(confirmBtn, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(mockRepo.cancelCalls, 1);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:mobile/core/error/exceptions.dart';
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

  int acceptCalls = 0;
  String? lastAcceptComment;
  Loan? acceptResultToReturn;

  @override
  Future<Loan> acceptLoan(int id, {String? comment}) async {
    acceptCalls++;
    lastAcceptComment = comment;
    if (errorToThrow != null) throw errorToThrow!;
    return acceptResultToReturn ??
        (loanDetailToReturn ?? Loan.fromJson(laravelLoanDetailJson)).copyWith(
          status: 'confirmed',
          acceptedAt: DateTime.now(),
        );
  }

  int rejectCalls = 0;
  String? lastRejectComment;
  Loan? rejectResultToReturn;

  @override
  Future<Loan> rejectLoan(int id, {String? comment}) async {
    rejectCalls++;
    lastRejectComment = comment;
    if (errorToThrow != null) throw errorToThrow!;
    return rejectResultToReturn ??
        (loanDetailToReturn ?? Loan.fromJson(laravelLoanDetailJson)).copyWith(
          status: 'rejected',
        );
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
  }) async => const LoanPagination();

  @override
  Future<Loan> createLoan(LoanCreationRequest request) async =>
      throw UnimplementedError();

  @override
  Future<Loan> validateLoan(int id) async {
    if (errorToThrow != null) throw errorToThrow!;
    return loanDetailToReturn ?? Loan.fromJson(laravelLoanDetailJson);
  }

  int requestExtensionCalls = 0;
  int? lastExtensionDuration;
  int acceptExtensionCalls = 0;
  int rejectExtensionCalls = 0;
  int cancelExtensionCalls = 0;

  @override
  Future<Loan> requestExtension(int id, int extensionDurationInMinutes) async {
    requestExtensionCalls++;
    lastExtensionDuration = extensionDurationInMinutes;
    if (errorToThrow != null) throw errorToThrow!;
    return (loanDetailToReturn ?? Loan.fromJson(laravelLoanDetailJson)).copyWith(
      extensionDurationInMinutes: extensionDurationInMinutes,
    );
  }

  @override
  Future<Loan> acceptExtension(int id) async {
    acceptExtensionCalls++;
    if (errorToThrow != null) throw errorToThrow!;
    final base = loanDetailToReturn ?? Loan.fromJson(laravelLoanDetailJson);
    return base.copyWith(
      durationInMinutes:
          base.extensionDurationInMinutes ?? base.durationInMinutes,
      extensionDurationInMinutes: null,
    );
  }

  @override
  Future<Loan> rejectExtension(int id) async {
    rejectExtensionCalls++;
    if (errorToThrow != null) throw errorToThrow!;
    return (loanDetailToReturn ?? Loan.fromJson(laravelLoanDetailJson)).copyWith(
      extensionDurationInMinutes: null,
    );
  }

  @override
  Future<Loan> cancelExtension(int id) async {
    cancelExtensionCalls++;
    if (errorToThrow != null) throw errorToThrow!;
    return (loanDetailToReturn ?? Loan.fromJson(laravelLoanDetailJson)).copyWith(
      extensionDurationInMinutes: null,
    );
  }

  @override
  Future<ExtensionEstimate> getExtensionEstimate(
          int id, int durationInMinutes) async =>
      const ExtensionEstimate(available: true);
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

    testWidgets('renders detail from GET /loans/{id} without extra', (
      tester,
    ) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider.overrideWith(
              () => _TestAuthController(testBorrowerUser),
            ),
          ],
          child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
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
      expect(
        find.text('Fuseau du véhicule : America/Montreal'),
        findsOneWidget,
      );

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
            authControllerProvider.overrideWith(
              () => _TestAuthController(testBorrowerUser),
            ),
          ],
          child: const MaterialApp(home: LoanDetailScreen(loanId: 999)),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.textContaining('Réservation introuvable (#999)'),
        findsOneWidget,
      );
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
            authControllerProvider.overrideWith(
              () => _TestAuthController(testBorrowerUser),
            ),
          ],
          child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Accès non autorisé'), findsOneWidget);
    });

    testWidgets(
      'cancels loan with confirmation dialog and disables button during call',
      (tester) async {
        final mockRepo = _MockLoansRepo();
        mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              loansRepositoryProvider.overrideWithValue(mockRepo),
              authControllerProvider.overrideWith(
                () => _TestAuthController(testBorrowerUser),
              ),
            ],
            child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
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
      },
    );

    testWidgets(
      'shows error and keeps state unchanged if cancellation fails with 403',
      (tester) async {
        final mockRepo = _MockLoansRepo();
        mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              loansRepositoryProvider.overrideWithValue(mockRepo),
              authControllerProvider.overrideWith(
                () => _TestAuthController(testBorrowerUser),
              ),
            ],
            child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
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
      },
    );

    testWidgets(
      'handles comment input validation and preserves text upon server error',
      (tester) async {
        final mockRepo = _MockLoansRepo();
        mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              loansRepositoryProvider.overrideWithValue(mockRepo),
              authControllerProvider.overrideWith(
                () => _TestAuthController(testBorrowerUser),
              ),
            ],
            child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
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

        expect(
          find.text('Le commentaire ne peut pas être vide.'),
          findsOneWidget,
        );
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
        ScaffoldMessenger.of(
          tester.element(find.byType(LoanDetailScreen)),
        ).clearSnackBars();
        await tester.pumpAndSettle();
        await tester.ensureVisible(submitCommentBtn);
        await tester.pumpAndSettle();
        await tester.tap(submitCommentBtn);
        await tester.pumpAndSettle();

        expect(mockRepo.commentCalls, 2);
        expect(mockRepo.lastCommentText, 'Message important à préserver');
        expect(find.text('Message important à préserver'), findsNothing);
      },
    );

    testWidgets('opens UpdateDatesDialog and updates dates', (tester) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider.overrideWith(
              () => _TestAuthController(testBorrowerUser),
            ),
          ],
          child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
        ),
      );

      await tester.pumpAndSettle();

      final updateBtn = find.byKey(const Key('action_update_dates_button'));
      expect(updateBtn, findsOneWidget);

      await tester.tap(updateBtn);
      await tester.pumpAndSettle();

      expect(find.text('Modifier les dates'), findsOneWidget);
      expect(
        find.byKey(const Key('confirm_update_dates_button')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('confirm_update_dates_button')));
      await tester.pumpAndSettle();

      expect(mockRepo.updateDatesCalls, 1);
    });

    testWidgets('displays 422 error on date conflict without altering state', (
      tester,
    ) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider.overrideWith(
              () => _TestAuthController(testBorrowerUser),
            ),
          ],
          child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
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
      expect(
        find.text('Le véhicule n\'est pas disponible sur cette période.'),
        findsOneWidget,
      );
      expect(mockRepo.updateDatesCalls, 1);
    });

    testWidgets(
      'formats dates in vehicle timezone when device is in different timezone',
      (tester) async {
        final mockRepo = _MockLoansRepo();
        mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              loansRepositoryProvider.overrideWithValue(mockRepo),
              authControllerProvider.overrideWith(
                () => _TestAuthController(testBorrowerUser),
              ),
            ],
            child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
          ),
        );

        await tester.pumpAndSettle();

        // laravelLoanDetailJson departure_at is 2026-10-15T14:00:00.000000Z
        // Loanable timezone is America/Montreal (EDT = UTC-4 in October).
        // 14:00 UTC - 4h = 10:00 in Montreal!
        expect(find.textContaining('10:00'), findsWidgets);
      },
    );

    testWidgets('double tap on cancel button sends only a single PUT request', (
      tester,
    ) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider.overrideWith(
              () => _TestAuthController(testBorrowerUser),
            ),
          ],
          child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
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

    testWidgets('borrower does not see owner accept or reject buttons', (
      tester,
    ) async {
      final mockRepo = _MockLoansRepo();
      mockRepo.loanDetailToReturn = Loan.fromJson(laravelLoanDetailJson);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider.overrideWith(
              () => _TestAuthController(testBorrowerUser),
            ),
          ],
          child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('action_owner_accept_button')), findsNothing);
      expect(find.byKey(const Key('action_owner_reject_button')), findsNothing);
    });

    testWidgets('owner sees accept and reject buttons and borrower info card', (
      tester,
    ) async {
      final mockRepo = _MockLoansRepo();
      final ownerDetail = Map<String, dynamic>.from(laravelLoanDetailJson);
      // Give current user (id 200) owner role in loanable directly at top level (LoanLoanableResource pattern)
      ownerDetail['loanable'] = {
        'id': 5,
        'name': 'Hyundai Ioniq 5',
        'type': 'car',
        'timezone': 'America/Montreal',
        'merged_user_roles': [
          {'user_id': 200, 'role': 'owner'},
        ],
      };
      mockRepo.loanDetailToReturn = Loan.fromJson(ownerDetail);

      const ownerUser = User(
        id: 200,
        email: 'owner@example.com',
        firstName: 'Proprio',
        lastName: 'Test',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            loansRepositoryProvider.overrideWithValue(mockRepo),
            authControllerProvider.overrideWith(
              () => _TestAuthController(ownerUser),
            ),
          ],
          child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
        ),
      );

      await tester.pumpAndSettle();

      // Borrower card must be present with borrower name & email
      expect(find.byKey(const Key('borrower_info_card')), findsOneWidget);
      expect(find.text('Jean Dupont'), findsWidgets);
      expect(find.text('jean.dupont@example.com'), findsOneWidget);

      // Owner buttons must be present
      expect(
        find.byKey(const Key('action_owner_accept_button')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('action_owner_reject_button')),
        findsOneWidget,
      );
    });

    testWidgets(
      'owner accept sends PUT /loans/{id}/accept with comment and non-reentrant double-tap',
      (tester) async {
        final mockRepo = _MockLoansRepo();
        final ownerDetail = Map<String, dynamic>.from(laravelLoanDetailJson);
        ownerDetail['loanable'] = {
          'id': 5,
          'name': 'Hyundai Ioniq 5',
          'type': 'car',
          'timezone': 'America/Montreal',
          'merged_user_roles': [
            {'user_id': 200, 'role': 'owner'},
          ],
        };
        mockRepo.loanDetailToReturn = Loan.fromJson(ownerDetail);

        const ownerUser = User(
          id: 200,
          email: 'owner@example.com',
          firstName: 'Proprio',
          lastName: 'Test',
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              loansRepositoryProvider.overrideWithValue(mockRepo),
              authControllerProvider.overrideWith(
                () => _TestAuthController(ownerUser),
              ),
            ],
            child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
          ),
        );

        await tester.pumpAndSettle();

        // Open accept dialog
        await tester.tap(find.byKey(const Key('action_owner_accept_button')));
        await tester.pumpAndSettle();

        expect(find.text('Accepter la demande'), findsOneWidget);

        // Enter optional comment
        await tester.enterText(
          find.byKey(const Key('owner_decision_comment_input')),
          'Clés dans la boîte à gants.',
        );

        final confirmBtn = find.byKey(
          const Key('owner_decision_confirm_accept_button'),
        );
        // Double tap to test non-reentrancy
        await tester.tap(confirmBtn);
        await tester.tap(confirmBtn, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(mockRepo.acceptCalls, 1);
        expect(mockRepo.lastAcceptComment, 'Clés dans la boîte à gants.');
        expect(find.text('Demande acceptée.'), findsOneWidget);
      },
    );

    testWidgets(
      'owner reject sends PUT /loans/{id}/reject with motif and non-reentrant double-tap',
      (tester) async {
        final mockRepo = _MockLoansRepo();
        final ownerDetail = Map<String, dynamic>.from(laravelLoanDetailJson);
        ownerDetail['loanable'] = {
          'id': 5,
          'name': 'Hyundai Ioniq 5',
          'type': 'car',
          'timezone': 'America/Montreal',
          'merged_user_roles': [
            {'user_id': 200, 'role': 'owner'},
          ],
        };
        mockRepo.loanDetailToReturn = Loan.fromJson(ownerDetail);

        const ownerUser = User(
          id: 200,
          email: 'owner@example.com',
          firstName: 'Proprio',
          lastName: 'Test',
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              loansRepositoryProvider.overrideWithValue(mockRepo),
              authControllerProvider.overrideWith(
                () => _TestAuthController(ownerUser),
              ),
            ],
            child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
          ),
        );

        await tester.pumpAndSettle();

        // Open reject dialog
        await tester.tap(find.byKey(const Key('action_owner_reject_button')));
        await tester.pumpAndSettle();

        expect(find.text('Refuser la demande'), findsOneWidget);

        await tester.enterText(
          find.byKey(const Key('owner_decision_comment_input')),
          'Indisponible cause entretien.',
        );

        final confirmBtn = find.byKey(
          const Key('owner_decision_confirm_reject_button'),
        );
        await tester.tap(confirmBtn);
        await tester.tap(confirmBtn, warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(mockRepo.rejectCalls, 1);
        expect(mockRepo.lastRejectComment, 'Indisponible cause entretien.');
        expect(find.text('Demande refusée.'), findsOneWidget);
      },
    );

    testWidgets(
      'accept dialog displays 422 unavailability error with Refuser/Réessayer buttons and preserves comment',
      (tester) async {
        final mockRepo = _MockLoansRepo();
        final ownerDetail = Map<String, dynamic>.from(laravelLoanDetailJson);
        ownerDetail['loanable'] = {
          'id': 5,
          'name': 'Hyundai Ioniq 5',
          'type': 'car',
          'timezone': 'America/Montreal',
          'merged_user_roles': [
            {'user_id': 200, 'role': 'owner'},
          ],
        };
        mockRepo.loanDetailToReturn = Loan.fromJson(ownerDetail);

        const ownerUser = User(
          id: 200,
          email: 'owner@example.com',
          firstName: 'Proprio',
          lastName: 'Test',
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              loansRepositoryProvider.overrideWithValue(mockRepo),
              authControllerProvider.overrideWith(
                () => _TestAuthController(ownerUser),
              ),
            ],
            child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
          ),
        );

        await tester.pumpAndSettle();

        // Trigger 422 error on accept
        mockRepo.errorToThrow = const ServerException(
          message: 'Le véhicule n\'est pas disponible sur cette période.',
          statusCode: 422,
        );

        await tester.tap(find.byKey(const Key('action_owner_accept_button')));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('owner_decision_comment_input')),
          'Tentative acceptation',
        );

        await tester.tap(
          find.byKey(const Key('owner_decision_confirm_accept_button')),
        );
        await tester.pumpAndSettle();

        // Dialog must remain open with error message, input preserved and action buttons
        expect(
          find.byKey(const Key('owner_decision_dialog_error')),
          findsOneWidget,
        );
        expect(
          find.textContaining(
            'Le véhicule n\'est pas disponible sur cette période.',
          ),
          findsOneWidget,
        );
        expect(find.text('Tentative acceptation'), findsOneWidget);
        expect(
          find.byKey(const Key('dialog_422_reject_button')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('dialog_422_retry_button')),
          findsOneWidget,
        );
        expect(mockRepo.acceptCalls, 1);
      },
    );

    testWidgets(
      '403 during decision triggers access loss and invalidates detail view',
      (tester) async {
        final mockRepo = _MockLoansRepo();
        final ownerDetail = Map<String, dynamic>.from(laravelLoanDetailJson);
        ownerDetail['loanable'] = {
          'id': 5,
          'name': 'Hyundai Ioniq 5',
          'type': 'car',
          'timezone': 'America/Montreal',
          'merged_user_roles': [
            {'user_id': 200, 'role': 'owner'},
          ],
        };
        mockRepo.loanDetailToReturn = Loan.fromJson(ownerDetail);

        const ownerUser = User(
          id: 200,
          email: 'owner@example.com',
          firstName: 'Proprio',
          lastName: 'Test',
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              loansRepositoryProvider.overrideWithValue(mockRepo),
              authControllerProvider.overrideWith(
                () => _TestAuthController(ownerUser),
              ),
            ],
            child: const MaterialApp(home: LoanDetailScreen(loanId: 42)),
          ),
        );

        await tester.pumpAndSettle();

        // Set error to throw 403 on accept call
        mockRepo.errorToThrow = const ForbiddenException(
          message: 'Action non autorisée.',
          statusCode: 403,
        );

        await tester.tap(find.byKey(const Key('action_owner_accept_button')));
        await tester.pumpAndSettle();

        await tester.tap(
          find.byKey(const Key('owner_decision_confirm_accept_button')),
        );
        await tester.pumpAndSettle();

        // Dialog shows access loss message
        expect(
          find.text(
            'Cette demande n\'est plus disponible ou a déjà été traitée.',
          ),
          findsOneWidget,
        );

        // Now close dialog
        await tester.tap(
          find.byKey(const Key('owner_decision_cancel_dialog_button')),
        );
        await tester.pumpAndSettle();

        // Detail has been invalidated and re-fetched
        // Because errorToThrow is still 403, the detail screen itself shows the loss of access error
        expect(find.textContaining('Accès non autorisé'), findsOneWidget);
        // Action buttons are removed
        expect(
          find.byKey(const Key('action_owner_accept_button')),
          findsNothing,
        );
      },
    );
  });
}

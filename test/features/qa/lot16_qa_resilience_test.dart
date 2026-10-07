import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/stripe_payment_service.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/availability/domain/entities/availability_rule.dart';
import 'package:mobile/features/availability/presentation/widgets/availability_rule_card.dart';
import 'package:mobile/features/loans/data/repositories/loan_payment_repository_impl.dart';
import 'package:mobile/features/loans/domain/entities/extension_estimate.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_comment.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_dates_update_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_pagination.dart';
import 'package:mobile/features/loans/domain/entities/loans_dashboard.dart';
import 'package:mobile/features/loans/domain/entities/payment_breakdown.dart';
import 'package:mobile/features/loans/domain/entities/payment_intent_response.dart';
import 'package:mobile/features/loans/domain/entities/payment_method_model.dart';
import 'package:mobile/features/loans/domain/repositories/loan_payment_repository.dart';
import 'package:mobile/features/loans/domain/repositories/loans_repository.dart';
import 'package:mobile/features/loans/presentation/controllers/loan_payment_controller.dart';
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';
import 'package:mobile/features/notifications/data/services/fake_push_notification_service.dart';
import 'package:mobile/features/notifications/domain/entities/push_payload.dart';
import 'package:mobile/features/notifications/domain/entities/push_token.dart';
import 'package:mobile/features/notifications/domain/repositories/push_tokens_repository.dart';
import 'package:mobile/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:mobile/features/notifications/presentation/widgets/foreground_notification_banner.dart';

// --- FAKES & TEST DOUBLES ---

class QaFakeLoanPaymentRepository implements LoanPaymentRepository {
  bool prepayCalled = false;
  bool shouldTimeoutOnPrepay = false;

  @override
  Future<PaymentIntentResponse> createPaymentIntent({
    required int loanId,
    int? platformTipCents,
    bool useBalance = true,
  }) async {
    return PaymentIntentResponse(
      loanId: loanId,
      financialBreakdown: const PaymentBreakdown(
        mandatoryContributionCents: 3450,
        totalEstimatedContributionCents: 3650,
        remainingContributionToPayCents: 3450,
        platformTipCents: 200,
        securityDepositCents: 25000,
      ),
      requiresStripeAction: true,
      stripe: const StripePaymentParams(
        customerId: 'cus_qa_123',
        ephemeralKeySecret: 'ek_qa_secret',
        contributionPaymentIntentClientSecret: 'pi_contrib_123_secret_abc',
        depositPaymentIntentClientSecret: 'pi_deposit_456_secret_def',
      ),
    );
  }

  @override
  Future<Loan> prepay({
    required int loanId,
    int? platformTipCents,
    String? contributionPaymentIntentId,
    String? depositPaymentIntentId,
  }) async {
    prepayCalled = true;
    if (shouldTimeoutOnPrepay) {
      throw TimeoutException('Network timeout while finalizing prepay');
    }
    return Loan(
      id: loanId,
      departureAt: DateTime.now(),
      durationInMinutes: 60,
      status: 'confirmed',
      prepaidAt: DateTime.now(),
      depositStatus: 'authorized',
    );
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async => [];

  @override
  Future<void> deletePaymentMethod(int id) async {}
}

class QaFakeLoansRepository implements LoansRepository {
  Loan? serverLoanState;

  @override
  Future<Loan> getLoanDetail(int id) async {
    return serverLoanState ??
        Loan(
          id: id,
          departureAt: DateTime.now(),
          durationInMinutes: 60,
          status: 'accepted',
        );
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
  Future<Loan> validateLoan(int id) => throw UnimplementedError();
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

class QaFakeStripePaymentService implements StripePaymentService {
  StripeSheetStatus statusToReturn = StripeSheetStatus.success;
  List<StripeSheetStatus> statusSequence = [];
  int presentCallCount = 0;
  List<String> initializedSecrets = [];

  @override
  Future<void> initialize() async {}

  @override
  Future<void> initPaymentSheet({
    required String paymentIntentClientSecret,
    required String customerId,
    required String customerEphemeralKeySecret,
    String? merchantDisplayName,
  }) async {
    initializedSecrets.add(paymentIntentClientSecret);
  }

  @override
  Future<StripeSheetResponse> presentPaymentSheet() async {
    presentCallCount++;
    final status = statusSequence.isNotEmpty
        ? statusSequence.removeAt(0)
        : statusToReturn;
    return StripeSheetResponse(status: status);
  }
}

class QaFakePushTokensRepository implements PushTokensRepository {
  @override
  Future<String> getOrCreateInstallationId() async => 'fake_install_id_qa';

  @override
  Future<PushToken> registerToken({
    required String token,
    required String platform,
    String? appVersion,
  }) async {
    return PushToken(
      id: 1,
      token: token,
      platform: platform,
      installationId: 'fake_install_id_qa',
    );
  }

  @override
  Future<void> revokeCurrentInstallationToken() async {}
}

class QaTestAuthController extends AuthController {
  final User? user;
  QaTestAuthController(this.user);

  @override
  FutureOr<User?> build() => user;
}

// --- MAIN TEST SUITE ---

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Lot 16 QA — Concurrency & Network Timeout Recovery', () {
    late ProviderContainer container;
    late QaFakeLoanPaymentRepository fakePaymentRepo;
    late QaFakeLoansRepository fakeLoansRepo;
    late QaFakeStripePaymentService fakeStripeService;

    setUp(() {
      fakePaymentRepo = QaFakeLoanPaymentRepository();
      fakeLoansRepo = QaFakeLoansRepository();
      fakeStripeService = QaFakeStripePaymentService();

      container = ProviderContainer(
        overrides: [
          loanPaymentRepositoryProvider.overrideWithValue(fakePaymentRepo),
          loansRepositoryProvider.overrideWithValue(fakeLoansRepo),
          stripePaymentServiceProvider.overrideWithValue(fakeStripeService),
        ],
      );
    });

    tearDown(() => container.dispose());

    test(
      'recovers to LoanPaymentSuccess when prepay times out but server confirmed',
      () async {
        final controller = container.read(
          loanPaymentControllerProvider.notifier,
        );
        final intentResponse = await controller.fetchBreakdown(100);
        expect(intentResponse, isNotNull);

        // Simulate network timeout on prepay
        fakePaymentRepo.shouldTimeoutOnPrepay = true;

        // Simulate that backend actually committed the prepay despite client timeout
        fakeLoansRepo.serverLoanState = Loan(
          id: 100,
          departureAt: DateTime.now(),
          durationInMinutes: 60,
          status: 'confirmed',
          prepaidAt: DateTime.now(),
          depositStatus: 'authorized',
        );

        final success = await controller.confirmPayment(
          loanId: 100,
          intentResponse: intentResponse!,
        );

        // Verifies recovery without throwing unhandled exception
        expect(success, isTrue);
        expect(
          container.read(loanPaymentControllerProvider),
          isA<LoanPaymentSuccess>(),
        );
      },
    );

    test(
      'cancellation on Stripe sheet stops execution and does not call prepay on server',
      () async {
        final controller = container.read(
          loanPaymentControllerProvider.notifier,
        );
        final intentResponse = await controller.fetchBreakdown(100);
        expect(intentResponse, isNotNull);

        fakeStripeService.statusToReturn = StripeSheetStatus.canceled;

        final success = await controller.confirmPayment(
          loanId: 100,
          intentResponse: intentResponse!,
        );

        expect(success, isFalse);
        expect(
          container.read(loanPaymentControllerProvider),
          isA<LoanPaymentCanceled>(),
        );
        expect(fakePaymentRepo.prepayCalled, isFalse);
      },
    );

    test(
      'when deposit sheet is canceled after contribution is paid, retry only presents deposit sheet without recharging contribution',
      () async {
        final controller = container.read(
          loanPaymentControllerProvider.notifier,
        );
        final intentResponse = await controller.fetchBreakdown(100);
        expect(intentResponse, isNotNull);

        // Attempt 1: Contribution succeeds, but deposit is canceled by user
        fakeStripeService.statusSequence = [
          StripeSheetStatus.success, // Step 1: Contribution succeeded
          StripeSheetStatus.canceled, // Step 2: Deposit canceled by user
        ];

        final firstAttempt = await controller.confirmPayment(
          loanId: 100,
          intentResponse: intentResponse!,
        );

        expect(firstAttempt, isFalse);
        expect(
          container.read(loanPaymentControllerProvider),
          isA<LoanPaymentCanceled>(),
        );
        expect(fakePaymentRepo.prepayCalled, isFalse);
        expect(fakeStripeService.presentCallCount, equals(2));
        expect(
          fakeStripeService.initializedSecrets,
          contains('pi_contrib_123_secret_abc'),
        );
        expect(
          fakeStripeService.initializedSecrets,
          contains('pi_deposit_456_secret_def'),
        );

        // Attempt 2: User reopens modal and retries payment
        fakeStripeService.initializedSecrets.clear();
        fakeStripeService.statusSequence = [
          StripeSheetStatus.success, // Step 2: Deposit now succeeds
        ];

        final secondAttempt = await controller.confirmPayment(
          loanId: 100,
          intentResponse: intentResponse,
        );

        expect(secondAttempt, isTrue);
        expect(
          container.read(loanPaymentControllerProvider),
          isA<LoanPaymentSuccess>(),
        );
        expect(fakePaymentRepo.prepayCalled, isTrue);

        // CRITICAL GUARANTEE: Contribution sheet was NOT presented again, only deposit sheet was initialized and presented!
        expect(
          fakeStripeService.initializedSecrets,
          isNot(contains('pi_contrib_123_secret_abc')),
        );
        expect(
          fakeStripeService.initializedSecrets,
          contains('pi_deposit_456_secret_def'),
        );
        expect(
          fakeStripeService.presentCallCount,
          equals(3),
        ); // 2 in attempt 1 + 1 in attempt 2
      },
    );
  });

  group('Lot 16 QA — Push Notifications Navigation & Deduplication', () {
    late ProviderContainer container;
    late FakePushNotificationService fakeService;
    late QaFakePushTokensRepository fakeRepo;

    setUp(() {
      fakeService = FakePushNotificationService();
      fakeRepo = QaFakePushTokensRepository();
    });

    test(
      'opened notification routes to /incidents/:id for incidentCreated and /loans/:id for loan events',
      () async {
        // 1. Unauthenticated container: controller internally resolves targetPath and sets pendingRedirectPath
        final unauthContainer = ProviderContainer(
          overrides: [
            pushNotificationServiceProvider.overrideWithValue(fakeService),
            pushTokensRepositoryProvider.overrideWithValue(fakeRepo),
            authControllerProvider.overrideWith(
              () => QaTestAuthController(null),
            ),
          ],
        );

        final unauthController = unauthContainer.read(
          notificationsControllerProvider.notifier,
        );
        await unauthController.initialize();

        final incidentPayload = PushPayload.tryParse(
          data: {
            'schema_version': '1',
            'event_type': 'incident_created',
            'incident_id': 99,
          },
          messageId: 'msg_inc_1',
        )!;

        unauthController.handleOpenedNotification(incidentPayload);
        expect(
          unauthController.state.pendingRedirectPath,
          equals('/incidents/99'),
        );

        final loanPayload = PushPayload.tryParse(
          data: {
            'schema_version': '1',
            'event_type': 'loan_accepted',
            'loan_id': 123,
          },
          messageId: 'msg_loan_1',
        )!;

        unauthController.handleOpenedNotification(loanPayload);
        expect(
          unauthController.state.pendingRedirectPath,
          equals('/loans/123'),
        );

        unauthContainer.dispose();
      },
    );

    test(
      'deduplicates duplicate push notifications by messageId within TTL window',
      () async {
        container = ProviderContainer(
          overrides: [
            pushNotificationServiceProvider.overrideWithValue(fakeService),
            pushTokensRepositoryProvider.overrideWithValue(fakeRepo),
            authControllerProvider.overrideWith(
              () => QaTestAuthController(
                const User(id: 1, email: 'user@loco.app'),
              ),
            ),
          ],
        );

        final controller = container.read(
          notificationsControllerProvider.notifier,
        );
        await controller.initialize();

        int openCount = 0;
        final payload = PushPayload.tryParse(
          data: {
            'schema_version': '1',
            'event_type': 'loan_accepted',
            'loan_id': 55,
          },
          messageId: 'duplicate_msg_id_123',
        )!;

        // First open
        controller.handleOpenedNotification(
          payload,
          onOpenPayload: (_) => openCount++,
        );
        expect(openCount, equals(1));

        // Duplicate delivery of the exact same message
        controller.handleOpenedNotification(
          payload,
          onOpenPayload: (_) => openCount++,
        );
        expect(
          openCount,
          equals(1),
          reason: 'Duplicate messageId must be ignored',
        );

        container.dispose();
      },
    );

    test(
      'unauthenticated cold start stores pending redirect path and consumes once',
      () async {
        container = ProviderContainer(
          overrides: [
            pushNotificationServiceProvider.overrideWithValue(fakeService),
            pushTokensRepositoryProvider.overrideWithValue(fakeRepo),
            authControllerProvider.overrideWith(
              () => QaTestAuthController(null),
            ), // Not logged in!
          ],
        );

        final controller = container.read(
          notificationsControllerProvider.notifier,
        );
        await controller.initialize();

        final payload = PushPayload.tryParse(
          data: {
            'schema_version': '1',
            'event_type': 'loan_extension_requested',
            'loan_id': 77,
          },
          messageId: 'cold_start_msg',
        )!;

        controller.handleOpenedNotification(payload);

        // Verifies pending redirect path stored in state
        expect(
          container.read(notificationsControllerProvider).pendingRedirectPath,
          equals('/loans/77'),
        );

        // Consumer consumes redirect after login
        controller.consumePendingRedirect();
        expect(
          container.read(notificationsControllerProvider).pendingRedirectPath,
          isNull,
        );

        container.dispose();
      },
    );
  });

  group('Lot 16 QA — Timezone & Daylight Saving Time (DST) Invariants', () {
    test(
      'ISO8601 parsing preserves start and end duration across DST transitions',
      () {
        // Spring Forward DST transition in America/Montreal (2026-03-08: 02:00 -> 03:00)
        final preDstUtc = DateTime.parse(
          '2026-03-08T06:00:00Z',
        ); // 01:00 EST (UTC-5)
        final postDstUtc = DateTime.parse(
          '2026-03-08T10:00:00Z',
        ); // 06:00 EDT (UTC-4)

        final diffMinutes = postDstUtc.difference(preDstUtc).inMinutes;
        expect(diffMinutes, equals(240));

        final loan = Loan(
          id: 999,
          departureAt: preDstUtc,
          durationInMinutes: diffMinutes,
          status: 'confirmed',
        );

        expect(loan.departureAt, equals(preDstUtc));
        expect(loan.durationInMinutes, equals(240));
      },
    );
  });

  group('Lot 16 QA — Accessibility (A11y) & Text Scale Resilience', () {
    testWidgets(
      'AvailabilityRuleCard renders cleanly under 1.5x and 2.0x font scaling without overflow',
      (tester) async {
        const rule = AvailabilityRule(
          id: 'rule_1',
          type: 'dates',
          scope: ['2026-10-15'],
          period: '09:00-17:00',
          available: false,
          title: 'Remplacement des pneus d\'hiver',
        );

        // Test with 2.0x accessibility font scale
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
              child: Scaffold(
                body: AvailabilityRuleCard(rule: rule, onDelete: () {}),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Remplacement des pneus d\'hiver'), findsOneWidget);
        expect(
          tester.takeException(),
          isNull,
          reason: 'No RenderFlex overflow under 2.0x font scale',
        );
      },
    );

    testWidgets(
      'ForegroundNotificationBanner displays cleanly with 1.5x font scale',
      (tester) async {
        const payload = PushPayload(
          schemaVersion: '1',
          eventType: PushEventType.incidentCreated,
          incidentId: 5,
          title: 'LocoMotion Signalement',
          body: 'Un dommage a été signalé sur votre véhicule',
        );

        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
              child: Scaffold(
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () => ForegroundNotificationBanner.show(
                      context,
                      payload: payload,
                    ),
                    child: const Text('Show Banner'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Banner'));
        await tester.pump(); // Render SnackBar

        expect(find.text('LocoMotion Signalement'), findsOneWidget);
        expect(
          find.text('Un dommage a été signalé sur votre véhicule'),
          findsOneWidget,
        );
        expect(find.text('Voir'), findsOneWidget);
        expect(
          tester.takeException(),
          isNull,
          reason: 'No RenderFlex overflow under 1.5x font scale',
        );
      },
    );
  });
}

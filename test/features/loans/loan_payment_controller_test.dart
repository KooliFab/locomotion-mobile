import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/stripe_payment_service.dart';
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

class FakeLoanPaymentRepository implements LoanPaymentRepository {
  bool prepayCalled = false;
  String? capturedContributionId;
  String? capturedDepositId;
  int? capturedTipCents;
  bool shouldThrowOnPrepay = false;
  PaymentIntentResponse? customPaymentIntentResponse;

  @override
  Future<PaymentIntentResponse> createPaymentIntent({
    required int loanId,
    int? platformTipCents,
    bool useBalance = true,
  }) async {
    if (customPaymentIntentResponse != null) {
      return customPaymentIntentResponse!;
    }
    return PaymentIntentResponse(
      loanId: loanId,
      financialBreakdown: PaymentBreakdown(
        mandatoryContributionCents: 3450,
        totalEstimatedContributionCents: 3450 + (platformTipCents ?? 200),
        remainingContributionToPayCents: 3450,
        platformTipCents: platformTipCents ?? 200,
        securityDepositCents: 25000,
      ),
      requiresStripeAction: true,
      stripe: const StripePaymentParams(
        customerId: 'cus_123',
        ephemeralKeySecret: 'ek_secret_123',
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
    if (shouldThrowOnPrepay) {
      throw Exception('Network timeout during prepay request');
    }
    prepayCalled = true;
    capturedTipCents = platformTipCents;
    capturedContributionId = contributionPaymentIntentId;
    capturedDepositId = depositPaymentIntentId;

    return Loan(
      id: loanId,
      departureAt: DateTime.now(),
      durationInMinutes: 60,
      status: 'confirmed',
      prepaidAt: DateTime.now(),
      depositStatus: 'authorized',
      depositAuthorizedCents: 25000,
    );
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async => [];

  @override
  Future<void> deletePaymentMethod(int id) async {}
}

class FakeLoansRepository implements LoansRepository {
  Loan? loanDetailToReturn;
  bool throwOnGetDetail = false;

  @override
  Future<Loan> getLoanDetail(int id) async {
    if (throwOnGetDetail) {
      throw Exception('Network error while checking loan status');
    }
    return loanDetailToReturn ??
        Loan(
          id: id,
          departureAt: DateTime.now(),
          durationInMinutes: 60,
          status: 'accepted',
        );
  }

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
  }) =>
      throw UnimplementedError();

  @override
  Future<Loan> rejectLoan(int id, {String? comment}) => throw UnimplementedError();

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
          int id, int durationInMinutes) =>
      throw UnimplementedError();
}

class FakeStripePaymentService implements StripePaymentService {
  final List<String> initializedSecrets = [];
  final List<StripeSheetStatus> statusQueue = [];
  StripeSheetStatus defaultStatus = StripeSheetStatus.success;
  String? errorToReturn;
  int presentCallCount = 0;

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
    final status = statusQueue.isNotEmpty
        ? statusQueue.removeAt(0)
        : defaultStatus;
    return StripeSheetResponse(
      status: status,
      errorMessage: errorToReturn,
    );
  }
}

void main() {
  late FakeLoanPaymentRepository fakePaymentRepository;
  late FakeLoansRepository fakeLoansRepository;
  late FakeStripePaymentService fakeStripeService;
  late ProviderContainer container;

  setUp(() {
    fakePaymentRepository = FakeLoanPaymentRepository();
    fakeLoansRepository = FakeLoansRepository();
    fakeStripeService = FakeStripePaymentService();

    container = ProviderContainer(
      overrides: [
        loanPaymentRepositoryProvider.overrideWithValue(fakePaymentRepository),
        loansRepositoryProvider.overrideWithValue(fakeLoansRepository),
        stripePaymentServiceProvider.overrideWithValue(fakeStripeService),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('LoanPaymentController - Issue 1 (Sequential Dual Stripe Sheets)', () {
    test('when both contribution and deposit required, presents both sheets sequentially',
        () async {
      final controller =
          container.read(loanPaymentControllerProvider.notifier);
      final response = await controller.fetchBreakdown(42);

      final success = await controller.confirmPayment(
        loanId: 42,
        intentResponse: response!,
        platformTipCents: 200,
      );

      expect(success, isTrue);
      // Both sheets must be presented
      expect(fakeStripeService.presentCallCount, 2);
      expect(fakeStripeService.initializedSecrets, [
        'pi_contrib_123_secret_abc',
        'pi_deposit_456_secret_def',
      ]);
      // Both IDs sent to prepay
      expect(fakePaymentRepository.prepayCalled, isTrue);
      expect(fakePaymentRepository.capturedContributionId, 'pi_contrib_123');
      expect(fakePaymentRepository.capturedDepositId, 'pi_deposit_456');

      final state = container.read(loanPaymentControllerProvider);
      expect(state, isA<LoanPaymentSuccess>());
    });

    test('canceling contribution (first sheet) stops flow and does not present deposit',
        () async {
      fakeStripeService.defaultStatus = StripeSheetStatus.canceled;

      final controller =
          container.read(loanPaymentControllerProvider.notifier);
      final response = await controller.fetchBreakdown(42);

      final success = await controller.confirmPayment(
        loanId: 42,
        intentResponse: response!,
      );

      expect(success, isFalse);
      expect(fakeStripeService.presentCallCount, 1);
      expect(fakePaymentRepository.prepayCalled, isFalse);

      final state = container.read(loanPaymentControllerProvider);
      expect(state, isA<LoanPaymentCanceled>());
    });

    test('canceling deposit (second sheet) stops flow without calling prepay',
        () async {
      // Step 1: success, Step 2: canceled
      fakeStripeService.statusQueue.addAll([
        StripeSheetStatus.success,
        StripeSheetStatus.canceled,
      ]);

      final controller =
          container.read(loanPaymentControllerProvider.notifier);
      final response = await controller.fetchBreakdown(42);

      final success = await controller.confirmPayment(
        loanId: 42,
        intentResponse: response!,
      );

      expect(success, isFalse);
      expect(fakeStripeService.presentCallCount, 2);
      expect(fakePaymentRepository.prepayCalled, isFalse);

      final state = container.read(loanPaymentControllerProvider);
      expect(state, isA<LoanPaymentCanceled>());
    });

    test(
        'R05: interruption between two sheets with new container/controller does not recharge contribution',
        () async {
      // Container 1: user starts payment, pays contribution, but cancels/interrupts deposit sheet
      final fakeStripe1 = FakeStripePaymentService();
      fakeStripe1.statusQueue.addAll([
        StripeSheetStatus.success, // Step 1: contribution succeeds
        StripeSheetStatus.canceled, // Step 2: deposit canceled / app closed
      ]);
      final fakeRepo1 = FakeLoanPaymentRepository();

      final container1 = ProviderContainer(
        overrides: [
          loanPaymentRepositoryProvider.overrideWithValue(fakeRepo1),
          loansRepositoryProvider.overrideWithValue(fakeLoansRepository),
          stripePaymentServiceProvider.overrideWithValue(fakeStripe1),
        ],
      );

      final controller1 =
          container1.read(loanPaymentControllerProvider.notifier);
      final response1 = await controller1.fetchBreakdown(42);

      final success1 = await controller1.confirmPayment(
        loanId: 42,
        intentResponse: response1!,
      );

      expect(success1, isFalse);
      expect(fakeStripe1.presentCallCount, 2);
      expect(fakeRepo1.prepayCalled, isFalse);

      // App is terminated and reopened with brand new Container / Controller:
      container1.dispose();

      final fakeStripe2 = FakeStripePaymentService();
      fakeStripe2.statusQueue.add(StripeSheetStatus.success); // Only deposit sheet presented

      final fakeRepo2 = FakeLoanPaymentRepository();
      // Server recognizes contribution is already paid from DB meta:
      fakeRepo2.customPaymentIntentResponse = const PaymentIntentResponse(
        loanId: 42,
        financialBreakdown: PaymentBreakdown(
          mandatoryContributionCents: 3450,
          totalEstimatedContributionCents: 3450,
          remainingContributionToPayCents: 0,
          contributionAlreadyPaid: true,
          securityDepositCents: 25000,
        ),
        requiresStripeAction: true,
        stripe: StripePaymentParams(
          customerId: 'cus_123',
          ephemeralKeySecret: 'ek_secret_123',
          contributionPaymentIntentClientSecret: null, // NOT recharged
          contributionPaymentIntentId: 'pi_contrib_123',
          contributionAlreadyPaid: true,
          depositPaymentIntentClientSecret: 'pi_deposit_456_secret_def',
        ),
      );

      final container2 = ProviderContainer(
        overrides: [
          loanPaymentRepositoryProvider.overrideWithValue(fakeRepo2),
          loansRepositoryProvider.overrideWithValue(fakeLoansRepository),
          stripePaymentServiceProvider.overrideWithValue(fakeStripe2),
        ],
      );

      final controller2 =
          container2.read(loanPaymentControllerProvider.notifier);
      final response2 = await controller2.fetchBreakdown(42);

      final success2 = await controller2.confirmPayment(
        loanId: 42,
        intentResponse: response2!,
      );

      expect(success2, isTrue);
      // Crucial assertion: contribution sheet was NOT presented again! Exactly 1 sheet (deposit)
      expect(fakeStripe2.presentCallCount, 1);
      expect(fakeStripe2.initializedSecrets, ['pi_deposit_456_secret_def']);
      // Prepay called with previously paid contribution ID and new deposit ID
      expect(fakeRepo2.prepayCalled, isTrue);
      expect(fakeRepo2.capturedContributionId, 'pi_contrib_123');
      expect(fakeRepo2.capturedDepositId, 'pi_deposit_456');

      container2.dispose();
    });

    test('when only contribution is required (e.g. bike), presents only 1 sheet and sends deposit null',
        () async {
      final controller =
          container.read(loanPaymentControllerProvider.notifier);
      const contribOnlyResponse = PaymentIntentResponse(
        loanId: 42,
        financialBreakdown: PaymentBreakdown(
          mandatoryContributionCents: 1500,
          totalEstimatedContributionCents: 1500,
          remainingContributionToPayCents: 1500,
          securityDepositCents: 0,
        ),
        requiresStripeAction: true,
        stripe: StripePaymentParams(
          customerId: 'cus_1',
          ephemeralKeySecret: 'ek_1',
          contributionPaymentIntentClientSecret: 'pi_contrib_only_secret_x',
          depositPaymentIntentClientSecret: null,
        ),
      );

      final success = await controller.confirmPayment(
        loanId: 42,
        intentResponse: contribOnlyResponse,
      );

      expect(success, isTrue);
      expect(fakeStripeService.presentCallCount, 1);
      expect(fakeStripeService.initializedSecrets, ['pi_contrib_only_secret_x']);
      expect(fakePaymentRepository.capturedContributionId, 'pi_contrib_only');
      expect(fakePaymentRepository.capturedDepositId, isNull);
    });

    test('when only deposit is required (car covered by balance), presents only 1 sheet and sends contrib null',
        () async {
      final controller =
          container.read(loanPaymentControllerProvider.notifier);
      const depositOnlyResponse = PaymentIntentResponse(
        loanId: 42,
        financialBreakdown: PaymentBreakdown(
          mandatoryContributionCents: 2000,
          userBalanceAppliedCents: 2000,
          totalEstimatedContributionCents: 2000,
          remainingContributionToPayCents: 0,
          securityDepositCents: 25000,
        ),
        requiresStripeAction: true,
        stripe: StripePaymentParams(
          customerId: 'cus_1',
          ephemeralKeySecret: 'ek_1',
          contributionPaymentIntentClientSecret: null,
          depositPaymentIntentClientSecret: 'pi_deposit_only_secret_y',
        ),
      );

      final success = await controller.confirmPayment(
        loanId: 42,
        intentResponse: depositOnlyResponse,
      );

      expect(success, isTrue);
      expect(fakeStripeService.presentCallCount, 1);
      expect(fakeStripeService.initializedSecrets, ['pi_deposit_only_secret_y']);
      expect(fakePaymentRepository.capturedContributionId, isNull);
      expect(fakePaymentRepository.capturedDepositId, 'pi_deposit_only');
    });
  });

  group('LoanPaymentController - Issue 2 (Tip Alignment)', () {
    test('confirmPayment strictly uses intentResponse.financialBreakdown.platformTipCents',
        () async {
      final controller =
          container.read(loanPaymentControllerProvider.notifier);
      final response = await controller.fetchBreakdown(42, platformTipCents: 500);

      // Even if a caller mistakenly passed 200 as parameter
      await controller.confirmPayment(
        loanId: 42,
        intentResponse: response!,
        platformTipCents: 200,
      );

      // Captured tip must be 500 from breakdown
      expect(fakePaymentRepository.capturedTipCents, 500);
    });
  });

  group('LoanPaymentController - Issue 3 (Timeout & State Recovery)', () {
    test('timeout during prepay automatically recovers if server confirmed loan',
        () async {
      fakePaymentRepository.shouldThrowOnPrepay = true;
      // Server already processed the loan
      fakeLoansRepository.loanDetailToReturn = Loan(
        id: 42,
        departureAt: DateTime.now(),
        durationInMinutes: 60,
        status: 'confirmed',
        prepaidAt: DateTime.now(),
      );

      final controller =
          container.read(loanPaymentControllerProvider.notifier);
      final response = await controller.fetchBreakdown(42);

      final success = await controller.confirmPayment(
        loanId: 42,
        intentResponse: response!,
      );

      expect(success, isTrue);
      final state = container.read(loanPaymentControllerProvider);
      expect(state, isA<LoanPaymentSuccess>());
    });

    test('timeout during prepay sets LoanPaymentError when server has not confirmed',
        () async {
      fakePaymentRepository.shouldThrowOnPrepay = true;
      fakeLoansRepository.loanDetailToReturn = Loan(
        id: 42,
        departureAt: DateTime.now(),
        durationInMinutes: 60,
        status: 'accepted',
        prepaidAt: null,
      );

      final controller =
          container.read(loanPaymentControllerProvider.notifier);
      final response = await controller.fetchBreakdown(42);

      final success = await controller.confirmPayment(
        loanId: 42,
        intentResponse: response!,
      );

      expect(success, isFalse);
      final state = container.read(loanPaymentControllerProvider);
      expect(state, isA<LoanPaymentError>());

      // Calling checkServerStatus after server eventually confirmed recovers state
      fakeLoansRepository.loanDetailToReturn = Loan(
        id: 42,
        departureAt: DateTime.now(),
        durationInMinutes: 60,
        status: 'confirmed',
        prepaidAt: DateTime.now(),
      );

      final checkRecovered = await controller.checkServerStatus(42);
      expect(checkRecovered, isTrue);
      expect(container.read(loanPaymentControllerProvider), isA<LoanPaymentSuccess>());
    });
  });

  group('LoanPaymentController - Zero Stripe (Balance only)', () {
    test('confirmPayment without Stripe confirms loan directly with balance',
        () async {
      final controller =
          container.read(loanPaymentControllerProvider.notifier);
      const noStripeResponse = PaymentIntentResponse(
        loanId: 42,
        financialBreakdown: PaymentBreakdown(
          mandatoryContributionCents: 1000,
          totalEstimatedContributionCents: 1000,
          userBalanceAppliedCents: 1000,
          remainingContributionToPayCents: 0,
          securityDepositCents: 0,
        ),
        requiresStripeAction: false,
        stripe: null,
      );

      final success = await controller.confirmPayment(
        loanId: 42,
        intentResponse: noStripeResponse,
      );

      expect(success, isTrue);
      expect(fakeStripeService.presentCallCount, 0);
      expect(fakePaymentRepository.prepayCalled, isTrue);

      final state = container.read(loanPaymentControllerProvider);
      expect(state, isA<LoanPaymentSuccess>());
    });
  });
}

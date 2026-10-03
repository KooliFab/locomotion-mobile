import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/stripe_payment_service.dart';
import 'package:mobile/features/loans/data/repositories/loan_payment_repository_impl.dart';
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
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';
import 'package:mobile/features/loans/presentation/widgets/loan_prepayment_modal.dart';

class StubPaymentRepository implements LoanPaymentRepository {
  int createIntentCallCount = 0;
  int? lastRequestedTipCents;
  bool shouldThrowOnPrepay = false;

  @override
  Future<PaymentIntentResponse> createPaymentIntent({
    required int loanId,
    int? platformTipCents,
    bool useBalance = true,
  }) async {
    createIntentCallCount++;
    lastRequestedTipCents = platformTipCents;
    final tip = platformTipCents ?? 200;

    return PaymentIntentResponse(
      loanId: loanId,
      financialBreakdown: PaymentBreakdown(
        mandatoryContributionCents: 3000,
        taxesTpsCents: 150,
        taxesTvqCents: 300,
        platformTipCents: tip,
        totalEstimatedContributionCents: 3450 + tip,
        remainingContributionToPayCents: 3450 + tip,
        securityDepositCents: 25000,
      ),
      requiresStripeAction: true,
      stripe: const StripePaymentParams(
        customerId: 'cus_1',
        ephemeralKeySecret: 'ek_1',
        contributionPaymentIntentClientSecret: 'pi_1_secret_1',
        depositPaymentIntentClientSecret: 'pi_2_secret_2',
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
      throw Exception('Erreur réseau simulée');
    }
    return Loan(
      id: loanId,
      departureAt: DateTime.now(),
      durationInMinutes: 60,
      status: 'confirmed',
      prepaidAt: DateTime.now(),
    );
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async => [];

  @override
  Future<void> deletePaymentMethod(int id) async {}
}

class StubLoansRepository implements LoansRepository {
  Loan? loanDetailToReturn;
  int getLoanDetailCallCount = 0;

  @override
  Future<Loan> getLoanDetail(int id) async {
    getLoanDetailCallCount++;
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
  }) =>
      throw UnimplementedError();

  @override
  Future<Loan> rejectLoan(int id, {String? comment}) => throw UnimplementedError();

  @override
  Future<Loan> updateLoanDates(
          int id, LoanDatesUpdateRequest request) =>
      throw UnimplementedError();
}

class StubStripePaymentService implements StripePaymentService {
  @override
  Future<void> initialize() async {}

  @override
  Future<void> initPaymentSheet({
    required String paymentIntentClientSecret,
    required String customerId,
    required String customerEphemeralKeySecret,
    String? merchantDisplayName,
  }) async {}

  @override
  Future<StripeSheetResponse> presentPaymentSheet() async {
    return const StripeSheetResponse(status: StripeSheetStatus.success);
  }
}

void main() {
  final testLoan = Loan(
    id: 10,
    departureAt: DateTime.now().add(const Duration(hours: 2)),
    durationInMinutes: 120,
    status: 'accepted',
    loanableName: 'Toyota Prius',
  );

  testWidgets('LoanPrepaymentModal renders financial breakdown and caution',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loanPaymentRepositoryProvider.overrideWithValue(StubPaymentRepository()),
          loansRepositoryProvider.overrideWithValue(StubLoansRepository()),
          stripePaymentServiceProvider.overrideWithValue(StubStripePaymentService()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: LoanPrepaymentModal(loan: testLoan),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    // Verify header and vehicle display
    expect(find.text('Prépaiement & Caution'), findsOneWidget);
    expect(find.text('Toyota Prius'), findsOneWidget);

    // Verify financial rows
    expect(find.text('Contribution trajet estimée'), findsOneWidget);
    expect(find.text('30.00 \$'), findsOneWidget);

    // Verify security deposit notice
    expect(find.textContaining('Caution requise : 250.00 \$ CAD'), findsOneWidget);

    // Verify tip selector
    expect(find.text('0 \$'), findsOneWidget);
    expect(find.text('2 \$'), findsOneWidget);

    // Verify action button
    expect(find.text('Payer & bloquer la caution'), findsOneWidget);
  });

  testWidgets('Changing tip refreshes breakdown and keeps tip aligned',
      (tester) async {
    final stubPayment = StubPaymentRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loanPaymentRepositoryProvider.overrideWithValue(stubPayment),
          loansRepositoryProvider.overrideWithValue(StubLoansRepository()),
          stripePaymentServiceProvider.overrideWithValue(StubStripePaymentService()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: LoanPrepaymentModal(loan: testLoan),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    // Initial breakdown loaded with default 200 cents ($2)
    expect(stubPayment.createIntentCallCount, 1);
    expect(stubPayment.lastRequestedTipCents, 200);

    // Select 5 $ tip
    await tester.tap(find.text('5 \$'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(stubPayment.createIntentCallCount, 2);
    expect(stubPayment.lastRequestedTipCents, 500);
  });

  testWidgets('Displays error message and "Vérifier le statut du prêt" button on failure',
      (tester) async {
    final stubPayment = StubPaymentRepository()..shouldThrowOnPrepay = true;
    final stubLoans = StubLoansRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loanPaymentRepositoryProvider.overrideWithValue(stubPayment),
          loansRepositoryProvider.overrideWithValue(stubLoans),
          stripePaymentServiceProvider.overrideWithValue(StubStripePaymentService()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: LoanPrepaymentModal(loan: testLoan),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    // Tap confirm button -> prepay will throw
    await tester.tap(find.text('Payer & bloquer la caution'));
    await tester.pump();
    await tester.pumpAndSettle();

    // Error box and check status button should appear
    expect(find.textContaining('Erreur réseau simulée'), findsOneWidget);
    expect(find.text('Vérifier le statut du prêt'), findsOneWidget);

    // Now set the loan to confirmed on server
    stubLoans.loanDetailToReturn = Loan(
      id: 10,
      departureAt: DateTime.now(),
      durationInMinutes: 120,
      status: 'confirmed',
      prepaidAt: DateTime.now(),
    );

    // Tap "Vérifier le statut du prêt"
    await tester.ensureVisible(find.text('Vérifier le statut du prêt'));
    await tester.tap(find.text('Vérifier le statut du prêt'));
    await tester.pump();
    await tester.pumpAndSettle();

    // Succeeded! Success view shown
    expect(find.text('Prépaiement confirmé !'), findsOneWidget);
  });
}

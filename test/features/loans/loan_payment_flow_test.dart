import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/loans/data/datasources/loan_payment_remote_data_source.dart';
import 'package:mobile/features/loans/data/repositories/loan_payment_repository_impl.dart';
import 'package:mobile/features/loans/domain/entities/invoice_summary.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/payment_method_model.dart';
import 'package:mobile/features/loans/domain/repositories/loan_payment_repository.dart';
import 'package:mobile/features/loans/domain/repositories/loans_repository.dart';
import 'package:mobile/features/loans/presentation/controllers/loan_payment_controller.dart';
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';
import 'package:mobile/features/profile/presentation/controllers/profile_controller.dart';

import '../../helpers/mock_api_client.dart';

Map<String, dynamic> _invoiceJson(double due) => {
  'items': [
    {'item_type': 'loan.price', 'amount': due, 'total': -due},
  ],
  'user_balance_change': -due,
};

Loan _loan({String status = 'accepted', double? tip = 2}) => Loan(
  id: 7,
  departureAt: DateTime.utc(2026, 10, 10, 10),
  durationInMinutes: 120,
  status: status,
  borrowerUserId: 1,
  platformTip: tip,
  borrowerMayContribute: true,
  borrowerInvoiceJson: _invoiceJson(12),
);

class _FakePaymentRepo implements LoanPaymentRepository {
  double invoiceDue = 12;
  double balance = 5;
  int addToBalanceCalls = 0;
  double? lastTopUp;
  int? lastPaymentMethodId;
  int prepayCalls = 0;
  int payCalls = 0;
  double? lastTip;
  bool failNextLoanAction = false;

  @override
  Future<InvoiceSummary?> estimateBorrowerInvoice({
    required int loanId,
    required double platformTip,
  }) async => InvoiceSummary.tryParse(_invoiceJson(invoiceDue + platformTip));

  @override
  Future<double> addToBalance({
    required double amount,
    int? paymentMethodId,
  }) async {
    addToBalanceCalls++;
    lastTopUp = amount;
    lastPaymentMethodId = paymentMethodId;
    balance += amount;
    return balance;
  }

  @override
  Future<Loan> prepay({required int loanId, required double platformTip}) {
    prepayCalls++;
    lastTip = platformTip;
    return _loanAction('confirmed');
  }

  @override
  Future<Loan> pay({required int loanId, required double platformTip}) {
    payCalls++;
    lastTip = platformTip;
    return _loanAction('completed');
  }

  Future<Loan> _loanAction(String status) async {
    if (failNextLoanAction) {
      failNextLoanAction = false;
      throw const ServerException(
        message: 'Solde insuffisant.',
        statusCode: 403,
      );
    }
    return _loan(status: status);
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async => const [
    PaymentMethodModel(
      id: 3,
      creditCardType: 'Visa',
      fourLastDigits: '4242',
      isDefault: true,
    ),
  ];

  @override
  Future<void> deletePaymentMethod(int id) async {}
}

class _FakeLoansRepo implements LoansRepository {
  Loan detail = _loan();

  @override
  Future<Loan> getLoanDetail(int id) async => detail;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeBalanceController extends UserBalanceController {
  _FakeBalanceController(this.repo);

  final _FakePaymentRepo repo;

  @override
  FutureOr<double> build() => repo.balance;
}

void main() {
  group('Payment data source uses the web routes', () {
    test('estimate sends platform_tip to GET /loans/{id}/estimate', () async {
      String? path;
      Map<String, dynamic>? query;
      final api = createMockApiClient((options) async {
        path = options.path;
        query = options.queryParameters;
        return jsonResponse({
          'available': true,
          'borrower_invoice': _invoiceJson(14.5),
        });
      });

      final invoice = await LoanPaymentRemoteDataSourceImpl(
        api,
      ).estimateBorrowerInvoice(loanId: 7, platformTip: 2.5);

      expect(path, '/loans/7/estimate');
      expect(query, {'platform_tip': 2.5});
      expect(invoice!.amountDue, 14.5);
      expect(invoice.items.single.label, 'Coût de l\'emprunt');
    });

    test('estimate without invoice means nothing to pay', () async {
      final api = createMockApiClient(
        (options) async => jsonResponse({'available': true}),
      );
      final invoice = await LoanPaymentRemoteDataSourceImpl(
        api,
      ).estimateBorrowerInvoice(loanId: 7, platformTip: 0);
      expect(invoice, isNull);
    });

    test('top-up calls PUT /auth/user/balance and parses scalar', () async {
      String? method;
      String? path;
      dynamic body;
      final api = createMockApiClient((options) async {
        method = options.method;
        path = options.path;
        body = options.data;
        return jsonResponse(42.5);
      });

      final balance = await LoanPaymentRemoteDataSourceImpl(
        api,
      ).addToBalance(amount: 30, paymentMethodId: 3);

      expect(method, 'PUT');
      expect(path, '/auth/user/balance');
      expect(body, {'amount': 30.0, 'payment_method_id': 3});
      expect(balance, 42.5);
    });

    test('prepay and pay send only platform_tip', () async {
      final calls = <String>[];
      final bodies = <dynamic>[];
      final api = createMockApiClient((options) async {
        calls.add('${options.method} ${options.path}');
        bodies.add(options.data);
        return jsonResponse({
          'data': {
            'id': 7,
            'departure_at': '2026-10-10T10:00:00Z',
            'duration_in_minutes': 120,
            'status': options.path.endsWith('prepay')
                ? 'confirmed'
                : 'completed',
          },
        });
      });
      final ds = LoanPaymentRemoteDataSourceImpl(api);

      final prepaid = await ds.prepay(loanId: 7, platformTip: 2);
      final paid = await ds.pay(loanId: 7, platformTip: 0);

      expect(calls, ['PUT /loans/7/prepay', 'PUT /loans/7/pay']);
      expect(bodies, [
        {'platform_tip': 2.0},
        {'platform_tip': 0.0},
      ]);
      expect(prepaid.status, 'confirmed');
      expect(paid.status, 'completed');
    });
  });

  group('LoanPaymentController', () {
    late _FakePaymentRepo repo;
    late _FakeLoansRepo loansRepo;
    late ProviderContainer container;

    setUp(() {
      repo = _FakePaymentRepo();
      loansRepo = _FakeLoansRepo();
      container = ProviderContainer(
        overrides: [
          loanPaymentRepositoryProvider.overrideWithValue(repo),
          loansRepositoryProvider.overrideWithValue(loansRepo),
          userBalanceControllerProvider.overrideWith(
            () => _FakeBalanceController(repo),
          ),
        ],
      );
    });

    tearDown(() => container.dispose());

    LoanPaymentController controller() =>
        container.read(loanPaymentControllerProvider(7).notifier);
    LoanPaymentState state() =>
        container.read(loanPaymentControllerProvider(7));

    test(
      'loads server invoice for the initial tip and computes top-up',
      () async {
        final sub = container.listen(
          loanPaymentControllerProvider(7),
          (_, _) {},
        );
        await controller().load(_loan());

        expect(state().platformTip, 2);
        expect(state().amountDue, 14); // 12 + 2 $ tip, from the server estimate
        expect(state().balance, 5);
        expect(state().missingAmount, 9);
        expect(state().selectedPaymentMethodId, 3);
        sub.close();
      },
    );

    test('tops up the missing amount with the card, then prepays', () async {
      final sub = container.listen(loanPaymentControllerProvider(7), (_, _) {});
      await controller().load(_loan());

      final ok = await controller().submit(action: LoanPaymentAction.prepay);

      expect(ok, isTrue);
      expect(repo.addToBalanceCalls, 1);
      expect(repo.lastTopUp, 9);
      expect(repo.lastPaymentMethodId, 3);
      expect(repo.prepayCalls, 1);
      expect(repo.lastTip, 2);
      expect(state().completedLoan!.status, 'confirmed');
      sub.close();
    });

    test(
      'does not charge the card when the balance already covers it',
      () async {
        repo.balance = 50;
        final sub = container.listen(
          loanPaymentControllerProvider(7),
          (_, _) {},
        );
        await controller().load(_loan(status: 'validated'));

        final ok = await controller().submit(action: LoanPaymentAction.pay);

        expect(ok, isTrue);
        expect(repo.addToBalanceCalls, 0);
        expect(repo.payCalls, 1);
        sub.close();
      },
    );

    test('retry after a failed prepay does not top up a second time', () async {
      repo.failNextLoanAction = true;
      final sub = container.listen(loanPaymentControllerProvider(7), (_, _) {});
      await controller().load(_loan());

      final first = await controller().submit(action: LoanPaymentAction.prepay);
      expect(first, isFalse);
      expect(state().error, 'Solde insuffisant.');
      expect(repo.addToBalanceCalls, 1);
      expect(state().needsTopUp, isFalse);

      final second = await controller().submit(
        action: LoanPaymentAction.prepay,
      );
      expect(second, isTrue);
      expect(repo.addToBalanceCalls, 1);
      expect(repo.prepayCalls, 2);
      sub.close();
    });

    test('an error after the server applied prepay is recovered', () async {
      repo.balance = 50;
      repo.failNextLoanAction = true;
      loansRepo.detail = _loan(status: 'confirmed');
      final sub = container.listen(loanPaymentControllerProvider(7), (_, _) {});
      await controller().load(_loan());

      final ok = await controller().submit(action: LoanPaymentAction.prepay);

      expect(ok, isTrue);
      expect(state().completedLoan!.status, 'confirmed');
      sub.close();
    });

    test('refuses a top-up below the missing amount', () async {
      final sub = container.listen(loanPaymentControllerProvider(7), (_, _) {});
      await controller().load(_loan());

      final ok = await controller().submit(
        action: LoanPaymentAction.prepay,
        topUpAmount: 3,
      );

      expect(ok, isFalse);
      expect(repo.addToBalanceCalls, 0);
      expect(repo.prepayCalls, 0);
      expect(state().error, contains('au moins 9.00'));
      sub.close();
    });

    test('changing the tip re-estimates the invoice on the server', () async {
      final sub = container.listen(loanPaymentControllerProvider(7), (_, _) {});
      await controller().load(_loan());

      await controller().setPlatformTip(5);

      expect(state().platformTip, 5);
      expect(state().amountDue, 17);
      sub.close();
    });
  });

  group('initialPlatformTip', () {
    test('is 0 when contributions do not apply', () {
      final loan = _loan().copyWith(
        applicableAmountTypes: {'contributions': 'not_applicable'},
      );
      expect(initialPlatformTip(loan), 0);
    });

    test('falls back to the desired contribution', () {
      final loan = _loan(tip: null).copyWith(desiredContribution: 4.5);
      expect(initialPlatformTip(loan), 4.5);
    });
  });
}

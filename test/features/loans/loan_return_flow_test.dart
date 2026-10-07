import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/incidents/data/datasources/incident_remote_data_source.dart';
import 'package:mobile/features/loans/data/datasources/loans_remote_data_source.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_factors_update.dart';

import '../../helpers/mock_api_client.dart';

Map<String, dynamic> _loanJson(String status) => {
  'id': 9,
  'departure_at': '2026-10-10T10:00:00Z',
  'duration_in_minutes': 60,
  'status': status,
};

Loan _loan({
  String status = 'ongoing',
  bool detailedMileage = true,
  int? mileageStart,
  int? mileageEnd,
  bool needsValidation = true,
  DateTime? borrowerValidatedAt,
}) => Loan(
  id: 9,
  departureAt: DateTime.utc(2026, 10, 10, 10),
  durationInMinutes: 60,
  status: status,
  borrowerUserId: 1,
  requiresDetailedMileage: detailedMileage,
  mileageStart: mileageStart,
  mileageEnd: mileageEnd,
  needsValidation: needsValidation,
  borrowerValidatedAt: borrowerValidatedAt,
);

void main() {
  group('Return information uses PUT /loans/{id}/factors', () {
    test('sends every field like the web factors box', () async {
      String? method;
      String? path;
      dynamic body;
      final api = createMockApiClient((options) async {
        method = options.method;
        path = options.path;
        body = options.data;
        return jsonResponse({'data': _loanJson('ended')});
      });

      final loan = await LoansRemoteDataSourceImpl(api).updateFactors(
        9,
        const LoanFactorsUpdate(
          mileageStart: 1200,
          mileageStartImageId: 4,
          mileageEnd: 1260,
          includeExpenses: true,
          expensesAmount: 18.5,
        ),
      );

      expect(method, 'PUT');
      expect(path, '/loans/9/factors');
      expect(body, {
        'mileage_start': 1200,
        'mileage_start_image_id': 4,
        'mileage_end': 1260,
        'mileage_end_image_id': null,
        'expenses_amount': 18.5,
        'expense_image_id': null,
      });
      expect(loan.status, 'ended');
    });

    test('omits expenses when the loan does not accept them', () {
      const update = LoanFactorsUpdate(mileageStart: 10, mileageEnd: 20);
      expect(update.toJson().containsKey('expenses_amount'), isFalse);
      expect(update.toJson().containsKey('expense_image_id'), isFalse);
    });

    test('early return calls PUT /loans/{id}/return', () async {
      String? path;
      final api = createMockApiClient((options) async {
        path = '${options.method} ${options.path}';
        return jsonResponse({'data': _loanJson('ended')});
      });

      final loan = await LoansRemoteDataSourceImpl(api).endLoanEarly(9);

      expect(path, 'PUT /loans/9/return');
      expect(loan.status, 'ended');
    });
  });

  group('Loan action rules follow the web app', () {
    test('prepay when accepted, pay when validated', () {
      expect(_loan(status: 'accepted').canBorrowerPrepay(1), isTrue);
      expect(_loan(status: 'confirmed').canBorrowerPrepay(1), isFalse);
      expect(_loan(status: 'validated').canBorrowerPay(1), isTrue);
      expect(_loan(status: 'ended').canBorrowerPay(1), isFalse);
      // Another user is not the borrower
      expect(_loan(status: 'accepted').canBorrowerPrepay(2), isFalse);
    });

    test('return information is editable from ongoing to validated', () {
      for (final s in ['ongoing', 'ended', 'validated']) {
        expect(_loan(status: s).canEditReturnInfo(1), isTrue, reason: s);
      }
      for (final s in ['requested', 'accepted', 'confirmed', 'completed']) {
        expect(_loan(status: s).canEditReturnInfo(1), isFalse, reason: s);
      }
    });

    test('early return only while ongoing', () {
      expect(_loan(status: 'ongoing').canEndEarly(1), isTrue);
      expect(_loan(status: 'ended').canEndEarly(1), isFalse);
    });

    test('validation waits for detailed mileage', () {
      final missing = _loan(status: 'ended', mileageStart: 100);
      expect(missing.needsMoreInformation, isTrue);
      expect(missing.canValidateReturn(1), isFalse);

      final filled = _loan(status: 'ended', mileageStart: 100, mileageEnd: 150);
      expect(filled.needsMoreInformation, isFalse);
      expect(filled.canValidateReturn(1), isTrue);

      final noMileage = _loan(status: 'ended', detailedMileage: false);
      expect(noMileage.canValidateReturn(1), isTrue);
    });

    test('a party that already validated cannot validate again', () {
      final loan = _loan(
        status: 'ended',
        detailedMileage: false,
        borrowerValidatedAt: DateTime.utc(2026, 10, 10, 12),
      );
      expect(loan.canValidateReturn(1), isFalse);
    });

    test('parses borrower_invoice from the loan resource', () {
      final loan = Loan.fromJson({
        ..._loanJson('validated'),
        'borrower_invoice': {
          'items': [
            {'item_type': 'loan.insurance', 'amount': 3, 'total': -3.45},
          ],
          'user_balance_change': -3.45,
        },
      });
      expect(loan.borrowerAmountDue, 3.45);
      expect(loan.borrowerInvoice!.items.single.label, 'Assurance');
    });
  });

  group('Incident detail without GET /incidents/{id}', () {
    test('reads the incident through the filtered list', () async {
      Map<String, dynamic>? query;
      String? path;
      final api = createMockApiClient((options) async {
        path = options.path;
        query = options.queryParameters;
        return jsonResponse({
          'data': [
            {'id': 31, 'loanable_id': 4, 'comments_on_incident': 'x'},
          ],
        });
      });

      final incident = await IncidentRemoteDataSourceImpl(
        api,
      ).getIncidentDetail(31);

      expect(path, '/incidents');
      expect(query!['id'], 31);
      expect(query!['relations'], isNot(contains('images')));
      expect(incident['id'], 31);
    });

    test('reports a missing incident as not found', () async {
      final api = createMockApiClient(
        (options) async => jsonResponse({'data': []}),
      );
      expect(
        () => IncidentRemoteDataSourceImpl(api).getIncidentDetail(31),
        throwsA(
          predicate((e) => e.toString().contains('Incident introuvable')),
        ),
      );
    });
  });
}

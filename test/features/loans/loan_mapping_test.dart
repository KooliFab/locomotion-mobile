import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_status.dart';
import 'package:mobile/features/loans/domain/entities/loans_dashboard.dart';
import '../../fixtures/loans_fixtures.dart';

void main() {
  group('Loan & Dashboard Mapping Tests', () {
    test('parses complete loans dashboard categories', () {
      final dashboard = LoansDashboard.fromJson(laravelLoansDashboardJson);

      expect(dashboard.started.total, 1);
      expect(dashboard.started.loans.length, 1);
      expect(dashboard.started.loans.first.id, 10);
      expect(dashboard.started.loans.first.status, 'ongoing');
      expect(dashboard.started.loans.first.parsedStatus, LoanStatus.ongoing);
      expect(
        dashboard.started.loans.first.displayLoanableName,
        'Toyota Prius Hybride',
      );
      expect(dashboard.started.loans.first.borrowerUserName, 'Jean Dupont');

      expect(dashboard.waiting.total, 1);
      expect(dashboard.waiting.loans.first.id, 11);
      expect(dashboard.waiting.loans.first.status, 'requested');
      expect(dashboard.waiting.loans.first.parsedStatus, LoanStatus.requested);

      expect(dashboard.needApproval.total, 1);
      expect(dashboard.needApproval.loans.first.id, 12);
      expect(dashboard.needApproval.loans.first.ownerActionRequired, true);

      expect(dashboard.future.total, 1);
      expect(dashboard.future.loans.first.id, 13);
      expect(dashboard.future.loans.first.status, 'confirmed');
      expect(dashboard.future.loans.first.parsedStatus, LoanStatus.confirmed);

      expect(dashboard.completed.total, 1);
      final completedLoan = dashboard.completed.loans.first;
      expect(completedLoan.id, 9);
      expect(completedLoan.status, 'completed');
      expect(completedLoan.parsedStatus, LoanStatus.completed);
      expect(completedLoan.borrowerTotal, 15.50);
      expect(completedLoan.totalCost, 15.50);
      expect(completedLoan.ownerTotal, 12.00);
      expect(completedLoan.startAt, DateTime(2026, 9, 20, 10, 0));
      expect(completedLoan.endAt, DateTime(2026, 9, 20, 12, 0));
    });

    test('recognizes all 9 persisted Laravel statuses including validated', () {
      const statuses = [
        ('requested', LoanStatus.requested),
        ('accepted', LoanStatus.accepted),
        ('confirmed', LoanStatus.confirmed),
        ('ongoing', LoanStatus.ongoing),
        ('ended', LoanStatus.ended),
        ('validated', LoanStatus.validated),
        ('completed', LoanStatus.completed),
        ('canceled', LoanStatus.canceled),
        ('rejected', LoanStatus.rejected),
      ];

      for (final (raw, expectedEnum) in statuses) {
        final loan = Loan.fromJson({
          'id': 1,
          'departure_at': '2026-10-01 10:00:00',
          'duration_in_minutes': 60,
          'status': raw,
        });

        expect(loan.status, raw);
        expect(
          loan.parsedStatus,
          expectedEnum,
          reason: 'Status $raw should parse as $expectedEnum',
        );
      }
    });

    test('handles unknown or future status safely without failing parsing', () {
      final loan = Loan.fromJson({
        'id': 999,
        'departure_at': '2026-10-01 10:00:00',
        'duration_in_minutes': 60,
        'status': 'under_dispute_future_status',
      });

      expect(loan.id, 999);
      expect(loan.status, 'under_dispute_future_status');
      expect(loan.parsedStatus, LoanStatus.unknown);
    });

    test(
      'throws FormatException on missing required loan fields (P1 check)',
      () {
        // Missing id
        expect(
          () => Loan.fromJson({
            'departure_at': '2026-10-01 10:00:00',
            'duration_in_minutes': 60,
            'status': 'requested',
          }),
          throwsFormatException,
        );

        // Missing departure_at
        expect(
          () => Loan.fromJson({
            'id': 1,
            'duration_in_minutes': 60,
            'status': 'requested',
          }),
          throwsFormatException,
        );

        // Missing duration_in_minutes
        expect(
          () => Loan.fromJson({
            'id': 1,
            'departure_at': '2026-10-01 10:00:00',
            'status': 'requested',
          }),
          throwsFormatException,
        );

        // Missing status
        expect(
          () => Loan.fromJson({
            'id': 1,
            'departure_at': '2026-10-01 10:00:00',
            'duration_in_minutes': 60,
          }),
          throwsFormatException,
        );
      },
    );

    test(
      'serializes LoanCreationRequest with exact keys required by Laravel',
      () {
        const request = LoanCreationRequest(
          loanableId: 123,
          borrowerUserId: 456,
          departureAt: '2026-10-01 09:00:00',
          durationInMinutes: 120,
          estimatedDistance: 20,
          alternativeTo: 'public_transit',
          alternativeToOther: null,
          messageForOwner: 'Merci de prêter votre véhicule !',
        );

        final json = request.toJson();

        expect(json['loanable_id'], 123);
        expect(json['borrower_user_id'], 456);
        expect(json['departure_at'], '2026-10-01 09:00:00');
        expect(json['duration_in_minutes'], 120);
        expect(json['estimated_distance'], 20);
        expect(json['alternative_to'], 'public_transit');
        expect(json['alternative_to_other'], isNull);
        expect(json['message_for_owner'], 'Merci de prêter votre véhicule !');
      },
    );
  });
}

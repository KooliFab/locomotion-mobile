import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/loans/data/datasources/loans_remote_data_source.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import '../../fixtures/loans_fixtures.dart';
import '../../helpers/mock_api_client.dart';

void main() {
  group('LoansRemoteDataSource Tests', () {
    test(
      'getDashboard calls /loans/dashboard and parses all categories',
      () async {
        String? capturedPath;

        final apiClient = createMockApiClient((options) async {
          capturedPath = options.path;
          return jsonResponse(laravelLoansDashboardJson);
        });

        final dataSource = LoansRemoteDataSourceImpl(apiClient);
        final dashboard = await dataSource.getDashboard();

        expect(capturedPath, '/loans/dashboard');
        expect(dashboard.started.total, 1);
        expect(dashboard.waiting.total, 1);
        expect(dashboard.needApproval.total, 1);
        expect(dashboard.future.total, 1);
        expect(dashboard.completed.total, 1);
      },
    );

    test(
      'createLoan serializes exact payload required by POST /loans',
      () async {
        String? capturedPath;
        String? capturedMethod;
        dynamic capturedBody;

        final apiClient = createMockApiClient((options) async {
          capturedPath = options.path;
          capturedMethod = options.method;
          capturedBody = options.data;
          return jsonResponse(laravelCreateLoanResponseJson, statusCode: 201);
        });

        final dataSource = LoansRemoteDataSourceImpl(apiClient);
        const request = LoanCreationRequest(
          loanableId: 1,
          borrowerUserId: 100,
          departureAt: '2026-10-10 10:00:00',
          durationInMinutes: 120,
          estimatedDistance: 25,
          alternativeTo: 'car',
          alternativeToOther: null,
          messageForOwner: 'Trajet pour achat volumineux',
        );

        final loan = await dataSource.createLoan(request);

        expect(capturedPath, '/loans');
        expect(capturedMethod, 'POST');

        final bodyMap = capturedBody is String
            ? jsonDecode(capturedBody)
            : capturedBody;
        expect(bodyMap['loanable_id'], 1);
        expect(bodyMap['borrower_user_id'], 100);
        expect(bodyMap['departure_at'], '2026-10-10 10:00:00');
        expect(bodyMap['duration_in_minutes'], 120);
        expect(bodyMap['estimated_distance'], 25);
        expect(bodyMap['alternative_to'], 'car');
        expect(bodyMap['message_for_owner'], 'Trajet pour achat volumineux');

        expect(loan.id, 25);
        expect(loan.status, 'requested');
      },
    );

    test(
      'propagates ServerException on validation error (422) without swallowing',
      () async {
        final apiClient = createMockApiClient((options) async {
          return jsonResponse({
            'message': 'Le véhicule est indisponible sur ce créneau.',
            'errors': {
              'departure_at': ['Conflit de disponibilité'],
            },
          }, statusCode: 422);
        });

        final dataSource = LoansRemoteDataSourceImpl(apiClient);
        const request = LoanCreationRequest(
          loanableId: 1,
          borrowerUserId: 100,
          departureAt: '2026-10-10 10:00:00',
          durationInMinutes: 120,
          estimatedDistance: 25,
          alternativeTo: 'car',
        );

        expect(
          () => dataSource.createLoan(request),
          throwsA(
            isA<ServerException>().having(
              (e) => e.statusCode,
              'statusCode',
              422,
            ),
          ),
        );
      },
    );
  });
}

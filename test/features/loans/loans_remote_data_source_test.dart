import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/loans/data/datasources/loans_remote_data_source.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_dates_update_request.dart';
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

    test(
      'propagates ConflictException on HTTP 409 without converting to fake success',
      () async {
        final apiClient = createMockApiClient((options) async {
          return jsonResponse({
            'message': 'Créneau déjà réservé par un autre utilisateur.',
          }, statusCode: 409);
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
            isA<ConflictException>().having(
              (e) => e.statusCode,
              'statusCode',
              409,
            ),
          ),
        );
      },
    );

    test(
      'propagates ForbiddenException on HTTP 403 (unapproved borrower)',
      () async {
        final apiClient = createMockApiClient((options) async {
          return jsonResponse({
            'message':
                'Dossier emprunteur non approuvé pour ce type de véhicule.',
          }, statusCode: 403);
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
            isA<ForbiddenException>().having(
              (e) => e.statusCode,
              'statusCode',
              403,
            ),
          ),
        );
      },
    );

    test('propagates UnauthorizedException on HTTP 401', () async {
      final apiClient = createMockApiClient((options) async {
        return jsonResponse({'message': 'Non authentifié.'}, statusCode: 401);
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
          isA<UnauthorizedException>().having(
            (e) => e.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
    });

    test(
      'getLoanDetail calls GET /loans/{id} and parses full LoanResource',
      () async {
        String? capturedPath;
        final apiClient = createMockApiClient((options) async {
          capturedPath = options.path;
          return jsonResponse({'data': laravelLoanDetailJson});
        });

        final dataSource = LoansRemoteDataSourceImpl(apiClient);
        final loan = await dataSource.getLoanDetail(42);

        expect(capturedPath, '/loans/42');
        expect(loan.id, 42);
        expect(loan.status, 'requested');
        expect(loan.loanable?.timezone, 'America/Montreal');
        expect(loan.comments.length, 1);
        expect(loan.comments.first.text, contains('batterie à 80%'));
      },
    );

    test(
      'getLoansPage sends page, per_page, status and borrower_id correctly',
      () async {
        String? capturedPath;
        Map<String, dynamic>? capturedQuery;
        final apiClient = createMockApiClient((options) async {
          capturedPath = options.path;
          capturedQuery = options.queryParameters;
          return jsonResponse(laravelLoansPaginatedJson);
        });

        final dataSource = LoansRemoteDataSourceImpl(apiClient);
        final page = await dataSource.getLoansPage(
          page: 1,
          perPage: 2,
          status: 'canceled,rejected',
          borrowerUserId: 100,
        );

        expect(capturedPath, '/loans');
        expect(capturedQuery?['page'], 1);
        expect(capturedQuery?['per_page'], 2);
        expect(capturedQuery?['status'], 'canceled,rejected');
        expect(capturedQuery?['borrower_user.id'], 100);

        expect(page.data.length, 2);
        expect(page.currentPage, 1);
        expect(page.lastPage, 2);
        expect(page.total, 4);
        expect(page.hasMore, true);
      },
    );

    test(
      'cancelLoan sends PUT /loans/{id}/cancel and returns updated Loan',
      () async {
        String? capturedPath;
        String? capturedMethod;
        final apiClient = createMockApiClient((options) async {
          capturedPath = options.path;
          capturedMethod = options.method;
          final map = Map<String, dynamic>.from(laravelLoanDetailJson);
          map['status'] = 'canceled';
          map['canceled_at'] = '2026-10-02 12:00:00';
          return jsonResponse({'data': map});
        });

        final dataSource = LoansRemoteDataSourceImpl(apiClient);
        final loan = await dataSource.cancelLoan(42);

        expect(capturedPath, '/loans/42/cancel');
        expect(capturedMethod, 'PUT');
        expect(loan.status, 'canceled');
        expect(loan.canceledAt, isNotNull);
      },
    );

    test(
      'updateLoanDates sends PUT /loans/{id}/dates with naive vehicle timezone payload',
      () async {
        String? capturedPath;
        String? capturedMethod;
        dynamic capturedData;
        final apiClient = createMockApiClient((options) async {
          capturedPath = options.path;
          capturedMethod = options.method;
          capturedData = options.data;
          return jsonResponse({'data': laravelLoanDetailJson});
        });

        final dataSource = LoansRemoteDataSourceImpl(apiClient);
        const req = LoanDatesUpdateRequest(
          departureAt: '2026-10-15 15:30:00',
          durationInMinutes: 240,
        );
        await dataSource.updateLoanDates(42, req);

        expect(capturedPath, '/loans/42/dates');
        expect(capturedMethod, 'PUT');
        expect(capturedData['departure_at'], '2026-10-15 15:30:00');
        expect(capturedData['duration_in_minutes'], 240);
      },
    );

    test(
      'addComment sends POST /loans/{id}/comment and parses LoanComment',
      () async {
        String? capturedPath;
        String? capturedMethod;
        dynamic capturedData;
        final apiClient = createMockApiClient((options) async {
          capturedPath = options.path;
          capturedMethod = options.method;
          capturedData = options.data;
          return jsonResponse({
            'data': {
              'id': 10,
              'loan_id': 42,
              'author_id': 100,
              'text': 'Merci beaucoup!',
              'created_at': '2026-10-01 12:00:00',
            },
          });
        });

        final dataSource = LoansRemoteDataSourceImpl(apiClient);
        final comment = await dataSource.addComment(42, 'Merci beaucoup!');

        expect(capturedPath, '/loans/42/comment');
        expect(capturedMethod, 'POST');
        expect(capturedData['text'], 'Merci beaucoup!');
        expect(comment.id, 10);
        expect(comment.text, 'Merci beaucoup!');
      },
    );

    test(
      'acceptLoan sends PUT /loans/{id}/accept with optional comment and parses returned Loan',
      () async {
        String? capturedPath;
        String? capturedMethod;
        dynamic capturedData;
        final apiClient = createMockApiClient((options) async {
          capturedPath = options.path;
          capturedMethod = options.method;
          capturedData = options.data;
          final map = Map<String, dynamic>.from(laravelLoanDetailJson);
          map['status'] = 'confirmed';
          map['accepted_at'] = '2026-10-02 14:00:00';
          return jsonResponse({'data': map});
        });

        final dataSource = LoansRemoteDataSourceImpl(apiClient);
        final loanWithComment = await dataSource.acceptLoan(
          42,
          comment: 'Bonne route !',
        );

        expect(capturedPath, '/loans/42/accept');
        expect(capturedMethod, 'PUT');
        expect(capturedData, {'comment': 'Bonne route !'});
        expect(loanWithComment.status, 'confirmed');

        // Test without comment (empty payload)
        final loanWithoutComment = await dataSource.acceptLoan(42);
        expect(capturedData, isNull);
        expect(loanWithoutComment.status, 'confirmed');
      },
    );

    test(
      'acceptLoan parses and preserves final status accepted when borrower cannot prepay',
      () async {
        final apiClient = createMockApiClient((options) async {
          final map = Map<String, dynamic>.from(laravelLoanDetailJson);
          map['status'] = 'accepted';
          map['accepted_at'] = '2026-10-02 14:00:00';
          return jsonResponse({'data': map});
        });

        final dataSource = LoansRemoteDataSourceImpl(apiClient);
        final loan = await dataSource.acceptLoan(42);
        expect(loan.status, 'accepted');
      },
    );

    test(
      'acceptLoan parses and preserves final status ongoing when departure is already in the past',
      () async {
        final apiClient = createMockApiClient((options) async {
          final map = Map<String, dynamic>.from(laravelLoanDetailJson);
          map['status'] = 'ongoing';
          map['accepted_at'] = '2026-10-02 14:00:00';
          return jsonResponse({'data': map});
        });

        final dataSource = LoansRemoteDataSourceImpl(apiClient);
        final loan = await dataSource.acceptLoan(42);
        expect(loan.status, 'ongoing');
      },
    );

    test(
      'acceptLoan propagates 422 unavailability error without altering local state',
      () async {
        final apiClient = createMockApiClient((options) async {
          return jsonResponse({
            'message': 'Le véhicule n\'est pas disponible sur cette période.',
          }, statusCode: 422);
        });

        final dataSource = LoansRemoteDataSourceImpl(apiClient);
        expect(
          () => dataSource.acceptLoan(42),
          throwsA(
            isA<ServerException>()
                .having((e) => e.statusCode, 'statusCode', 422)
                .having(
                  (e) => e.message,
                  'message',
                  contains('Le véhicule n\'est pas disponible'),
                ),
          ),
        );
      },
    );

    test(
      'rejectLoan sends PUT /loans/{id}/reject with optional comment and parses returned Loan',
      () async {
        String? capturedPath;
        String? capturedMethod;
        dynamic capturedData;
        final apiClient = createMockApiClient((options) async {
          capturedPath = options.path;
          capturedMethod = options.method;
          capturedData = options.data;
          final map = Map<String, dynamic>.from(laravelLoanDetailJson);
          map['status'] = 'rejected';
          return jsonResponse({'data': map});
        });

        final dataSource = LoansRemoteDataSourceImpl(apiClient);
        final loan = await dataSource.rejectLoan(
          42,
          comment: 'Véhicule en révision',
        );

        expect(capturedPath, '/loans/42/reject');
        expect(capturedMethod, 'PUT');
        expect(capturedData, {'comment': 'Véhicule en révision'});
        expect(loan.status, 'rejected');
      },
    );

    test('rejectLoan propagates 403 on loss of access', () async {
      final apiClient = createMockApiClient((options) async {
        return jsonResponse({
          'message': 'Action non autorisée.',
        }, statusCode: 403);
      });

      final dataSource = LoansRemoteDataSourceImpl(apiClient);
      expect(
        () => dataSource.rejectLoan(42),
        throwsA(
          isA<ForbiddenException>().having(
            (e) => e.statusCode,
            'statusCode',
            403,
          ),
        ),
      );
    });

    test(
      'LogInterceptor in ApiClient does not log request or response bodies (privacy check)',
      () {
        final client = ApiClient.create(
          storageService: FakeSecureStorageService(),
          baseUrl: 'http://localhost:8000/api/v1',
        );
        final logInterceptor = client.dio.interceptors
            .whereType<LogInterceptor>()
            .first;
        expect(logInterceptor.requestBody, isFalse);
        expect(logInterceptor.responseBody, isFalse);
      },
    );
  });
}

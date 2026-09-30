import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/loanables/data/datasources/loanables_remote_data_source.dart';
import '../../fixtures/loanables_fixtures.dart';
import '../../helpers/mock_api_client.dart';

void main() {
  group('LoanablesRemoteDataSource Tests', () {
    test(
      'getLoanables passes correct query parameters and parses paginated envelope',
      () async {
        String? capturedPath;
        Map<String, dynamic>? capturedQuery;

        final apiClient = createMockApiClient((options) async {
          capturedPath = options.path;
          capturedQuery = options.queryParameters;
          return jsonResponse(laravelPaginatedLoanablesJson);
        });

        final dataSource = LoanablesRemoteDataSourceImpl(apiClient);
        final result = await dataSource.getLoanables(
          type: 'car',
          communityId: 10,
          page: 1,
        );

        expect(capturedPath, '/loanables');
        expect(capturedQuery?['type'], 'car');
        expect(capturedQuery?['shared_in_community'], 10);
        expect(capturedQuery?['page'], 1);

        expect(result.items.length, 2);
        expect(result.page, 1);
        expect(result.lastPage, 3);
        expect(result.total, 16);
        expect(result.hasMore, isTrue);

        final car = result.items.first;
        expect(car.id, 1);
        expect(car.name, 'Toyota Prius Hybride');
      },
    );

    test(
      'getLoanables reports hasMore when meta indicates another page',
      () async {
        final page2Envelope = {
          'data': [
            {'id': 3, 'name': 'Vélo', 'type': 'bike'},
          ],
          'links': {
            'first': 'http://localhost/api/v1/loanables?page=1',
            'last': 'http://localhost/api/v1/loanables?page=2',
            'prev': 'http://localhost/api/v1/loanables?page=1',
            'next': null,
          },
          'meta': {
            'current_page': 2,
            'from': 16,
            'last_page': 3,
            'per_page': 15,
            'to': 16,
            'total': 40,
          },
        };

        final apiClient = createMockApiClient((options) async {
          return jsonResponse(page2Envelope);
        });

        final dataSource = LoanablesRemoteDataSourceImpl(apiClient);
        final result = await dataSource.getLoanables(page: 2);

        expect(result.page, 2);
        expect(result.lastPage, 3);
        expect(result.hasMore, isTrue);
        expect(result.items.length, 1);
      },
    );

    test(
      'getLoanables throws FormatException on unexpected envelope',
      () async {
        final apiClient = createMockApiClient((options) async {
          return jsonResponse({'unexpected': true});
        });

        final dataSource = LoanablesRemoteDataSourceImpl(apiClient);

        expect(() => dataSource.getLoanables(), throwsFormatException);
      },
    );

    test('getLoanables throws FormatException on invalid list item', () async {
      final apiClient = createMockApiClient((options) async {
        return jsonResponse({
          'data': ['not-a-map'],
          'meta': {'current_page': 1, 'last_page': 1, 'total': 1},
        });
      });

      final dataSource = LoanablesRemoteDataSourceImpl(apiClient);

      expect(() => dataSource.getLoanables(), throwsFormatException);
    });

    test(
      'getLoanableDetails queries correct endpoint and returns Loanable',
      () async {
        String? capturedPath;

        final apiClient = createMockApiClient((options) async {
          capturedPath = options.path;
          return jsonResponse({'data': laravelLoanableDetailJson});
        });

        final dataSource = LoanablesRemoteDataSourceImpl(apiClient);
        final detail = await dataSource.getLoanableDetails(42);

        expect(capturedPath, '/loanables/42');
        expect(detail.id, 1);
        expect(detail.name, 'Toyota Prius Hybride');
        expect(detail.type, 'car');
      },
    );

    test(
      'getAvailability sends start, end and responseMode and parses events',
      () async {
        String? capturedPath;
        Map<String, dynamic>? capturedQuery;

        final apiClient = createMockApiClient((options) async {
          capturedPath = options.path;
          capturedQuery = options.queryParameters;
          return jsonResponse(laravelAvailabilityEventsJson);
        });

        final dataSource = LoanablesRemoteDataSourceImpl(apiClient);
        final intervals = await dataSource.getAvailability(
          5,
          start: '2026-10-01 00:00:00',
          end: '2026-10-02 00:00:00',
          responseMode: 'unavailable',
        );

        expect(capturedPath, '/loanables/5/availability');
        expect(capturedQuery?['start'], '2026-10-01 00:00:00');
        expect(capturedQuery?['end'], '2026-10-02 00:00:00');
        expect(capturedQuery?['responseMode'], 'unavailable');

        expect(intervals.length, 3);
        expect(intervals.first.isAvailable, true);
      },
    );

    test('getAvailability defaults to responseMode=available', () async {
      Map<String, dynamic>? capturedQuery;

      final apiClient = createMockApiClient((options) async {
        capturedQuery = options.queryParameters;
        return jsonResponse(laravelAvailabilityEventsJson);
      });

      final dataSource = LoanablesRemoteDataSourceImpl(apiClient);
      await dataSource.getAvailability(
        5,
        start: '2026-10-01 00:00:00',
        end: '2026-10-02 00:00:00',
      );

      expect(capturedQuery?['responseMode'], 'available');
    });

    test(
      'throws FormatException on unexpected availability response envelope (P1 check)',
      () async {
        final apiClient = createMockApiClient((options) async {
          return jsonResponse({'unexpected': 'envelope'});
        });

        final dataSource = LoanablesRemoteDataSourceImpl(apiClient);

        expect(
          () => dataSource.getAvailability(
            1,
            start: '2026-10-01',
            end: '2026-10-02',
          ),
          throwsFormatException,
        );
      },
    );

    test(
      'propagates ServerException on HTTP error without returning fake fallback',
      () async {
        final apiClient = createMockApiClient((options) async {
          return jsonResponse({
            'message': 'Vehicule introuvable.',
          }, statusCode: 404);
        });

        final dataSource = LoanablesRemoteDataSourceImpl(apiClient);

        expect(
          () => dataSource.getLoanableDetails(999),
          throwsA(
            isA<ServerException>().having(
              (e) => e.statusCode,
              'statusCode',
              404,
            ),
          ),
        );
      },
    );
  });
}

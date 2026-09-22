import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/loanables/data/datasources/loanables_remote_data_source.dart';
import '../../fixtures/loanables_fixtures.dart';
import '../../helpers/mock_api_client.dart';

void main() {
  group('LoanablesRemoteDataSource Tests', () {
    test('getLoanables passes correct query parameters and parses paginated envelope', () async {
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
      expect(capturedQuery?['community_id'], 10);
      expect(capturedQuery?['page'], 1);

      expect(result.length, 2);
      expect(result.first.id, 1);
      expect(result.first.name, 'Toyota Prius Hybride');
    });

    test('getLoanableDetails queries correct endpoint and returns Loanable', () async {
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
    });

    test('getAvailability sends start, end and responseMode=available and parses events', () async {
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
      );

      expect(capturedPath, '/loanables/5/availability');
      expect(capturedQuery?['start'], '2026-10-01 00:00:00');
      expect(capturedQuery?['end'], '2026-10-02 00:00:00');
      expect(capturedQuery?['responseMode'], 'available');

      expect(intervals.length, 3);
      expect(intervals.first.isAvailable, true);
    });

    test('throws FormatException on unexpected availability response envelope (P1 check)', () async {
      final apiClient = createMockApiClient((options) async {
        return jsonResponse({'unexpected': 'envelope'});
      });

      final dataSource = LoanablesRemoteDataSourceImpl(apiClient);

      expect(
        () => dataSource.getAvailability(1, start: '2026-10-01', end: '2026-10-02'),
        throwsFormatException,
      );
    });

    test('propagates ServerException on HTTP error without returning fake fallback', () async {
      final apiClient = createMockApiClient((options) async {
        return jsonResponse(
          {'message': 'Vehicule introuvable.'},
          statusCode: 404,
        );
      });

      final dataSource = LoanablesRemoteDataSourceImpl(apiClient);

      expect(
        () => dataSource.getLoanableDetails(999),
        throwsA(isA<ServerException>().having(
          (e) => e.statusCode,
          'statusCode',
          404,
        )),
      );
    });
  });
}

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/constants/app_constants.dart';
import 'package:mobile/features/loans/data/datasources/loan_inspection_remote_data_source.dart';
import 'package:mobile/features/loans/data/repositories/loan_inspection_repository_impl.dart';
import '../../helpers/mock_api_client.dart';

void main() {
  group('LoanInspectionRemoteDataSource & Repository', () {
    test(
      'uploadInspectionPhoto posts to /images and returns image ID',
      () async {
        final apiClient = createMockApiClient((options) async {
          expect(options.path, equals(ApiEndpoints.images));
          expect(options.method, equals('POST'));

          return ResponseBody.fromString(
            jsonEncode({
              'data': {
                'id': 456,
                'field': 'front',
                'url': 'http://localhost/images/tmp/1/front.jpg',
              },
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        final dataSource = LoanInspectionRemoteDataSourceImpl(apiClient);
        final repo = LoanInspectionRepositoryImpl(dataSource);

        // Create a temporary mock file
        final tempDir = Directory.systemTemp.createTempSync();
        final tempFile = File('${tempDir.path}/front_test.jpg')
          ..writeAsStringSync('fake-jpeg-data');

        final imageId = await repo.uploadInspectionPhoto(
          file: tempFile,
          field: 'front',
        );

        expect(imageId, equals(456));
        tempDir.deleteSync(recursive: true);
      },
    );

    test(
      'submitDepartureInspection posts payload to departure endpoint with Idempotency-Key',
      () async {
        Map<String, dynamic>? capturedBody;
        String? capturedIdempotency;

        final apiClient = createMockApiClient((options) async {
          expect(
            options.path,
            equals(ApiEndpoints.loanDepartureInspection(42)),
          );
          expect(options.method, equals('POST'));
          capturedIdempotency = options.headers['Idempotency-Key'];
          capturedBody = options.data is Map<String, dynamic>
              ? options.data
              : null;

          return ResponseBody.fromString(
            jsonEncode({
              'data': {
                'id': 101,
                'loan_id': 42,
                'inspection_type': 'departure',
                'odometer_km': 150000,
                'fuel_battery_level_percent': 90,
                'cleanliness_rating': 5,
                'checklist': {'key_present': true},
                'photos': {'front': 'images/tmp/1/front.jpg'},
                'existing_damages_notes': 'Aucun dégât',
                'sealed_hash': 'sha256_sealed_test_hash',
                'created_at': '2026-10-03T11:00:00.000Z',
              },
            }),
            201,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        final dataSource = LoanInspectionRemoteDataSourceImpl(apiClient);
        final repo = LoanInspectionRepositoryImpl(dataSource);

        final payload = {
          'odometer_km': 150000,
          'fuel_battery_level_percent': 90,
          'cleanliness_rating': 5,
          'checklist': {'key_present': true},
          'photos': {'front': 'images/tmp/1/front.jpg'},
          'existing_damages_notes': 'Aucun dégât',
        };

        final inspection = await repo.submitDepartureInspection(
          loanId: 42,
          payload: payload,
          idempotencyKey: 'idem-key-12345',
        );

        expect(capturedIdempotency, equals('idem-key-12345'));
        expect(capturedBody?['odometer_km'], equals(150000));
        expect(inspection.loanId, equals(42));
        expect(inspection.inspectionType, equals('departure'));
        expect(inspection.odometerKm, equals(150000));
        expect(inspection.sealedHash, equals('sha256_sealed_test_hash'));
      },
    );

    test(
      'getDepartureInspection retrieves departure inspection for loan',
      () async {
        final apiClient = createMockApiClient((options) async {
          expect(options.path, equals(ApiEndpoints.loanInspections(42)));
          expect(options.method, equals('GET'));

          return ResponseBody.fromString(
            jsonEncode({
              'data': {
                'departure': {
                  'id': 202,
                  'loan_id': 42,
                  'inspection_type': 'departure',
                  'odometer_km': 98000,
                  'fuel_battery_level_percent': 75,
                  'cleanliness_rating': 4,
                  'checklist': {'key_present': true},
                  'photos': {},
                  'created_at': '2026-10-03T11:00:00.000Z',
                },
                'return': null,
              },
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        final dataSource = LoanInspectionRemoteDataSourceImpl(apiClient);
        final repo = LoanInspectionRepositoryImpl(dataSource);

        final inspection = await repo.getDepartureInspection(42);
        expect(inspection, isNotNull);
        expect(inspection!.loanId, equals(42));
        expect(inspection.odometerKm, equals(98000));
      },
    );

    test(
      'getDepartureInspection returns null when departure is null',
      () async {
        final apiClient = createMockApiClient((options) async {
          return ResponseBody.fromString(
            jsonEncode({
              'data': {'departure': null, 'return': null},
            }),
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        });

        final dataSource = LoanInspectionRemoteDataSourceImpl(apiClient);
        final repo = LoanInspectionRepositoryImpl(dataSource);

        final inspection = await repo.getDepartureInspection(42);
        expect(inspection, isNull);
      },
    );
  });
}

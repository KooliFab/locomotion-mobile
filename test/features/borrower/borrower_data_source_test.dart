import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/borrower/data/datasources/borrower_remote_data_source.dart';
import 'package:mobile/features/borrower/domain/entities/borrower_submission_request.dart';
import '../../fixtures/borrower_fixtures.dart';
import '../../helpers/mock_api_client.dart';

void main() {
  group('BorrowerRemoteDataSource.uploadFile', () {
    test(
      'sends correct multipart: field key + file key = field value',
      () async {
        late RequestOptions capturedOptions;
        final client = createMockApiClient((options) async {
          capturedOptions = options;
          return jsonResponse(uploadedFileRefJson);
        });
        final ds = BorrowerRemoteDataSourceImpl(client);
        final tmpFile = File('${Directory.systemTemp.path}/test_gaa.pdf');
        await tmpFile.writeAsString('fake pdf content');

        try {
          final result = await ds.uploadFile(field: 'gaa', file: tmpFile);
          expect(result.id, 123);
          expect(result.field, 'gaa');
          expect(result.originalFilename, 'document.pdf');

          // Verify multipart structure
          final formData = capturedOptions.data as FormData;
          final fieldPart = formData.fields.firstWhere((f) => f.key == 'field');
          expect(fieldPart.value, 'gaa');
          // File part key should equal field value
          expect(formData.files.any((f) => f.key == 'gaa'), true);
        } finally {
          await tmpFile.delete();
        }
      },
    );

    test('throws ValidationException on 422', () async {
      final client = createMockApiClient((options) async {
        return jsonResponse({
          'message': 'Fichier invalide',
          'errors': {
            'gaa': ['Format non accepté'],
          },
        }, statusCode: 422);
      });
      final ds = BorrowerRemoteDataSourceImpl(client);
      final tmpFile = File('${Directory.systemTemp.path}/test_bad.exe');
      await tmpFile.writeAsString('bad file');
      try {
        await expectLater(
          () => ds.uploadFile(field: 'gaa', file: tmpFile),
          throwsA(isA<ValidationException>()),
        );
      } finally {
        await tmpFile.delete();
      }
    });

    test('throws NetworkException on connection error', () async {
      final client = createMockApiClient((_) async {
        throw DioException(
          requestOptions: RequestOptions(path: '/files'),
          type: DioExceptionType.connectionError,
        );
      });
      final ds = BorrowerRemoteDataSourceImpl(client);
      final tmpFile = File('${Directory.systemTemp.path}/test_net.pdf');
      await tmpFile.writeAsString('content');
      try {
        await expectLater(
          () => ds.uploadFile(field: 'gaa', file: tmpFile),
          throwsA(isA<NetworkException>()),
        );
      } finally {
        await tmpFile.delete();
      }
    });
  });

  group('BorrowerRemoteDataSource.submitBorrower', () {
    const request = BorrowerSubmissionRequest(
      userId: 42,
      driversLicenseNumber: 'TEST-XXXX',
      hasNotBeenSuedLastTenYears: true,
      gaa: [FileIdRef(id: 101)],
      saaq: [FileIdRef(id: 102)],
    );

    test('returns Borrower on success', () async {
      final client = createMockApiClient((_) async {
        return jsonResponse(borrowerPendingJson);
      });
      final ds = BorrowerRemoteDataSourceImpl(client);
      final borrower = await ds.submitBorrower(request);
      expect(borrower.userId, 42);
      expect(borrower.submittedAt, isNotNull);
    });

    test('throws UnauthorizedException on 401', () async {
      final client = createMockApiClient((_) async {
        return jsonResponse({'message': 'Unauthenticated.'}, statusCode: 401);
      });
      final ds = BorrowerRemoteDataSourceImpl(client);
      await expectLater(
        () => ds.submitBorrower(request),
        throwsA(isA<UnauthorizedException>()),
      );
    });

    test('throws ForbiddenException on 403', () async {
      final client = createMockApiClient((_) async {
        return jsonResponse({
          'message': 'This action is unauthorized.',
        }, statusCode: 403);
      });
      final ds = BorrowerRemoteDataSourceImpl(client);
      await expectLater(
        () => ds.submitBorrower(request),
        throwsA(isA<ForbiddenException>()),
      );
    });

    test('throws ValidationException on 422 with field errors', () async {
      final client = createMockApiClient((_) async {
        return jsonResponse({
          'message': 'Le champ numéro de permis est requis.',
          'errors': {
            'drivers_license_number': ['Le champ numéro de permis est requis.'],
          },
        }, statusCode: 422);
      });
      final ds = BorrowerRemoteDataSourceImpl(client);
      // Caller should preserve local form content — not mark as submitted
      await expectLater(
        () => ds.submitBorrower(request),
        throwsA(isA<ValidationException>()),
      );
    });

    test(
      'throws NetworkException on connection error — not deduced as success',
      () async {
        final client = createMockApiClient((_) async {
          throw DioException(
            requestOptions: RequestOptions(path: '/users/42/borrower/submit'),
            type: DioExceptionType.connectionError,
          );
        });
        final ds = BorrowerRemoteDataSourceImpl(client);
        await expectLater(
          () => ds.submitBorrower(request),
          throwsA(isA<NetworkException>()),
        );
      },
    );
  });
}

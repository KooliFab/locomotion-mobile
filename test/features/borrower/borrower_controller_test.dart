import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/borrower/domain/entities/borrower.dart';
import 'package:mobile/features/borrower/domain/entities/borrower_submission_request.dart';
import 'package:mobile/features/borrower/domain/entities/uploaded_file_ref.dart';
import 'package:mobile/features/borrower/domain/repositories/borrower_repository.dart';
import 'dart:io';

/// Fake repository for controller tests
class _FakeBorrowerRepository implements BorrowerRepository {
  final Exception? uploadError;
  final Exception? submitError;

  _FakeBorrowerRepository({this.uploadError, this.submitError});

  @override
  Future<UploadedFileRef> uploadFile({
    required String field,
    required File file,
  }) async {
    if (uploadError != null) throw uploadError!;
    throw UnimplementedError('No upload result configured');
  }

  @override
  Future<Borrower> submitBorrower(BorrowerSubmissionRequest request) async {
    if (submitError != null) throw submitError!;
    throw UnimplementedError('No submit result configured');
  }
}

void main() {
  group('BorrowerRepository error propagation', () {
    test(
      'uploadFile propagates NetworkException — no success assumed',
      () async {
        final repo = _FakeBorrowerRepository(
          uploadError: const NetworkException(message: 'Pas de réseau'),
        );
        await expectLater(
          () => repo.uploadFile(field: 'gaa', file: File('fake')),
          throwsA(isA<NetworkException>()),
        );
      },
    );

    test(
      'submitBorrower propagates ValidationException — form preserved',
      () async {
        final repo = _FakeBorrowerRepository(
          submitError: const ValidationException(
            message: 'Invalide',
            errors: {
              'gaa': ['Fichier requis'],
            },
          ),
        );
        const request = BorrowerSubmissionRequest(
          userId: 42,
          driversLicenseNumber: 'TEST',
          hasNotBeenSuedLastTenYears: true,
          gaa: [],
          saaq: [],
        );
        await expectLater(
          () => repo.submitBorrower(request),
          throwsA(
            isA<ValidationException>().having(
              (e) => e.errors?['gaa'],
              'gaa error',
              isNotNull,
            ),
          ),
        );
      },
    );

    test('submitBorrower propagates UnauthorizedException on 401', () async {
      final repo = _FakeBorrowerRepository(
        submitError: const UnauthorizedException(),
      );
      const request = BorrowerSubmissionRequest(
        userId: 42,
        driversLicenseNumber: 'TEST',
        hasNotBeenSuedLastTenYears: true,
        gaa: [],
        saaq: [],
      );
      await expectLater(
        () => repo.submitBorrower(request),
        throwsA(isA<UnauthorizedException>()),
      );
    });
  });
}

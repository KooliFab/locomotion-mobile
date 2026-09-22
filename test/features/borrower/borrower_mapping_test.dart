import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/borrower/domain/entities/borrower.dart';
import 'package:mobile/features/borrower/domain/entities/borrower_status.dart';
import 'package:mobile/features/borrower/domain/entities/borrower_submission_request.dart';
import 'package:mobile/features/borrower/domain/entities/uploaded_file_ref.dart';
import '../../fixtures/borrower_fixtures.dart';

void main() {
  group('Borrower.fromJson', () {
    test('parses incomplete borrower (submittedAt == null)', () {
      final borrower = Borrower.fromJson(borrowerIncompleteJson);
      expect(borrower.userId, 42);
      expect(borrower.submittedAt, isNull);
      expect(borrower.approved, false);
      expect(borrower.suspended, false);
      expect(borrower.validated, false);
    });

    test('parses pending borrower', () {
      final borrower = Borrower.fromJson(borrowerPendingJson);
      expect(borrower.submittedAt, isNotNull);
      expect(borrower.approved, false);
      expect(borrower.suspended, false);
      expect(borrower.validated, false);
    });

    test('parses validated borrower', () {
      final borrower = Borrower.fromJson(borrowerValidatedJson);
      expect(borrower.validated, true);
      expect(borrower.approved, true);
      expect(borrower.suspended, false);
    });

    test('parses suspended borrower', () {
      final borrower = Borrower.fromJson(borrowerSuspendedJson);
      expect(borrower.suspended, true);
      expect(borrower.suspendedAt, isNotNull);
    });

    test('parses unexpected combination borrower', () {
      final borrower = Borrower.fromJson(borrowerUnexpectedJson);
      expect(borrower.approved, true);
      expect(borrower.validated, false);
      // approved_at is set, validated is false — unexpected state
    });

    test('toString does not expose driversLicenseNumber', () {
      final borrower = Borrower.fromJson({
        ...borrowerValidatedJson,
        'drivers_license_number': 'A99999-SENSITIVE',
      });
      expect(borrower.toString(), isNot(contains('A99999-SENSITIVE')));
    });
  });

  group('BorrowerStatus.from', () {
    test('null borrower => incomplete', () {
      expect(BorrowerStatusX.from(null), BorrowerStatus.incomplete);
    });

    test('submittedAt null => incomplete', () {
      final b = Borrower.fromJson(borrowerIncompleteJson);
      expect(BorrowerStatusX.from(b), BorrowerStatus.incomplete);
    });

    test('submitted, not approved, not suspended => pending', () {
      final b = Borrower.fromJson(borrowerPendingJson);
      expect(BorrowerStatusX.from(b), BorrowerStatus.pending);
    });

    test('validated => validated', () {
      final b = Borrower.fromJson(borrowerValidatedJson);
      expect(BorrowerStatusX.from(b), BorrowerStatus.validated);
    });

    test('suspended => suspended', () {
      final b = Borrower.fromJson(borrowerSuspendedJson);
      expect(BorrowerStatusX.from(b), BorrowerStatus.suspended);
    });

    test('unexpected combination => checkRequired', () {
      final b = Borrower.fromJson(borrowerUnexpectedJson);
      expect(BorrowerStatusX.from(b), BorrowerStatus.checkRequired);
    });
  });

  group('UploadedFileRef.fromJson', () {
    test('parses correctly from FileResource', () {
      final ref = UploadedFileRef.fromJson(uploadedFileRefJson);
      expect(ref.id, 123);
      expect(ref.originalFilename, 'document.pdf');
      expect(ref.field, 'gaa');
    });
  });

  group('BorrowerSubmissionRequest.toJson', () {
    test('serializes gaa and saaq as list of {id}', () {
      const request = BorrowerSubmissionRequest(
        userId: 42,
        driversLicenseNumber: 'TEST-XXXX',
        hasNotBeenSuedLastTenYears: true,
        gaa: [FileIdRef(id: 101)],
        saaq: [FileIdRef(id: 102)],
      );
      final json = request.toJson();
      expect(json['user_id'], 42);
      expect(json['has_not_been_sued_last_ten_years'], true);
      expect(json['gaa'], [
        {'id': 101},
      ]);
      expect(json['saaq'], [
        {'id': 102},
      ]);
    });

    test('toString does not expose driversLicenseNumber', () {
      const request = BorrowerSubmissionRequest(
        userId: 42,
        driversLicenseNumber: 'SENSITIVE-LICENSE',
        hasNotBeenSuedLastTenYears: true,
        gaa: [FileIdRef(id: 1)],
        saaq: [FileIdRef(id: 2)],
      );
      expect(request.toString(), isNot(contains('SENSITIVE-LICENSE')));
    });
  });
}

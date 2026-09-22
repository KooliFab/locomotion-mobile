import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/borrower/domain/entities/borrower.dart';
import 'package:mobile/features/borrower/domain/usecases/borrower_eligibility.dart';
import '../../fixtures/borrower_fixtures.dart';

void main() {
  group('BorrowerEligibility.canRequest', () {
    final validatedBorrower = Borrower.fromJson(borrowerValidatedJson);
    final pendingBorrower = Borrower.fromJson(borrowerPendingJson);
    final incompleteBorrower = Borrower.fromJson(borrowerIncompleteJson);
    const nullBorrower = null;

    group('car', () {
      test('allows when validated', () {
        expect(BorrowerEligibility.canRequest('car', validatedBorrower), true);
      });
      test('blocks when pending', () {
        expect(BorrowerEligibility.canRequest('car', pendingBorrower), false);
      });
      test('blocks when incomplete', () {
        expect(
          BorrowerEligibility.canRequest('car', incompleteBorrower),
          false,
        );
      });
      test('blocks when null', () {
        expect(BorrowerEligibility.canRequest('car', nullBorrower), false);
      });
    });

    group('car_trailer', () {
      test('allows when validated', () {
        expect(
          BorrowerEligibility.canRequest('car_trailer', validatedBorrower),
          true,
        );
      });
      test('blocks when not validated', () {
        expect(
          BorrowerEligibility.canRequest('car_trailer', pendingBorrower),
          false,
        );
      });
      test('blocks when null', () {
        expect(
          BorrowerEligibility.canRequest('car_trailer', nullBorrower),
          false,
        );
      });
    });

    group('bike', () {
      test('allows regardless of borrower state', () {
        expect(BorrowerEligibility.canRequest('bike', nullBorrower), true);
        expect(
          BorrowerEligibility.canRequest('bike', incompleteBorrower),
          true,
        );
        expect(BorrowerEligibility.canRequest('bike', validatedBorrower), true);
      });
    });

    group('trailer', () {
      test('allows regardless of borrower state', () {
        expect(BorrowerEligibility.canRequest('trailer', nullBorrower), true);
        expect(
          BorrowerEligibility.canRequest('trailer', incompleteBorrower),
          true,
        );
        expect(
          BorrowerEligibility.canRequest('trailer', validatedBorrower),
          true,
        );
      });
    });

    group('unknown type', () {
      test('allows by default (defers to backend)', () {
        expect(BorrowerEligibility.canRequest('scooter', nullBorrower), true);
      });
    });
  });
}

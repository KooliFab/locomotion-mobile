import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/loans/domain/entities/loan_draft.dart';
import 'package:mobile/features/loans/domain/entities/transport_alternative.dart';

void main() {
  group('LoanDraft Validation & Domain Tests', () {
    const baseDraft = LoanDraft(
      loanableId: 1,
      loanableName: 'Toyota Prius Hybride',
      loanableType: 'car',
      minLoanDurationInMinutes: 60,
      maxLoanDurationInMinutes: 480,
      departureDate: '2026-10-10',
      departureTime: '14:30',
      durationInMinutes: 120,
      estimatedDistance: 30,
      alternativeTo: TransportAlternative.publicTransit,
    );

    test(
      'valid draft produces correct departureAtString and has no errors',
      () {
        expect(baseDraft.isValid, isTrue);
        expect(baseDraft.scheduleValidationError, isNull);
        expect(baseDraft.tripDetailsValidationError, isNull);
        expect(baseDraft.fullValidationError, isNull);
        expect(baseDraft.departureAtString, '2026-10-10 14:30:00');
      },
    );

    test('schedule validation detects missing departure date', () {
      final draft = baseDraft.copyWith(departureDate: null);
      expect(draft.isValid, isFalse);
      expect(draft.scheduleValidationError, contains('date de départ'));
    });

    test('schedule validation detects missing departure time', () {
      final draft = baseDraft.copyWith(departureTime: null);
      expect(draft.isValid, isFalse);
      expect(draft.scheduleValidationError, contains('heure de départ'));
    });

    test('schedule validation rejects departure date in the past for vehicle timezone', () {
      final draft = baseDraft.copyWith(
        departureDate: '2020-01-01',
        vehicleTimezone: 'America/Montreal',
      );
      expect(draft.isValid, isFalse);
      expect(
        draft.scheduleValidationError,
        contains('ne peut pas être dans le passé'),
      );
    });

    test('schedule validation enforces min loan duration bound', () {
      final draft = baseDraft.copyWith(durationInMinutes: 30); // min is 60
      expect(draft.isValid, isFalse);
      expect(draft.scheduleValidationError, contains('durée minimale'));
    });

    test('schedule validation enforces max loan duration bound', () {
      final draft = baseDraft.copyWith(durationInMinutes: 600); // max is 480
      expect(draft.isValid, isFalse);
      expect(draft.scheduleValidationError, contains('durée maximale'));
    });

    test('trip details validation requires positive estimated distance', () {
      final draftZero = baseDraft.copyWith(estimatedDistance: 0);
      expect(draftZero.isValid, isFalse);
      expect(
        draftZero.tripDetailsValidationError,
        contains('distance estimée'),
      );

      final draftNull = baseDraft.copyWith(estimatedDistance: null);
      expect(draftNull.isValid, isFalse);
      expect(
        draftNull.tripDetailsValidationError,
        contains('distance estimée'),
      );
    });

    test('trip details validation requires transport alternative', () {
      final draft = baseDraft.copyWith(alternativeTo: null);
      expect(draft.isValid, isFalse);
      expect(
        draft.tripDetailsValidationError,
        contains('mode de transport remplacé'),
      );
    });

    test(
      'trip details validation requires alternativeToOther when other is selected',
      () {
        final draftWithoutOther = baseDraft.copyWith(
          alternativeTo: TransportAlternative.other,
          alternativeToOther: null,
        );
        expect(draftWithoutOther.isValid, isFalse);
        expect(
          draftWithoutOther.tripDetailsValidationError,
          contains('préciser l\'autre mode'),
        );

        final draftWithEmptyOther = baseDraft.copyWith(
          alternativeTo: TransportAlternative.other,
          alternativeToOther: '   ',
        );
        expect(draftWithEmptyOther.isValid, isFalse);

        final draftWithOther = baseDraft.copyWith(
          alternativeTo: TransportAlternative.other,
          alternativeToOther: 'Covoiturage entre collègues',
        );
        expect(draftWithOther.isValid, isTrue);
      },
    );

    test('all transport alternatives parse properly from value', () {
      for (final alt in TransportAlternative.values) {
        final parsed = TransportAlternative.fromValue(alt.value);
        expect(parsed, alt);
        expect(alt.label.isNotEmpty, isTrue);
      }
      expect(TransportAlternative.fromValue('invalid_code'), isNull);
    });
  });
}

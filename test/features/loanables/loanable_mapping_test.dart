import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/loanables/domain/entities/loanable.dart';
import 'package:mobile/features/loanables/domain/entities/loanable_availability.dart';
import 'package:mobile/features/loanables/domain/entities/vehicle_local_dates.dart';
import '../../fixtures/loanables_fixtures.dart';

void main() {
  group('Loanable Mapping Tests', () {
    test('parses real ListLoanableResource paginated collection correctly', () {
      final items = (laravelPaginatedLoanablesJson['data'] as List)
          .map((e) => Loanable.fromJson(e as Map<String, dynamic>))
          .toList();

      expect(items.length, 2);

      final car = items.first;
      expect(car.id, 1);
      expect(car.name, 'Toyota Prius Hybride');
      expect(car.type, 'car');
      expect(car.sharingMode, 'self_service');
      expect(car.availabilityStatus, 'has_availabilities');
      expect(car.isAvailable, true);
      expect(car.timezone, 'America/Montreal');
      expect(car.latitude, 45.5532);
      expect(car.longitude, -73.6543);
      expect(car.communityName, isNull);
      expect(car.activeIncidents.length, 1);
      expect(car.activeIncidents.first.incidentType, 'breakdown');
      expect(car.activeIncidents.first.isBlocking, false);
      // ListLoanableResource does not contain image
      expect(car.image, isNull);

      final bike = items.last;
      expect(bike.id, 2);
      expect(bike.name, 'Vélo Cargo Babboe');
      expect(bike.type, 'bike');
      expect(bike.sharingMode, 'on_demand');
      expect(bike.availabilityStatus, 'no_availabilities');
      expect(bike.isAvailable, false);
      expect(bike.communityName, isNull);
      expect(bike.image, isNull);
    });

    test(
      'parses full LoanableResource detail correctly with images and details',
      () {
        final detail = Loanable.fromJson(laravelLoanableDetailJson);

        expect(detail.id, 1);
        expect(detail.type, 'car');
        expect(detail.name, 'Toyota Prius Hybride');
        expect(detail.sharingMode, 'self_service');
        expect(detail.minLoanDurationInMinutes, 30);
        expect(detail.maxLoanDurationInMinutes, 2880);
        expect(detail.instructions, contains('boîte à gants'));
        expect(detail.returnInstructions, contains('Verrouiller'));
        expect(
          detail.locationDescription,
          'Stationnement réservé rue Lajeunesse',
        );
        expect(detail.comments, contains('propre'));
        expect(detail.image, isNotNull);
        expect(detail.image!.id, 42);
        expect(
          detail.image!.buildUrl(
            'http://localhost:8000/api/v1',
            size: 'thumbnail',
          ),
          'http://localhost:8000/api/v1/images/42?size=thumbnail',
        );
        expect(detail.images.length, 2);
        expect(detail.images[0].id, 42);
        expect(detail.images[1].id, 43);
        expect(detail.details?['seats'], 5);
        expect(detail.latitude, 45.5532);
        expect(detail.longitude, -73.6543);
      },
    );

    test('null availability status is not treated as available', () {
      final item = Loanable.fromJson({
        'id': 1,
        'name': 'Vélo',
        'type': 'bike',
        'availability_status': null,
      });
      expect(item.isAvailable, false);
    });

    test('tolerates missing optional fields without inventing fake data', () {
      final minimalJson = <String, dynamic>{
        'id': 99,
        'name': 'Vélo simple',
        'type': 'bike',
      };

      final item = Loanable.fromJson(minimalJson);

      expect(item.id, 99);
      expect(item.name, 'Vélo simple');
      expect(item.type, 'bike');
      expect(item.latitude, isNull);
      expect(item.longitude, isNull);
      expect(item.availabilityStatus, isNull);
      expect(item.isAvailable, false);
      expect(item.timezone, isNull);
      expect(item.image, isNull);
      expect(item.images, isEmpty);
      expect(item.activeIncidents, isEmpty);
      expect(item.minLoanDurationInMinutes, isNull);
      expect(item.maxLoanDurationInMinutes, isNull);
      expect(item.instructions, isNull);
    });

    test('parses availability events correctly from data.available', () {
      final intervals = laravelAvailabilityEventsJson
          .map((e) => LoanableAvailabilityInterval.fromJson(e))
          .toList();

      expect(intervals.length, 3);

      expect(intervals[0].isAvailable, true);
      expect(intervals[0].start, DateTime(2026, 10, 1, 8, 0, 0));
      expect(intervals[0].end, DateTime(2026, 10, 1, 12, 0, 0));

      expect(intervals[1].isAvailable, false);
      expect(intervals[1].start, DateTime(2026, 10, 1, 12, 0, 0));
      expect(intervals[1].end, DateTime(2026, 10, 1, 14, 0, 0));

      expect(intervals[2].isAvailable, true);
      expect(intervals[2].start, DateTime(2026, 10, 1, 14, 0, 0));
      expect(intervals[2].end, DateTime(2026, 10, 1, 18, 0, 0));
    });

    test('vehicle-local dates keep naive strings and shift by whole days', () {
      expect(VehicleLocalDates.hhmm('2026-10-01 08:30:00'), '08:30');
      expect(VehicleLocalDates.dayOf('2026-10-01 08:30:00'), '2026-10-01');
      expect(VehicleLocalDates.shiftYmd('2026-10-01', 7), '2026-10-08');
      expect(VehicleLocalDates.shiftYmd('2026-10-01', -7), '2026-09-24');
      // Cross a DST boundary on wall-clock dates (no device TZ involved).
      expect(VehicleLocalDates.shiftYmd('2026-03-07', 2), '2026-03-09');
      expect(VehicleLocalDates.daysFrom('2026-10-01', 7), [
        '2026-10-01',
        '2026-10-02',
        '2026-10-03',
        '2026-10-04',
        '2026-10-05',
        '2026-10-06',
        '2026-10-07',
      ]);
      expect(VehicleLocalDates.hhmm(null), '');
      expect(VehicleLocalDates.dayOf(null), '');
      expect(
        () => VehicleLocalDates.shiftYmd('not-a-date', 1),
        throwsFormatException,
      );
    });

    test(
      'throws FormatException on malformed availability event (P1 check)',
      () {
        // Missing data.available
        expect(
          () => LoanableAvailabilityInterval.fromJson({
            'type': 'availability',
            'start': '2026-10-01 08:00:00',
            'end': '2026-10-01 12:00:00',
          }),
          throwsFormatException,
        );

        // Missing start or end
        expect(
          () => LoanableAvailabilityInterval.fromJson({
            'type': 'availability',
            'end': '2026-10-01 12:00:00',
            'data': {'available': true},
          }),
          throwsFormatException,
        );

        // Invalid date format
        expect(
          () => LoanableAvailabilityInterval.fromJson({
            'type': 'availability',
            'start': 'not-a-date',
            'end': '2026-10-01 12:00:00',
            'data': {'available': true},
          }),
          throwsFormatException,
        );
      },
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/loanables/domain/entities/loanable.dart';
import 'package:mobile/features/loanables/domain/entities/loanable_availability.dart';
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
      expect(car.availabilityStatus, 'available');
      expect(car.isAvailable, true);
      expect(car.timezone, 'America/Montreal');
      expect(car.latitude, 45.5532);
      expect(car.longitude, -73.6543);
      expect(car.communityName, 'Bibliothèque LocoMotion Ahuntsic');
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
      expect(bike.availabilityStatus, 'unavailable');
      expect(bike.isAvailable, false);
      expect(bike.communityName, 'Bibliothèque Petite-Patrie');
      expect(bike.image, isNull);
    });

    test('parses full LoanableResource detail correctly with images and details', () {
      final detail = Loanable.fromJson(laravelLoanableDetailJson);

      expect(detail.id, 1);
      expect(detail.type, 'car');
      expect(detail.name, 'Toyota Prius Hybride');
      expect(detail.sharingMode, 'self_service');
      expect(detail.minLoanDurationInMinutes, 30);
      expect(detail.maxLoanDurationInMinutes, 2880);
      expect(detail.instructions, contains('boîte à gants'));
      expect(detail.returnInstructions, contains('Verrouiller'));
      expect(detail.locationDescription, 'Stationnement réservé rue Lajeunesse');
      expect(detail.comments, contains('propre'));
      expect(detail.image, isNotNull);
      expect(detail.image!.id, 42);
      expect(
        detail.image!.buildUrl('http://localhost:8000/api/v1', size: 'thumbnail'),
        'http://localhost:8000/api/v1/images/42?size=thumbnail',
      );
      expect(detail.images.length, 2);
      expect(detail.images[0].id, 42);
      expect(detail.images[1].id, 43);
      expect(detail.details?['seats'], 5);
      expect(detail.latitude, 45.5532);
      expect(detail.longitude, -73.6543);
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

    test('throws FormatException on malformed availability event (P1 check)', () {
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
    });
  });
}

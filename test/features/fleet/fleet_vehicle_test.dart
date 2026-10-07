import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/fleet/domain/entities/fleet_vehicle.dart';

void main() {
  group('FleetVehicle Entity', () {
    test('decodes complete JSON with snake_case fields correctly', () {
      final json = {
        'id': 42,
        'name': 'Toyota Prius Prime Rosemont',
        'type': 'car',
        'sharing_mode': 'hybrid',
        'availability_mode': 'always',
        'availability_status': 'has_availabilities',
        'location_description': 'Dans l\'allée ouest',
        'published': true,
        'min_loan_duration_in_minutes': 60,
        'max_loan_duration_in_minutes': 2880,
        'timezone': 'America/Toronto',
        'user_role': 'owner',
        'updated_at': '2026-10-03T18:00:00.000000Z',
        'position': [45.542, -73.575],
        'details': {
          'brand': 'Toyota',
          'model': 'Prius Prime',
          'year_of_circulation': 2022,
          'engine': 'hybrid',
        },
      };

      final vehicle = FleetVehicle.fromJson(json);

      expect(vehicle.id, 42);
      expect(vehicle.name, 'Toyota Prius Prime Rosemont');
      expect(vehicle.type, 'car');
      expect(vehicle.sharingMode, 'hybrid');
      expect(vehicle.availabilityMode, 'always');
      expect(vehicle.published, true);
      expect(vehicle.latitude, 45.542);
      expect(vehicle.longitude, -73.575);
      expect(vehicle.isCar, true);
      expect(vehicle.isDraft, false);
      expect(vehicle.updatedAt, '2026-10-03T18:00:00.000000Z');
    });

    test('derives published from the list resource availability_status', () {
      // GET /loanables?for=profile returns ListLoanableResource, without
      // a `published` flag.
      final published = FleetVehicle.fromJson({
        'id': 105,
        'name': 'Vélo cargo familial',
        'type': 'bike',
        'availability_status': 'no_availabilities',
      });
      final unpublished = FleetVehicle.fromJson({
        'id': 106,
        'name': 'Remorque',
        'type': 'trailer',
        'availability_status': 'unpublished',
      });

      expect(published.published, true);
      expect(published.isBike, true);
      expect(unpublished.published, false);
      expect(unpublished.isDraft, true);
    });

    test('identifies draft vehicles correctly', () {
      final json = {
        'id': 201,
        'name': 'Remorque neuve',
        'type': 'trailer',
        'published': false,
      };

      final vehicle = FleetVehicle.fromJson(json);

      expect(vehicle.published, false);
      expect(vehicle.isDraft, true);
      expect(vehicle.isTrailer, true);
    });
  });
}

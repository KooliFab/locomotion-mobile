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
        'is_suspended': false,
        'suspended_at': null,
        'suspension_reason': null,
        'active_loans_count': 2,
        'confirmed_future_loans_count': 3,
        'pending_requests_count': 1,
        'future_loans_count': 4,
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
      expect(vehicle.isSuspended, false);
      expect(vehicle.activeLoansCount, 2);
      expect(vehicle.confirmedFutureLoansCount, 3);
      expect(vehicle.pendingRequestsCount, 1);
      expect(vehicle.futureLoansCount, 4);
      expect(vehicle.latitude, 45.542);
      expect(vehicle.longitude, -73.575);
      expect(vehicle.isCar, true);
      expect(vehicle.isDraft, false);
      expect(vehicle.hasActiveLoans, true);
      expect(vehicle.hasFutureLoans, true);
      expect(vehicle.updatedAt, '2026-10-03T18:00:00.000000Z');
    });

    test('correctly decodes suspended vehicle with reason and date', () {
      final json = {
        'id': 105,
        'name': 'Vélo cargo familial',
        'type': 'bike',
        'sharing_mode': 'on_demand',
        'published': true,
        'is_suspended': true,
        'suspended_at': '2026-10-03T15:30:00.000000Z',
        'suspension_reason': 'Freins en révision chez le vélociste',
        'active_loans_count': 1,
        'confirmed_future_loans_count': 0,
        'pending_requests_count': 0,
        'future_loans_count': 0,
      };

      final vehicle = FleetVehicle.fromJson(json);

      expect(vehicle.isSuspended, true);
      expect(vehicle.suspendedAt, isNotNull);
      expect(vehicle.suspensionReason, 'Freins en révision chez le vélociste');
      expect(vehicle.hasActiveLoans, true);
      expect(vehicle.hasFutureLoans, false);
      expect(vehicle.isBike, true);
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

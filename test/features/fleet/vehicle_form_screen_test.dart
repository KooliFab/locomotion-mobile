import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/fleet/domain/entities/fleet_vehicle.dart';
import 'package:mobile/features/fleet/domain/repositories/fleet_repository.dart';
import 'package:mobile/features/fleet/presentation/controllers/fleet_controller.dart';
import 'package:mobile/features/fleet/presentation/screens/vehicle_form_screen.dart';

class MockFleetFormRepository implements FleetRepository {
  bool shouldThrowConflict = false;
  Map<String, dynamic>? lastCreatedData;
  Map<String, dynamic>? lastUpdatedData;
  String? lastIdempotencyKey;
  String? lastLockVersion;

  @override
  Future<List<FleetVehicle>> getOwnerFleet() async => [];

  @override
  Future<FleetVehicle> createVehicle(
    Map<String, dynamic> data, {
    String? idempotencyKey,
  }) async {
    lastCreatedData = data;
    lastIdempotencyKey = idempotencyKey;
    return FleetVehicle(
      id: 99,
      name: data['name'] ?? '',
      type: data['type'] ?? 'bike',
      published: false,
    );
  }

  @override
  Future<FleetVehicle> updateVehicle(
    int id,
    Map<String, dynamic> data, {
    String? lockVersion,
  }) async {
    if (shouldThrowConflict) {
      throw const ConflictException(
        message: 'Ce véhicule a été modifié par un autre gestionnaire.',
      );
    }
    lastUpdatedData = data;
    lastLockVersion = lockVersion;
    return FleetVehicle(
      id: id,
      name: data['name'] ?? '',
      type: data['type'] ?? 'car',
      published: true,
      updatedAt: '2026-10-03T19:00:00.000000Z',
    );
  }

  @override
  Future<void> publishVehicle(int id) async {}

  @override
  Future<Map<String, dynamic>> suspendVehicle(
    int id, {
    String? reason,
    bool preserveFuture = true,
  }) async => {};

  @override
  Future<FleetVehicle> unsuspendVehicle(int id) async =>
      const FleetVehicle(id: 1, name: '', type: 'car');
}

void main() {
  late MockFleetFormRepository mockRepo;

  setUp(() {
    mockRepo = MockFleetFormRepository();
  });

  Widget buildFormWidget({int? vehicleId, FleetVehicle? initialVehicle}) {
    return ProviderScope(
      overrides: [fleetRepositoryProvider.overrideWithValue(mockRepo)],
      child: MaterialApp(
        home: VehicleFormScreen(
          vehicleId: vehicleId,
          initialVehicle: initialVehicle,
        ),
      ),
    );
  }

  testWidgets('Published car displays locked technical fields warning banner', (
    tester,
  ) async {
    const publishedCar = FleetVehicle(
      id: 42,
      name: 'Toyota Prius Rosemont',
      type: 'car',
      published: true,
      updatedAt: '2026-10-03T18:00:00.000000Z',
      details: {
        'brand': 'Toyota',
        'model': 'Prius',
        'year_of_circulation': 2021,
        'plate_number': 'ABC-123',
        'engine': 'hybrid',
      },
    );

    await tester.pumpWidget(
      buildFormWidget(vehicleId: 42, initialVehicle: publishedCar),
    );
    await tester.pumpAndSettle();

    // Verify warning banner is displayed
    expect(
      find.textContaining(
        'Champs techniques verrouillés : cette voiture est déjà publiée',
      ),
      findsOneWidget,
    );

    // Verify lock icons appear on locked technical inputs
    expect(find.byIcon(Icons.lock), findsWidgets);
  });

  testWidgets('Update conflict 409 displays conflict recovery dialog', (
    tester,
  ) async {
    mockRepo.shouldThrowConflict = true;

    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    const publishedCar = FleetVehicle(
      id: 42,
      name: 'Toyota Prius Rosemont',
      type: 'car',
      published: true,
      locationDescription: 'Dans l\'allée ouest',
      updatedAt: '2026-10-03T18:00:00.000000Z',
    );

    await tester.pumpWidget(
      buildFormWidget(vehicleId: 42, initialVehicle: publishedCar),
    );
    await tester.pumpAndSettle();

    final submitBtn = find.byKey(const Key('submit_vehicle_button'));
    expect(submitBtn, findsOneWidget);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    // Verify 409 Conflict dialog is displayed
    expect(find.text('Conflit de modification (409)'), findsOneWidget);
    expect(find.text('Recharger les données'), findsOneWidget);
    expect(find.text('Fermer sans écraser'), findsOneWidget);
  });

  testWidgets('Creation sends idempotency key to prevent duplicates', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildFormWidget());
    await tester.pumpAndSettle();

    // Fill vehicle name
    final nameField = find.byKey(const Key('vehicle_name_field'));
    await tester.enterText(nameField, 'Mon Super Vélo Cargo');

    // Fill location
    final locationField = find.byKey(const Key('location_description_field'));
    await tester.enterText(locationField, 'Dans la cour');

    // Fill bike model
    final modelField = find.byKey(const Key('bike_model_field'));
    await tester.enterText(modelField, 'Speed 500');
    await tester.pumpAndSettle();

    final submitBtn = find.byKey(const Key('submit_vehicle_button'));
    expect(submitBtn, findsOneWidget);
    await tester.tap(submitBtn);
    await tester.pumpAndSettle();

    expect(mockRepo.lastCreatedData, isNotNull);
    expect(mockRepo.lastCreatedData!['name'], 'Mon Super Vélo Cargo');
    expect(mockRepo.lastCreatedData!['location_description'], 'Dans la cour');
    expect(mockRepo.lastIdempotencyKey, isNotNull);
    expect(mockRepo.lastIdempotencyKey!.length, 36); // UUID v4 format
  });
}

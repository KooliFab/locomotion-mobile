import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/fleet/domain/entities/fleet_vehicle.dart';
import 'package:mobile/features/fleet/domain/repositories/fleet_repository.dart';
import 'package:mobile/features/fleet/presentation/controllers/fleet_controller.dart';
import 'package:mobile/features/fleet/presentation/screens/owner_fleet_screen.dart';

class MockFleetRepository implements FleetRepository {
  List<FleetVehicle> fleet = [
    const FleetVehicle(
      id: 1,
      name: 'Vélo de Ville Rosemont',
      type: 'bike',
      sharingMode: 'on_demand',
      published: true,
      locationDescription: 'Devant la cour',
    ),
    const FleetVehicle(
      id: 2,
      name: 'Toyota Prius Partagée',
      type: 'car',
      sharingMode: 'hybrid',
      published: true,
      locationDescription: 'Allée privée',
    ),
    const FleetVehicle(
      id: 3,
      name: 'Remorque Enfants',
      type: 'trailer',
      sharingMode: 'self_service',
      published: false,
    ),
  ];

  int publishCallCount = 0;

  @override
  Future<List<FleetVehicle>> getOwnerFleet() async => List.of(fleet);

  @override
  Future<FleetVehicle> getVehicle(int id) async =>
      fleet.firstWhere((v) => v.id == id);

  @override
  Future<FleetVehicle> createVehicle(
    Map<String, dynamic> data, {
    String? idempotencyKey,
  }) async {
    final newVehicle = FleetVehicle(
      id: fleet.length + 1,
      name: data['name'] ?? 'Nouveau véhicule',
      type: data['type'] ?? 'bike',
      published: false,
    );
    fleet.add(newVehicle);
    return newVehicle;
  }

  @override
  Future<FleetVehicle> updateVehicle(
    int id,
    Map<String, dynamic> data, {
    String? lockVersion,
  }) async {
    final index = fleet.indexWhere((v) => v.id == id);
    if (index >= 0) {
      fleet[index] = fleet[index].copyWith(
        name: data['name'] ?? fleet[index].name,
      );
      return fleet[index];
    }
    throw Exception('Not found');
  }

  @override
  Future<void> publishVehicle(int id) async {
    publishCallCount++;
    final index = fleet.indexWhere((v) => v.id == id);
    if (index >= 0) {
      fleet[index] = fleet[index].copyWith(published: true);
    }
  }
}

void main() {
  late MockFleetRepository mockRepo;

  setUp(() {
    mockRepo = MockFleetRepository();
  });

  Widget buildTestWidget() {
    return ProviderScope(
      overrides: [fleetRepositoryProvider.overrideWithValue(mockRepo)],
      child: const MaterialApp(home: OwnerFleetScreen()),
    );
  }

  testWidgets('OwnerFleetScreen renders all vehicles with status badges', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Vélo de Ville Rosemont'), findsOneWidget);
    expect(find.text('Toyota Prius Partagée'), findsOneWidget);
    expect(find.text('Remorque Enfants'), findsOneWidget);

    expect(find.text('Publié'), findsNWidgets(2));
    expect(find.text('Brouillon'), findsOneWidget);
    // Suspension is not part of the web reference API
    expect(find.textContaining('Suspendu'), findsNothing);
  });

  testWidgets('Filter chips toggle filtered lists properly', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Publiés (2)'), findsOneWidget);

    final draftChip = find.text('Brouillons (1)');
    await tester.tap(draftChip);
    await tester.pumpAndSettle();

    expect(find.text('Remorque Enfants'), findsOneWidget);
    expect(find.text('Toyota Prius Partagée'), findsNothing);
  });

  testWidgets('Draft vehicle menu offers publish but no suspension', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Brouillons (1)'));
    await tester.pumpAndSettle();

    final moreButtons = find.byIcon(Icons.more_vert_rounded);
    await tester.tap(moreButtons.first);
    await tester.pumpAndSettle();

    expect(find.text('Publier'), findsOneWidget);
    expect(find.text('Suspendre'), findsNothing);
  });
}

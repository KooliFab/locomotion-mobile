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
      isSuspended: false,
      activeLoansCount: 1,
      confirmedFutureLoansCount: 2,
      futureLoansCount: 2,
      locationDescription: 'Devant la cour',
    ),
    const FleetVehicle(
      id: 2,
      name: 'Toyota Prius Partagée',
      type: 'car',
      sharingMode: 'hybrid',
      published: true,
      isSuspended: true,
      suspensionReason: 'Changement de freins',
      activeLoansCount: 0,
      confirmedFutureLoansCount: 1,
      futureLoansCount: 1,
      locationDescription: 'Allée privée',
    ),
    const FleetVehicle(
      id: 3,
      name: 'Remorque Enfants',
      type: 'trailer',
      sharingMode: 'self_service',
      published: false,
      isSuspended: false,
      activeLoansCount: 0,
      confirmedFutureLoansCount: 0,
      futureLoansCount: 0,
    ),
  ];

  int suspendCallCount = 0;
  int unsuspendCallCount = 0;
  int publishCallCount = 0;

  @override
  Future<List<FleetVehicle>> getOwnerFleet() async => List.of(fleet);

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

  @override
  Future<Map<String, dynamic>> suspendVehicle(
    int id, {
    String? reason,
    bool preserveFuture = true,
  }) async {
    suspendCallCount++;
    final index = fleet.indexWhere((v) => v.id == id);
    if (index >= 0) {
      fleet[index] = fleet[index].copyWith(
        isSuspended: true,
        suspensionReason: reason,
      );
    }
    return {'message': 'Véhicule suspendu'};
  }

  @override
  Future<FleetVehicle> unsuspendVehicle(int id) async {
    unsuspendCallCount++;
    final index = fleet.indexWhere((v) => v.id == id);
    if (index >= 0) {
      fleet[index] = fleet[index].copyWith(
        isSuspended: false,
        suspensionReason: null,
      );
      return fleet[index];
    }
    throw Exception('Not found');
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

  testWidgets(
    'OwnerFleetScreen renders all vehicles with status badges and metrics',
    (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify all vehicle names are present
      expect(find.text('Vélo de Ville Rosemont'), findsOneWidget);
      expect(find.text('Toyota Prius Partagée'), findsOneWidget);
      expect(find.text('Remorque Enfants'), findsOneWidget);

      // Verify status badges
      expect(find.text('Publié'), findsOneWidget);
      expect(find.text('Suspendu'), findsOneWidget);
      expect(find.text('Brouillon'), findsOneWidget);

      // Verify loan activity metrics
      expect(find.text('1 en cours'), findsOneWidget);
      expect(find.text('2 réservés'), findsOneWidget);
    },
  );

  testWidgets('Filter chips toggle filtered lists properly', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Filter by Suspendus
    final suspendedChip = find.text('Suspendus (1)');
    expect(suspendedChip, findsOneWidget);
    await tester.tap(suspendedChip);
    await tester.pumpAndSettle();

    expect(find.text('Toyota Prius Partagée'), findsOneWidget);
    expect(find.text('Vélo de Ville Rosemont'), findsNothing);
    expect(find.text('Remorque Enfants'), findsNothing);

    // Filter by Brouillons
    final draftChip = find.text('Brouillons (1)');
    await tester.tap(draftChip);
    await tester.pumpAndSettle();

    expect(find.text('Remorque Enfants'), findsOneWidget);
    expect(find.text('Toyota Prius Partagée'), findsNothing);
  });

  testWidgets(
    'Suspension dialog displays active loan counts and triggers suspension',
    (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Open popup menu for the first vehicle (Vélo de Ville Rosemont)
      final moreButtons = find.byIcon(Icons.more_vert_rounded);
      await tester.tap(moreButtons.first);
      await tester.pumpAndSettle();

      // Tap "Suspendre"
      final suspendMenuOption = find.text('Suspendre');
      expect(suspendMenuOption, findsOneWidget);
      await tester.tap(suspendMenuOption);
      await tester.pumpAndSettle();

      // Suspension dialog should be visible
      expect(find.text('Suspendre le véhicule'), findsOneWidget);
      expect(find.textContaining('Prêts en cours'), findsOneWidget);
      expect(
        find.textContaining('Aucune annulation automatique'),
        findsOneWidget,
      );

      // Tap "Confirmer la suspension"
      final confirmBtn = find.byKey(const Key('confirm_suspend_button'));
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(mockRepo.suspendCallCount, 1);
    },
  );
}

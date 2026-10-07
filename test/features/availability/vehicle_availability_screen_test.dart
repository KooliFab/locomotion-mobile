import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/availability/domain/entities/availability_config.dart';
import 'package:mobile/features/availability/domain/entities/availability_rule.dart';
import 'package:mobile/features/availability/domain/entities/conflicting_loan.dart';
import 'package:mobile/features/availability/domain/repositories/availability_repository.dart';
import 'package:mobile/features/availability/presentation/controllers/vehicle_availability_controller.dart';
import 'package:mobile/features/availability/presentation/screens/vehicle_availability_screen.dart';
import 'package:mobile/features/loanables/domain/entities/loanable_availability.dart';

class MockAvailabilityRepository implements AvailabilityRepository {
  AvailabilityConfig config;
  List<ConflictingLoan> mockConflicts;
  int saveCallCount = 0;
  String? lastSavedJson;

  MockAvailabilityRepository({
    required this.config,
    this.mockConflicts = const [],
  });

  @override
  Future<AvailabilityConfig> getAvailabilityConfig(int vehicleId) async =>
      config;

  @override
  Future<List<ConflictingLoan>> checkConflicts(
    int vehicleId, {
    required String availabilityMode,
    required String availabilityJson,
  }) async => mockConflicts;

  @override
  Future<void> saveAvailabilityConfig(
    int vehicleId, {
    required String availabilityMode,
    required String availabilityJson,
    String? lockVersion,
  }) async {
    saveCallCount++;
    lastSavedJson = availabilityJson;
    final decoded = jsonDecode(availabilityJson) as List;
    final rules = decoded
        .map((e) => AvailabilityRule.fromJson(e as Map<String, dynamic>))
        .toList();
    config = AvailabilityConfig(
      vehicleId: vehicleId,
      availabilityMode: availabilityMode,
      rules: rules,
      lockVersion: 'v-new',
    );
  }

  @override
  Future<List<LoanableAvailabilityInterval>> previewAvailability(
    int vehicleId, {
    required String start,
    required String end,
    required String availabilityMode,
    required String availabilityJson,
    String? timezone,
  }) async => [];
}

void main() {
  const puncRule = AvailabilityRule(
    id: 'punc-1',
    type: 'dates',
    scope: ['2026-10-15'],
    period: '09:00-17:00',
    available: false,
    title: 'Visite garage',
  );

  const recRule = AvailabilityRule(
    id: 'rec-1',
    type: 'weekdays',
    scope: ['SA'],
    period: '00:00-24:00',
    available: false,
    title: 'Samedi réservé',
  );

  Widget createWidget({
    required MockAvailabilityRepository repo,
    required int vehicleId,
  }) {
    return ProviderScope(
      overrides: [availabilityRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(home: VehicleAvailabilityScreen(vehicleId: vehicleId)),
    );
  }

  testWidgets(
    'VehicleAvailabilityScreen renders tabs and rules in always mode',
    (tester) async {
      final repo = MockAvailabilityRepository(
        config: const AvailabilityConfig(
          vehicleId: 10,
          availabilityMode: 'always',
          rules: [puncRule, recRule],
        ),
      );

      await tester.pumpWidget(createWidget(repo: repo, vehicleId: 10));
      await tester.pumpAndSettle();

      expect(find.text('Disponibilités & Calendrier'), findsOneWidget);
      expect(find.text('Ponctuelles'), findsOneWidget);
      expect(find.text('Récurrentes'), findsOneWidget);
      expect(find.text('Aperçu'), findsOneWidget);

      // In Ponctuelles tab
      expect(find.text('Visite garage'), findsOneWidget);

      // Switch to Récurrentes tab
      await tester.tap(find.text('Récurrentes'));
      await tester.pumpAndSettle();

      expect(find.text('Samedi réservé'), findsOneWidget);

      // Floating action button for adding rule is visible
      expect(find.byType(FloatingActionButton), findsOneWidget);
    },
  );

  testWidgets(
    'VehicleAvailabilityScreen renders read-only banner and hides FAB in never mode',
    (tester) async {
      final repo = MockAvailabilityRepository(
        config: const AvailabilityConfig(
          vehicleId: 10,
          availabilityMode: 'never',
          rules: [recRule],
        ),
      );

      await tester.pumpWidget(createWidget(repo: repo, vehicleId: 10));
      await tester.pumpAndSettle();

      // Banner is visible
      expect(
        find.textContaining('mode de disponibilité restreinte'),
        findsOneWidget,
      );

      // FAB is not shown in read-only mode
      expect(find.byType(FloatingActionButton), findsNothing);

      // Switch to recurring tab to view the rule
      await tester.tap(find.text('Récurrentes'));
      await tester.pumpAndSettle();

      expect(find.text('Samedi réservé'), findsOneWidget);

      // Edit and delete buttons are not present
      expect(find.byIcon(Icons.delete_outline), findsNothing);
      expect(find.byIcon(Icons.edit_outlined), findsNothing);
    },
  );

  testWidgets('Tapping FAB opens the availability rule form sheet', (
    tester,
  ) async {
    final repo = MockAvailabilityRepository(
      config: const AvailabilityConfig(
        vehicleId: 10,
        availabilityMode: 'always',
        rules: [],
      ),
    );

    await tester.pumpWidget(createWidget(repo: repo, vehicleId: 10));
    await tester.pumpAndSettle();

    final fab = find.byType(FloatingActionButton);
    expect(fab, findsOneWidget);

    await tester.tap(fab);
    await tester.pumpAndSettle();

    expect(find.text('Nouvelle indisponibilité'), findsOneWidget);
    expect(find.text('Type d\'indisponibilité'), findsOneWidget);
    expect(find.text('Enregistrer'), findsOneWidget);
  });

  testWidgets(
    'Deleting a rule opens confirmation and removes rule upon approval',
    (tester) async {
      final repo = MockAvailabilityRepository(
        config: const AvailabilityConfig(
          vehicleId: 10,
          availabilityMode: 'always',
          rules: [puncRule],
        ),
      );

      await tester.pumpWidget(createWidget(repo: repo, vehicleId: 10));
      await tester.pumpAndSettle();

      expect(find.text('Visite garage'), findsOneWidget);

      final deleteIcon = find.byIcon(Icons.delete_outline);
      expect(deleteIcon, findsOneWidget);

      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      expect(find.text('Supprimer cette règle ?'), findsOneWidget);

      // Confirm deletion
      await tester.tap(find.widgetWithText(ElevatedButton, 'Supprimer'));
      await tester.pumpAndSettle();

      expect(repo.saveCallCount, 1);
      expect(repo.lastSavedJson, '[]');
      expect(find.text('Règle supprimée avec succès.'), findsOneWidget);
    },
  );

  testWidgets(
    'Multi-dates batch rule renders web-managed badge and hides edit button',
    (tester) async {
      const multiDateRule = AvailabilityRule(
        id: 'batch-1',
        type: 'dates',
        scope: ['2026-10-15', '2026-10-16', '2026-10-17'],
        period: '00:00-24:00',
        available: false,
        title: 'Fermeture exceptionnelle web',
      );

      final repo = MockAvailabilityRepository(
        config: const AvailabilityConfig(
          vehicleId: 10,
          availabilityMode: 'always',
          rules: [multiDateRule],
        ),
      );

      await tester.pumpWidget(createWidget(repo: repo, vehicleId: 10));
      await tester.pumpAndSettle();

      expect(find.text('Fermeture exceptionnelle web'), findsOneWidget);
      expect(find.text('Géré via le web (multi-dates)'), findsOneWidget);

      // Edit button is hidden to prevent accidental date loss
      expect(find.byIcon(Icons.edit_outlined), findsNothing);
      // Delete button remains accessible
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    },
  );

  testWidgets(
    'Continuous multi-day block is displayed as 1 item and deleted atomically',
    (tester) async {
      final slices = AvailabilityRule.createContinuousBlock(
        baseId: 'group-weekend',
        startDate: DateTime(2026, 10, 16),
        endDate: DateTime(2026, 10, 18),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 18, minute: 0),
        isAllDay: false,
        title: 'Séjour camping',
      );

      final repo = MockAvailabilityRepository(
        config: AvailabilityConfig(
          vehicleId: 10,
          availabilityMode: 'always',
          rules: slices,
        ),
      );

      await tester.pumpWidget(createWidget(repo: repo, vehicleId: 10));
      await tester.pumpAndSettle();

      // Grouped into a single card in UI
      expect(find.text('Séjour camping'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);

      // Delete the continuous block
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Supprimer'));
      await tester.pumpAndSettle();

      expect(repo.saveCallCount, 1);
      // Both slices were deleted atomically
      expect(repo.lastSavedJson, '[]');
    },
  );
}

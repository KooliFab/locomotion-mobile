import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/incidents/data/repositories/incident_repository_impl.dart';
import 'package:mobile/features/incidents/domain/entities/incident.dart';
import 'package:mobile/features/incidents/domain/entities/incident_category.dart';
import 'package:mobile/features/incidents/domain/entities/incident_note.dart';
import 'package:mobile/features/incidents/domain/repositories/incident_repository.dart';
import 'package:mobile/features/incidents/presentation/screens/incidents_list_screen.dart';

class MockIncidentRepository implements IncidentRepository {
  final List<Incident> incidents;

  MockIncidentRepository({this.incidents = const []});

  @override
  Future<List<Incident>> getIncidents({int? loanId, int? loanableId, String? status}) async {
    return incidents;
  }

  @override
  Future<Incident> getIncidentDetail(int incidentId) async =>
      incidents.firstWhere((i) => i.id == incidentId);

  @override
  Future<Incident> createIncident({
    required int loanableId,
    int? loanId,
    required IncidentCategory category,
    required String description,
    List<int> imageIds = const [],
    String? idempotencyKey,
  }) async =>
      throw UnimplementedError();

  @override
  Future<IncidentNote> addNote(int incidentId, String text) async =>
      throw UnimplementedError();

  @override
  Future<Incident> resolveIncident(int incidentId) async =>
      throw UnimplementedError();

  @override
  Future<Incident> reopenIncident(int incidentId) async =>
      throw UnimplementedError();

  @override
  Future<int> uploadImage(String filePath) async => 1;
}

void main() {
  final testIncidents = [
    Incident(
      id: 1,
      loanableId: 10,
      loanableName: 'Vélo Ville 1',
      incidentType: 'small_incident',
      status: 'in_process',
      commentsOnIncident: '[Crevaison] Pneu arrière dégonflé.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Incident(
      id: 2,
      loanableId: 10,
      loanableName: 'Vélo Ville 1',
      incidentType: 'small_incident',
      status: 'completed',
      commentsOnIncident: '[Panne] Chaîne réparée et lubrifiée.',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  Widget buildTestWidget({
    required MockIncidentRepository repo,
    int? loanId,
    int? loanableId,
  }) {
    return ProviderScope(
      overrides: [
        incidentRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp(
        home: IncidentsListScreen(
          loanId: loanId,
          loanableId: loanableId,
        ),
      ),
    );
  }

  testWidgets('displays empty state when no incidents are found', (tester) async {
    final repo = MockIncidentRepository(incidents: const []);

    await tester.pumpWidget(buildTestWidget(repo: repo));
    await tester.pumpAndSettle();

    expect(find.text('Aucun incident signalé.'), findsOneWidget);
  });

  testWidgets('displays list of incidents and filters by status chips', (tester) async {
    final repo = MockIncidentRepository(incidents: testIncidents);

    await tester.pumpWidget(buildTestWidget(repo: repo));
    await tester.pumpAndSettle();

    // Both incidents shown under "Tous"
    expect(find.text('Pneu arrière dégonflé.'), findsOneWidget);
    expect(find.text('Chaîne réparée et lubrifiée.'), findsOneWidget);

    // Filter by "En cours"
    final inProcessChip = find.widgetWithText(FilterChip, 'En cours');
    await tester.tap(inProcessChip);
    await tester.pumpAndSettle();

    expect(find.text('Pneu arrière dégonflé.'), findsOneWidget);
    expect(find.text('Chaîne réparée et lubrifiée.'), findsNothing);

    // Filter by "Résolus"
    final completedChip = find.widgetWithText(FilterChip, 'Résolus');
    await tester.tap(completedChip);
    await tester.pumpAndSettle();

    expect(find.text('Pneu arrière dégonflé.'), findsNothing);
    expect(find.text('Chaîne réparée et lubrifiée.'), findsOneWidget);

    // Switch back to "Tous" should properly reset filter
    final allChip = find.widgetWithText(FilterChip, 'Tous');
    await tester.tap(allChip);
    await tester.pumpAndSettle();

    expect(find.text('Pneu arrière dégonflé.'), findsOneWidget);
    expect(find.text('Chaîne réparée et lubrifiée.'), findsOneWidget);
  });

  testWidgets('shows FAB button when loanableId is provided, and hides it when null', (tester) async {
    final repo = MockIncidentRepository(incidents: testIncidents);

    // With loanableId -> FAB visible
    await tester.pumpWidget(buildTestWidget(repo: repo, loanableId: 10));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('report_incident_fab')), findsOneWidget);

    // Without loanableId -> FAB not rendered
    await tester.pumpWidget(buildTestWidget(repo: repo));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('report_incident_fab')), findsNothing);
  });
}

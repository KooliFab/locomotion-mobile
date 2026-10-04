import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/incidents/data/repositories/incident_repository_impl.dart';
import 'package:mobile/features/incidents/domain/entities/incident.dart';
import 'package:mobile/features/incidents/domain/entities/incident_category.dart';
import 'package:mobile/features/incidents/domain/entities/incident_note.dart';
import 'package:mobile/features/incidents/domain/repositories/incident_repository.dart';
import 'package:mobile/features/incidents/presentation/screens/incident_report_screen.dart';

class MockIncidentRepository implements IncidentRepository {
  List<Incident> incidents = [];
  Incident? createdIncident;
  bool throwOnCreate = false;
  bool throwTimeout = false;
  int createCallCount = 0;

  @override
  Future<List<Incident>> getIncidents({int? loanId, int? loanableId, String? status}) async {
    return incidents;
  }

  @override
  Future<Incident> getIncidentDetail(int incidentId) async {
    return createdIncident ??
        incidents.firstWhere(
          (i) => i.id == incidentId,
          orElse: () => Incident(id: incidentId, incidentType: 'general', status: 'in_process'),
        );
  }

  @override
  Future<Incident> createIncident({
    required int loanableId,
    int? loanId,
    required IncidentCategory category,
    required String description,
    List<int> imageIds = const [],
    String? idempotencyKey,
  }) async {
    if (throwTimeout) throw Exception('Connection timeout');
    if (throwOnCreate) throw Exception('API Error');
    createCallCount++;
    final incident = Incident(
      id: 999,
      loanableId: loanableId,
      loanId: loanId,
      incidentType: category.backendType,
      status: 'in_process',
      commentsOnIncident: '${category.prefix} $description',
      photoImageIds: imageIds,
    );
    createdIncident = incident;
    return incident;
  }

  @override
  Future<IncidentNote> addNote(int incidentId, String text) async {
    return IncidentNote(id: 1, incidentId: incidentId, authorId: 1, text: text, createdAt: DateTime.now());
  }

  @override
  Future<Incident> resolveIncident(int incidentId) async {
    return (createdIncident ?? incidents.first).copyWith(status: 'completed');
  }

  @override
  Future<Incident> reopenIncident(int incidentId) async {
    return (createdIncident ?? incidents.first).copyWith(status: 'in_process');
  }

  @override
  Future<int> uploadImage(String filePath) async {
    return 101;
  }
}

void main() {
  late MockIncidentRepository mockRepository;

  setUp(() {
    mockRepository = MockIncidentRepository();
  });

  Widget buildTestWidget({
    int loanableId = 42,
    String? vehicleName = 'Vélo Test',
    int? loanId = 10,
    String? ownerName = 'Alice Dupont',
    String? ownerPhone = '0600000000',
    String? ownerEmail = 'alice@example.com',
  }) {
    return ProviderScope(
      overrides: [
        incidentRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: MaterialApp(
        home: IncidentReportScreen(
          loanableId: loanableId,
          vehicleName: vehicleName,
          loanId: loanId,
          ownerName: ownerName,
          ownerPhone: ownerPhone,
          ownerEmail: ownerEmail,
        ),
      ),
    );
  }

  testWidgets('renders report screen with emergency card, context card and category picker',
      (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Check header and emergency disclaimer
    expect(find.text('Signaler un incident'), findsOneWidget);
    expect(find.byKey(const Key('emergency_disclaimer_card')), findsOneWidget);
    expect(find.textContaining('112'), findsOneWidget);
    expect(find.textContaining('Alice Dupont'), findsOneWidget);
    expect(find.textContaining('0600000000'), findsOneWidget);

    // Check context card
    expect(find.byKey(const Key('incident_context_card')), findsOneWidget);
    expect(find.text('Vélo Test'), findsOneWidget);

    // Check category picker and categories
    expect(find.byKey(const Key('incident_category_picker')), findsOneWidget);
    expect(find.text('Dommage matériel'), findsOneWidget);
    expect(find.text('Crevaison / Pneu'), findsOneWidget);
    expect(find.text('Panne mécanique'), findsOneWidget);
    expect(find.text('Retard de restitution'), findsOneWidget);
    expect(find.text('Accident / Collision'), findsOneWidget);

    // Submit button should be initially disabled
    final submitButtonFinder = find.byKey(const Key('submit_incident_button'));
    expect(submitButtonFinder, findsOneWidget);
    final submitButton = tester.widget<ElevatedButton>(submitButtonFinder);
    expect(submitButton.onPressed, isNull);
  });

  testWidgets('selecting damage and typing >= 10 chars enables submit button', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Tap on damage category
    final damageCard = find.byKey(const Key('category_card_damage'));
    await tester.ensureVisible(damageCard);
    await tester.tap(damageCard);
    await tester.pumpAndSettle();

    // Type description < 10 chars
    final descField = find.byKey(const Key('incident_description_field'));
    await tester.ensureVisible(descField);
    await tester.enterText(descField, 'Court');
    await tester.pumpAndSettle();

    // Button still disabled
    var submitButton = tester.widget<ElevatedButton>(find.byKey(const Key('submit_incident_button')));
    expect(submitButton.onPressed, isNull);

    // Type >= 10 chars
    await tester.enterText(descField, 'Rayure profonde sur le côté gauche');
    await tester.pumpAndSettle();

    // Button should now be enabled
    submitButton = tester.widget<ElevatedButton>(find.byKey(const Key('submit_incident_button')));
    expect(submitButton.onPressed, isNotNull);

    // Tap submit
    await tester.tap(find.byKey(const Key('submit_incident_button')));
    await tester.pump();

    expect(mockRepository.createCallCount, equals(1));
    expect(mockRepository.createdIncident?.incidentType, equals('small_incident'));
  });

  testWidgets('selecting accident requires safety acknowledgment before submit', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Select accident category
    final accidentCard = find.byKey(const Key('category_card_accident'));
    await tester.ensureVisible(accidentCard);
    await tester.tap(accidentCard);
    await tester.pumpAndSettle();

    // Enter valid description
    final descField = find.byKey(const Key('incident_description_field'));
    await tester.ensureVisible(descField);
    await tester.enterText(descField, 'Accrochage avec un poteau de signalisation');
    await tester.pumpAndSettle();

    // Safety acknowledgment checkbox should appear
    final checkboxFinder = find.byKey(const Key('safety_disclaimer_checkbox'));
    expect(checkboxFinder, findsOneWidget);

    // Submit button still disabled because safety checkbox not checked
    var submitButton = tester.widget<ElevatedButton>(find.byKey(const Key('submit_incident_button')));
    expect(submitButton.onPressed, isNull);

    // Check safety disclaimer
    await tester.ensureVisible(checkboxFinder);
    await tester.tap(checkboxFinder);
    await tester.pumpAndSettle();

    // Submit button should now be enabled
    submitButton = tester.widget<ElevatedButton>(find.byKey(const Key('submit_incident_button')));
    expect(submitButton.onPressed, isNotNull);

    // Tap submit
    await tester.tap(find.byKey(const Key('submit_incident_button')));
    await tester.pump();

    expect(mockRepository.createCallCount, equals(1));
    expect(mockRepository.createdIncident?.incidentType, equals('accident'));
  });

  testWidgets('handles timeout with unknown result and shows reconciliation button', (tester) async {
    mockRepository.throwTimeout = true;

    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    // Select damage
    final damageCard = find.byKey(const Key('category_card_damage'));
    await tester.ensureVisible(damageCard);
    await tester.tap(damageCard);
    await tester.pumpAndSettle();

    // Type description
    final descField = find.byKey(const Key('incident_description_field'));
    await tester.ensureVisible(descField);
    await tester.enterText(descField, 'Rayure profonde sur la portière.');
    await tester.pumpAndSettle();

    // Tap submit -> triggers timeout
    final submitButton = find.byKey(const Key('submit_incident_button'));
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Verification banner and reconcile button should be visible
    expect(find.byKey(const Key('incident_reconcile_card')), findsOneWidget);
    expect(find.byKey(const Key('reconcile_incident_button')), findsOneWidget);
  });
}

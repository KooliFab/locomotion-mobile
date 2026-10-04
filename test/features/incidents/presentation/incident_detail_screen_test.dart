import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/incidents/data/repositories/incident_repository_impl.dart';
import 'package:mobile/features/incidents/domain/entities/incident.dart';
import 'package:mobile/features/incidents/domain/entities/incident_category.dart';
import 'package:mobile/features/incidents/domain/entities/incident_note.dart';
import 'package:mobile/features/incidents/domain/repositories/incident_repository.dart';
import 'package:mobile/core/storage/storage_providers.dart';
import 'package:mobile/features/incidents/presentation/screens/incident_detail_screen.dart';
import 'package:mobile/features/incidents/presentation/widgets/add_note_dialog.dart';
import '../../../helpers/mock_api_client.dart';

class _FakeAuthController extends AuthController {
  final User? _user;
  _FakeAuthController(this._user);

  @override
  User? build() => _user;
}

class MockIncidentRepository implements IncidentRepository {
  Incident incident;
  int resolveCallCount = 0;
  int addNoteCallCount = 0;
  String? lastAddedNote;

  MockIncidentRepository({required this.incident});

  @override
  Future<List<Incident>> getIncidents({int? loanId, int? loanableId, String? status}) async =>
      [incident];

  @override
  Future<Incident> getIncidentDetail(int incidentId) async => incident;

  @override
  Future<Incident> createIncident({
    required int loanableId,
    int? loanId,
    required IncidentCategory category,
    required String description,
    List<int> imageIds = const [],
    String? idempotencyKey,
  }) async =>
      incident;

  @override
  Future<IncidentNote> addNote(int incidentId, String text) async {
    addNoteCallCount++;
    lastAddedNote = text;
    final note = IncidentNote(
      id: 10,
      incidentId: incidentId,
      authorId: 1,
      authorName: 'Auteur Note',
      text: text,
      createdAt: DateTime.now(),
    );
    incident = incident.copyWith(notes: [...incident.notes, note]);
    return note;
  }

  @override
  Future<Incident> resolveIncident(int incidentId) async {
    resolveCallCount++;
    incident = incident.copyWith(status: 'completed');
    return incident;
  }

  @override
  Future<Incident> reopenIncident(int incidentId) async {
    incident = incident.copyWith(status: 'in_process');
    return incident;
  }

  @override
  Future<int> uploadImage(String filePath) async => 1;
}

void main() {
  const borrowerUser = User(
    id: 99,
    email: 'bob@example.com',
    firstName: 'Bob',
    lastName: 'Emprunteur',
  );

  const ownerUser = User(
    id: 10,
    email: 'alice@example.com',
    firstName: 'Alice',
    lastName: 'Propriétaire',
  );

  final baseIncident = Incident(
    id: 50,
    loanableId: 12,
    loanableName: 'Vélo Cargo Alice',
    loanId: 8,
    incidentType: 'small_incident',
    status: 'in_process',
    commentsOnIncident: '[Crevaison] Crevaison roue avant. [Preuves: image_id#55]',
    photoImageIds: const [55],
    reportedByUserId: 99,
    reportedByUserName: 'Bob Emprunteur',
    vehicleOwnerIds: const [10],
    notes: [
      IncidentNote(
        id: 1,
        incidentId: 50,
        authorId: 99,
        authorName: 'Bob Emprunteur',
        text: 'Déposé au point relais pour assistance.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ],
  );

  Widget buildTestWidget({
    required MockIncidentRepository repo,
    required User user,
  }) {
    return ProviderScope(
      overrides: [
        authControllerProvider.overrideWith(() => _FakeAuthController(user)),
        incidentRepositoryProvider.overrideWithValue(repo),
        secureStorageServiceProvider.overrideWithValue(FakeSecureStorageService()),
      ],
      child: const MaterialApp(
        home: IncidentDetailScreen(incidentId: 50),
      ),
    );
  }

  testWidgets('renders incident details and hides resolution button for borrower', (tester) async {
    final repo = MockIncidentRepository(incident: baseIncident);

    await tester.pumpWidget(buildTestWidget(repo: repo, user: borrowerUser));
    await tester.pumpAndSettle();

    // Verify category, clean text and vehicle
    expect(find.text('Crevaison / Pneu'), findsOneWidget);
    expect(find.text('Crevaison roue avant.'), findsOneWidget);
    expect(find.text('Vélo Cargo Alice'), findsOneWidget);

    // Verify existing note
    expect(find.text('Déposé au point relais pour assistance.'), findsOneWidget);
    expect(find.text('Bob Emprunteur'), findsWidgets);

    // Borrower cannot resolve -> button not shown
    expect(find.byKey(const Key('resolve_incident_button')), findsNothing);

    // Borrower can add note
    expect(find.byKey(const Key('add_note_button')), findsOneWidget);
  });

  testWidgets('shows resolution button for owner and handles resolution flow', (tester) async {
    final repo = MockIncidentRepository(incident: baseIncident);

    await tester.pumpWidget(buildTestWidget(repo: repo, user: ownerUser));
    await tester.pumpAndSettle();

    // Owner can resolve -> button shown
    final resolveBtn = find.byKey(const Key('resolve_incident_button'));
    expect(resolveBtn, findsOneWidget);

    // Tap resolve button
    await tester.ensureVisible(resolveBtn);
    await tester.tap(resolveBtn);
    await tester.pumpAndSettle();

    // Confirmation dialog appears
    expect(find.text('Clôturer l\'incident'), findsOneWidget);
    final confirmBtn = find.byKey(const Key('confirm_resolve_button'));
    expect(confirmBtn, findsOneWidget);

    await tester.tap(confirmBtn);
    await tester.pumpAndSettle();

    expect(repo.resolveCallCount, equals(1));
    expect(repo.incident.isResolved, isTrue);
  });

  testWidgets('adding a note opens dialog and updates timeline', (tester) async {
    final repo = MockIncidentRepository(incident: baseIncident);

    await tester.pumpWidget(buildTestWidget(repo: repo, user: borrowerUser));
    await tester.pumpAndSettle();

    // Tap add note button
    final addNoteBtn = find.byKey(const Key('add_note_button'));
    await tester.ensureVisible(addNoteBtn);
    await tester.tap(addNoteBtn);
    await tester.pumpAndSettle();

    // Add note dialog appears
    expect(find.byType(AddNoteDialog), findsOneWidget);
    final noteInput = find.byKey(const Key('incident_note_input'));
    expect(noteInput, findsOneWidget);

    await tester.enterText(noteInput, 'Réparation effectuée par le réparateur.');
    await tester.pumpAndSettle();

    final submitNoteBtn = find.byKey(const Key('submit_note_button'));
    await tester.tap(submitNoteBtn);
    await tester.pumpAndSettle();

    expect(repo.addNoteCallCount, equals(1));
    expect(repo.lastAddedNote, equals('Réparation effectuée par le réparateur.'));
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/loanables/domain/entities/loanable.dart';
import 'package:mobile/features/loanables/domain/entities/loanable_availability.dart';
import 'package:mobile/features/loanables/domain/entities/loanable_availability_window.dart';
import 'package:mobile/features/loanables/domain/entities/loanable_incident.dart';
import 'package:mobile/features/loanables/domain/entities/loanables_page.dart';
import 'package:mobile/features/loanables/domain/entities/vehicle_local_dates.dart';
import 'package:mobile/features/loanables/domain/repositories/loanables_repository.dart';
import 'package:mobile/features/loanables/presentation/controllers/loanables_controller.dart';
import 'package:mobile/features/loanables/presentation/screens/loanable_detail_screen.dart';

Loanable _detail({
  int id = 1,
  String type = 'car',
  String? status = 'has_availabilities',
  double? lat,
  double? lng,
  List<LoanableIncident> incidents = const [],
}) {
  return Loanable(
    id: id,
    name: 'Toyota Prius Hybride',
    type: type,
    availabilityStatus: status,
    timezone: 'America/Montreal',
    latitude: lat,
    longitude: lng,
    locationDescription: 'Stationnement Lajeunesse',
    instructions: 'Clé dans la boîte à gants.',
    minLoanDurationInMinutes: 30,
    maxLoanDurationInMinutes: 2880,
    activeIncidents: incidents,
    images: const [],
  );
}

class _FakeLoanablesRepository implements LoanablesRepository {
  _FakeLoanablesRepository({
    required this.detail,
    this.window,
    this.windowError,
  });

  final Loanable detail;
  final LoanableAvailabilityWindow? window;
  final Object? windowError;

  @override
  Future<LoanablesPage> getLoanables({
    String? type,
    int? communityId,
    int? page,
  }) async {
    return LoanablesPage(items: [detail], page: 1, lastPage: 1);
  }

  @override
  Future<Loanable> getLoanableDetails(int id) async => detail;

  @override
  Future<List<LoanableAvailabilityInterval>> getAvailability(
    int loanableId, {
    required String start,
    required String end,
    String responseMode = 'available',
  }) async {
    if (windowError != null) throw windowError!;
    final w =
        window ??
        const LoanableAvailabilityWindow(available: [], unavailable: []);
    return responseMode == 'available' ? w.available : w.unavailable;
  }
}

void main() {
  group('LoanableDetailScreen', () {
    Future<void> pumpDetail(
      WidgetTester tester, {
      required Loanable detail,
      LoanableAvailabilityWindow? window,
      Object? windowError,
    }) async {
      final container = ProviderContainer(
        overrides: [
          loanablesRepositoryProvider.overrideWithValue(
            _FakeLoanablesRepository(
              detail: detail,
              window: window,
              windowError: windowError,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(home: LoanableDetailScreen(loanableId: detail.id)),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders detail without photo (placeholder)', (tester) async {
      await pumpDetail(tester, detail: _detail());

      expect(find.text('Toyota Prius Hybride'), findsOneWidget);
      // Status badge + availability legend both render the label.
      expect(find.text('Disponible'), findsNWidgets(2));
      expect(find.text('Indisponible'), findsOneWidget);
      expect(find.text('Localisation'), findsOneWidget);
      expect(find.text('Stationnement Lajeunesse'), findsOneWidget);
      expect(find.text('Instructions'), findsOneWidget);
      expect(find.textContaining('boîte à gants'), findsOneWidget);
      expect(find.text('Disponibilités'), findsOneWidget);
      expect(
        find.text('Fuseau du véhicule : America/Montreal'),
        findsOneWidget,
      );
      expect(find.text('Continuer vers la demande'), findsOneWidget);
    });

    testWidgets('renders detail without position (fallback panel)', (
      tester,
    ) async {
      await pumpDetail(tester, detail: _detail(lat: null, lng: null));

      expect(find.text('Position non disponible'), findsOneWidget);
    });

    testWidgets('renders with position (map area present)', (tester) async {
      await pumpDetail(tester, detail: _detail(lat: 45.5, lng: -73.6));

      expect(find.text('Position non disponible'), findsNothing);
      expect(find.text('Localisation'), findsOneWidget);
    });

    testWidgets('shows unavailable badge for no_availabilities', (
      tester,
    ) async {
      await pumpDetail(tester, detail: _detail(status: 'no_availabilities'));

      // Status badge + availability legend both render the label.
      expect(find.text('Indisponible'), findsNWidgets(2));
      expect(find.text('Disponible'), findsOneWidget); // legend only
    });

    testWidgets('shows duration limits', (tester) async {
      await pumpDetail(tester, detail: _detail());

      expect(find.text('Durée minimale'), findsOneWidget);
      expect(find.text('30 min'), findsOneWidget);
      expect(find.text('Durée maximale'), findsOneWidget);
      expect(find.text('2880 min'), findsOneWidget);
    });

    testWidgets('shows empty availability message when window is empty', (
      tester,
    ) async {
      await pumpDetail(
        tester,
        detail: _detail(),
        window: const LoanableAvailabilityWindow(
          available: [],
          unavailable: [],
        ),
      );

      expect(
        find.text('Aucune donnée de disponibilité pour cette période.'),
        findsOneWidget,
      );
    });

    testWidgets('shows availability error explicitly', (tester) async {
      await pumpDetail(
        tester,
        detail: _detail(),
        windowError: Exception('réseau'),
      );

      expect(
        find.textContaining('Impossible de charger les disponibilités'),
        findsOneWidget,
      );
    });

    testWidgets('renders available and unavailable slots with vehicle times', (
      tester,
    ) async {
      // Slots must fall inside the 7-day window starting today.
      final today = DateTime.now();
      final ymd = VehicleLocalDates.formatYmd(today);
      final available = LoanableAvailabilityInterval(
        type: 'availability',
        start: DateTime(today.year, today.month, today.day, 8),
        end: DateTime(today.year, today.month, today.day, 12),
        isAvailable: true,
        rawStart: '$ymd 08:00:00',
        rawEnd: '$ymd 12:00:00',
      );
      final unavailable = LoanableAvailabilityInterval(
        type: 'availability',
        start: DateTime(today.year, today.month, today.day, 12),
        end: DateTime(today.year, today.month, today.day, 14),
        isAvailable: false,
        rawStart: '$ymd 12:00:00',
        rawEnd: '$ymd 14:00:00',
      );

      await pumpDetail(
        tester,
        detail: _detail(),
        window: LoanableAvailabilityWindow(
          available: [available],
          unavailable: [unavailable],
        ),
      );

      expect(find.textContaining('08:00 – 12:00'), findsOneWidget);
      expect(find.textContaining('12:00 – 14:00'), findsOneWidget);
      expect(find.text('Disponible'), findsWidgets);
      expect(find.text('Indisponible'), findsWidgets);
    });

    testWidgets('CTA is always disabled (Lot 3 not delivered)', (tester) async {
      await pumpDetail(tester, detail: _detail());

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Continuer vers la demande'),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('shows incidents section when present', (tester) async {
      final detail = _detail(
        id: 10,
        type: 'bike',
        status: 'no_availabilities',
        incidents: [
          const LoanableIncident(
            id: 1,
            incidentType: 'breakdown',
            status: 'open',
            isBlocking: true,
          ),
        ],
      );

      await pumpDetail(tester, detail: detail);

      expect(find.text('Incident(s) actuel(s)'), findsOneWidget);
      expect(find.text('breakdown'), findsOneWidget);
      expect(find.text('Bloquant'), findsOneWidget);
    });
  });
}

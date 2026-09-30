import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/router/routes.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/loanables/domain/entities/loanable.dart';
import 'package:mobile/features/loanables/domain/entities/loanables_page.dart';
import 'package:mobile/features/loanables/presentation/controllers/loanables_controller.dart';
import 'package:mobile/features/loanables/presentation/screens/explore_screen.dart';
import 'package:mobile/features/communities/domain/entities/community.dart';
import 'package:mobile/features/communities/presentation/controllers/communities_controller.dart';

class _FakeCommunitiesController extends CommunitiesListController {
  @override
  Future<List<Community>> build() async => const [];
}

Loanable _loanable({
  int id = 1,
  String name = 'Toyota Prius',
  String type = 'car',
  String? status = 'has_availabilities',
  double? lat = 45.5,
  double? lng = -73.6,
  String? community,
}) {
  return Loanable(
    id: id,
    name: name,
    type: type,
    availabilityStatus: status,
    latitude: lat,
    longitude: lng,
    communityName: community,
  );
}

void main() {
  group('ExploreScreen', () {
    Future<void> pumpExplore(
      WidgetTester tester, {
      required LoanablesPage page,
    }) async {
      final container = ProviderContainer(
        overrides: [
          loanablesListControllerProvider.overrideWith(
            () => _FakeListController(page),
          ),
          selectedLoanableTypeProvider.overrideWith(
            () => _FakeTypeController(),
          ),
          selectedLoanableCommunityProvider.overrideWith(
            () => _FakeCommunityController(),
          ),
          communitiesListControllerProvider.overrideWith(
            () => _FakeCommunitiesController(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: ExploreScreen()),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('renders vehicle cards from list', (tester) async {
      await pumpExplore(
        tester,
        page: LoanablesPage(
          items: [
            _loanable(name: 'Toyota Prius', community: 'Ahuntsic'),
            _loanable(id: 2, name: 'Cargo Babboe', type: 'bike'),
          ],
          page: 1,
          lastPage: 1,
        ),
      );

      expect(find.text('Toyota Prius'), findsOneWidget);
      expect(find.text('Cargo Babboe'), findsOneWidget);
      expect(find.text('Disponible'), findsNWidgets(2));
    });

    testWidgets('shows real empty state when list is empty', (tester) async {
      await pumpExplore(
        tester,
        page: const LoanablesPage(items: [], page: 1, lastPage: 1),
      );

      expect(
        find.text('Aucun véhicule ne correspond à ces filtres.'),
        findsOneWidget,
      );
    });

    testWidgets('shows all four type chips including car_trailer', (
      tester,
    ) async {
      await pumpExplore(
        tester,
        page: const LoanablesPage(items: [], page: 1, lastPage: 1),
      );

      expect(find.text('Tous'), findsOneWidget);
      expect(find.text('🚗 Voitures'), findsOneWidget);
      expect(find.text('🚲 Vélos & Cargos'), findsOneWidget);
      expect(find.text('🛒 Remorques'), findsOneWidget);
      expect(find.text('🚙 Remorques auto'), findsOneWidget);
    });

    testWidgets('does not show unavailable as Disponible', (tester) async {
      await pumpExplore(
        tester,
        page: LoanablesPage(
          items: [_loanable(name: 'Vélo cassé', status: 'no_availabilities')],
          page: 1,
          lastPage: 1,
        ),
      );

      expect(find.text('Indisponible'), findsOneWidget);
      expect(find.text('Disponible'), findsNothing);
    });

    testWidgets('hides status badge when availabilityStatus is null', (
      tester,
    ) async {
      await pumpExplore(
        tester,
        page: LoanablesPage(
          items: [_loanable(name: 'Sans statut', status: null)],
          page: 1,
          lastPage: 1,
        ),
      );

      expect(find.text('Sans statut'), findsOneWidget);
      expect(find.text('Disponible'), findsNothing);
      expect(find.text('Indisponible'), findsNothing);
    });

    testWidgets('shows load more button when hasMore', (tester) async {
      await pumpExplore(
        tester,
        page: LoanablesPage(
          items: [_loanable()],
          page: 1,
          lastPage: 3,
          total: 40,
        ),
      );

      expect(find.text('Charger plus'), findsOneWidget);
    });

    testWidgets('hides load more on last page', (tester) async {
      await pumpExplore(
        tester,
        page: LoanablesPage(items: [_loanable()], page: 1, lastPage: 1),
      );

      expect(find.text('Charger plus'), findsNothing);
    });

    testWidgets('shows load more error when present', (tester) async {
      await pumpExplore(
        tester,
        page: LoanablesPage(
          items: [_loanable()],
          page: 1,
          lastPage: 3,
          isLoadingMore: false,
          loadMoreError: 'Réseau indisponible',
        ),
      );

      expect(find.textContaining('Erreur de chargement'), findsOneWidget);
    });

    testWidgets('filters vehicles when type chip is tapped', (tester) async {
      final typeController = _FakeTypeController();
      final listController = _FakeListController(
        const LoanablesPage(items: [], page: 1, lastPage: 1),
      );

      final container = ProviderContainer(
        overrides: [
          loanablesListControllerProvider.overrideWith(() => listController),
          selectedLoanableTypeProvider.overrideWith(() => typeController),
          selectedLoanableCommunityProvider.overrideWith(
            () => _FakeCommunityController(),
          ),
          communitiesListControllerProvider.overrideWith(
            () => _FakeCommunitiesController(),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: ExploreScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('🚗 Voitures'));
      await tester.pumpAndSettle();

      expect(typeController.state, 'car');
    });

    testWidgets('map mode falls back to list view when no coordinates exist', (
      tester,
    ) async {
      await pumpExplore(
        tester,
        page: LoanablesPage(
          items: [
            _loanable(
              name: 'Vélo sans GPS',
              type: 'bike',
              lat: null,
              lng: null,
            ),
          ],
          page: 1,
          lastPage: 1,
        ),
      );

      // Switch to Map view using the AppBar toggle button
      await tester.tap(find.byIcon(Icons.map_rounded));
      await tester.pumpAndSettle();

      // Banner text must appear
      expect(
        find.textContaining('Aucun véhicule avec position valide'),
        findsOneWidget,
      );
      // Fallback vehicle list must still be visible and render the vehicle
      expect(find.text('Vélo sans GPS'), findsOneWidget);
    });
  });

  group('AppColors used by explore', () {
    test('success/warning distinguish availability', () {
      expect(AppColors.success, isNot(AppColors.warning));
    });
  });

  test('loanable detail path helper', () {
    expect(AppRoutes.loanableDetailPath(42), '/loanables/42');
  });
}

class _FakeListController extends LoanablesListController {
  final LoanablesPage page;

  _FakeListController(this.page);

  @override
  Future<LoanablesPage> build() async => page;

  @override
  Future<void> refresh() async {}

  @override
  Future<void> loadMore() async {}
}

class _FakeTypeController extends SelectedLoanableType {
  @override
  String? build() => null;
}

class _FakeCommunityController extends SelectedLoanableCommunity {
  @override
  int? build() => null;
}

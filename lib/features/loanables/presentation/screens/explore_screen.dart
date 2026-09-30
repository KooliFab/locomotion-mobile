import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/maps/adaptive_map_widget.dart';
import '../../../../core/maps/map_marker.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/api_test_dialog.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../communities/domain/entities/community.dart';
import '../../../communities/presentation/controllers/communities_controller.dart';
import '../../domain/entities/loanable.dart';
import '../../domain/entities/loanables_page.dart';
import '../controllers/loanables_controller.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  bool _isMapView = false;

  @override
  Widget build(BuildContext context) {
    final loanablesAsync = ref.watch(loanablesListControllerProvider);
    final selectedType = ref.watch(selectedLoanableTypeProvider);
    final selectedCommunityId = ref.watch(selectedLoanableCommunityProvider);
    final communitiesAsync = ref.watch(communitiesListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LocoMotion'),
        actions: [
          IconButton(
            icon: const Icon(Icons.troubleshoot_rounded),
            tooltip: 'Tester API backend',
            onPressed: () => ApiTestDialog.show(context),
          ),
          IconButton(
            icon: Icon(_isMapView ? Icons.list_rounded : Icons.map_rounded),
            tooltip: _isMapView ? 'Vue Liste' : 'Vue Carte',
            onPressed: () => setState(() => _isMapView = !_isMapView),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'Tous',
                        type: null,
                        selected: selectedType == null,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: '🚗 Voitures',
                        type: 'car',
                        selected: selectedType == 'car',
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: '🚲 Vélos & Cargos',
                        type: 'bike',
                        selected: selectedType == 'bike',
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: '🛒 Remorques',
                        type: 'trailer',
                        selected: selectedType == 'trailer',
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        label: '🚙 Remorques auto',
                        type: 'car_trailer',
                        selected: selectedType == 'car_trailer',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _buildCommunityDropdown(communitiesAsync, selectedCommunityId),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // Content: Map or List
          Expanded(
            child: AsyncValueWidget<LoanablesPage>(
              value: loanablesAsync,
              onRetry: () =>
                  ref.read(loanablesListControllerProvider.notifier).refresh(),
              data: (page) {
                final loanables = page.items;
                if (loanables.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Aucun véhicule ne correspond à ces filtres.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  );
                }

                if (_isMapView) {
                  final markers = loanables
                      .where((l) => l.latitude != null && l.longitude != null)
                      .map(
                        (l) => AppMapMarker(
                          id: l.id.toString(),
                          title: l.name,
                          snippet: l.communityName ?? l.locationDescription,
                          latitude: l.latitude!,
                          longitude: l.longitude!,
                          type: l.type,
                          onTap: () =>
                              context.push(AppRoutes.loanableDetailPath(l.id)),
                        ),
                      )
                      .toList();

                  if (markers.isEmpty) {
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          color: AppColors.lightTint,
                          child: const Text(
                            'Aucun véhicule avec position valide.\n'
                            'Voici la liste en mode carte.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildLoanablesListView(
                            context,
                            page,
                            loanables,
                          ),
                        ),
                      ],
                    );
                  }

                  return AdaptiveMapWidget(
                    initialLatitude: markers.first.latitude,
                    initialLongitude: markers.first.longitude,
                    markers: markers,
                  );
                }

                return _buildLoanablesListView(context, page, loanables);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanablesListView(
    BuildContext context,
    LoanablesPage page,
    List<Loanable> loanables,
  ) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () =>
          ref.read(loanablesListControllerProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...loanables.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildLoanableCard(context, item),
            ),
          ),
          if (page.loadMoreError != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Erreur de chargement : ${page.loadMoreError}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.danger),
              ),
            ),
          if (page.hasMore)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 20),
              child: page.isLoadingMore
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : OutlinedButton(
                      onPressed: () => ref
                          .read(loanablesListControllerProvider.notifier)
                          .loadMore(),
                      child: const Text('Charger plus'),
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required String? type,
    required bool selected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.textPrimary,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (_) {
        ref.read(selectedLoanableTypeProvider.notifier).selectType(type);
      },
    );
  }

  Widget _buildCommunityDropdown(
    AsyncValue<List<Community>> communitiesAsync,
    int? selectedCommunityId,
  ) {
    return Row(
      children: [
        const Icon(Icons.groups_outlined, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Expanded(
          child: communitiesAsync.when(
            data: (communities) {
              if (communities.isEmpty) {
                return const Text(
                  'Aucune communauté accessible',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                );
              }
              final validSelection = communities.any(
                (c) => c.id == selectedCommunityId,
              );
              return DropdownButtonHideUnderline(
                child: DropdownButton<int?>(
                  isExpanded: true,
                  value: validSelection ? selectedCommunityId : null,
                  hint: const Text(
                    'Toutes les communautés',
                    style: TextStyle(fontSize: 13),
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('Toutes les communautés'),
                    ),
                    ...communities.map(
                      (c) => DropdownMenuItem<int?>(
                        value: c.id,
                        child: Text(
                          c.name,
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    ref
                        .read(selectedLoanableCommunityProvider.notifier)
                        .selectCommunity(value);
                  },
                ),
              );
            },
            loading: () => const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (e, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 14,
                  color: AppColors.danger,
                ),
                const SizedBox(width: 4),
                const Flexible(
                  child: Text(
                    'Erreur : filtre communauté indisponible',
                    style: TextStyle(fontSize: 12, color: AppColors.danger),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => ref
                      .read(communitiesListControllerProvider.notifier)
                      .refresh(),
                  child: const Text(
                    'Réessayer',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoanableCard(BuildContext context, Loanable item) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(AppRoutes.loanableDetailPath(item.id)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.lightTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _iconForType(item.type),
                      color: AppColors.primaryDark,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (item.communityName != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.communityName!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        if (item.locationDescription != null) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.place_outlined,
                                size: 14,
                                color: AppColors.textMuted,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item.locationDescription!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (item.availabilityStatus != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item.isAvailable
                            ? AppColors.successBg
                            : AppColors.warningBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.isAvailable ? 'Disponible' : 'Indisponible',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: item.isAvailable
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                      ),
                    ),
                ],
              ),
              if (item.comments != null &&
                  item.comments!.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  item.comments!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'car':
        return Icons.directions_car_rounded;
      case 'bike':
        return Icons.pedal_bike_rounded;
      case 'trailer':
        return Icons.rv_hookup_rounded;
      case 'car_trailer':
        return Icons.local_shipping_rounded;
      default:
        return Icons.commute_rounded;
    }
  }
}

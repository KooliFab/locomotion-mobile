import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/maps/adaptive_map_widget.dart';
import '../../../../core/maps/map_marker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/api_test_dialog.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../domain/entities/loanable.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(label: 'Tous', type: null, selected: selectedType == null),
                  const SizedBox(width: 8),
                  _buildFilterChip(label: '🚗 Voitures', type: 'car', selected: selectedType == 'car'),
                  const SizedBox(width: 8),
                  _buildFilterChip(label: '🚲 Vélos & Cargos', type: 'bike', selected: selectedType == 'bike'),
                  const SizedBox(width: 8),
                  _buildFilterChip(label: '🛒 Remorques', type: 'trailer', selected: selectedType == 'trailer'),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // Content: Map or List
          Expanded(
            child: AsyncValueWidget<List<Loanable>>(
              value: loanablesAsync,
              onRetry: () => ref.read(loanablesListControllerProvider.notifier).refresh(),
              data: (loanables) {
                if (loanables.isEmpty) {
                  return const Center(
                    child: Text(
                      'Aucun véhicule disponible dans cette catégorie.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                if (_isMapView) {
                  final markers = loanables
                      .where((l) => l.latitude != null && l.longitude != null)
                      .map((l) => AppMapMarker(
                            id: l.id.toString(),
                            title: l.name,
                            snippet: l.communityName ?? l.address,
                            latitude: l.latitude!,
                            longitude: l.longitude!,
                            type: l.type,
                          ))
                      .toList();

                  return AdaptiveMapWidget(
                    initialLatitude: markers.isNotEmpty ? markers.first.latitude : 45.5017,
                    initialLongitude: markers.isNotEmpty ? markers.first.longitude : -73.5673,
                    markers: markers,
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => ref.read(loanablesListControllerProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: loanables.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final item = loanables[index];
                      return _buildLoanableCard(context, item);
                    },
                  ),
                );
              },
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

  Widget _buildLoanableCard(BuildContext context, Loanable item) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Future navigation to loanable detail
        },
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
                        if (item.address != null) ...[
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.place_outlined, size: 14, color: AppColors.textMuted),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item.address!,
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.isAvailable ? AppColors.successBg : AppColors.warningBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.isAvailable ? 'Disponible' : 'Réservé',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: item.isAvailable ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
              if (item.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  item.description!,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
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
      default:
        return Icons.commute_rounded;
    }
  }
}

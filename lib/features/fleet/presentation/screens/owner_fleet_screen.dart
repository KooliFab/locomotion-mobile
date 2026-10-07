import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../loanables/presentation/widgets/loanable_image_widget.dart';
import '../../domain/entities/fleet_vehicle.dart';
import '../controllers/fleet_controller.dart';
import '../widgets/vehicle_suspension_dialog.dart';

enum FleetFilter { all, published, suspended, draft }

class OwnerFleetScreen extends ConsumerStatefulWidget {
  const OwnerFleetScreen({super.key});

  @override
  ConsumerState<OwnerFleetScreen> createState() => _OwnerFleetScreenState();
}

class _OwnerFleetScreenState extends ConsumerState<OwnerFleetScreen> {
  FleetFilter _currentFilter = FleetFilter.all;

  @override
  Widget build(BuildContext context) {
    final fleetAsync = ref.watch(ownerFleetControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma flotte de véhicules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Actualiser',
            onPressed: () =>
                ref.read(ownerFleetControllerProvider.notifier).refreshFleet(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('add_vehicle_fab'),
        onPressed: () => context.push(AppRoutes.fleetCreate),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Ajouter un véhicule'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: fleetAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppColors.danger,
                ),
                const SizedBox(height: 12),
                Text(
                  'Erreur lors du chargement de la flotte :\n$err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref
                      .read(ownerFleetControllerProvider.notifier)
                      .refreshFleet(),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
        data: (vehicles) {
          final filteredVehicles = _applyFilter(vehicles);

          return Column(
            children: [
              _buildFilterBar(vehicles),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => ref
                      .read(ownerFleetControllerProvider.notifier)
                      .refreshFleet(),
                  child: filteredVehicles.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                          itemCount: filteredVehicles.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _VehicleFleetCard(
                              vehicle: filteredVehicles[index],
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<FleetVehicle> _applyFilter(List<FleetVehicle> list) {
    switch (_currentFilter) {
      case FleetFilter.all:
        return list;
      case FleetFilter.published:
        return list.where((v) => v.published && !v.isSuspended).toList();
      case FleetFilter.suspended:
        return list.where((v) => v.isSuspended).toList();
      case FleetFilter.draft:
        return list.where((v) => !v.published).toList();
    }
  }

  Widget _buildFilterBar(List<FleetVehicle> all) {
    final publishedCount = all
        .where((v) => v.published && !v.isSuspended)
        .length;
    final suspendedCount = all.where((v) => v.isSuspended).length;
    final draftCount = all.where((v) => !v.published).length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildChoiceChip('Tous (${all.length})', FleetFilter.all),
          const SizedBox(width: 8),
          _buildChoiceChip('Publiés ($publishedCount)', FleetFilter.published),
          const SizedBox(width: 8),
          _buildChoiceChip(
            'Suspendus ($suspendedCount)',
            FleetFilter.suspended,
          ),
          const SizedBox(width: 8),
          _buildChoiceChip('Brouillons ($draftCount)', FleetFilter.draft),
        ],
      ),
    );
  }

  Widget _buildChoiceChip(String label, FleetFilter filter) {
    final isSelected = _currentFilter == filter;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (_) => setState(() => _currentFilter = filter),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_car_outlined,
                size: 64,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'Aucun véhicule trouvé dans cette vue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ajoutez un véhicule ou changez de filtre.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VehicleFleetCard extends ConsumerWidget {
  final FleetVehicle vehicle;

  const _VehicleFleetCard({required this.vehicle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = vehicle;

    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AppRoutes.fleetDetailPath(v.id)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildThumbnail(v),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildTypeBadge(v.type),
                            const SizedBox(width: 6),
                            if (v.sharingMode != null)
                              _buildSharingModeBadge(v.sharingMode!),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _buildStatusBadge(v),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),

              // Activity indicators row
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        _buildLoanCounter(
                          icon: Icons.play_arrow_rounded,
                          label: '${v.activeLoansCount} en cours',
                          isActive: v.hasActiveLoans,
                        ),
                        _buildLoanCounter(
                          icon: Icons.calendar_month_outlined,
                          label: '${v.futureLoansCount} réservés',
                          isActive: v.hasFutureLoans,
                        ),
                      ],
                    ),
                  ),
                  // Quick Actions
                  IconButton(
                    icon: const Icon(Icons.visibility_outlined, size: 20),
                    tooltip: 'Aperçu emprunteur',
                    onPressed: () =>
                        context.push(AppRoutes.fleetPreviewPath(v.id)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    tooltip: 'Modifier',
                    onPressed: () =>
                        context.push(AppRoutes.fleetEditPath(v.id)),
                  ),
                  _buildActionMenu(context, ref, v),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(FleetVehicle v) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LoanableImageWidget(image: v.image, width: 64, height: 64),
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    String label = type.toUpperCase();
    if (type == 'bike') label = 'VÉLO';
    if (type == 'car') label = 'AUTO';
    if (type == 'trailer') label = 'REMORQUE';
    if (type == 'car_trailer') label = 'REMORQUE AUTO';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSharingModeBadge(String mode) {
    String label = mode;
    if (mode == 'on_demand') label = 'Sur demande';
    if (mode == 'self_service') label = 'Libre-service';
    if (mode == 'hybrid') label = 'Hybride';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(FleetVehicle v) {
    if (v.isSuspended) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.pause_circle_filled, size: 14, color: AppColors.warning),
            SizedBox(width: 4),
            Text(
              'Suspendu',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      );
    }

    if (v.published) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 14,
              color: AppColors.success,
            ),
            SizedBox(width: 4),
            Text(
              'Publié',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.edit_note_rounded,
            size: 14,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 4),
          Text(
            'Brouillon',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanCounter({
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: isActive ? AppColors.primary : AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionMenu(BuildContext context, WidgetRef ref, FleetVehicle v) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (action) async {
        if (action == 'preview') {
          context.push(AppRoutes.fleetPreviewPath(v.id));
        } else if (action == 'edit') {
          context.push(AppRoutes.fleetEditPath(v.id));
        } else if (action == 'publish') {
          _confirmPublish(context, ref, v);
        } else if (action == 'suspend') {
          await VehicleSuspensionDialog.show(
            context,
            vehicle: v,
            onConfirm: (reason, preserve) async {
              await ref
                  .read(ownerFleetControllerProvider.notifier)
                  .suspendVehicle(
                    v.id,
                    reason: reason,
                    preserveFuture: preserve,
                  );
            },
          );
        } else if (action == 'unsuspend') {
          await ref
              .read(ownerFleetControllerProvider.notifier)
              .unsuspendVehicle(v.id);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Véhicule réactivé avec succès.')),
            );
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'preview',
          child: Row(
            children: [
              Icon(Icons.visibility_outlined, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text('Aperçu emprunteur')),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text('Modifier')),
            ],
          ),
        ),
        if (v.isDraft)
          const PopupMenuItem(
            value: 'publish',
            child: Row(
              children: [
                Icon(Icons.publish_rounded, size: 18, color: AppColors.primary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Publier',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        if (v.published && !v.isSuspended)
          const PopupMenuItem(
            value: 'suspend',
            child: Row(
              children: [
                Icon(
                  Icons.pause_circle_outline,
                  size: 18,
                  color: AppColors.warning,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Suspendre',
                    style: TextStyle(color: AppColors.warning),
                  ),
                ),
              ],
            ),
          ),
        if (v.isSuspended)
          const PopupMenuItem(
            value: 'unsuspend',
            child: Row(
              children: [
                Icon(
                  Icons.play_circle_outline,
                  size: 18,
                  color: AppColors.success,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Réactiver',
                    style: TextStyle(color: AppColors.success),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _confirmPublish(BuildContext context, WidgetRef ref, FleetVehicle v) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Publier ce véhicule ?'),
        content: Text(
          'Une fois publié, ${v.name} sera visible et réservable par les membres de votre communauté selon les règles de disponibilité définies.\n\nAttention : pour les voitures, certains champs techniques (marque, modèle, motorisation...) seront verrouillés après publication.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await ref
                    .read(ownerFleetControllerProvider.notifier)
                    .publishVehicle(v.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Véhicule publié avec succès.'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erreur de publication : $e'),
                      backgroundColor: AppColors.danger,
                    ),
                  );
                }
              }
            },
            child: const Text('Publier'),
          ),
        ],
      ),
    );
  }
}

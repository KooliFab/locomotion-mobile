import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../loanables/presentation/widgets/loanable_image_widget.dart';
import '../../domain/entities/fleet_vehicle.dart';
import '../controllers/fleet_controller.dart';

class OwnerVehicleDetailScreen extends ConsumerWidget {
  final int vehicleId;

  const OwnerVehicleDetailScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(fleetVehicleDetailProvider(vehicleId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion du véhicule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Modifier',
            onPressed: () => context.push(AppRoutes.fleetEditPath(vehicleId)),
          ),
        ],
      ),
      body: vehicleAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Erreur : $err'),
          ),
        ),
        data: (vehicle) {
          if (vehicle == null) {
            return const Center(child: Text('Véhicule introuvable'));
          }
          return _buildBody(context, ref, vehicle);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, FleetVehicle v) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header Card
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LoanableImageWidget(
                      image: v.image,
                      width: 72,
                      height: 72,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildStatusPill(v),
                          const SizedBox(width: 6),
                          if (v.userRole != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.border,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                v.userRole!.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Availability Management Tile
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.background,
              child: Icon(Icons.calendar_month, color: AppColors.primary),
            ),
            title: const Text(
              'Disponibilités & Calendrier',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Text(
              v.availabilityMode == 'never'
                  ? 'Mode restreint (créneaux fermés par défaut)'
                  : 'Gérer les indisponibilités ponctuelles & récurrentes',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
            onTap: () => context.push(AppRoutes.fleetAvailabilityPath(v.id)),
          ),
        ),
        // Incidents Management Tile
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            key: const Key('vehicle_incidents_tile'),
            leading: const CircleAvatar(
              backgroundColor: AppColors.background,
              child: Icon(
                Icons.report_problem_outlined,
                color: AppColors.warning,
              ),
            ),
            title: const Text(
              'Incidents & Dommages',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: const Text(
              'Consulter l\'historique et les signalements en cours',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
            onTap: () =>
                context.push('${AppRoutes.incidents}?loanable_id=${v.id}'),
          ),
        ),
        const SizedBox(height: 16),

        // Action Buttons Row
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.fleetPreviewPath(v.id)),
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: const Text('Aperçu'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.push(AppRoutes.fleetEditPath(v.id)),
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Modifier'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (v.isDraft) ...[
          ElevatedButton.icon(
            onPressed: () => _publishVehicle(context, ref, v),
            icon: const Icon(Icons.publish_rounded, color: Colors.white),
            label: const Text(
              'Publier le véhicule',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
        const SizedBox(height: 20),

        // Information Section
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Paramètres de partage',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Mode de partage', v.sharingMode ?? 'N/A'),
                _buildInfoRow(
                  'Durée minimale',
                  '${v.minLoanDurationInMinutes ?? 30} minutes',
                ),
                _buildInfoRow(
                  'Durée maximale',
                  '${v.maxLoanDurationInMinutes ?? 1440} minutes',
                ),
                _buildInfoRow(
                  'Emplacement',
                  v.locationDescription ?? 'Non renseigné',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(FleetVehicle v) {
    if (v.published) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'PUBLIÉ',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.success,
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'BROUILLON',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Future<void> _publishVehicle(
    BuildContext context,
    WidgetRef ref,
    FleetVehicle v,
  ) async {
    try {
      await ref
          .read(ownerFleetControllerProvider.notifier)
          .publishVehicle(v.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Véhicule publié avec succès.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }
}

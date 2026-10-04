import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../loanables/presentation/widgets/loanable_image_widget.dart';
import '../../domain/entities/fleet_vehicle.dart';
import '../controllers/fleet_controller.dart';
import '../widgets/vehicle_suspension_dialog.dart';

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
            onPressed: () =>
                context.push(AppRoutes.fleetEditPath(vehicleId)),
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

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    FleetVehicle v,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Status & Suspension Banner
        if (v.isSuspended) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.warning),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.pause_circle_filled,
                      color: AppColors.warning,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Véhicule actuellement suspendu',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.warning,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () async {
                        await ref
                            .read(ownerFleetControllerProvider.notifier)
                            .unsuspendVehicle(v.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Véhicule réactivé avec succès.'),
                            ),
                          );
                        }
                      },
                      child: const Text('Réactiver'),
                    ),
                  ],
                ),
                if (v.suspendedAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Suspendu le ${DateFormat('dd/MM/yyyy à HH:mm').format(v.suspendedAt!)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                if (v.suspensionReason != null &&
                    v.suspensionReason!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Motif : ${v.suspensionReason}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Header Card
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

        // Activity Stats Card
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Activité des réservations',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        title: 'En cours',
                        value: '${v.activeLoansCount}',
                        subtitle: 'Dont retards',
                        highlight: v.hasActiveLoans,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricTile(
                        title: 'Confirmées',
                        value: '${v.confirmedFutureLoansCount}',
                        subtitle: 'À venir',
                        highlight: v.confirmedFutureLoansCount > 0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricTile(
                        title: 'En attente',
                        value: '${v.pendingRequestsCount}',
                        subtitle: 'Demandes',
                        highlight: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Action Buttons Row
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    context.push(AppRoutes.fleetPreviewPath(v.id)),
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: const Text('Aperçu'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () =>
                    context.push(AppRoutes.fleetEditPath(v.id)),
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
        ] else if (!v.isSuspended) ...[
          OutlinedButton.icon(
            onPressed: () => _openSuspensionDialog(context, ref, v),
            icon: const Icon(Icons.pause_circle_outline, color: AppColors.warning),
            label: const Text(
              'Suspendre les nouvelles réservations',
              style: TextStyle(color: AppColors.warning),
            ),
          ),
        ],
        const SizedBox(height: 20),

        // Information Section
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String subtitle,
    required bool highlight,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlight ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: highlight ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
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
    if (v.isSuspended) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'SUSPENDU',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.warning,
          ),
        ),
      );
    }
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

  Future<void> _openSuspensionDialog(
    BuildContext context,
    WidgetRef ref,
    FleetVehicle v,
  ) async {
    await VehicleSuspensionDialog.show(
      context,
      vehicle: v,
      onConfirm: (reason, preserve) async {
        await ref
            .read(ownerFleetControllerProvider.notifier)
            .suspendVehicle(v.id, reason: reason, preserveFuture: preserve);
      },
    );
  }

  Future<void> _publishVehicle(
    BuildContext context,
    WidgetRef ref,
    FleetVehicle v,
  ) async {
    try {
      await ref.read(ownerFleetControllerProvider.notifier).publishVehicle(v.id);
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

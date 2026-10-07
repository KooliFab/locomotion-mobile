import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../loanables/presentation/widgets/loanable_image_widget.dart';
import '../../domain/entities/fleet_vehicle.dart';
import '../controllers/fleet_controller.dart';

class VehiclePreviewScreen extends ConsumerWidget {
  final int vehicleId;

  const VehiclePreviewScreen({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleAsync = ref.watch(fleetVehicleDetailProvider(vehicleId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aperçu emprunteur'),
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
          return _buildContent(context, ref, vehicle);
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    FleetVehicle vehicle,
  ) {
    return Column(
      children: [
        // Mode Aperçu Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            border: const Border(
              bottom: BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.visibility_rounded,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  vehicle.isDraft
                      ? 'Mode aperçu — Ce véhicule est encore en brouillon et invisible pour les emprunteurs.'
                      : 'Mode aperçu — Voici comment ce véhicule apparaît dans le catalogue public.',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Main preview content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Image
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LoanableImageWidget(
                    image: vehicle.image,
                    height: 220,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title and Badges
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _badge(
                              vehicle.type.toUpperCase(),
                              AppColors.textSecondary,
                            ),
                            const SizedBox(width: 8),
                            if (vehicle.sharingMode != null)
                              _badge(
                                _sharingModeLabel(vehicle.sharingMode!),
                                AppColors.primary,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Location Section
              _infoCard(
                title: 'Emplacement & Prise en charge',
                icon: Icons.location_on_outlined,
                children: [
                  Text(
                    vehicle.locationDescription?.isNotEmpty == true
                        ? vehicle.locationDescription!
                        : 'Aucune description d\'emplacement spécifiée.',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Technical Details Section
              if (vehicle.details != null && vehicle.details!.isNotEmpty)
                _infoCard(
                  title: 'Caractéristiques techniques',
                  icon: Icons.info_outline_rounded,
                  children: vehicle.details!.entries
                      .where(
                        (e) => e.value != null && e.value.toString().isNotEmpty,
                      )
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Text(
                                '${_formatKey(e.key)} : ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '${e.value}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 16),

              // Instructions
              _infoCard(
                title: 'Instructions d\'accès & départ',
                icon: Icons.key_outlined,
                children: [
                  Text(
                    vehicle.instructions?.isNotEmpty == true
                        ? vehicle.instructions!
                        : 'Les instructions détaillées seront communiquées une fois la réservation validée.',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),

        // Bottom action bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      context.push(AppRoutes.fleetEditPath(vehicle.id)),
                  child: const Text('Modifier l\'annonce'),
                ),
              ),
              if (vehicle.isDraft) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await ref
                            .read(ownerFleetControllerProvider.notifier)
                            .publishVehicle(vehicle.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Véhicule publié avec succès.'),
                            ),
                          );
                          context.pop();
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Publier'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  String _sharingModeLabel(String mode) {
    if (mode == 'on_demand') return 'Sur demande';
    if (mode == 'self_service') return 'Libre-service';
    if (mode == 'hybrid') return 'Hybride';
    return mode;
  }

  String _formatKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '',
        )
        .join(' ');
  }
}

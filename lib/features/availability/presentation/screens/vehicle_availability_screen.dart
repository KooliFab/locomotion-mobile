import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/availability_config.dart';
import '../../domain/entities/availability_rule.dart';
import '../controllers/vehicle_availability_controller.dart';
import '../widgets/availability_calendar_preview.dart';
import '../widgets/availability_rule_card.dart';
import '../widgets/availability_rule_form_sheet.dart';

class VehicleAvailabilityScreen extends ConsumerStatefulWidget {
  final int vehicleId;

  const VehicleAvailabilityScreen({super.key, required this.vehicleId});

  @override
  ConsumerState<VehicleAvailabilityScreen> createState() =>
      _VehicleAvailabilityScreenState();
}

class _VehicleAvailabilityScreenState
    extends ConsumerState<VehicleAvailabilityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(
      vehicleAvailabilityConfigProvider(widget.vehicleId),
    );
    final controllerState = ref.watch(
      vehicleAvailabilityControllerProvider(widget.vehicleId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disponibilités & Calendrier'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
            onPressed: () {
              ref.invalidate(
                vehicleAvailabilityConfigProvider(widget.vehicleId),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Ponctuelles'),
            Tab(text: 'Récurrentes'),
            Tab(text: 'Aperçu'),
          ],
        ),
      ),
      body: configAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.danger,
                ),
                const SizedBox(height: 12),
                Text('Erreur : $err', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(
                      vehicleAvailabilityConfigProvider(widget.vehicleId),
                    );
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
        data: (config) => _buildContent(context, config, controllerState),
      ),
      floatingActionButton: configAsync.maybeWhen(
        data: (config) => config.isNeverMode
            ? null
            : FloatingActionButton.extended(
                onPressed: () async {
                  await AvailabilityRuleFormSheet.show(
                    context,
                    vehicleId: widget.vehicleId,
                  );
                },
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                icon: const Icon(Icons.add),
                label: const Text('Ajouter'),
              ),
        orElse: () => null,
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AvailabilityConfig config,
    VehicleAvailabilityState state,
  ) {
    return Column(
      children: [
        // Mode Banner
        if (config.isNeverMode)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.warning),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Ce véhicule est configuré en mode de disponibilité restreinte ("sur créneaux"). Ses règles sont gérées via l\'interface d\'administration web et sont présentées ici en lecture seule pour préserver leur configuration.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),

        if (state.errorMessage != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.danger),
            ),
            child: Text(
              state.errorMessage!,
              style: const TextStyle(fontSize: 12, color: AppColors.danger),
            ),
          ),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 0: Punctual Rules
              _buildPunctualTab(context, config),

              // Tab 1: Recurring Rules
              _buildRecurringTab(context, config),

              // Tab 2: Calendar Preview
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: AvailabilityCalendarPreview(config: config),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPunctualTab(BuildContext context, AvailabilityConfig config) {
    final rules = config.punctualRules;

    if (rules.isEmpty) {
      return _buildEmptyState(
        icon: Icons.event_available,
        title: 'Aucune indisponibilité ponctuelle',
        subtitle:
            'Le véhicule est disponible sans coupure ponctuelle programmée.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: rules.length,
      itemBuilder: (context, index) {
        final rule = rules[index];
        return AvailabilityRuleCard(
          rule: rule,
          isReadOnly: config.isNeverMode,
          onEdit: () {
            AvailabilityRuleFormSheet.show(
              context,
              vehicleId: widget.vehicleId,
              initialRule: rule,
            );
          },
          onDelete: () => _confirmDeleteRule(rule),
        );
      },
    );
  }

  Widget _buildRecurringTab(BuildContext context, AvailabilityConfig config) {
    final rules = config.recurringRules;

    if (rules.isEmpty) {
      return _buildEmptyState(
        icon: Icons.repeat,
        title: 'Aucune indisponibilité récurrente',
        subtitle:
            'Aucun jour fixe de la semaine n\'est bloqué de manière récurrente.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: rules.length,
      itemBuilder: (context, index) {
        final rule = rules[index];
        return AvailabilityRuleCard(
          rule: rule,
          isReadOnly: config.isNeverMode,
          onEdit: () {
            AvailabilityRuleFormSheet.show(
              context,
              vehicleId: widget.vehicleId,
              initialRule: rule,
            );
          },
          onDelete: () => _confirmDeleteRule(rule),
        );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 54,
              color: AppColors.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteRule(AvailabilityRule rule) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer cette règle ?'),
        content: Text(
          'Voulez-vous supprimer cette indisponibilité (${rule.formattedSummary}) ? Le créneau redeviendra immédiatement disponible à la réservation.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final success = await ref
        .read(vehicleAvailabilityControllerProvider(widget.vehicleId).notifier)
        .deleteRule(rule.id, groupId: rule.groupId);

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Règle supprimée avec succès.')),
      );
    }
  }
}

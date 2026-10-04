import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/incident.dart';
import '../controllers/incidents_list_controller.dart';
import '../widgets/incident_status_badge.dart';

class IncidentsListScreen extends ConsumerWidget {
  final int? loanId;
  final int? loanableId;

  const IncidentsListScreen({
    super.key,
    this.loanId,
    this.loanableId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = loanId != null
        ? loanIncidentsListProvider(loanId!)
        : (loanableId != null
            ? vehicleIncidentsListProvider(loanableId!)
            : incidentsListControllerProvider);

    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Signalements & Incidents'),
      ),
      floatingActionButton: loanableId != null
          ? FloatingActionButton.extended(
              key: const Key('report_incident_fab'),
              onPressed: () => context.push(
                AppRoutes.incidentReportPath(
                  loanableId: loanableId!,
                  loanId: loanId,
                ),
              ),
              icon: const Icon(Icons.add_alert_rounded),
              label: const Text('Signaler'),
            )
          : null,
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Tous'),
                  selected: state.filterStatus == null || state.filterStatus!.isEmpty,
                  onSelected: (_) => notifier.setFilter(null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('En cours'),
                  selected: state.filterStatus == 'in_process',
                  onSelected: (_) => notifier.setFilter('in_process'),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Résolus'),
                  selected: state.filterStatus == 'completed',
                  onSelected: (_) => notifier.setFilter('completed'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // List content
          Expanded(
            child: Builder(
              builder: (context) {
                if (state.isLoading && state.incidents.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.errorMessage != null && state.incidents.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
                          const SizedBox(height: 8),
                          Text(
                            state.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.danger),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => notifier.loadIncidents(),
                            child: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final list = state.filteredIncidents;
                if (list.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          const Text(
                            'Aucun incident signalé.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => notifier.loadIncidents(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final incident = list[index];
                      return _IncidentCard(incident: incident);
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
}

class _IncidentCard extends StatelessWidget {
  final Incident incident;

  const _IncidentCard({required this.incident});

  @override
  Widget build(BuildContext context) {
    final category = incident.category;
    final dateStr = incident.createdAt != null
        ? '${incident.createdAt!.day.toString().padLeft(2, '0')}/${incident.createdAt!.month.toString().padLeft(2, '0')}/${incident.createdAt!.year}'
        : '';

    return InkWell(
      onTap: () {
        context.push(Routes.incidentDetail(incident.id));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(category.icon, color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    category.label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                IncidentStatusBadge(incident: incident),
              ],
            ),
            const SizedBox(height: 8),
            if (incident.cleanComments.isNotEmpty)
              Text(
                incident.cleanComments,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (incident.loanableName != null) ...[
                  const Icon(Icons.directions_car_outlined, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    incident.loanableName!,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                ],
                if (dateStr.isNotEmpty) ...[
                  const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    dateStr,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
                const Spacer(),
                const Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

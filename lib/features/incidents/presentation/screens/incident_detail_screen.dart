import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../loanables/domain/entities/loanable_image.dart';
import '../../../loanables/presentation/widgets/loanable_image_widget.dart';
import '../controllers/incident_detail_controller.dart';
import '../widgets/add_note_dialog.dart';
import '../widgets/incident_notes_timeline.dart';
import '../widgets/incident_status_badge.dart';

class IncidentDetailScreen extends ConsumerWidget {
  final int incidentId;

  const IncidentDetailScreen({super.key, required this.incidentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(incidentDetailControllerProvider(incidentId));
    final notifier = ref.read(incidentDetailControllerProvider(incidentId).notifier);

    final authState = ref.watch(authControllerProvider);
    final currentUser = authState.value;
    final currentUserId = currentUser?.id ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détail du signalement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: state.isLoading ? null : () => notifier.loadIncident(),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.isLoading && state.incident == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.errorMessage != null && state.incident == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.danger, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.danger),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => notifier.loadIncident(),
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          final incident = state.incident;
          if (incident == null) {
            return const Center(child: Text('Incident introuvable.'));
          }

          final category = incident.category;
          final canResolve = incident.canResolve(currentUserId);

          return RefreshIndicator(
            onRefresh: () => notifier.loadIncident(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Status Header Card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(category.icon, color: AppColors.primary, size: 28),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  category.label,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              IncidentStatusBadge(incident: incident),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (incident.createdAt != null)
                            Text(
                              'Signalé le ${incident.createdAt!.day.toString().padLeft(2, '0')}/${incident.createdAt!.month.toString().padLeft(2, '0')}/${incident.createdAt!.year} par ${incident.reportedByUserName ?? 'un utilisateur'}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          if (incident.isBlocking && incident.blockingUntil != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.danger.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.block, size: 16, color: AppColors.danger),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'Véhicule bloqué jusqu\'au ${incident.blockingUntil!.day.toString().padLeft(2, '0')}/${incident.blockingUntil!.month.toString().padLeft(2, '0')}/${incident.blockingUntil!.year} à ${incident.blockingUntil!.hour.toString().padLeft(2, '0')}:${incident.blockingUntil!.minute.toString().padLeft(2, '0')}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.danger,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Vehicle & Loan Info
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informations associées',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          if (incident.loanableName != null)
                            _buildInfoRow(
                              Icons.directions_car_outlined,
                              'Véhicule',
                              incident.loanableName!,
                            ),
                          if (incident.loanId != null)
                            _buildInfoRow(
                              Icons.bookmark_outline,
                              'Réservation liée',
                              '#${incident.loanId}',
                            ),
                          if (incident.assigneeName != null)
                            _buildInfoRow(
                              Icons.assignment_ind_outlined,
                              'Assigné à',
                              incident.assigneeName!,
                            ),
                          if (incident.resolvedByUserName != null)
                            _buildInfoRow(
                              Icons.check_circle_outline,
                              'Résolu par',
                              incident.resolvedByUserName!,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description & Proofs
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          if (incident.detailsHidden)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.lock_outline, size: 18, color: AppColors.textSecondary),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Les commentaires détaillés sont réservés aux gestionnaires et parties prenantes directes.',
                                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else ...[
                            Text(
                              incident.cleanComments.isNotEmpty
                                  ? incident.cleanComments
                                  : 'Aucune description textuelle.',
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (incident.photos.isNotEmpty || incident.photoImageIds.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              const Divider(),
                              const SizedBox(height: 8),
                              Text(
                                'Preuves photographiques (${incident.photos.isNotEmpty ? incident.photos.length : incident.photoImageIds.length}) :',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                height: 100,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: incident.photos.isNotEmpty
                                      ? incident.photos.length
                                      : incident.photoImageIds.length,
                                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final photo = incident.photos.isNotEmpty
                                        ? incident.photos[index]
                                        : LoanableImage(id: incident.photoImageIds[index]);
                                    return GestureDetector(
                                      onTap: () => _showPhotoPreview(context, photo),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Stack(
                                          children: [
                                            LoanableImageWidget(
                                              image: photo,
                                              height: 100,
                                              width: 100,
                                            ),
                                            Positioned(
                                              bottom: 4,
                                              right: 4,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  '#${photo.id}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Resolution button (strictly authorized roles only)
                  if (canResolve) ...[
                    if (incident.isInProcess)
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton.icon(
                          key: const Key('resolve_incident_button'),
                          onPressed: state.isResolving
                              ? null
                              : () => _confirmAndResolve(context, notifier),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: state.isResolving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.check_circle_outline, size: 20),
                          label: const Text(
                            'Marquer comme résolu',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    else if (incident.isCompleted)
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: OutlinedButton.icon(
                          key: const Key('reopen_incident_button'),
                          onPressed: state.isReopening
                              ? null
                              : () async {
                                  final success = await notifier.reopen();
                                  if (context.mounted && success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Incident rouvert.'),
                                      ),
                                    );
                                  }
                                },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.warning,
                            side: const BorderSide(color: AppColors.warning),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: state.isReopening
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.replay_rounded, size: 20),
                          label: const Text(
                            'Rouvrir cet incident',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],

                  // Notes section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notes et suivi (${incident.notes.length})',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (!incident.detailsHidden)
                        TextButton.icon(
                          key: const Key('add_note_button'),
                          onPressed: () {
                            showDialog<bool>(
                              context: context,
                              builder: (ctx) => AddNoteDialog(
                                onAddNote: notifier.addNote,
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_comment_outlined, size: 18),
                          label: const Text('Ajouter une note'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (incident.detailsHidden)
                    const Text(
                      'Les notes d\'échange sont masquées pour des raisons de confidentialité.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    )
                  else
                    IncidentNotesTimeline(notes: incident.notes),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            '$label : ',
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmAndResolve(BuildContext context, IncidentDetailController notifier) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clôturer l\'incident'),
        content: const Text(
          'Confirmez-vous que l\'incident est résolu et que le véhicule peut être utilisé normalement ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            key: const Key('confirm_resolve_button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirmer la résolution'),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed == true) {
        final success = await notifier.resolve();
        if (context.mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Incident marqué comme résolu.'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    });
  }

  void _showPhotoPreview(BuildContext context, LoanableImage photo) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LoanableImageWidget(
                image: photo,
                height: 350,
                width: double.infinity,
              ),
            ),
            IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black54,
                radius: 16,
                child: Icon(Icons.close, color: Colors.white, size: 18),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

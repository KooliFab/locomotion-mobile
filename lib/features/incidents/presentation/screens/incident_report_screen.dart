import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/incident_report_controller.dart';
import '../widgets/emergency_disclaimer_card.dart';
import '../widgets/incident_category_picker.dart';

class IncidentReportScreen extends ConsumerStatefulWidget {
  final int loanableId;
  final String? vehicleName;
  final int? loanId;
  final String? ownerName;
  final String? ownerPhone;
  final String? ownerEmail;

  const IncidentReportScreen({
    super.key,
    required this.loanableId,
    this.vehicleName,
    this.loanId,
    this.ownerName,
    this.ownerPhone,
    this.ownerEmail,
  });

  @override
  ConsumerState<IncidentReportScreen> createState() =>
      _IncidentReportScreenState();
}

class _IncidentReportScreenState extends ConsumerState<IncidentReportScreen> {
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        ref.read(incidentReportControllerProvider.notifier).reset();
      }
    });
    _descriptionController.addListener(() {
      ref
          .read(incidentReportControllerProvider.notifier)
          .setDescription(_descriptionController.text);
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final controller = ref.read(incidentReportControllerProvider.notifier);
    final incident = await controller.submit(
      loanableId: widget.loanableId,
      loanId: widget.loanId,
    );

    if (!mounted) return;

    if (incident != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incident signalé avec succès.'),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate to incident detail if route exists, or pop back
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
      } else {
        try {
          context.go(Routes.incidentDetail(incident.id));
        } catch (_) {}
      }
    }
  }

  Future<void> _handleReconcile() async {
    final notifier = ref.read(incidentReportControllerProvider.notifier);
    final incident = await notifier.reconcile(
      loanableId: widget.loanableId,
      loanId: widget.loanId,
    );
    if (!mounted) return;

    if (incident != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signalement réconcilié avec succès.'),
          backgroundColor: AppColors.success,
        ),
      );
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
      } else {
        try {
          context.go(Routes.incidentDetail(incident.id));
        } catch (_) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(incidentReportControllerProvider);
    final notifier = ref.read(incidentReportControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Signaler un incident')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Context card
            Container(
              key: const Key('incident_context_card'),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.directions_car_outlined,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.vehicleName != null)
                          Text(
                            widget.vehicleName!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        if (widget.loanId != null)
                          Text(
                            'Réservation #${widget.loanId}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Emergency disclaimer
            EmergencyDisclaimerCard(
              ownerName: widget.ownerName,
              ownerPhone: widget.ownerPhone,
              ownerEmail: widget.ownerEmail,
            ),
            const SizedBox(height: 20),

            // Category picker
            IncidentCategoryPicker(
              key: const Key('incident_category_picker'),
              selectedCategory: state.selectedCategory,
              onCategorySelected: notifier.setCategory,
            ),
            const SizedBox(height: 16),

            // Description field
            Text(
              'Description de l\'incident *',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            TextField(
              key: const Key('incident_description_field'),
              controller: _descriptionController,
              maxLines: 4,
              enabled: !state.isSubmitting,
              decoration: InputDecoration(
                hintText:
                    'Décrivez précisément ce qui s\'est passé, les dégâts ou le retard estimé...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                helperText:
                    '${state.description.trim().length} / 10 caractères minimum',
                helperStyle: TextStyle(
                  color: state.description.trim().length < 10
                      ? AppColors.textSecondary
                      : AppColors.success,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Safety confirmation checkbox
            if (state.selectedCategory != null &&
                state.selectedCategory!.requiresSafetyDisclaimer) ...[
              Material(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: CheckboxListTile(
                    key: const Key('safety_disclaimer_checkbox'),
                    value: state.safetyAcknowledged,
                    onChanged: state.isSubmitting
                        ? null
                        : (val) => notifier.setSafetyAcknowledged(val ?? false),
                    title: const Text(
                      'J\'atteste être en sécurité et que les secours ont été prévenus si la situation l\'exige.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Reconciliation / Unknown result display
            if (state.hasUnknownResult) ...[
              Container(
                key: const Key('incident_reconcile_card'),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade400),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.amber.shade800,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Délai dépassé : le serveur a peut-être reçu votre signalement.',
                            style: TextStyle(
                              color: Colors.amber.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Pour éviter la création d\'un signalement en double, veuillez vérifier le statut avant de renvoyer.',
                      style: TextStyle(
                        color: Colors.amber.shade900,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        key: const Key('reconcile_incident_button'),
                        onPressed: state.isReconciling
                            ? null
                            : _handleReconcile,
                        icon: state.isReconciling
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.sync, size: 16),
                        label: const Text('Vérifier et réconcilier'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ] else if (state.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.danger),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.danger,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage!,
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                key: const Key('submit_incident_button'),
                onPressed: state.canSubmit ? _handleSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: state.isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Envoyer le signalement',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

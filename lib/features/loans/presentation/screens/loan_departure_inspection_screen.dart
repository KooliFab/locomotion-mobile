import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/services/inspection_photo_service.dart';
import '../../../../core/services/photo_capture_coordinator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/departure_draft.dart';
import '../../domain/entities/loan.dart';
import '../controllers/loan_departure_controller.dart';
import '../controllers/loans_controller.dart';

class LoanDepartureInspectionScreen extends ConsumerStatefulWidget {
  final int loanId;
  final Loan? initialLoan;

  const LoanDepartureInspectionScreen({
    super.key,
    required this.loanId,
    this.initialLoan,
  });

  @override
  ConsumerState<LoanDepartureInspectionScreen> createState() =>
      _LoanDepartureInspectionScreenState();
}

class _LoanDepartureInspectionScreenState
    extends ConsumerState<LoanDepartureInspectionScreen> {
  final _odometerController = TextEditingController();
  final _damagesController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _odometerController.dispose();
    _damagesController.dispose();
    super.dispose();
  }

  void _syncControllersWithDraft(DepartureDraft draft) {
    if (_odometerController.text.isEmpty && draft.odometerKm != null) {
      _odometerController.text = draft.odometerKm.toString();
    }
    if (_damagesController.text.isEmpty &&
        draft.existingDamagesNotes != null &&
        draft.existingDamagesNotes!.isNotEmpty) {
      _damagesController.text = draft.existingDamagesNotes!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loanAsync = ref.watch(loanDetailProvider(widget.loanId));
    final currentUser = ref.watch(authControllerProvider).value;

    final loan = loanAsync.value ?? widget.initialLoan;
    if (loan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Prise en charge')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final isMotorized = loan.isMotorized;
    final requiresMileage = loan.requiresMileageTracking;

    final state = ref.watch(loanDepartureControllerProvider(widget.loanId));
    final controller = ref.read(
      loanDepartureControllerProvider(widget.loanId).notifier,
    );

    // One-time initialization of the draft
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await controller.initialize(
          userId: currentUser?.id ?? 0,
          loanId: widget.loanId,
          requiresMileage: requiresMileage,
          isMotorized: isMotorized,
          initialOdometer: loan.mileageStart,
        );
        await _recoverLostCapture(
          userId: currentUser?.id,
          requiresMileage: requiresMileage,
          controller: controller,
        );
      });
    }

    // Sync input text controllers once draft is loaded
    if (!state.isLoading) {
      _syncControllersWithDraft(state.draft);
    }

    // React to submission success
    ref.listen<DepartureInspectionState>(
      loanDepartureControllerProvider(widget.loanId),
      (previous, next) {
        if (next.submissionSuccess != null &&
            previous?.submissionSuccess == null) {
          _showSuccessDialog(context, next.submissionSuccess!.sealedHash);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('État des lieux de départ')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Vehicle Instructions & Instructions Card
                  _buildInstructionsCard(loan),
                  const SizedBox(height: 16),

                  // Error / Recovery banner
                  if (state.errorMessage != null) ...[
                    _buildErrorBanner(context, state.errorMessage!, controller),
                    const SizedBox(height: 16),
                  ],

                  // Checklist Section
                  _buildChecklistSection(state.draft, controller, isMotorized),
                  const SizedBox(height: 20),

                  // Odometer & Fuel / Battery Section
                  _buildOdometerAndGaugesSection(
                    state.draft,
                    controller,
                    isMotorized,
                    requiresMileage,
                  ),
                  const SizedBox(height: 20),

                  // Photos Grid
                  _buildPhotosSection(
                    state.draft,
                    controller,
                    isMotorized,
                    requiresMileage,
                  ),
                  const SizedBox(height: 20),

                  // Existing damages notes
                  _buildExistingDamagesSection(controller, isMotorized),
                  const SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton(
                    key: const Key('submit_departure_button'),
                    onPressed: (state.canSubmit && !state.isSubmitting)
                        ? () => controller.submitDeparture(
                            loanId: widget.loanId,
                            requiresMileage: requiresMileage,
                          )
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: state.isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Confirmer l\'état des lieux de départ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildInstructionsCard(Loan loan) {
    return Card(
      elevation: 0,
      color: AppColors.primary.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  loan.displayLoanableName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Effectuez le tour du véhicule, vérifiez la présence des équipements obligatoires et prenez les photos de départ afin de certifier son état initial.',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner(
    BuildContext context,
    String error,
    LoanDepartureController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red.shade900, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => controller.checkServerStatus(widget.loanId),
                child: const Text('Vérifier le statut du prêt'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistSection(
    DepartureDraft draft,
    LoanDepartureController controller,
    bool isMotorized,
  ) {
    final items = isMotorized
        ? [
            ('key_present', 'Clé physique du véhicule présente'),
            ('insurance_paper_present', 'Documents d\'assurance à bord'),
            ('charging_cable_present', 'Câble de recharge / Accessoires'),
            ('spare_wheel_present', 'Roue de secours / Kit de gonflage'),
          ]
        : [
            ('lock_present', 'Antivol présent et fonctionnel'),
            ('lock_key_present', 'Clé d\'antivol présente'),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Checklist de départ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...items.map((item) {
          final isChecked = draft.checklist[item.$1] ?? false;
          return CheckboxListTile(
            key: Key('checklist_${item.$1}'),
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(item.$2, style: const TextStyle(fontSize: 14)),
            value: isChecked,
            onChanged: (val) {
              controller.toggleChecklistItem(
                item.$1,
                val ?? false,
                isMotorized,
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildOdometerAndGaugesSection(
    DepartureDraft draft,
    LoanDepartureController controller,
    bool isMotorized,
    bool requiresMileage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Relevé du véhicule',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),

        if (requiresMileage) ...[
          TextField(
            key: const Key('odometer_input'),
            controller: _odometerController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Compteur kilométrique (KM) *',
              hintText: 'Ex: 124500',
              suffixText: 'KM',
              border: OutlineInputBorder(),
            ),
            onChanged: (val) {
              final km = int.tryParse(val.trim());
              controller.updateOdometer(km, requiresMileage);
            },
          ),
          const SizedBox(height: 16),
        ],

        // Battery / Fuel Slider
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isMotorized
                  ? 'Niveau de carburant / batterie :'
                  : 'Niveau de batterie (si assistance électrique) :',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              '${draft.fuelBatteryLevelPercent} %',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        Slider(
          key: const Key('battery_fuel_slider'),
          value: draft.fuelBatteryLevelPercent.toDouble(),
          min: 0,
          max: 100,
          divisions: 20,
          label: '${draft.fuelBatteryLevelPercent} %',
          onChanged: (val) =>
              controller.updateFuelBattery(val.toInt(), isMotorized),
        ),
        const SizedBox(height: 8),

        // Cleanliness
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'État de propreté :',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Row(
              children: List.generate(5, (index) {
                final rating = index + 1;
                return IconButton(
                  key: Key('cleanliness_star_$rating'),
                  icon: Icon(
                    rating <= draft.cleanlinessRating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: Colors.amber,
                  ),
                  onPressed: () =>
                      controller.updateCleanliness(rating, isMotorized),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotosSection(
    DepartureDraft draft,
    LoanDepartureController controller,
    bool isMotorized,
    bool requiresMileage,
  ) {
    final photoSlots = isMotorized
        ? [
            if (requiresMileage)
              ('dashboard_odometer', 'Tableau de bord (Compteur) *'),
            ('front', 'Face avant *'),
            ('back', 'Face arrière *'),
            ('left_side', 'Côté gauche *'),
            ('right_side', 'Côté droit *'),
          ]
        : [
            ('front', 'Vue générale du véhicule *'),
            ('back', 'Détail antivol / accessoires'),
            if (requiresMileage)
              ('dashboard_odometer', 'Tableau de bord (Compteur) *'),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '3. Photos de preuve',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        const Text(
          'Chaque photo est compressée et certifiée. Les uploads interrompus sont repris sans re-téléversement.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: photoSlots.map((slot) {
            final entry = draft.photos[slot.$1];
            return _buildPhotoTile(
              field: slot.$1,
              label: slot.$2,
              entry: entry,
              controller: controller,
              isMotorized: isMotorized,
              requiresMileage: requiresMileage,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPhotoTile({
    required String field,
    required String label,
    required DraftPhotoEntry? entry,
    required LoanDepartureController controller,
    required bool isMotorized,
    required bool requiresMileage,
  }) {
    final status = entry?.status ?? DraftPhotoStatus.notTaken;
    final isUploaded = status == DraftPhotoStatus.uploaded;
    final isUploading = status == DraftPhotoStatus.uploading;
    final isError = status == DraftPhotoStatus.error;

    return Container(
      width: (MediaQuery.of(context).size.width - 44) / 2,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isUploaded
              ? Colors.green.shade400
              : isError
              ? Colors.red.shade300
              : Colors.grey.shade300,
          width: isUploaded ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          // Tile Body
          if (isUploading) ...[
            const SizedBox(
              height: 48,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            const SizedBox(height: 4),
            const Text(
              'Envoi...',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ] else if (isUploaded) ...[
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 32,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Validée',
              style: TextStyle(
                fontSize: 11,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ] else if (isError) ...[
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
                size: 32,
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => controller.retryUpload(
                field: field,
                requiresMileage: requiresMileage,
              ),
              child: const Text('Réessayer', style: TextStyle(fontSize: 11)),
            ),
          ] else ...[
            IconButton.filledTonal(
              key: Key('photo_button_$field'),
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () =>
                  _pickPhoto(field, isMotorized, requiresMileage, controller),
            ),
            const SizedBox(height: 4),
            const Text(
              'Prendre photo',
              style: TextStyle(fontSize: 11, color: Colors.black54),
            ),
          ],
        ],
      ),
    );
  }

  /// Re-attaches a photo captured right before Android destroyed the activity.
  Future<void> _recoverLostCapture({
    required int? userId,
    required bool requiresMileage,
    required LoanDepartureController controller,
  }) async {
    if (userId == null || !mounted) return;
    final recovered = await ref
        .read(photoCaptureCoordinatorProvider)
        .recover(
          userId: userId,
          loanId: widget.loanId,
          phase: PhotoCapturePhase.departure,
        );
    if (recovered == null || !mounted) return;

    final file = recovered.file;
    if (file != null) {
      await controller.attachAndUploadPhoto(
        field: recovered.context.field,
        file: file,
        requiresMileage: recovered.context.requiresMileage,
      );
    } else if (recovered.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(recovered.errorMessage!),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  Future<void> _pickPhoto(
    String field,
    bool isMotorized,
    bool requiresMileage,
    LoanDepartureController controller,
  ) async {
    final coordinator = ref.read(photoCaptureCoordinatorProvider);
    final userId = ref.read(authControllerProvider).value?.id;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Prendre une photo (Appareil)'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choisir depuis la galerie'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final result = userId == null
        ? await ref
              .read(inspectionPhotoServiceProvider)
              .capturePhoto(source: source)
        : await coordinator.capture(
            context: PendingPhotoCapture(
              userId: userId,
              loanId: widget.loanId,
              phase: PhotoCapturePhase.departure,
              field: field,
              requiresMileage: requiresMileage,
              startedAt: DateTime.now(),
            ),
            source: source,
          );
    if (!mounted) return;

    switch (result) {
      case PhotoCaptureSuccess(:final file):
        await controller.attachAndUploadPhoto(
          field: field,
          file: file,
          requiresMileage: requiresMileage,
        );
      case PhotoCapturePermissionDenied():
        _showPermissionDeniedDialog();
      case PhotoCaptureFailure(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red.shade700,
          ),
        );
      case PhotoCaptureCancelled():
        break;
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permission caméra requise'),
        content: const Text(
          'L\'accès à l\'appareil photo est nécessaire pour capturer les photos de l\'état des lieux. Veuillez autoriser l\'accès dans les paramètres de votre appareil.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              AppSettings.openAppSettings();
            },
            child: const Text('Ouvrir les paramètres'),
          ),
        ],
      ),
    );
  }

  Widget _buildExistingDamagesSection(
    LoanDepartureController controller,
    bool isMotorized,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '4. Dommages existants (optionnel)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          key: const Key('damages_input'),
          controller: _damagesController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText:
                'Notez ici toute rayure, accroc ou dommage préexistant...',
            border: OutlineInputBorder(),
          ),
          onChanged: (val) {
            controller.updateExistingDamages(val.trim(), isMotorized);
          },
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context, String? sealedHash) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Prise en charge validée'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'L\'état des lieux de départ a été scellé et enregistré avec succès. Votre prêt est désormais en cours !',
            ),
            if (sealedHash != null && sealedHash.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Empreinte de scellement (SHA-256) :\n${sealedHash.substring(0, 16)}...',
                style: const TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.loanDetailPath(widget.loanId));
            },
            child: const Text('Accéder au prêt en cours'),
          ),
        ],
      ),
    );
  }
}

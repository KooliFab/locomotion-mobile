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
import '../../domain/entities/return_draft.dart';
import '../controllers/loan_return_controller.dart';
import '../controllers/loans_controller.dart';

class LoanReturnInspectionScreen extends ConsumerStatefulWidget {
  final int loanId;
  final Loan? initialLoan;

  const LoanReturnInspectionScreen({
    super.key,
    required this.loanId,
    this.initialLoan,
  });

  @override
  ConsumerState<LoanReturnInspectionScreen> createState() =>
      _LoanReturnInspectionScreenState();
}

class _LoanReturnInspectionScreenState
    extends ConsumerState<LoanReturnInspectionScreen> {
  final _odometerController = TextEditingController();
  final _damagesController = TextEditingController();
  final _commentsController = TextEditingController();
  final _signerNameController = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _odometerController.dispose();
    _damagesController.dispose();
    _commentsController.dispose();
    _signerNameController.dispose();
    super.dispose();
  }

  void _syncControllersWithDraft(ReturnDraft draft) {
    if (_odometerController.text.isEmpty && draft.odometerKm != null) {
      _odometerController.text = draft.odometerKm.toString();
    }
    if (_commentsController.text.isEmpty &&
        draft.comments != null &&
        draft.comments!.isNotEmpty) {
      _commentsController.text = draft.comments!;
    }
    if (_signerNameController.text.isEmpty &&
        draft.signerFullName != null &&
        draft.signerFullName!.isNotEmpty) {
      _signerNameController.text = draft.signerFullName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loanAsync = ref.watch(loanDetailProvider(widget.loanId));
    final currentUser = ref.watch(authControllerProvider).value;

    final loan = loanAsync.value ?? widget.initialLoan;
    if (loan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Restitution du véhicule')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final isMotorized = loan.isMotorized;
    final requiresMileage = loan.requiresMileageTracking;
    final mileageStart = loan.mileageStart;

    final state = ref.watch(loanReturnControllerProvider(widget.loanId));
    final controller = ref.read(
      loanReturnControllerProvider(widget.loanId).notifier,
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
          mileageStart: mileageStart,
          initialOdometer: loan.mileageEnd ?? loan.mileageStart,
        );
        await _recoverLostCapture(
          userId: currentUser?.id,
          mileageStart: mileageStart,
          controller: controller,
        );
      });
    }

    if (!state.isLoading) {
      _syncControllersWithDraft(state.draft);
    }

    // React to submission success
    ref.listen<ReturnInspectionState>(
      loanReturnControllerProvider(widget.loanId),
      (previous, next) {
        if (next.submissionSuccess != null &&
            previous?.submissionSuccess == null) {
          _showSuccessDialog(context, next.submissionSuccess!.sealedHash);
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('État des lieux de retour')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Vehicle instructions card
                  _buildInstructionsCard(loan),
                  const SizedBox(height: 16),

                  // Error / Recovery banner
                  if (state.errorMessage != null) ...[
                    _buildErrorBanner(context, state.errorMessage!, controller),
                    const SizedBox(height: 16),
                  ],

                  // 1. Return Checklist
                  _buildChecklistSection(
                    state.draft,
                    controller,
                    isMotorized,
                    requiresMileage,
                    mileageStart,
                  ),
                  const SizedBox(height: 20),

                  // 2. Odometer & Gauges
                  _buildOdometerAndGaugesSection(
                    state.draft,
                    controller,
                    isMotorized,
                    requiresMileage,
                    mileageStart,
                  ),
                  const SizedBox(height: 20),

                  // 3. Photos
                  _buildPhotosSection(
                    state.draft,
                    controller,
                    isMotorized,
                    requiresMileage,
                    mileageStart,
                  ),
                  const SizedBox(height: 20),

                  // 4. New Damages & Comments
                  _buildDamagesAndCommentsSection(
                    state.draft,
                    controller,
                    isMotorized,
                    requiresMileage,
                    mileageStart,
                    loan,
                  ),
                  const SizedBox(height: 20),

                  // 5. Digital Return Signature
                  _buildSignatureSection(
                    state.draft,
                    controller,
                    isMotorized,
                    requiresMileage,
                    mileageStart,
                    '${currentUser?.firstName ?? ''} ${currentUser?.lastName ?? ''}'
                        .trim(),
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton(
                    key: const Key('submit_return_button'),
                    onPressed: (state.canSubmit && !state.isSubmitting)
                        ? () => controller.submitReturn(
                            loanId: widget.loanId,
                            requiresMileage: requiresMileage,
                            mileageStart: mileageStart,
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
                            'Confirmer l\'état des lieux de retour',
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
                const Icon(
                  Icons.assignment_turned_in_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Restitution : ${loan.displayLoanableName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              loan.isMotorized
                  ? 'Relevez le compteur final (>= ${loan.mileageStart ?? 0} km), vérifiez le niveau de carburant/batterie et signalez tout nouvel incident avant signature.'
                  : 'Vérifiez la restitution des clés, l\'antivol et l\'état général du matériel avant signature.',
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner(
    BuildContext context,
    String error,
    LoanReturnController controller,
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
    ReturnDraft draft,
    LoanReturnController controller,
    bool isMotorized,
    bool requiresMileage,
    int? mileageStart,
  ) {
    final items = isMotorized
        ? [
            (
              'key_returned',
              'Clés du véhicule remises au propriétaire / coffre',
            ),
            ('clean_inside', 'Habitacle nettoyé et débarrassé de tout déchet'),
            ('clean_outside', 'Carrosserie propre et vérifiée'),
            ('fuel_battery_level_ok', 'Niveau d\'énergie conforme au contrat'),
          ]
        : [
            ('lock_secured', 'Antivol remis et attaché en lieu sûr'),
            ('key_returned', 'Clé d\'antivol / accessoires restitués'),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Checklist de restitution',
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
                requiresMileage,
                mileageStart,
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildOdometerAndGaugesSection(
    ReturnDraft draft,
    LoanReturnController controller,
    bool isMotorized,
    bool requiresMileage,
    int? mileageStart,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Relevé kilométrique et jauges',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),

        if (requiresMileage) ...[
          TextField(
            key: const Key('odometer_input'),
            controller: _odometerController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Compteur kilométrique de retour (KM) *',
              hintText: mileageStart != null
                  ? 'Ex: ${mileageStart + 50}'
                  : 'Ex: 124500',
              helperText: mileageStart != null
                  ? 'Kilométrage initial : $mileageStart km (doit être >= $mileageStart)'
                  : null,
              suffixText: 'KM',
              border: const OutlineInputBorder(),
            ),
            onChanged: (val) {
              final km = int.tryParse(val.trim());
              controller.updateOdometer(km, requiresMileage, mileageStart);
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
                  ? 'Niveau de carburant / batterie restant :'
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
          onChanged: (val) => controller.updateFuelBattery(
            val.toInt(),
            requiresMileage,
            mileageStart,
          ),
        ),
        const SizedBox(height: 8),

        // Cleanliness
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'État de propreté au retour :',
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
                  onPressed: () => controller.updateCleanliness(
                    rating,
                    requiresMileage,
                    mileageStart,
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhotosSection(
    ReturnDraft draft,
    LoanReturnController controller,
    bool isMotorized,
    bool requiresMileage,
    int? mileageStart,
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
          '3. Photos de clôture',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        const Text(
          'Prenez les photos attestant de l\'état du véhicule au retour. Chaque photo est horodatée et scellée numériquement (SHA-256).',
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
              mileageStart: mileageStart,
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
    required LoanReturnController controller,
    required bool isMotorized,
    required bool requiresMileage,
    required int? mileageStart,
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
                mileageStart: mileageStart,
              ),
              child: const Text('Réessayer', style: TextStyle(fontSize: 11)),
            ),
          ] else ...[
            IconButton.filledTonal(
              key: Key('photo_button_$field'),
              icon: const Icon(Icons.camera_alt_outlined),
              onPressed: () => _pickPhoto(
                field: field,
                isMotorized: isMotorized,
                requiresMileage: requiresMileage,
                mileageStart: mileageStart,
                controller: controller,
              ),
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

  Widget _buildDamagesAndCommentsSection(
    ReturnDraft draft,
    LoanReturnController controller,
    bool isMotorized,
    bool requiresMileage,
    int? mileageStart,
    Loan loan,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '4. Incident ou dommage survenu',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          key: const Key('new_damages_switch'),
          contentPadding: EdgeInsets.zero,
          title: const Text('Signaler de nouveaux dommages ou incidents'),
          subtitle: const Text(
            'Activez si un impact, une rayure ou une anomalie est apparu pendant le trajet.',
            style: TextStyle(fontSize: 12),
          ),
          value: draft.newDamagesDeclared,
          onChanged: (val) {
            controller.toggleNewDamages(val, requiresMileage, mileageStart);
          },
        ),
        if (draft.newDamagesDeclared && loan.loanableId != null) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            key: const Key('open_detailed_incident_report_button'),
            onPressed: () {
              context.push(
                AppRoutes.incidentReportPath(
                  loanableId: loan.loanableId!,
                  vehicleName: loan.loanableName,
                  loanId: loan.id,
                  ownerName: loan.ownerUserName,
                  ownerPhone: loan.ownerUserPhone,
                  ownerEmail: loan.ownerUserEmail,
                ),
              );
            },
            icon: const Icon(Icons.assignment_late_outlined, size: 18),
            label: const Text('Ouvrir un signalement d\'incident détaillé'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.warning,
              side: const BorderSide(color: AppColors.warning),
            ),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 8),
        TextField(
          key: const Key('comments_input'),
          controller: _commentsController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Commentaires de retour (optionnel)',
            hintText: 'Observations, remarques ou détails sur le trajet...',
            border: OutlineInputBorder(),
          ),
          onChanged: (val) {
            controller.updateComments(val, requiresMileage, mileageStart);
          },
        ),
      ],
    );
  }

  Widget _buildSignatureSection(
    ReturnDraft draft,
    LoanReturnController controller,
    bool isMotorized,
    bool requiresMileage,
    int? mileageStart,
    String? currentUserName,
  ) {
    final signatureEntry = draft.signaturePhoto;
    final isUploaded = signatureEntry?.status == DraftPhotoStatus.uploaded;
    final isUploading = signatureEntry?.status == DraftPhotoStatus.uploading;
    final isError = signatureEntry?.status == DraftPhotoStatus.error;

    return Card(
      key: const Key('return_signature_card'),
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.draw_outlined, color: AppColors.primary),
                SizedBox(width: 8),
                Text(
                  '5. Signature contradictoire de retour',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'En signant, vous attestez sur l\'honneur de l\'exactitude des relevés et des photos fournis.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              key: const Key('signer_name_input'),
              controller: _signerNameController,
              decoration: const InputDecoration(
                labelText: 'Nom et prénom du signataire',
                hintText: 'Ex: Jean Dupont',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                controller.updateSignerFullName(
                  val,
                  requiresMileage,
                  mileageStart,
                );
              },
            ),
            const SizedBox(height: 16),

            // Signature capture tile
            Row(
              children: [
                if (isUploading) ...[
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  const Text('Téléversement de la signature...'),
                ] else if (isUploaded) ...[
                  const Icon(Icons.check_circle, color: Colors.green, size: 28),
                  const SizedBox(width: 10),
                  const Text(
                    'Signature enregistrée',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => controller.removePhoto(
                      'return_signature',
                      requiresMileage,
                      mileageStart,
                    ),
                    child: const Text('Remplacer'),
                  ),
                ] else if (isError) ...[
                  const Icon(Icons.error_outline, color: Colors.red, size: 28),
                  const SizedBox(width: 10),
                  const Text('Échec du téléversement'),
                  const Spacer(),
                  TextButton(
                    onPressed: () => controller.retryUpload(
                      field: 'return_signature',
                      requiresMileage: requiresMileage,
                      mileageStart: mileageStart,
                    ),
                    child: const Text('Réessayer'),
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    key: const Key('return_signature_button'),
                    onPressed: () => _pickPhoto(
                      field: 'return_signature',
                      isMotorized: isMotorized,
                      requiresMileage: requiresMileage,
                      mileageStart: mileageStart,
                      controller: controller,
                    ),
                    icon: const Icon(Icons.draw, size: 18),
                    label: const Text('Joindre signature'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Re-attaches a photo captured right before Android destroyed the activity.
  Future<void> _recoverLostCapture({
    required int? userId,
    required int? mileageStart,
    required LoanReturnController controller,
  }) async {
    if (userId == null || !mounted) return;
    final recovered = await ref
        .read(photoCaptureCoordinatorProvider)
        .recover(
          userId: userId,
          loanId: widget.loanId,
          phase: PhotoCapturePhase.returnInspection,
        );
    if (recovered == null || !mounted) return;

    final file = recovered.file;
    if (file != null) {
      final captureContext = recovered.context;
      if (captureContext.field == 'return_signature') {
        await controller.attachAndUploadSignature(
          file: file,
          requiresMileage: captureContext.requiresMileage,
          mileageStart: mileageStart,
        );
      } else {
        await controller.attachAndUploadPhoto(
          field: captureContext.field,
          file: file,
          requiresMileage: captureContext.requiresMileage,
          mileageStart: mileageStart,
        );
      }
    } else if (recovered.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(recovered.errorMessage!)));
    }
  }

  Future<void> _pickPhoto({
    required String field,
    required bool isMotorized,
    required bool requiresMileage,
    required int? mileageStart,
    required LoanReturnController controller,
  }) async {
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
              phase: PhotoCapturePhase.returnInspection,
              field: field,
              requiresMileage: requiresMileage,
              startedAt: DateTime.now(),
            ),
            source: source,
          );
    if (!mounted) return;

    switch (result) {
      case PhotoCaptureSuccess(:final file):
        if (field == 'return_signature') {
          await controller.attachAndUploadSignature(
            file: file,
            requiresMileage: requiresMileage,
            mileageStart: mileageStart,
          );
        } else {
          await controller.attachAndUploadPhoto(
            field: field,
            file: file,
            requiresMileage: requiresMileage,
            mileageStart: mileageStart,
          );
        }
      case PhotoCapturePermissionDenied(:final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      case PhotoCaptureFailure(:final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      case PhotoCaptureCancelled():
        break;
    }
  }

  void _showSuccessDialog(BuildContext context, String? sealedHash) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        key: const Key('return_inspection_success_dialog'),
        icon: const Icon(Icons.verified_rounded, color: Colors.green, size: 48),
        title: const Text('Véhicule restitué !'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'L\'état des lieux de retour a été certifié avec succès.',
              style: TextStyle(fontSize: 14),
            ),
            if (sealedHash != null && sealedHash.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Empreinte de scellement LCCJTI :',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sealedHash,
                      style: const TextStyle(
                        fontSize: 9,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            key: const Key('return_success_ok_button'),
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.loanDetailPath(widget.loanId));
            },
            child: const Text('Voir le dossier du prêt'),
          ),
        ],
      ),
    );
  }
}

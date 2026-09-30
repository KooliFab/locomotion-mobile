import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../loanables/domain/entities/loanable.dart';
import '../../../loanables/domain/entities/vehicle_local_dates.dart';
import '../../domain/entities/loan_draft.dart';
import '../../domain/entities/transport_alternative.dart';
import '../controllers/loan_creation_controller.dart';
import '../controllers/loan_creation_state.dart';

class LoanReservationScreen extends ConsumerStatefulWidget {
  final Loanable loanable;

  const LoanReservationScreen({super.key, required this.loanable});

  @override
  ConsumerState<LoanReservationScreen> createState() =>
      _LoanReservationScreenState();
}

class _LoanReservationScreenState extends ConsumerState<LoanReservationScreen> {
  late final LoanDraft _initialDraft;
  late final TextEditingController _distanceController;
  late final TextEditingController _alternativeOtherController;
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    final todayYmd = VehicleLocalDates.nowYmdInZone(widget.loanable.timezone);
    _initialDraft = LoanDraft(
      loanableId: widget.loanable.id,
      loanableName: widget.loanable.name,
      loanableType: widget.loanable.type,
      communityId: widget.loanable.communityId,
      communityName: widget.loanable.communityName,
      vehicleTimezone: widget.loanable.timezone,
      minLoanDurationInMinutes: widget.loanable.minLoanDurationInMinutes,
      maxLoanDurationInMinutes: widget.loanable.maxLoanDurationInMinutes,
      departureDate: todayYmd,
      departureTime: '10:00',
      durationInMinutes: widget.loanable.minLoanDurationInMinutes ?? 60,
    );

    _distanceController = TextEditingController();
    _alternativeOtherController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _distanceController.dispose();
    _alternativeOtherController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loanCreationControllerProvider(_initialDraft));
    final controller = ref.read(
      loanCreationControllerProvider(_initialDraft).notifier,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Réserver un véhicule')),
      body: SafeArea(
        child: Column(
          children: [
            _buildStepper(state.currentStep),
            if (state.generalError != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.danger,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.generalError!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (state.availabilityConflictMessage != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.availabilityConflictMessage!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: switch (state.currentStep) {
                  0 => _buildStepSchedule(state, controller),
                  1 => _buildStepTripDetails(state, controller),
                  2 => _buildStepSummary(state, controller),
                  _ => const SizedBox.shrink(),
                },
              ),
            ),
            _buildBottomBar(state, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper(int currentStep) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _stepIndicator(0, 'Créneau', currentStep),
          _stepDivider(currentStep > 0),
          _stepIndicator(1, 'Détails', currentStep),
          _stepDivider(currentStep > 1),
          _stepIndicator(2, 'Résumé', currentStep),
        ],
      ),
    );
  }

  Widget _stepIndicator(int stepIndex, String title, int currentStep) {
    final isActive = currentStep == stepIndex;
    final isDone = currentStep > stepIndex;

    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isDone
              ? AppColors.primary
              : (isActive ? AppColors.primaryDark : AppColors.border),
          child: isDone
              ? const Icon(Icons.check, size: 14, color: Colors.white)
              : Text(
                  '${stepIndex + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.white : AppColors.textMuted,
                  ),
                ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _stepDivider(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: active ? AppColors.primary : AppColors.border,
      ),
    );
  }

  // --- Step 0: Schedule ---
  Widget _buildStepSchedule(
    LoanCreationState state,
    LoanCreationController controller,
  ) {
    final draft = state.draft;
    final timezone = draft.vehicleTimezone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.loanable.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (timezone != null) ...[
          const SizedBox(height: 4),
          Text(
            'Fuseau horaire du véhicule : $timezone',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
        const SizedBox(height: 20),

        // Date selector
        const Text(
          'Date de départ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          key: const Key('departure_date_picker_button'),
          onTap: () async {
            final nowNaive = VehicleLocalDates.nowYmdInZone(
              draft.vehicleTimezone,
            );
            final parts = (draft.departureDate ?? nowNaive).split('-');
            final initialDate = DateTime.utc(
              int.parse(parts[0]),
              int.parse(parts[1]),
              int.parse(parts[2]),
            );

            final nowParts = nowNaive.split('-');
            final firstDate = DateTime.utc(
              int.parse(nowParts[0]),
              int.parse(nowParts[1]),
              int.parse(nowParts[2]),
            );
            final lastDate = firstDate.add(const Duration(days: 90));

            final picked = await showDatePicker(
              context: context,
              initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
              firstDate: firstDate,
              lastDate: lastDate,
            );
            if (picked != null) {
              controller.updateDepartureDate(
                VehicleLocalDates.formatYmd(picked),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: state.fieldErrors?['departure_at'] != null
                    ? AppColors.danger
                    : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  draft.departureDate != null
                      ? VehicleLocalDates.shortLabel(draft.departureDate!)
                      : 'Sélectionner une date',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Icon(
                  Icons.calendar_month_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
        if (state.fieldErrors?['departure_at'] != null) ...[
          const SizedBox(height: 4),
          Text(
            state.fieldErrors!['departure_at']!,
            style: const TextStyle(fontSize: 12, color: AppColors.danger),
          ),
        ],

        const SizedBox(height: 18),

        // Time selector
        const Text(
          'Heure de départ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          key: const Key('departure_time_picker_button'),
          onTap: () async {
            final timeParts = (draft.departureTime ?? '10:00').split(':');
            final initialTime = TimeOfDay(
              hour: int.tryParse(timeParts[0]) ?? 10,
              minute: int.tryParse(timeParts[1]) ?? 0,
            );

            final picked = await showTimePicker(
              context: context,
              initialTime: initialTime,
            );
            if (picked != null) {
              final h = picked.hour.toString().padLeft(2, '0');
              final m = picked.minute.toString().padLeft(2, '0');
              controller.updateDepartureTime('$h:$m');
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  draft.departureTime ?? 'Sélectionner une heure',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Icon(
                  Icons.access_time_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        // Duration selector
        const Text(
          'Durée de la réservation',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          key: const Key('duration_dropdown'),
          initialValue: draft.durationInMinutes,
          decoration: InputDecoration(
            errorText: state.fieldErrors?['duration_in_minutes'],
          ),
          items: _buildDurationItems(
            minMinutes: draft.minLoanDurationInMinutes,
            maxMinutes: draft.maxLoanDurationInMinutes,
          ),
          onChanged: (val) {
            if (val != null) controller.updateDuration(val);
          },
        ),
        if (draft.minLoanDurationInMinutes != null ||
            draft.maxLoanDurationInMinutes != null) ...[
          const SizedBox(height: 6),
          Text(
            'Contraintes du véhicule : '
            '${draft.minLoanDurationInMinutes != null ? "min ${draft.minLoanDurationInMinutes} min" : ""}'
            '${draft.minLoanDurationInMinutes != null && draft.maxLoanDurationInMinutes != null ? " / " : ""}'
            '${draft.maxLoanDurationInMinutes != null ? "max ${draft.maxLoanDurationInMinutes} min" : ""}',
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
        ],
      ],
    );
  }

  List<DropdownMenuItem<int>> _buildDurationItems({
    int? minMinutes,
    int? maxMinutes,
  }) {
    final candidateDurations = [
      30,
      60,
      90,
      120,
      180,
      240,
      360,
      480,
      720,
      1440,
      2880,
    ];

    final filtered = candidateDurations.where((d) {
      if (minMinutes != null && d < minMinutes) return false;
      if (maxMinutes != null && d > maxMinutes) return false;
      return true;
    }).toList();

    if (minMinutes != null && !filtered.contains(minMinutes)) {
      filtered.insert(0, minMinutes);
      filtered.sort();
    }

    return filtered.map((d) {
      String label;
      if (d < 60) {
        label = '$d minutes';
      } else if (d % 60 == 0) {
        final hours = d ~/ 60;
        label = hours >= 24
            ? '${hours ~/ 24} jour${hours ~/ 24 > 1 ? "s" : ""}'
            : '$hours heure${hours > 1 ? "s" : ""}';
      } else {
        label = '${d ~/ 60}h ${(d % 60).toString().padLeft(2, "0")}';
      }
      return DropdownMenuItem<int>(value: d, child: Text(label));
    }).toList();
  }

  // --- Step 1: Trip Details ---
  Widget _buildStepTripDetails(
    LoanCreationState state,
    LoanCreationController controller,
  ) {
    final draft = state.draft;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Détails du déplacement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        // Estimated distance
        AppTextField(
          key: const Key('estimated_distance_input'),
          label: 'Distance estimée (en km)',
          hint: 'Ex: 25',
          keyboardType: TextInputType.number,
          controller: _distanceController,
          onChanged: (val) {
            final parsed = int.tryParse(val.trim());
            if (parsed != null) controller.updateEstimatedDistance(parsed);
          },
        ),
        if (state.fieldErrors?['estimated_distance'] != null) ...[
          const SizedBox(height: 4),
          Text(
            state.fieldErrors!['estimated_distance']!,
            style: const TextStyle(fontSize: 12, color: AppColors.danger),
          ),
        ],

        const SizedBox(height: 18),

        // Transport alternative
        const Text(
          'Mode de transport remplacé',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<TransportAlternative>(
          key: const Key('alternative_to_dropdown'),
          initialValue: draft.alternativeTo,
          hint: const Text('Sélectionnez une option'),
          decoration: InputDecoration(
            errorText: state.fieldErrors?['alternative_to'],
          ),
          items: TransportAlternative.values.map((alt) {
            return DropdownMenuItem<TransportAlternative>(
              value: alt,
              child: Text(alt.label),
            );
          }).toList(),
          onChanged: (val) => controller.updateAlternativeTo(val),
        ),

        // Alternative to other
        if (draft.alternativeTo == TransportAlternative.other) ...[
          const SizedBox(height: 14),
          AppTextField(
            key: const Key('alternative_other_input'),
            label: 'Précisez l\'autre mode',
            hint: 'Ex: Covoiturage, taxi...',
            controller: _alternativeOtherController,
            onChanged: (val) => controller.updateAlternativeToOther(val),
          ),
          if (state.fieldErrors?['alternative_to_other'] != null) ...[
            const SizedBox(height: 4),
            Text(
              state.fieldErrors!['alternative_to_other']!,
              style: const TextStyle(fontSize: 12, color: AppColors.danger),
            ),
          ],
        ],

        const SizedBox(height: 18),

        // Message for owner
        AppTextField(
          key: const Key('message_for_owner_input'),
          label: 'Message pour le propriétaire (facultatif)',
          hint: 'Expliquez brièvement l\'objet de votre déplacement...',
          maxLines: 3,
          controller: _messageController,
          onChanged: (val) => controller.updateMessageForOwner(val),
        ),
      ],
    );
  }

  // --- Step 2: Summary ---
  Widget _buildStepSummary(
    LoanCreationState state,
    LoanCreationController controller,
  ) {
    final draft = state.draft;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Résumé de votre demande',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Vérifiez attentivement les informations avant d\'envoyer votre demande de réservation.',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 18),

        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.border),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryRow('Véhicule', draft.loanableName, isBold: true),
                if (draft.communityName != null) ...[
                  const SizedBox(height: 8),
                  _summaryRow('Communauté', draft.communityName!),
                ],
                const Divider(height: 24),
                _summaryRow(
                  'Départ',
                  '${draft.departureDate} à ${draft.departureTime}',
                ),
                const SizedBox(height: 8),
                _summaryRow('Durée', '${draft.durationInMinutes} minutes'),
                const SizedBox(height: 8),
                _summaryRow(
                  'Distance estimée',
                  '${draft.estimatedDistance} km',
                ),
                const SizedBox(height: 8),
                _summaryRow('Mode remplacé', draft.alternativeTo?.label ?? '—'),
                if (draft.alternativeTo == TransportAlternative.other &&
                    draft.alternativeToOther != null) ...[
                  const SizedBox(height: 8),
                  _summaryRow('Précision', draft.alternativeToOther!),
                ],
                if (draft.messageForOwner != null &&
                    draft.messageForOwner!.trim().isNotEmpty) ...[
                  const Divider(height: 24),
                  const Text(
                    'Message au propriétaire :',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    draft.messageForOwner!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // --- Bottom Navigation & Submit Bar ---
  Widget _buildBottomBar(
    LoanCreationState state,
    LoanCreationController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (state.currentStep > 0)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: AppButton(
                  key: const Key('previous_step_button'),
                  text: 'Précédent',
                  variant: AppButtonVariant.outline,
                  onPressed: state.isSubmitting || state.isCheckingAvailability
                      ? null
                      : () => controller.goToStep(state.currentStep - 1),
                ),
              ),
            ),
          Expanded(
            child: switch (state.currentStep) {
              0 => AppButton(
                key: const Key('next_step_button'),
                text: 'Suivant',
                isLoading: state.isCheckingAvailability,
                onPressed: state.isCheckingAvailability || state.isSubmitting
                    ? null
                    : () => controller.goToTripDetailsStep(),
              ),
              1 => AppButton(
                key: const Key('next_step_button'),
                text: 'Vérifier',
                onPressed: state.isCheckingAvailability || state.isSubmitting
                    ? null
                    : () => controller.goToSummaryStep(),
              ),
              2 => AppButton(
                key: const Key('submit_reservation_button'),
                text: 'Envoyer la demande',
                isLoading: state.isSubmitting,
                onPressed: state.isSubmitting || state.isCheckingAvailability
                    ? null
                    : () async {
                        final created = await controller.submitReservation();
                        if (created != null && mounted) {
                          context.go(
                            AppRoutes.loanSuccessPath(created.id),
                            extra: created,
                          );
                        }
                      },
              ),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }
}

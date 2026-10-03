import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/error/exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../loanables/domain/entities/vehicle_local_dates.dart';
import '../../domain/entities/extension_estimate.dart';
import '../../domain/entities/loan.dart';
import '../controllers/loans_controller.dart';

class LoanExtensionBottomSheet extends ConsumerStatefulWidget {
  final Loan loan;

  const LoanExtensionBottomSheet({
    super.key,
    required this.loan,
  });

  static Future<bool?> show(BuildContext context, Loan loan) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => LoanExtensionBottomSheet(loan: loan),
    );
  }

  @override
  ConsumerState<LoanExtensionBottomSheet> createState() =>
      _LoanExtensionBottomSheetState();
}

class _LoanExtensionBottomSheetState
    extends ConsumerState<LoanExtensionBottomSheet> {
  int _additionalMinutes = 60;
  bool _isLoadingEstimate = false;
  ExtensionEstimate? _estimate;
  int? _estimateDuration;
  int _estimateRequestId = 0;
  String? _estimateError;
  bool _isSubmitting = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _fetchEstimate();
  }

  int get _newTotalDuration => widget.loan.durationInMinutes + _additionalMinutes;

  DateTime get _newReturnAt =>
      widget.loan.departureAt.add(Duration(minutes: _newTotalDuration));

  String _formatTimeInZone(DateTime dt, String? timezone) {
    if (timezone != null && timezone.isNotEmpty) {
      try {
        final loc = tz.getLocation(timezone);
        final tzDt = tz.TZDateTime.from(dt, loc);
        final h = tzDt.hour.toString().padLeft(2, '0');
        final m = tzDt.minute.toString().padLeft(2, '0');
        final day = tzDt.day;
        final month = tzDt.month <= 12
            ? VehicleLocalDates.shortMonths[tzDt.month - 1]
            : '';
        return '$day $month à ${h}h$m';
      } catch (_) {}
    }
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final day = dt.day;
    final month =
        dt.month <= 12 ? VehicleLocalDates.shortMonths[dt.month - 1] : '';
    return '$day $month à ${h}h$m';
  }

  Future<void> _fetchEstimate() async {
    final reqId = ++_estimateRequestId;
    final targetDuration = _newTotalDuration;

    setState(() {
      _isLoadingEstimate = true;
      _estimateError = null;
    });

    try {
      final repo = ref.read(loansRepositoryProvider);
      final res = await repo.getExtensionEstimate(
        widget.loan.id,
        targetDuration,
      );
      if (mounted && reqId == _estimateRequestId) {
        setState(() {
          _estimate = res;
          _estimateDuration = targetDuration;
          _isLoadingEstimate = false;
        });
      }
    } catch (e) {
      if (mounted && reqId == _estimateRequestId) {
        setState(() {
          _estimate = null;
          _estimateDuration = null;
          _estimateError = e is AppException ? e.message : e.toString();
          _isLoadingEstimate = false;
        });
      }
    }
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      await ref.read(loanActionsControllerProvider.notifier).requestExtension(
            loanId: widget.loan.id,
            extensionDurationInMinutes: _newTotalDuration,
            loanableId: widget.loan.loanableId,
          );
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _submitError = e is AppException ? e.message : e.toString();
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loan = widget.loan;
    final tzName = loan.loanable?.timezone;
    final currentReturnAt = loan.actualReturnAt ??
        loan.departureAt.add(Duration(minutes: loan.durationInMinutes));

    const quickOptions = [
      (15, '+15 min', Key('chip_extension_15')),
      (30, '+30 min', Key('chip_extension_30')),
      (60, '+1 h', Key('chip_extension_60')),
      (120, '+2 h', Key('chip_extension_120')),
      (240, '+4 h', Key('chip_extension_240')),
      (1440, '+1 jour', Key('chip_extension_1440')),
    ];

    final hasValidEstimate = _estimate != null &&
        _estimateDuration == _newTotalDuration &&
        _estimateError == null;
    final isAvailable = hasValidEstimate && _estimate!.available;
    final canSubmit = isAvailable && !_isLoadingEstimate && !_isSubmitting;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.more_time_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Prolonger la réservation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        loan.displayLoanableName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Current Scheduled Return
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Retour prévu actuellement',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          _formatTimeInZone(currentReturnAt, tzName),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (tzName != null) ...[
                          Text(
                            'Fuseau du véhicule : $tzName',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Additional Duration Selector
            const Text(
              'Ajouter du temps',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: quickOptions.map((opt) {
                final isSelected = _additionalMinutes == opt.$1;
                return ChoiceChip(
                  key: opt.$3,
                  label: Text(opt.$2),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val && _additionalMinutes != opt.$1) {
                      setState(() {
                        _additionalMinutes = opt.$1;
                      });
                      _fetchEstimate();
                    }
                  },
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Projected Time Summary Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.lightTint.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nouveau retour prévu :',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        _formatTimeInZone(_newReturnAt, tzName),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nouvelle durée totale :',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '$_newTotalDuration min (+$_additionalMinutes min)',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Live Estimate & Availability status
            if (_isLoadingEstimate) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Vérification de la disponibilité...',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (_estimateError != null) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _estimateError!,
                  style: const TextStyle(color: AppColors.danger, fontSize: 13),
                ),
              ),
            ] else if (_estimate != null) ...[
              if (_estimate!.available) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Créneau disponible',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                                fontSize: 13,
                              ),
                            ),
                            if (_estimate!.borrowerTotal != null) ...[
                              Builder(
                                builder: (ctx) {
                                  final currentTotal = widget.loan.borrowerTotal;
                                  final newTotal = _estimate!.borrowerTotal!;
                                  final surcharge = currentTotal != null
                                      ? (newTotal - currentTotal)
                                      : null;
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (surcharge != null && surcharge > 0) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          'Supplément prolongation : +${surcharge.toStringAsFixed(2)} \$ CAD',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryDark,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 2),
                                      Text(
                                        'Nouveau total estimé : ${newTotal.toStringAsFixed(2)} \$ (taxes incluses)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: (surcharge != null && surcharge > 0)
                                              ? AppColors.textSecondary
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.dangerBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.danger,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Véhicule non disponible sur ce créneau',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.danger,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_estimate!.blockingLoan != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          'Une réservation suivante commence à ${_formatTimeInZone(_estimate!.blockingLoan!.departureAt ?? _newReturnAt, tzName)}.',
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                        if (_estimate!.blockingLoan!.borrowerPhone != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Contact : ${_estimate!.blockingLoan!.borrowerName ?? 'Emprunteur'} (${_estimate!.blockingLoan!.borrowerPhone})',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ],
              if ((_estimate?.depositExpiresBeforeReturn ?? false) ||
                  (widget.loan.depositExpiresAt != null &&
                      _newReturnAt.isAfter(widget.loan.depositExpiresAt!))) ...[
                const SizedBox(height: 10),
                Container(
                  key: const Key('deposit_expiration_warning_banner'),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warningBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Attention : expiration de caution',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _estimate?.depositWarning ??
                                  ((_estimate?.depositExpiresAt ?? widget.loan.depositExpiresAt) != null
                                      ? 'La nouvelle date de retour (${_formatTimeInZone(_newReturnAt, tzName)}) dépasse la validité de votre caution (prévue jusqu\'au ${_formatTimeInZone((_estimate?.depositExpiresAt ?? widget.loan.depositExpiresAt)!, tzName)}).'
                                      : 'La nouvelle date de retour dépasse la durée de validité de votre caution.'),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],

            if (_submitError != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _submitError!,
                  style: const TextStyle(color: AppColors.danger, fontSize: 13),
                ),
              ),
            ],
            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              key: const Key('confirm_extension_button'),
              onPressed: canSubmit ? _handleSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      loan.isSelfService
                          ? 'Prolonger immédiatement'
                          : 'Envoyer la demande au propriétaire',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

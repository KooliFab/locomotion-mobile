import 'package:flutter/material.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../loanables/domain/entities/vehicle_local_dates.dart';
import '../../domain/entities/loan.dart';
import 'loan_status_helper.dart';

class UpdateDatesDialog extends StatefulWidget {
  final Loan loan;
  final Future<void> Function(String departureAt, int durationInMinutes) onSave;

  const UpdateDatesDialog({
    super.key,
    required this.loan,
    required this.onSave,
  });

  @override
  State<UpdateDatesDialog> createState() => _UpdateDatesDialogState();
}

class _UpdateDatesDialogState extends State<UpdateDatesDialog> {
  late String _departureDate; // yyyy-MM-dd
  late String _departureTime; // HH:mm
  late int _durationInMinutes;
  bool _isLoading = false;
  String? _generalError;
  String? _departureError;
  String? _durationError;

  @override
  void initState() {
    super.initState();
    // Convert departure to vehicle local time so the initial form fields
    // match the vehicle's wall-clock time rather than UTC or device local.
    final tz = widget.loan.loanable?.timezone;
    final vehicleDep = LoanDateFormatter.toVehicleDateTime(
      widget.loan.departureAt,
      tz,
    );
    _departureDate = VehicleLocalDates.formatYmd(vehicleDep);
    _departureTime =
        '${vehicleDep.hour.toString().padLeft(2, '0')}:${vehicleDep.minute.toString().padLeft(2, '0')}';
    _durationInMinutes = widget.loan.durationInMinutes;
  }

  Future<void> _submit() async {
    // Client-side validations
    if (_durationInMinutes < 15) {
      setState(() {
        _durationError = 'La durée minimale est de 15 minutes.';
      });
      return;
    }

    final vehicleTz = widget.loan.loanable?.timezone;
    final todayYmd = VehicleLocalDates.nowYmdInZone(vehicleTz);
    if (_departureDate.compareTo(todayYmd) < 0) {
      setState(() {
        _departureError = 'La date ne peut pas être dans le passé.';
      });
      return;
    }

    final time = _departureTime.length == 5
        ? '$_departureTime:00'
        : _departureTime;
    final naiveDeparture = '$_departureDate $time';

    setState(() {
      _isLoading = true;
      _generalError = null;
      _departureError = null;
      _durationError = null;
    });

    try {
      await widget.onSave(naiveDeparture, _durationInMinutes);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (e is ValidationException) {
            final errs = e.errors;
            if (errs != null && errs.isNotEmpty) {
              if (errs.containsKey('departure_at')) {
                final v = errs['departure_at'];
                _departureError = v is List ? v.join(', ') : v.toString();
              }
              if (errs.containsKey('duration_in_minutes')) {
                final v = errs['duration_in_minutes'];
                _durationError = v is List ? v.join(', ') : v.toString();
              }
            }
            // General or availability 422 error
            _generalError = e.message;
          } else if (e is AppException) {
            _generalError = e.message;
          } else {
            _generalError = e.toString();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier les dates'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_generalError != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(8),
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
                        _generalError!,
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Date de départ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: _isLoading
                  ? null
                  : () async {
                      final initial =
                          DateTime.tryParse(_departureDate) ?? DateTime.now();
                      final now = DateTime.now();
                      final candidateFirst = now.subtract(
                        const Duration(days: 30),
                      );
                      final firstDate = initial.isBefore(candidateFirst)
                          ? initial.subtract(const Duration(days: 7))
                          : candidateFirst;
                      final candidateLast = now.add(const Duration(days: 365));
                      final lastDate = initial.isAfter(candidateLast)
                          ? initial.add(const Duration(days: 30))
                          : candidateLast;

                      final picked = await showDatePicker(
                        context: context,
                        initialDate: initial,
                        firstDate: firstDate,
                        lastDate: lastDate,
                      );
                      if (picked != null) {
                        setState(() {
                          _departureDate = VehicleLocalDates.formatYmd(picked);
                          _departureError = null;
                        });
                      }
                    },
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _departureError,
                  suffixIcon: const Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                  ),
                ),
                child: Text(_departureDate),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Heure de départ (fuseau du véhicule)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            InkWell(
              onTap: _isLoading
                  ? null
                  : () async {
                      final parts = _departureTime.split(':');
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: int.tryParse(parts[0]) ?? 9,
                          minute: int.tryParse(parts[1]) ?? 0,
                        ),
                      );
                      if (picked != null) {
                        setState(() {
                          _departureTime =
                              '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                          _departureError = null;
                        });
                      }
                    },
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: const Icon(Icons.access_time_rounded, size: 18),
                ),
                child: Text(_departureTime),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Durée (en minutes, min. 15)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            TextFormField(
              initialValue: _durationInMinutes.toString(),
              enabled: !_isLoading,
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final v = int.tryParse(val);
                if (v != null) {
                  _durationInMinutes = v;
                  if (_durationError != null) {
                    setState(() {
                      _durationError = null;
                    });
                  }
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: _durationError,
                suffixText: 'minutes',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          key: const Key('confirm_update_dates_button'),
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Enregistrer'),
        ),
      ],
    );
  }
}

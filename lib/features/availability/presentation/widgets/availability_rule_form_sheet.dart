import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../loanables/domain/entities/loanable_availability.dart';
import '../../domain/entities/availability_rule.dart';
import '../../domain/entities/conflicting_loan.dart';
import '../controllers/vehicle_availability_controller.dart';
import 'conflicting_loans_sheet.dart';

class AvailabilityRuleFormSheet extends ConsumerStatefulWidget {
  final int vehicleId;
  final AvailabilityRule? initialRule;

  const AvailabilityRuleFormSheet({
    super.key,
    required this.vehicleId,
    this.initialRule,
  });

  static Future<bool?> show(
    BuildContext context, {
    required int vehicleId,
    AvailabilityRule? initialRule,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AvailabilityRuleFormSheet(
        vehicleId: vehicleId,
        initialRule: initialRule,
      ),
    );
  }

  @override
  ConsumerState<AvailabilityRuleFormSheet> createState() =>
      _AvailabilityRuleFormSheetState();
}

class _AvailabilityRuleFormSheetState
    extends ConsumerState<AvailabilityRuleFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  late bool _isRecurring;
  late bool _isMultiDay;
  late DateTime _startDate;
  late DateTime _endDate;
  late Set<String> _selectedDays;
  late bool _isAllDay;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  bool _isCheckingConflicts = false;
  List<ConflictingLoan> _conflicts = [];
  int _conflictCheckRequestId = 0;
  List<LoanableAvailabilityInterval> _previewIntervals = [];

  @override
  void initState() {
    super.initState();
    final rule = widget.initialRule;

    if (rule != null) {
      _titleController.text = rule.title ?? '';
      _isRecurring = rule.isRecurringWeekly;
      _isAllDay = rule.isAllDay;

      final startParts = rule.startTime.split(':');
      final endParts = rule.endTime.split(':');
      _startTime = TimeOfDay(
        hour: int.tryParse(startParts[0]) ?? 9,
        minute: int.tryParse(startParts.length > 1 ? startParts[1] : '0') ?? 0,
      );
      _endTime = TimeOfDay(
        hour: int.tryParse(endParts[0]) ?? 17,
        minute: int.tryParse(endParts.length > 1 ? endParts[1] : '0') ?? 0,
      );

      if (_isRecurring) {
        _isMultiDay = false;
        _startDate = DateTime.now();
        _endDate = DateTime.now();
        _selectedDays = Set<String>.from(rule.scope);
      } else {
        _selectedDays = {'SA', 'SU'};
        if (rule.type == 'dateRange' && rule.scope.length >= 2) {
          _isMultiDay = true;
          _startDate = DateTime.tryParse(rule.scope.first) ?? DateTime.now();
          _endDate = DateTime.tryParse(rule.scope.last) ?? DateTime.now();
        } else {
          _isMultiDay = false;
          _startDate = rule.scope.isNotEmpty
              ? DateTime.tryParse(rule.scope.first) ?? DateTime.now()
              : DateTime.now();
          _endDate = _startDate;
        }
      }
    } else {
      _isRecurring = false;
      _isMultiDay = false;
      _startDate = DateTime.now().add(const Duration(days: 1));
      _endDate = _startDate;
      _selectedDays = {'SA', 'SU'};
      _isAllDay = true;
      _startTime = const TimeOfDay(hour: 9, minute: 0);
      _endTime = const TimeOfDay(hour: 17, minute: 0);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runConflictCheck();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  List<AvailabilityRule> _buildDraftRules() {
    if (_isRecurring) {
      final period = _isAllDay
          ? '00:00-24:00'
          : '${_formatTime(_startTime)}-${_formatTime(_endTime)}';

      return [
        AvailabilityRule(
          id: widget.initialRule?.id ?? AvailabilityRule.newId(),
          type: 'weekdays',
          scope: _selectedDays.toList(),
          period: period,
          available: false,
          title: _titleController.text.trim().isNotEmpty
              ? _titleController.text.trim()
              : null,
          rawJson: widget.initialRule?.rawJson ?? const {},
        ),
      ];
    }

    if (_isMultiDay) {
      return AvailabilityRule.createContinuousBlock(
        baseId: widget.initialRule?.groupId ??
            widget.initialRule?.id ??
            AvailabilityRule.newId(),
        startDate: _startDate,
        endDate: _endDate,
        startTime: _startTime,
        endTime: _endTime,
        isAllDay: _isAllDay,
        title: _titleController.text.trim().isNotEmpty
            ? _titleController.text.trim()
            : null,
      );
    }

    final period = _isAllDay
        ? '00:00-24:00'
        : '${_formatTime(_startTime)}-${_formatTime(_endTime)}';

    // If an existing rule had multiple dates in its scope, preserve all existing dates (Point 3)
    final List<String> scope;
    if (widget.initialRule != null &&
        widget.initialRule!.type == 'dates' &&
        widget.initialRule!.scope.length > 1) {
      scope = List<String>.from(widget.initialRule!.scope);
    } else {
      scope = [DateFormat('yyyy-MM-dd').format(_startDate)];
    }

    return [
      AvailabilityRule(
        id: widget.initialRule?.id ?? AvailabilityRule.newId(),
        type: 'dates',
        scope: scope,
        period: period,
        available: false,
        title: _titleController.text.trim().isNotEmpty
            ? _titleController.text.trim()
            : null,
        rawJson: widget.initialRule?.rawJson ?? const {},
      ),
    ];
  }

  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Future<void> _runConflictCheck() async {
    if (!mounted) return;
    final requestId = ++_conflictCheckRequestId;

    setState(() {
      _isCheckingConflicts = true;
    });

    try {
      final draftRules = _buildDraftRules();
      final conflicts = await ref
          .read(vehicleAvailabilityControllerProvider(widget.vehicleId).notifier)
          .checkConflictsForDraftRules(
            draftRules,
            ruleToReplaceId: widget.initialRule?.id,
            groupToReplaceId: widget.initialRule?.groupId,
          );

      // Invoke engine preview via /loanables/availability
      final currentConfig =
          await ref.read(vehicleAvailabilityConfigProvider(widget.vehicleId).future);
      final previewStart = DateFormat('yyyy-MM-dd').format(_startDate);
      final previewEnd = DateFormat('yyyy-MM-dd').format(
        _isMultiDay
            ? _endDate.add(const Duration(days: 1))
            : _startDate.add(const Duration(days: 1)),
      );

      final candidateRules = <AvailabilityRule>[];
      for (final r in currentConfig.rules) {
        if (widget.initialRule?.id != null && r.id == widget.initialRule!.id) continue;
        if (widget.initialRule?.groupId != null && r.groupId == widget.initialRule!.groupId) continue;
        candidateRules.add(r);
      }
      candidateRules.addAll(draftRules);

      final intervals = await ref.read(availabilityRepositoryProvider).previewAvailability(
        widget.vehicleId,
        start: previewStart,
        end: previewEnd,
        availabilityMode: currentConfig.availabilityMode,
        availabilityJson: jsonEncode(candidateRules.map((r) => r.toJson()).toList()),
      );

      if (mounted && requestId == _conflictCheckRequestId) {
        setState(() {
          _conflicts = conflicts;
          _previewIntervals = intervals;
          _isCheckingConflicts = false;
        });
      }
    } catch (_) {
      if (mounted && requestId == _conflictCheckRequestId) {
        setState(() {
          _isCheckingConflicts = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controllerState =
        ref.watch(vehicleAvailabilityControllerProvider(widget.vehicleId));
    final isBusy = controllerState.isSubmitting || _isCheckingConflicts;
    final hasConflicts = _conflicts.isNotEmpty;
    final isEditing = widget.initialRule != null;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing
                        ? 'Modifier l\'indisponibilité'
                        : 'Nouvelle indisponibilité',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title / Reason
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Motif (optionnel)',
                  hintText: 'Ex : Vacances, Entretien garage...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label_outline),
                ),
              ),
              const SizedBox(height: 16),

              // Type Selector
              const Text(
                'Type d\'indisponibilité',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Ponctuelle',
                      icon: Icons.event,
                      selected: !_isRecurring,
                      onSelected: (val) {
                        if (val) {
                          setState(() => _isRecurring = false);
                          _runConflictCheck();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Récurrente',
                      icon: Icons.repeat,
                      selected: _isRecurring,
                      onSelected: (val) {
                        if (val) {
                          setState(() => _isRecurring = true);
                          _runConflictCheck();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Sub-type content
              if (!_isRecurring) ...[
                Row(
                  children: [
                    const Text('Période multi-jours :'),
                    const Spacer(),
                    Switch(
                      value: _isMultiDay,
                      onChanged: (val) {
                        setState(() {
                          _isMultiDay = val;
                          if (!_isMultiDay) {
                            _endDate = _startDate;
                          } else if (_endDate.isBefore(_startDate)) {
                            _endDate = _startDate.add(const Duration(days: 1));
                          }
                        });
                        _runConflictCheck();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        label: _isMultiDay ? 'Date de début' : 'Date',
                        date: _startDate,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _startDate,
                            firstDate: DateTime.now().subtract(const Duration(days: 1)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() {
                              _startDate = picked;
                              if (!_isMultiDay || _endDate.isBefore(_startDate)) {
                                _endDate = picked;
                              }
                            });
                            _runConflictCheck();
                          }
                        },
                      ),
                    ),
                    if (_isMultiDay) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDateField(
                          label: 'Date de fin',
                          date: _endDate,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _endDate.isBefore(_startDate) ? _startDate : _endDate,
                              firstDate: _startDate,
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (picked != null) {
                              setState(() => _endDate = picked);
                              _runConflictCheck();
                            }
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ] else ...[
                const Text(
                  'Jours de la semaine concernés',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildDayChip('MO', 'Lun'),
                    _buildDayChip('TU', 'Mar'),
                    _buildDayChip('WE', 'Mer'),
                    _buildDayChip('TH', 'Jeu'),
                    _buildDayChip('FR', 'Ven'),
                    _buildDayChip('SA', 'Sam'),
                    _buildDayChip('SU', 'Dim'),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              // Hours / Period
              Row(
                children: [
                  const Text('Toute la journée (00:00 - 24:00) :'),
                  const Spacer(),
                  Switch(
                    value: _isAllDay,
                    onChanged: (val) {
                      setState(() => _isAllDay = val);
                      _runConflictCheck();
                    },
                  ),
                ],
              ),
              if (!_isAllDay) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimeField(
                        label: 'Heure de début',
                        time: _startTime,
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _startTime,
                          );
                          if (picked != null) {
                            setState(() => _startTime = picked);
                            _runConflictCheck();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTimeField(
                        label: 'Heure de fin',
                        time: _endTime,
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _endTime,
                          );
                          if (picked != null) {
                            setState(() => _endTime = picked);
                            _runConflictCheck();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),

              // Conflict Alert Banner
              if (_isCheckingConflicts)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Vérification des conflits avec les prêts...',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              else if (hasConflicts)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.danger),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.warning, color: AppColors.danger, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Conflit détecté avec ${_conflicts.length} réservation(s)',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.danger,
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              foregroundColor: AppColors.danger,
                            ),
                            onPressed: () {
                              ConflictingLoansSheet.show(
                                context,
                                conflicts: _conflicts,
                              );
                            },
                            child: const Text('Détails'),
                          ),
                        ],
                      ),
                      const Text(
                        'Vous ne pouvez pas bloquer ce créneau tant qu\'il chevauche des réservations existantes.',
                        style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.success, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Aucun conflit avec les réservations existantes',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_previewIntervals.isNotEmpty && !hasConflicts) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle_outline, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Aperçu moteur (/loanables/availability) : ${_previewIntervals.length} créneau(x)',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ..._previewIntervals.take(3).map((interval) {
                        final startStr = DateFormat('dd/MM HH:mm').format(interval.start);
                        final endStr = DateFormat('dd/MM HH:mm').format(interval.end);
                        return Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '• $startStr → $endStr (${interval.isAvailable ? "disponible" : "bloqué"})',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        );
                      }),
                      if (_previewIntervals.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            '+ ${_previewIntervals.length - 3} autre(s) créneau(x)...',
                            style: TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: isBusy ? null : () => Navigator.of(context).pop(),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (hasConflicts || isBusy)
                            ? Colors.grey
                            : AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: (hasConflicts || isBusy) ? null : _submitForm,
                      child: controllerState.isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              hasConflicts
                                  ? 'Conflit bloquant'
                                  : (isEditing ? 'Modifier' : 'Enregistrer'),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required IconData icon,
    required bool selected,
    required ValueChanged<bool> onSelected,
  }) {
    return InkWell(
      onTap: () => onSelected(!selected),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.12) : AppColors.card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayChip(String code, String label) {
    final isSelected = _selectedDays.contains(code);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        setState(() {
          if (val) {
            _selectedDays.add(code);
          } else {
            if (_selectedDays.length > 1) {
              _selectedDays.remove(code);
            }
          }
        });
        _runConflictCheck();
      },
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
        ),
        child: Text(
          DateFormat('dd/MM/yyyy').format(date),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.access_time, size: 18),
        ),
        child: Text(
          _formatTime(time),
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    final draftRules = _buildDraftRules();
    final notifier =
        ref.read(vehicleAvailabilityControllerProvider(widget.vehicleId).notifier);

    final success = await notifier.saveRules(
      draftRules,
      ruleToReplaceId: widget.initialRule?.id,
      groupToReplaceId: widget.initialRule?.groupId,
    );

    if (success && mounted) {
      Navigator.of(context).pop(true);
    } else if (mounted) {
      final state =
          ref.read(vehicleAvailabilityControllerProvider(widget.vehicleId));
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }
}

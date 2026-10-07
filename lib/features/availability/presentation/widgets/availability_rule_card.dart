import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/availability_rule.dart';

class AvailabilityRuleCard extends StatelessWidget {
  final AvailabilityRule rule;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isReadOnly;

  const AvailabilityRuleCard({
    super.key,
    required this.rule,
    this.onEdit,
    this.onDelete,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: rule.isCustomServerRule
              ? AppColors.textSecondary.withValues(alpha: 0.3)
              : AppColors.border,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  rule.isRecurringWeekly
                      ? Icons.repeat
                      : (rule.type == 'dateRange'
                            ? Icons.date_range
                            : Icons.calendar_today),
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    rule.title != null && rule.title!.isNotEmpty
                        ? rule.title!
                        : (rule.isRecurringWeekly
                              ? 'Indisponibilité récurrente'
                              : 'Indisponibilité ponctuelle'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: rule.isAllDay
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    rule.isAllDay
                        ? 'Journée entière'
                        : '${rule.startTime} - ${rule.endTime}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: rule.isAllDay
                          ? AppColors.primary
                          : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              rule.formattedSummary,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            if (rule.isMultiDatesBatch)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Géré via le web (multi-dates)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (!isReadOnly && !rule.isCustomServerRule) ...[
              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onEdit != null && rule.isEditableInApp)
                    TextButton.icon(
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text(
                        'Modifier',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        foregroundColor: AppColors.primary,
                      ),
                      onPressed: onEdit,
                    ),
                  if (onDelete != null)
                    TextButton.icon(
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text(
                        'Supprimer',
                        style: TextStyle(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        foregroundColor: AppColors.danger,
                      ),
                      onPressed: onDelete,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

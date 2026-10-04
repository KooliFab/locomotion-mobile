import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/incident.dart';

class IncidentStatusBadge extends StatelessWidget {
  final Incident incident;

  const IncidentStatusBadge({super.key, required this.incident});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String text;
    IconData icon;

    if (incident.isCompleted) {
      bg = AppColors.success.withValues(alpha: 0.12);
      fg = AppColors.success;
      text = 'Résolu';
      icon = Icons.check_circle_outline;
    } else if (incident.isBlocking) {
      bg = AppColors.danger.withValues(alpha: 0.12);
      fg = AppColors.danger;
      text = 'Véhicule bloqué';
      icon = Icons.block;
    } else {
      bg = AppColors.primary.withValues(alpha: 0.12);
      fg = AppColors.primary;
      text = 'En cours';
      icon = Icons.hourglass_top_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

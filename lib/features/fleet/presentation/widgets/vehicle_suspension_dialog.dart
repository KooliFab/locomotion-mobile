import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/fleet_vehicle.dart';

class VehicleSuspensionDialog extends StatefulWidget {
  final FleetVehicle vehicle;
  final Future<void> Function(String? reason, bool preserveFuture) onConfirm;

  const VehicleSuspensionDialog({
    super.key,
    required this.vehicle,
    required this.onConfirm,
  });

  static Future<bool?> show(
    BuildContext context, {
    required FleetVehicle vehicle,
    required Future<void> Function(String? reason, bool preserveFuture)
    onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) =>
          VehicleSuspensionDialog(vehicle: vehicle, onConfirm: onConfirm),
    );
  }

  @override
  State<VehicleSuspensionDialog> createState() =>
      _VehicleSuspensionDialogState();
}

class _VehicleSuspensionDialogState extends State<VehicleSuspensionDialog> {
  final _reasonController = TextEditingController();
  final bool _preserveFuture = true;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final nav = Navigator.of(context, rootNavigator: true);

    try {
      await widget.onConfirm(
        _reasonController.text.trim().isEmpty
            ? null
            : _reasonController.text.trim(),
        _preserveFuture,
      );
      nav.pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.vehicle;

    return AlertDialog(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.pause_circle_outline_rounded,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Suspendre le véhicule',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vous êtes sur le point de suspendre temporairement ${v.name}.',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Loan counts summary card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildCountRow(
                    icon: Icons.play_arrow_rounded,
                    label: 'Prêts en cours (y compris retards)',
                    count: v.activeLoansCount,
                    highlight: v.hasActiveLoans,
                  ),
                  const Divider(height: 16),
                  _buildCountRow(
                    icon: Icons.check_circle_outline,
                    label: 'Réservations confirmées à venir',
                    count: v.confirmedFutureLoansCount,
                    highlight: v.confirmedFutureLoansCount > 0,
                  ),
                  if (v.pendingRequestsCount > 0) ...[
                    const Divider(height: 16),
                    _buildCountRow(
                      icon: Icons.pending_outlined,
                      label: 'Demandes en attente',
                      count: v.pendingRequestsCount,
                      highlight: false,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Reassurance info banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Aucune annulation automatique : les prêts en cours et confirmés sont préservés. Votre calendrier et vos règles habituelles restent sauvegardés pour la réactivation.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Reason input
            TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Motif de suspension (optionnel)',
                hintText: 'Ex. Entretien mécanique, congés...',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: const TextStyle(color: AppColors.danger, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          key: const Key('confirm_suspend_button'),
          onPressed: _isLoading ? null : _handleConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warning,
            foregroundColor: Colors.white,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Confirmer la suspension'),
        ),
      ],
    );
  }

  Widget _buildCountRow({
    required IconData icon,
    required String label,
    required int count,
    required bool highlight,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: highlight ? AppColors.warning : AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: highlight
                ? AppColors.warning.withValues(alpha: 0.15)
                : AppColors.border,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: highlight ? AppColors.warning : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

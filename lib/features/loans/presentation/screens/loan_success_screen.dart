import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/loan.dart';

class LoanSuccessScreen extends StatelessWidget {
  final Loan loan;

  const LoanSuccessScreen({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat;
    try {
      dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'fr');
    } catch (_) {
      dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.successBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Demande envoyée !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Votre demande de réservation a bien été enregistrée et transmise au propriétaire pour approbation.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              // Card summary based on backend returned Loan
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              loan.displayLoanableName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warningBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              loan.status == 'requested'
                                  ? 'En attente'
                                  : loan.status,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 28),
                      _detailRow('N° de réservation', '#${loan.id}'),
                      const SizedBox(height: 10),
                      _detailRow('Départ', dateFormat.format(loan.startAt)),
                      const SizedBox(height: 10),
                      _detailRow('Retour prévu', dateFormat.format(loan.endAt)),
                      const SizedBox(height: 10),
                      _detailRow('Durée', '${loan.durationInMinutes} min'),
                      if (loan.estimatedDistance != null) ...[
                        const SizedBox(height: 10),
                        _detailRow(
                          'Distance estimée',
                          '${loan.estimatedDistance} km',
                        ),
                      ],
                      if (loan.totalCost != null) ...[
                        const SizedBox(height: 10),
                        _detailRow(
                          'Coût estimé',
                          '${loan.totalCost!.toStringAsFixed(2)} \$',
                          isBold: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              AppButton(
                text: 'Voir mes réservations',
                onPressed: () => context.go(AppRoutes.loans),
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Retour à l\'accueil',
                variant: AppButtonVariant.outline,
                onPressed: () => context.go(AppRoutes.explore),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

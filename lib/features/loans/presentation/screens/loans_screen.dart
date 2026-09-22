import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../domain/entities/loan.dart';
import '../controllers/loans_controller.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(myLoansControllerProvider);
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'fr');

    return Scaffold(
      appBar: AppBar(title: const Text('Mes Réservations')),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.read(myLoansControllerProvider.notifier).refresh(),
        child: AsyncValueWidget<List<Loan>>(
          value: loansAsync,
          onRetry: () => ref.read(myLoansControllerProvider.notifier).refresh(),
          data: (loans) {
            if (loans.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.lightTint,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.calendar_today_rounded,
                          color: AppColors.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Aucune réservation active',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Explorez la carte pour trouver et réserver un véhicule dans votre communauté.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: loans.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final loan = loans[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              loan.displayLoanableName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            _buildStatusBadge(loan.status),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 16,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${dateFormat.format(loan.startAt)} → ${dateFormat.format(loan.endAt)}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        if (loan.totalCost != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Total estimé : ${loan.totalCost!.toStringAsFixed(2)} \$',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color fg;
    String label;

    switch (status) {
      case 'ongoing':
      case 'in_progress':
        bg = AppColors.successBg;
        fg = AppColors.success;
        label = 'En cours';
        break;
      case 'confirmed':
        bg = AppColors.infoBg;
        fg = AppColors.info;
        label = 'Confirmé';
        break;
      case 'accepted':
        bg = AppColors.infoBg;
        fg = AppColors.info;
        label = 'Accepté';
        break;
      case 'requested':
      case 'pending':
        bg = AppColors.warningBg;
        fg = AppColors.warning;
        label = 'En attente';
        break;
      case 'validated':
        bg = AppColors.infoBg;
        fg = AppColors.info;
        label = 'Validé';
        break;
      case 'ended':
        bg = Colors.amber.shade100;
        fg = Colors.amber.shade800;
        label = 'À valider';
        break;
      case 'completed':
        bg = Colors.grey.shade200;
        fg = Colors.grey.shade700;
        label = 'Terminé';
        break;
      case 'canceled':
      case 'cancelled':
        bg = AppColors.dangerBg;
        fg = AppColors.danger;
        label = 'Annulé';
        break;
      case 'rejected':
        bg = AppColors.dangerBg;
        fg = AppColors.danger;
        label = 'Refusé';
        break;
      default:
        bg = Colors.grey.shade100;
        fg = Colors.grey.shade600;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

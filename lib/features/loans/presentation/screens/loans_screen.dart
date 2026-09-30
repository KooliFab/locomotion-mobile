import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loans_dashboard.dart';
import '../controllers/loans_controller.dart';
import '../widgets/loan_status_helper.dart';

class LoansScreen extends ConsumerStatefulWidget {
  const LoansScreen({super.key});

  @override
  ConsumerState<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends ConsumerState<LoansScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Automatic refresh on app return to foreground
      ref.read(loansDashboardControllerProvider.notifier).refresh();
      ref.invalidate(cancelledOrRejectedLoansProvider);
    }
  }

  Future<void> _refreshAll() async {
    await ref.read(loansDashboardControllerProvider.notifier).refresh();
    ref.invalidate(cancelledOrRejectedLoansProvider);
  }

  @override
  Widget build(BuildContext context) {
    final dashboardAsync = ref.watch(loansDashboardControllerProvider);
    final cancelledOrRejectedAsync =
        ref.watch(cancelledOrRejectedLoansProvider);
    final currentUser = ref.watch(authControllerProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Réservations'),
        actions: [
          IconButton(
            tooltip: 'Toutes les réservations',
            icon: const Icon(Icons.list_alt_rounded),
            onPressed: () => context.push(AppRoutes.loansList),
          ),
          IconButton(
            tooltip: 'Actualiser',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refreshAll,
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _refreshAll,
        child: AsyncValueWidget<LoansDashboard>(
          value: dashboardAsync,
          onRetry: _refreshAll,
          data: (dashboard) {
            final userId = currentUser?.id;

            // 1. En attente (waiting is strictly borrower requested loans where borrower_user_id == current user)
            final waitingLoans = userId == null
                ? <Loan>[]
                : dashboard.waiting.loans
                    .where((l) => l.borrowerUserId == userId)
                    .toList();
            final waitingTotal = dashboard.waiting.total;

            // 2. Acceptées / confirmées (future) - strictly filter for borrower role
            final futureLoans = userId == null
                ? <Loan>[]
                : dashboard.future.loans
                    .where((l) => l.borrowerUserId == userId)
                    .toList();
            // If some loans in future were owner loans, the displayed count must reflect borrower loans
            // when total <= loans.length, or show total if un-truncated
            final futureTotal = dashboard.future.total > dashboard.future.loans.length
                ? dashboard.future.total
                : futureLoans.length;

            // 3. En cours (started) - strictly filter for borrower role
            final startedLoans = userId == null
                ? <Loan>[]
                : dashboard.started.loans
                    .where((l) => l.borrowerUserId == userId)
                    .toList();
            final startedTotal = dashboard.started.total > dashboard.started.loans.length
                ? dashboard.started.total
                : startedLoans.length;

            // 4. Terminées (completed) - strictly filter for borrower role
            final completedLoans = userId == null
                ? <Loan>[]
                : dashboard.completed.loans
                    .where((l) => l.borrowerUserId == userId)
                    .toList();
            final completedTotal = dashboard.completed.total > dashboard.completed.loans.length
                ? dashboard.completed.total
                : completedLoans.length;

            // 5. Annulées / refusées (from GET /loans?status=canceled,rejected)
            final cancelledOrRejectedLoans = userId == null
                ? <Loan>[]
                : (cancelledOrRejectedAsync.value ?? <Loan>[])
                    .where((l) => l.borrowerUserId == null || l.borrowerUserId == userId)
                    .toList();

            final isEmptyOverall = waitingLoans.isEmpty &&
                futureLoans.isEmpty &&
                startedLoans.isEmpty &&
                completedLoans.isEmpty &&
                cancelledOrRejectedLoans.isEmpty;

            if (isEmptyOverall) {
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
                        'Aucune réservation',
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
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go(AppRoutes.explore),
                        child: const Text('Explorer les véhicules'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Section 1: En attente
                _buildSection(
                  context,
                  title: 'En attente',
                  icon: Icons.hourglass_top_rounded,
                  color: Colors.amber.shade800,
                  loans: waitingLoans,
                  totalCount: waitingTotal,
                  filterStatus: 'requested',
                ),

                // Section 2: Acceptées / confirmées
                _buildSection(
                  context,
                  title: 'Acceptées / Confirmées',
                  icon: Icons.check_circle_outline_rounded,
                  color: Colors.blue.shade700,
                  loans: futureLoans,
                  totalCount: futureTotal,
                  filterStatus: 'accepted,confirmed',
                ),

                // Section 3: En cours
                _buildSection(
                  context,
                  title: 'En cours',
                  icon: Icons.directions_car_rounded,
                  color: const Color(0xFF047857), // emerald 700
                  loans: startedLoans,
                  totalCount: startedTotal,
                  filterStatus: 'ongoing,ended,validated',
                ),

                // Section 4: Terminées
                _buildSection(
                  context,
                  title: 'Terminées',
                  icon: Icons.task_alt_rounded,
                  color: Colors.grey.shade700,
                  loans: completedLoans,
                  totalCount: completedTotal,
                  filterStatus: 'completed',
                ),

                // Section 5: Annulées / refusées
                _buildSection(
                  context,
                  title: 'Annulées / Refusées',
                  icon: Icons.cancel_outlined,
                  color: Colors.red.shade700,
                  loans: cancelledOrRejectedLoans,
                  totalCount: cancelledOrRejectedLoans.length,
                  filterStatus: 'canceled,rejected',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<Loan> loans,
    required int totalCount,
    required String filterStatus,
  }) {
    if (loans.isEmpty) return const SizedBox.shrink();

    final showViewAll = totalCount > loans.length || totalCount > 5;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: color),
                  const SizedBox(width: 8),
                  Text(
                    '$title ($totalCount)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (showViewAll)
                TextButton(
                  key: Key('view_all_$filterStatus'),
                  onPressed: () {
                    context.push(AppRoutes.loansListPath(status: filterStatus));
                  },
                  child: const Text('Voir tout'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: loans.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final loan = loans[index];
              return _LoanCard(loan: loan);
            },
          ),
        ],
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  final Loan loan;

  const _LoanCard({required this.loan});

  @override
  Widget build(BuildContext context) {
    final status = loan.parsedStatus;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push(AppRoutes.loanDetailPath(loan.id));
        },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: LoanStatusHelper.backgroundColor(status),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      LoanStatusHelper.label(status),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: LoanStatusHelper.foregroundColor(status),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      LoanDateFormatter.formatRange(loan),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              if (loan.totalCost != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Total : ${loan.totalCost!.toStringAsFixed(2)} \$',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

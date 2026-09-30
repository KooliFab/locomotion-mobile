import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/loan.dart';
import '../controllers/loans_controller.dart';
import '../widgets/loan_status_helper.dart';

class LoansListScreen extends ConsumerStatefulWidget {
  final String? initialStatus;

  const LoansListScreen({super.key, this.initialStatus});

  @override
  ConsumerState<LoansListScreen> createState() => _LoansListScreenState();
}

class _LoansListScreenState extends ConsumerState<LoansListScreen> {
  final List<Loan> _loans = [];
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
    _loadPage(1);
  }

  Future<void> _loadPage(int page, {bool isRefresh = false}) async {
    if (page == 1) {
      setState(() {
        _isLoading = true;
        _error = null;
        if (isRefresh) _loans.clear();
      });
    } else {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      final repo = ref.read(loansRepositoryProvider);
      final currentUser = ref.read(authControllerProvider).value;

      final res = await repo.getLoansPage(
        page: page,
        perPage: 10,
        status: _selectedStatus,
        borrowerUserId: currentUser?.id,
      );

      if (mounted) {
        setState(() {
          if (page == 1) {
            _loans.clear();
          }
          _loans.addAll(res.data);
          _currentPage = res.currentPage;
          _lastPage = res.lastPage;
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toutes mes réservations'),
      ),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip(null, 'Tous'),
                const SizedBox(width: 8),
                _buildFilterChip('requested', 'En attente'),
                const SizedBox(width: 8),
                _buildFilterChip('accepted,confirmed', 'Acceptées / Confirmées'),
                const SizedBox(width: 8),
                _buildFilterChip('ongoing,ended,validated', 'En cours'),
                const SizedBox(width: 8),
                _buildFilterChip('completed', 'Terminées'),
                const SizedBox(width: 8),
                _buildFilterChip('canceled,rejected', 'Annulées / Refusées'),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main list
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_error != null && _loans.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 48, color: AppColors.danger),
              const SizedBox(height: 12),
              Text(
                'Erreur: $_error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _loadPage(1),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }

    if (_loans.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_rounded, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              const Text(
                'Aucune réservation trouvée.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    final hasMore = _currentPage < _lastPage;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => _loadPage(1, isRefresh: true),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _loans.length + (hasMore ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == _loans.length) {
            // Load more button
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  key: const Key('load_more_button'),
                  onPressed: _isLoadingMore
                      ? null
                      : () => _loadPage(_currentPage + 1),
                  child: _isLoadingMore
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Charger plus'),
                ),
              ),
            );
          }

          final loan = _loans[index];
          final status = loan.parsedStatus;

          return Card(
            key: Key('loan_item_${loan.id}'),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                await context.push(AppRoutes.loanDetailPath(loan.id));
                if (mounted) {
                  _loadPage(1, isRefresh: true);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
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
                    Text(
                      LoanDateFormatter.formatRange(loan),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (loan.totalCost != null) ...[
                      const SizedBox(height: 4),
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
        },
      ),
    );
  }

  Widget _buildFilterChip(String? status, String label) {
    final isSelected = _selectedStatus == status;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedStatus = status;
          });
          _loadPage(1);
        }
      },
    );
  }
}

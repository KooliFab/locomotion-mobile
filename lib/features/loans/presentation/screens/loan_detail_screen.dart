import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_status.dart';
import '../controllers/loans_controller.dart';
import '../widgets/loan_comments_section.dart';
import '../widgets/loan_prepayment_modal.dart';
import '../widgets/loan_status_helper.dart';
import '../widgets/loan_timeline_widget.dart';
import '../widgets/owner_decision_dialog.dart';
import '../widgets/update_dates_dialog.dart';

class LoanDetailScreen extends ConsumerStatefulWidget {
  final int loanId;
  final Loan? initialLoan;

  const LoanDetailScreen({super.key, required this.loanId, this.initialLoan});

  @override
  ConsumerState<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends ConsumerState<LoanDetailScreen> {
  bool _isCancelling = false;
  bool _isCommenting = false;
  bool _isDeciding = false;
  String? _screenError;

  Future<void> _handleOwnerDecision(Loan loan, OwnerDecisionType type) async {
    setState(() {
      _isDeciding = true;
    });

    try {
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => OwnerDecisionDialog(
          loan: loan,
          decisionType: type,
          onAccessLost: () {
            invalidateLoanViews(
              ref,
              loanId: widget.loanId,
              loanableId: loan.loanableId,
            );
          },
          onSwitchToReject: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _handleOwnerDecision(loan, OwnerDecisionType.reject);
              }
            });
          },
          onConfirm: (comment) async {
            if (type == OwnerDecisionType.accept) {
              await ref
                  .read(loanActionsControllerProvider.notifier)
                  .accept(
                    widget.loanId,
                    comment: comment,
                    loanableId: loan.loanableId,
                  );
            } else {
              await ref
                  .read(loanActionsControllerProvider.notifier)
                  .reject(
                    widget.loanId,
                    comment: comment,
                    loanableId: loan.loanableId,
                  );
            }
          },
        ),
      );

      if (result == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              type == OwnerDecisionType.accept
                  ? 'Demande acceptée.'
                  : 'Demande refusée.',
            ),
            backgroundColor: type == OwnerDecisionType.accept
                ? AppColors.success
                : AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeciding = false;
        });
      }
    }
  }

  Future<void> _handleCancel(Loan loan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer l\'annulation'),
        content: const Text(
          'Êtes-vous sûr de vouloir annuler cette réservation ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Non, garder'),
          ),
          ElevatedButton(
            key: const Key('confirm_cancel_button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Oui, annuler'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isCancelling = true;
      _screenError = null;
    });

    try {
      await ref
          .read(loanActionsControllerProvider.notifier)
          .cancel(widget.loanId, loanableId: loan.loanableId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Réservation annulée avec succès.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final msg = e is AppException ? e.message : e.toString();
        setState(() {
          _screenError = msg;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCancelling = false;
        });
      }
    }
  }

  Future<void> _handleUpdateDates(Loan loan) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => UpdateDatesDialog(
        loan: loan,
        onSave: (departureAt, durationInMinutes) async {
          await ref
              .read(loanActionsControllerProvider.notifier)
              .updateDates(
                loanId: widget.loanId,
                departureAt: departureAt,
                durationInMinutes: durationInMinutes,
                loanableId: loan.loanableId,
              );
        },
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dates mises à jour avec succès.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _handleAddComment(String text, Loan loan) async {
    setState(() {
      _isCommenting = true;
      _screenError = null;
    });

    try {
      await ref
          .read(loanActionsControllerProvider.notifier)
          .addComment(
            loanId: widget.loanId,
            text: text,
            loanableId: loan.loanableId,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Commentaire ajouté.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final msg = e is AppException ? e.message : e.toString();
        setState(() {
          _screenError = msg;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: AppColors.danger),
        );
      }
      rethrow;
    } finally {
      if (mounted) {
        setState(() {
          _isCommenting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loanAsync = ref.watch(loanDetailProvider(widget.loanId));
    final currentUser = ref.watch(authControllerProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Réservation #${widget.loanId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(loanDetailProvider(widget.loanId)),
          ),
        ],
      ),
      body: AsyncValueWidget<Loan>(
        value: loanAsync,
        onRetry: () => ref.invalidate(loanDetailProvider(widget.loanId)),
        error: (e, _) {
          final isAccessError =
              e is ForbiddenException ||
              (e is ServerException &&
                  (e.statusCode == 404 || e.statusCode == 403));
          String message = 'Impossible de charger la réservation.';
          if (e is ForbiddenException) {
            message =
                'Accès non autorisé : cette demande n\'est plus disponible ou a déjà été traitée.';
          } else if (e is ServerException && e.statusCode == 404) {
            message =
                'Réservation introuvable (#${widget.loanId}) : cette demande n\'est plus disponible ou a déjà été traitée.';
          } else if (e is AppException) {
            message = e.message;
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: AppColors.danger,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isAccessError) ...[
                    ElevatedButton.icon(
                      key: const Key('back_to_dashboard_button'),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Retour au tableau de bord'),
                      onPressed: () => context.go(AppRoutes.loans),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () =>
                          ref.invalidate(loanDetailProvider(widget.loanId)),
                      child: const Text('Réessayer'),
                    ),
                  ] else
                    ElevatedButton(
                      onPressed: () =>
                          ref.invalidate(loanDetailProvider(widget.loanId)),
                      child: const Text('Réessayer'),
                    ),
                ],
              ),
            ),
          );
        },
        data: (loan) {
          final status = loan.parsedStatus;
          final isOwner = loan.isUserOwner(currentUser?.id);
          final canOwnerAccept = loan.canOwnerAccept(currentUser?.id);
          final canOwnerReject = loan.canOwnerReject(currentUser?.id);
          final canOwnerCancel = loan.canOwnerCancel(currentUser?.id);
          final canBorrowerCancel = loan.canBorrowerCancel(currentUser?.id);
          final canBorrowerPrepay = loan.canBorrowerPrepay(currentUser?.id);
          final canCancel = canBorrowerCancel || canOwnerCancel;
          final canUpdateDates = loan.canBorrowerUpdateDates(currentUser?.id);
          final canComment =
              loan.canBorrowerComment(currentUser?.id) || isOwner;

          final hasBorrowerInfo =
              loan.borrowerUserName != null ||
              loan.borrowerUserEmail != null ||
              loan.borrowerUserPhone != null;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async =>
                ref.invalidate(loanDetailProvider(widget.loanId)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_screenError != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.dangerBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _screenError!,
                        style: const TextStyle(
                          color: AppColors.danger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Vehicle card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _buildStatusChip(status),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (loan.communityName != null) ...[
                            Text(
                              'Communauté : ${loan.communityName}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            'Créneau : ${LoanDateFormatter.formatRange(loan)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Durée : ${loan.durationInMinutes} minutes',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          if (loan.loanable?.timezone != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Fuseau du véhicule : ${loan.loanable!.timezone}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                          if (loan.totalCost != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Total : ${loan.totalCost!.toStringAsFixed(2)} \$',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Borrower Card (for owners or if participant info is present)
                  if (hasBorrowerInfo) ...[
                    const SizedBox(height: 12),
                    Card(
                      key: const Key('borrower_info_card'),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.primaryLight,
                                  radius: 20,
                                  child: Text(
                                    loan.borrowerUserName != null &&
                                            loan.borrowerUserName!.isNotEmpty
                                        ? loan.borrowerUserName![0]
                                              .toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Emprunteur',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        loan.borrowerUserName ??
                                            'Non renseigné',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (loan.borrowerUserEmail != null) ...[
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.email_outlined,
                                    size: 16,
                                    color: AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      loan.borrowerUserEmail!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (loan.borrowerUserPhone != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone_outlined,
                                    size: 16,
                                    color: AppColors.textMuted,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      loan.borrowerUserPhone!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Caution active banner
                  if (loan.hasAuthorizedDeposit) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            color: Colors.blue.shade700,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Caution autorisée : ${loan.depositAuthorizedDollars != null ? '${loan.depositAuthorizedDollars!.toStringAsFixed(2)} \$' : '250,00 \$'} CAD',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Empreinte bancaire Stripe retenue sans encaissement direct.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Borrower Prepayment Action (Prépayer & bloquer la caution)
                  if (canBorrowerPrepay) ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      key: const Key('action_prepay_button'),
                      onPressed: () => LoanPrepaymentModal.show(context, loan),
                      icon: const Icon(Icons.payment_outlined, size: 20),
                      label: const Text(
                        'Prépayer & bloquer la caution',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],

                  // Owner Actions row (Accepter / Refuser) for requested loans
                  if (canOwnerAccept || canOwnerReject) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (canOwnerAccept)
                          Expanded(
                            child: ElevatedButton.icon(
                              key: const Key('action_owner_accept_button'),
                              onPressed: _isDeciding
                                  ? null
                                  : () => _handleOwnerDecision(
                                      loan,
                                      OwnerDecisionType.accept,
                                    ),
                              icon: const Icon(
                                Icons.check_circle_outline_rounded,
                                size: 18,
                              ),
                              label: const Text('Accepter'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        if (canOwnerAccept && canOwnerReject)
                          const SizedBox(width: 12),
                        if (canOwnerReject)
                          Expanded(
                            child: OutlinedButton.icon(
                              key: const Key('action_owner_reject_button'),
                              onPressed: _isDeciding
                                  ? null
                                  : () => _handleOwnerDecision(
                                      loan,
                                      OwnerDecisionType.reject,
                                    ),
                              icon: const Icon(Icons.cancel_outlined, size: 18),
                              label: const Text('Refuser'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.danger,
                                side: const BorderSide(color: AppColors.danger),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],

                  // Borrower / Generic Actions row (Modifier dates / Annuler)
                  if (canUpdateDates || canCancel) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (canUpdateDates)
                          Expanded(
                            child: OutlinedButton.icon(
                              key: const Key('action_update_dates_button'),
                              onPressed: _isCancelling || _isDeciding
                                  ? null
                                  : () => _handleUpdateDates(loan),
                              icon: const Icon(
                                Icons.edit_calendar_rounded,
                                size: 18,
                              ),
                              label: const Text('Modifier dates'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(
                                  color: AppColors.primary,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        if (canUpdateDates && canCancel)
                          const SizedBox(width: 12),
                        if (canCancel)
                          Expanded(
                            child: ElevatedButton.icon(
                              key: const Key('action_cancel_button'),
                              onPressed: _isCancelling || _isDeciding
                                  ? null
                                  : () => _handleCancel(loan),
                              icon: _isCancelling
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.cancel_outlined, size: 18),
                              label: const Text('Annuler'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.danger,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),
                  // Timeline
                  LoanTimelineWidget(loan: loan),

                  const SizedBox(height: 16),
                  // Comments & messages
                  LoanCommentsSection(
                    loan: loan,
                    isSubmitting: _isCommenting,
                    onAddComment: canComment
                        ? (text) => _handleAddComment(text, loan)
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(LoanStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: LoanStatusHelper.backgroundColor(status),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LoanStatusHelper.icon(status),
            size: 14,
            color: LoanStatusHelper.foregroundColor(status),
          ),
          const SizedBox(width: 4),
          Text(
            LoanStatusHelper.label(status),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: LoanStatusHelper.foregroundColor(status),
            ),
          ),
        ],
      ),
    );
  }
}

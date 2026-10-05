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
import '../controllers/loan_settle_controller.dart';
import '../controllers/loans_controller.dart';
import '../widgets/loan_comments_section.dart';
import '../widgets/loan_prepayment_modal.dart';
import '../widgets/loan_status_helper.dart';
import '../widgets/loan_timeline_widget.dart';
import '../widgets/loan_extension_bottom_sheet.dart';
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
  bool _isValidating = false;
  bool _isSettling = false;
  bool _isDecidingExtension = false;
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

  Future<void> _handleValidateReturn(Loan loan) async {
    setState(() {
      _isValidating = true;
      _screenError = null;
    });

    try {
      await ref
          .read(loanActionsControllerProvider.notifier)
          .validate(loan.id, loanableId: loan.loanableId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Validation du retour confirmée.'),
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
          _isValidating = false;
        });
      }
    }
  }

  Future<void> _handleOpenExtension(Loan loan) async {
    final res = await LoanExtensionBottomSheet.show(context, loan);
    if (res == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Demande de prolongation enregistrée.'),
          backgroundColor: AppColors.success,
        ),
      );
      ref.invalidate(loanDetailProvider(widget.loanId));
    }
  }

  Future<void> _handleAcceptExtension(Loan loan) async {
    setState(() {
      _isDecidingExtension = true;
      _screenError = null;
    });

    try {
      await ref
          .read(loanActionsControllerProvider.notifier)
          .acceptExtension(loan.id, loanableId: loan.loanableId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prolongation acceptée avec succès.'),
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
          _isDecidingExtension = false;
        });
      }
    }
  }

  Future<void> _handleRejectExtension(Loan loan) async {
    setState(() {
      _isDecidingExtension = true;
      _screenError = null;
    });

    try {
      await ref
          .read(loanActionsControllerProvider.notifier)
          .rejectExtension(loan.id, loanableId: loan.loanableId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demande de prolongation refusée.'),
            backgroundColor: AppColors.danger,
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
          _isDecidingExtension = false;
        });
      }
    }
  }

  Future<void> _handleCancelExtension(Loan loan) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Annuler la prolongation'),
        content: const Text(
          'Êtes-vous sûr de vouloir annuler votre demande de prolongation ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Garder'),
          ),
          ElevatedButton(
            key: const Key('confirm_cancel_extension_dialog_button'),
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
      _isDecidingExtension = true;
      _screenError = null;
    });

    try {
      await ref
          .read(loanActionsControllerProvider.notifier)
          .cancelExtension(loan.id, loanableId: loan.loanableId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demande de prolongation annulée.'),
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
          _isDecidingExtension = false;
        });
      }
    }
  }

  Future<bool?> _showFinancialBreakdownDialog(BuildContext context, Loan loan) {
    final distanceKm = loan.actualDistance ??
        (loan.mileageEnd != null && loan.mileageStart != null
            ? (loan.mileageEnd! - loan.mileageStart!).clamp(0, 999999)
            : (loan.estimatedDistance ?? 0));

    final effectiveDuration = loan.actualReturnAt != null
        ? loan.actualReturnAt!.difference(loan.departureAt)
        : Duration(minutes: loan.durationInMinutes);
    final durationHours = (effectiveDuration.inMinutes / 60.0).toStringAsFixed(1);

    final finalTotal = loan.borrowerTotal != null ? loan.borrowerTotal!.abs() : 0.0;
    final isPrepaid = loan.prepaidAt != null;

    // Breakdown subtotal and provincial/federal taxes (Quebec TPS 5% + TVQ 9.975%)
    final subtotal = finalTotal > 0 ? (finalTotal / 1.14975) : 0.0;
    final tps = subtotal * 0.05;
    final tvq = subtotal * 0.09975;

    // Prepayment & balance reconciliation
    final prepaidAmount = isPrepaid ? finalTotal : 0.0;
    final balanceDue = (finalTotal - prepaidAmount).clamp(0.0, 999999.0);
    final refund = (prepaidAmount - finalTotal).clamp(0.0, 999999.0);

    final depositDollars = loan.depositAuthorizedDollars ?? 250.00;

    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Règlement final',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Récapitulatif financier',
                    style: TextStyle(fontSize: 13, color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vérifiez le relevé d\'utilisation réel avant de confirmer la clôture et la libération de la caution.',
                style: TextStyle(fontSize: 13, color: Colors.blueGrey),
              ),
              const SizedBox(height: 16),

              // Utilization details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildBreakdownRow('Distance réelle parcourue', '$distanceKm km'),
                    const SizedBox(height: 6),
                    _buildBreakdownRow('Durée d\'utilisation réelle', '$durationHours h'),
                    if (loan.mileageStart != null && loan.mileageEnd != null) ...[
                      const SizedBox(height: 6),
                      _buildBreakdownRow('Compteur (départ / retour)', '${loan.mileageStart} / ${loan.mileageEnd} km'),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Financial breakdown (Subtotal, TPS, TVQ, Total)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildBreakdownRow('Contribution d\'utilisation (HT)', '${subtotal.toStringAsFixed(2)} \$'),
                    const SizedBox(height: 4),
                    _buildBreakdownRow('TPS (5 %)', '${tps.toStringAsFixed(2)} \$'),
                    const SizedBox(height: 4),
                    _buildBreakdownRow('TVQ (9,975 %)', '${tvq.toStringAsFixed(2)} \$'),
                    const Divider(height: 14),
                    _buildBreakdownRow(
                      'Total réel du prêt',
                      '${finalTotal.toStringAsFixed(2)} \$',
                      isBold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Reconciliation card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isPrepaid ? Colors.blue.shade50 : Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isPrepaid ? Colors.blue.shade200 : Colors.amber.shade300,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isPrepaid ? Icons.check_circle_outline : Icons.info_outline,
                          size: 18,
                          color: isPrepaid ? Colors.blue.shade800 : Colors.amber.shade900,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isPrepaid ? 'Prépaiement Stripe réconcilié' : 'Règlement final direct',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isPrepaid ? Colors.blue.shade900 : Colors.amber.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (isPrepaid) ...[
                      _buildBreakdownRow('Montant déjà prépayé', '${prepaidAmount.toStringAsFixed(2)} \$'),
                      const SizedBox(height: 4),
                      if (balanceDue > 0)
                        _buildBreakdownRow(
                          'Reliquat à régler',
                          '${balanceDue.toStringAsFixed(2)} \$',
                          isBold: true,
                          highlightColor: AppColors.danger,
                        )
                      else if (refund > 0)
                        _buildBreakdownRow(
                          'Trop-perçu à créditer',
                          '${refund.toStringAsFixed(2)} \$',
                          isBold: true,
                          highlightColor: AppColors.success,
                        )
                      else
                        _buildBreakdownRow('Reliquat / Solde dû', '0,00 \$', isBold: true),
                    ] else ...[
                      _buildBreakdownRow(
                        'Montant à débiter du solde',
                        '${finalTotal.toStringAsFixed(2)} \$',
                        isBold: true,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Caution / Deposit release guarantee
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined, color: Colors.green.shade800, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Caution bancaire Stripe',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Libération intégrale de l\'empreinte (${depositDollars.toStringAsFixed(0)} \$ CAD)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            key: const Key('confirm_settle_button'),
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmer & Clôturer'),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(
    String label,
    String value, {
    bool isBold = false,
    Color? highlightColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isBold ? Colors.black87 : Colors.blueGrey.shade700,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: highlightColor ?? (isBold ? Colors.black87 : Colors.blueGrey.shade900),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Future<void> _handleSettleLoan(Loan loan) async {
    if (loan.paidAt == null) {
      final confirmed = await _showFinancialBreakdownDialog(context, loan);
      if (confirmed != true) return;
    }

    setState(() {
      _isSettling = true;
      _screenError = null;
    });

    try {
      final success = await ref
          .read(loanSettleControllerProvider.notifier)
          .settleLoan(loanId: loan.id, releaseDeposit: true);
      if (!mounted) return;

      if (success) {
        final settleState = ref.read(loanSettleControllerProvider);
        final responseData =
            settleState is LoanSettleSuccess ? settleState.data : null;
        final depositStatus = responseData?['deposit_status'];
        final isDepositReleased = depositStatus == 'released' ||
            responseData?['deposit_released'] == true;
        final isReleaseFailed = depositStatus == 'release_failed' ||
            responseData?['deposit_release_failed'] == true;

        if (isReleaseFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Prêt clôturé, mais la libération de la caution a échoué. Vous pouvez réessayer.'),
              backgroundColor: AppColors.warning,
            ),
          );
        } else if (isDepositReleased) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prêt clôturé et caution libérée avec succès.'),
              backgroundColor: AppColors.success,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prêt clôturé avec succès.'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        final settleState = ref.read(loanSettleControllerProvider);
        final errorMsg = settleState is LoanSettleError
            ? settleState.message
            : 'Échec du règlement final.';
        setState(() {
          _screenError = errorMsg;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: AppColors.danger,
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
          _isSettling = false;
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
          if (loanAsync.hasValue && loanAsync.value?.loanableId != null)
            IconButton(
              key: const Key('report_incident_button'),
              icon: const Icon(Icons.report_problem_outlined),
              tooltip: 'Signaler un incident',
              onPressed: () {
                final loan = loanAsync.value!;
                context.push(
                  AppRoutes.incidentReportPath(
                    loanableId: loan.loanableId!,
                    vehicleName: loan.loanableName,
                    loanId: loan.id,
                    ownerName: loan.ownerUserName,
                    ownerPhone: loan.ownerUserPhone,
                    ownerEmail: loan.ownerUserEmail,
                  ),
                );
              },
            ),
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
          final canTakeOver = loan.canTakeOver(currentUser?.id);
          final canReturnVehicle = loan.canReturnVehicle(currentUser?.id);
          final canValidateReturn = loan.canValidateReturn(currentUser?.id);
          final canSettleAndClose = loan.canSettleAndClose(currentUser?.id);
          final canRequestExtension = loan.canRequestExtension(currentUser?.id);
          final canAcceptExtension = loan.canAcceptExtension(currentUser?.id);
          final canRejectExtension = loan.canRejectExtension(currentUser?.id);
          final canCancelExtension = loan.canCancelExtension(currentUser?.id);
          final hasPendingExtension = loan.hasPendingExtension;
          final isTakeOverUpcoming = !canTakeOver &&
              !loan.departureInspectionCompleted &&
              status == LoanStatus.confirmed &&
              (isOwner ||
                  currentUser?.id == loan.borrowerUserId ||
                  loan.borrowerUserId == null);
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
                          if (hasPendingExtension && loan.extendedReturnAt != null) ...[
                            const SizedBox(height: 6),
                            Container(
                              key: const Key('slot_pending_extension_badge'),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.orange.shade200),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.more_time,
                                    size: 14,
                                    color: Colors.orange.shade800,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      'Prolongation demandée : +${loan.pendingExtensionAdditionalMinutes ?? ''} min (fin : ${LoanDateFormatter.formatInVehicleZone(loan.extendedReturnAt, vehicleTimezone: loan.loanable?.timezone)})',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange.shade900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

                  // Departure Take-Over Action (Prendre en charge le véhicule)
                  if (canTakeOver) ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      key: const Key('action_take_over_button'),
                      onPressed: () =>
                          context.push(AppRoutes.loanDeparturePath(loan.id)),
                      icon: const Icon(
                        Icons.directions_car_filled_outlined,
                        size: 20,
                      ),
                      label: const Text(
                        'Prendre en charge le véhicule',
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

                  // Departure window upcoming notice
                  if (isTakeOverUpcoming) ...[
                    const SizedBox(height: 12),
                    Container(
                      key: const Key('take_over_window_upcoming_card'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'La prise en charge sera disponible 1 heure avant le départ.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Certified Departure Inspection Badge
                  if (loan.departureInspectionCompleted) ...[
                    const SizedBox(height: 12),
                    Container(
                      key: const Key('departure_inspection_completed_badge'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.green.shade700,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'État des lieux de départ certifié',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Return Vehicle Action (Restituer le véhicule)
                  if (canReturnVehicle) ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      key: const Key('action_return_vehicle_button'),
                      onPressed: () =>
                          context.push(AppRoutes.loanReturnPath(loan.id)),
                      icon: const Icon(
                        Icons.assignment_turned_in_outlined,
                        size: 20,
                      ),
                      label: const Text(
                        'Restituer le véhicule',
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

                  // Owner Pending Extension Decision Card
                  if (hasPendingExtension && (canAcceptExtension || canRejectExtension)) ...[
                    const SizedBox(height: 12),
                    Container(
                      key: const Key('owner_pending_extension_card'),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.more_time,
                                color: Colors.amber.shade800,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Demande de prolongation reçue',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'L\'emprunteur demande une prolongation de +${loan.pendingExtensionAdditionalMinutes ?? ''} min (nouveau retour prévu à ${loan.extendedReturnAt != null ? LoanDateFormatter.formatInVehicleZone(loan.extendedReturnAt, vehicleTimezone: loan.loanable?.timezone) : ''}).',
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (canAcceptExtension)
                                Expanded(
                                  child: ElevatedButton.icon(
                                    key: const Key('action_accept_extension_button'),
                                    onPressed: _isDecidingExtension
                                        ? null
                                        : () => _handleAcceptExtension(loan),
                                    icon: _isDecidingExtension
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Icon(Icons.check, size: 18),
                                    label: const Text('Accepter'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.success,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              if (canAcceptExtension && canRejectExtension)
                                const SizedBox(width: 8),
                              if (canRejectExtension)
                                Expanded(
                                  child: OutlinedButton.icon(
                                    key: const Key('action_reject_extension_button'),
                                    onPressed: _isDecidingExtension
                                        ? null
                                        : () => _handleRejectExtension(loan),
                                    icon: const Icon(Icons.close, size: 18),
                                    label: const Text('Refuser'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.danger,
                                      side: const BorderSide(color: AppColors.danger),
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Borrower Pending Extension Card
                  if (hasPendingExtension && canCancelExtension) ...[
                    const SizedBox(height: 12),
                    Container(
                      key: const Key('borrower_pending_extension_card'),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.hourglass_top_rounded,
                                color: Colors.blue.shade700,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Prolongation en attente d\'approbation',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Votre demande de prolongation de +${loan.pendingExtensionAdditionalMinutes ?? ''} min (jusqu\'à ${loan.extendedReturnAt != null ? LoanDateFormatter.formatInVehicleZone(loan.extendedReturnAt, vehicleTimezone: loan.loanable?.timezone) : ''}) est en attente de réponse du propriétaire.',
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            key: const Key('action_cancel_extension_button'),
                            onPressed: _isDecidingExtension
                                ? null
                                : () => _handleCancelExtension(loan),
                            icon: const Icon(Icons.cancel_outlined, size: 16),
                            label: const Text('Annuler la demande de prolongation'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.danger,
                              side: const BorderSide(color: AppColors.danger),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Request Extension Action (Prolonger la réservation)
                  if (canRequestExtension) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      key: const Key('action_request_extension_button'),
                      onPressed: () => _handleOpenExtension(loan),
                      icon: const Icon(Icons.more_time_rounded, size: 20),
                      label: const Text(
                        'Prolonger la réservation',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],

                  // Certified Return Inspection Badge
                  if (loan.returnInspectionCompleted) ...[
                    const SizedBox(height: 12),
                    Container(
                      key: const Key('return_inspection_completed_badge'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.green.shade700,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'État des lieux de retour certifié',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Contradictory Validation Card
                  if (canValidateReturn) ...[
                    const SizedBox(height: 12),
                    Container(
                      key: const Key('owner_contradictory_validation_card'),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.rule_rounded,
                                color: Colors.amber.shade800,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Validation contradictoire requise',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Le véhicule a été restitué. Confirmez la conformité des relevés pour valider le retour.',
                            style: TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            key: const Key('action_owner_validate_return_button'),
                            onPressed: _isValidating
                                ? null
                                : () => _handleValidateReturn(loan),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: _isValidating
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text('Valider le retour'),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Settlement & Closing Action (Régler & clôturer le prêt)
                  if (canSettleAndClose) ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      key: const Key('action_settle_loan_button'),
                      onPressed:
                          _isSettling ? null : () => _handleSettleLoan(loan),
                      icon: const Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                      ),
                      label: _isSettling
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Régler & clôturer le prêt',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],

                  // Finalized Paid & Settled Badge
                  if (loan.paidAt != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      key: const Key('loan_settled_badge'),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: loan.isDepositReleaseFailed
                            ? Colors.amber.shade50
                            : Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: loan.isDepositReleaseFailed
                              ? Colors.amber.shade300
                              : Colors.teal.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            loan.isDepositReleaseFailed
                                ? Icons.warning_amber_rounded
                                : Icons.check_circle_rounded,
                            color: loan.isDepositReleaseFailed
                                ? Colors.amber.shade800
                                : Colors.teal.shade700,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              loan.isDepositReleaseFailed
                                  ? 'Règlement finalisé — échec de libération caution'
                                  : (loan.isMotorized && !loan.isDepositReleased
                                      ? 'Règlement finalisé'
                                      : 'Règlement finalisé et caution libérée'),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: loan.isDepositReleaseFailed
                                    ? Colors.amber.shade900
                                    : Colors.teal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Retry Deposit Release Action if initial release failed
                  if (loan.canRetryReleaseDeposit(currentUser?.id)) ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      key: const Key('action_retry_release_deposit_button'),
                      onPressed:
                          _isSettling ? null : () => _handleSettleLoan(loan),
                      icon: const Icon(
                        Icons.replay_rounded,
                        size: 20,
                      ),
                      label: _isSettling
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Réessayer la libération de la caution',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.warning,
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

                  // Incident Reporting Card
                  if (loan.loanableId != null) ...[
                    const SizedBox(height: 12),
                    Card(
                      key: const Key('incident_assistance_card'),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.orange.shade200),
                      ),
                      color: Colors.orange.shade50.withValues(alpha: 0.5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.report_problem_outlined,
                              color: Colors.orange.shade800,
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Incident ou imprévu ?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    'Panne, retard, crevaison ou dommage : signalez-le sans attendre.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              key: const Key('report_incident_link_button'),
                              onPressed: () {
                                context.push(
                                  AppRoutes.incidentReportPath(
                                    loanableId: loan.loanableId!,
                                    vehicleName: loan.loanableName,
                                    loanId: loan.id,
                                    ownerName: loan.ownerUserName,
                                    ownerPhone: loan.ownerUserPhone,
                                    ownerEmail: loan.ownerUserEmail,
                                  ),
                                );
                              },
                              child: const Text('Signaler'),
                            ),
                          ],
                        ),
                      ),
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

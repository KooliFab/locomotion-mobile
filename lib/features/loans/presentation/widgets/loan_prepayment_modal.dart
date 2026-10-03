import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/payment_intent_response.dart';
import '../controllers/loan_payment_controller.dart';

class LoanPrepaymentModal extends ConsumerStatefulWidget {
  final Loan loan;

  const LoanPrepaymentModal({
    super.key,
    required this.loan,
  });

  static Future<void> show(BuildContext context, Loan loan) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LoanPrepaymentModal(loan: loan),
    );
  }

  @override
  ConsumerState<LoanPrepaymentModal> createState() =>
      _LoanPrepaymentModalState();
}

class _LoanPrepaymentModalState extends ConsumerState<LoanPrepaymentModal> {
  int _selectedTipCents = 200; // default 2 $ CAD
  bool _useBalance = true;
  PaymentIntentResponse? _intentResponse;
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBreakdown();
    });
  }

  Future<void> _loadBreakdown() async {
    final int currentId = ++_requestId;
    final response =
        await ref.read(loanPaymentControllerProvider.notifier).fetchBreakdown(
              widget.loan.id,
              platformTipCents: _selectedTipCents,
              useBalance: _useBalance,
            );
    if (mounted && currentId == _requestId) {
      setState(() {
        _intentResponse = response;
      });
    }
  }

  void _onTipSelected(int tipCents) {
    if (_selectedTipCents == tipCents) return;
    setState(() {
      _selectedTipCents = tipCents;
    });
    _loadBreakdown();
  }

  void _onToggleBalance(bool? value) {
    final newValue = value ?? true;
    if (_useBalance == newValue) return;
    setState(() {
      _useBalance = newValue;
    });
    _loadBreakdown();
  }

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(loanPaymentControllerProvider);
    final breakdown = _intentResponse?.financialBreakdown;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              const Icon(Icons.payment, color: AppColors.primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Prépaiement & Caution',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      widget.loan.displayLoanableName,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(height: 24),

          // Body depending on state
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (paymentState is LoanPaymentLoadingBreakdown &&
                      breakdown == null) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('Calcul de l\'estimation financière...'),
                          ],
                        ),
                      ),
                    ),
                  ] else if (paymentState is LoanPaymentSuccess) ...[
                    _buildSuccessView(context),
                  ] else ...[
                    if (breakdown != null) ...[
                      _buildFinancialBreakdownCard(breakdown),
                      const SizedBox(height: 16),
                      _buildTipSelector(),
                      const SizedBox(height: 16),
                      if (breakdown.hasDeposit) ...[
                        _buildSecurityDepositNotice(breakdown),
                        const SizedBox(height: 16),
                      ],
                    ],
                    if (paymentState is LoanPaymentError) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    paymentState.message,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton.icon(
                              onPressed: () async {
                                await ref
                                    .read(loanPaymentControllerProvider.notifier)
                                    .checkServerStatus(widget.loan.id);
                              },
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Vérifier le statut du prêt'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red.shade900,
                                side: BorderSide(color: Colors.red.shade300),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),

          // Action Button
          if (paymentState is! LoanPaymentSuccess) ...[
            const SizedBox(height: 16),
            _buildActionButton(paymentState, breakdown),
          ],
        ],
      ),
    );
  }

  Widget _buildFinancialBreakdownCard(dynamic breakdown) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildRow(
              'Contribution trajet estimée',
              '${breakdown.mandatoryContributionDollars.toStringAsFixed(2)} \$',
            ),
            if (breakdown.taxesTpsCents > 0 || breakdown.taxesTvqCents > 0) ...[
              const SizedBox(height: 6),
              _buildRow(
                'Taxes québécoises (TPS + TVQ)',
                '${(breakdown.taxesTpsDollars + breakdown.taxesTvqDollars).toStringAsFixed(2)} \$',
                isSubtext: true,
              ),
            ],
            if (breakdown.platformTipCents > 0) ...[
              const SizedBox(height: 6),
              _buildRow(
                'Soutien à la plateforme LocoMotion',
                '${breakdown.platformTipDollars.toStringAsFixed(2)} \$',
              ),
            ],
            if (breakdown.hasBalanceDeduction || !_useBalance) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Utiliser mon solde disponible',
                    style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
                  ),
                  Switch.adaptive(
                    value: _useBalance,
                    onChanged: _onToggleBalance,
                    activeTrackColor: AppColors.primary,
                  ),
                ],
              ),
              if (_useBalance && breakdown.hasBalanceDeduction) ...[
                const SizedBox(height: 4),
                _buildRow(
                  'Déduction de votre solde',
                  '-${breakdown.userBalanceAppliedDollars.toStringAsFixed(2)} \$',
                  color: Colors.green.shade700,
                ),
              ],
            ],
            const Divider(height: 20),
            _buildRow(
              'Total à régler maintenant',
              '${breakdown.remainingContributionToPayDollars.toStringAsFixed(2)} \$ CAD',
              isBold: true,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool isBold = false,
    bool isSubtext = false,
    double fontSize = 14,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSubtext ? 12 : fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isSubtext ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildTipSelector() {
    final tipOptions = [0, 200, 500, 1000];
    final paymentState = ref.watch(loanPaymentControllerProvider);
    final isProcessing = paymentState is LoanPaymentProcessing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ajouter un pourboire pour soutenir LocoMotion :',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Row(
          children: tipOptions.map((tip) {
            final isSelected = _selectedTipCents == tip;
            final label = tip == 0 ? '0 \$' : '${(tip / 100).toInt()} \$';
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: isProcessing ? null : (_) => _onTipSelected(tip),
                  selectedColor: AppColors.primary.withAlpha(40),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSecurityDepositNotice(dynamic breakdown) {
    return Container(
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
              Icon(Icons.shield, color: Colors.amber.shade900, size: 20),
              const SizedBox(width: 8),
              Text(
                'Caution requise : ${breakdown.securityDepositDollars.toStringAsFixed(2)} \$ CAD',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Une empreinte bancaire sera retenue temporairement sur votre carte (valide 7 jours). Aucun montant ne sera encaissé si le véhicule est restitué sans dommage.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(LoanPaymentState state, dynamic breakdown) {
    final isLoading = state is LoanPaymentProcessing ||
        state is LoanPaymentLoadingBreakdown;

    final isTipSyncing = _intentResponse == null ||
        _intentResponse!.financialBreakdown.platformTipCents !=
            _selectedTipCents;

    final requiresStripe = _intentResponse?.requiresStripeAction ?? true;
    final label = requiresStripe
        ? 'Payer & bloquer la caution'
        : 'Confirmer avec mon solde';

    final isButtonDisabled =
        isLoading || _intentResponse == null || isTipSyncing;

    return ElevatedButton(
      onPressed: isButtonDisabled
          ? null
          : () async {
              await ref
                  .read(loanPaymentControllerProvider.notifier)
                  .confirmPayment(
                    loanId: widget.loan.id,
                    intentResponse: _intentResponse!,
                    platformTipCents:
                        _intentResponse!.financialBreakdown.platformTipCents,
                  );
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  state is LoanPaymentProcessing
                      ? state.message
                      : 'Chargement...',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )
          : isTipSyncing
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Mise à jour du montant...',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : Text(
                  label,
                  style:
                      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
    );
  }

  Widget _buildSuccessView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Prépaiement confirmé !',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Votre réservation est confirmée et votre caution a été enregistrée avec succès.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer et voir la réservation'),
          ),
        ],
      ),
    );
  }
}

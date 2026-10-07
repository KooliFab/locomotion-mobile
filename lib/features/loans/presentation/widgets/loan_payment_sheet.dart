import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/invoice_summary.dart';
import '../../domain/entities/loan.dart';
import '../controllers/loan_payment_controller.dart';

/// Prepayment (accepted loan) or final payment (validated loan), following
/// the web payment box: the server computes the invoice, the balance is topped
/// up with a saved card when needed, then `/prepay` or `/pay` is called.
class LoanPaymentSheet extends ConsumerStatefulWidget {
  final Loan loan;
  final LoanPaymentAction action;

  const LoanPaymentSheet({super.key, required this.loan, required this.action});

  /// Returns `true` once the server has applied the payment action.
  static Future<bool?> show(
    BuildContext context,
    Loan loan,
    LoanPaymentAction action,
  ) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LoanPaymentSheet(loan: loan, action: action),
    );
  }

  @override
  ConsumerState<LoanPaymentSheet> createState() => _LoanPaymentSheetState();
}

class _LoanPaymentSheetState extends ConsumerState<LoanPaymentSheet> {
  final _topUpController = TextEditingController();

  LoanPaymentController get _controller =>
      ref.read(loanPaymentControllerProvider(widget.loan.id).notifier);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.load(widget.loan);
    });
  }

  @override
  void dispose() {
    _topUpController.dispose();
    super.dispose();
  }

  String get _title => widget.action == LoanPaymentAction.prepay
      ? 'Prépayer la réservation'
      : 'Payer et clôturer l\'emprunt';

  String _money(double value) => '${value.toStringAsFixed(2)} \$';

  List<double> _tipChoices() {
    final choices = <double>{0, 2, 5, 10};
    final desired = widget.loan.desiredContribution;
    if (desired != null && desired > 0) choices.add(desired);
    return choices.toList()..sort();
  }

  Future<void> _submit(LoanPaymentState state) async {
    double? topUp;
    if (state.needsTopUp) {
      topUp = double.tryParse(_topUpController.text.replaceAll(',', '.'));
      topUp ??= state.missingAmount;
    }
    final ok = await _controller.submit(
      action: widget.action,
      topUpAmount: topUp,
    );
    if (!mounted || !ok) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loanPaymentControllerProvider(widget.loan.id));

    if (state.needsTopUp && _topUpController.text.isEmpty) {
      _topUpController.text = state.missingAmount.toStringAsFixed(2);
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              if (state.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                if (widget.loan.borrowerMayContribute &&
                    !widget.loan.isExemptFromContributions)
                  _buildTipSelector(state),
                _buildInvoice(state),
                const SizedBox(height: 12),
                _buildBalance(state),
                if (state.needsTopUp) _buildTopUp(state),
              ],
              if (state.error != null) ...[
                const SizedBox(height: 12),
                Container(
                  key: const Key('payment_error'),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.dangerBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    state.error!,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                key: const Key('payment_submit_button'),
                onPressed: state.loading || state.submitting || state.estimating
                    ? null
                    : () => _submit(state),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: state.submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        _submitLabel(state),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _submitLabel(LoanPaymentState state) {
    final action = widget.action == LoanPaymentAction.prepay
        ? 'prépayer'
        : 'payer';
    if (state.needsTopUp) return 'Ajouter au solde et $action';
    return action == 'prépayer' ? 'Prépayer' : 'Payer';
  }

  Widget _buildTipSelector(LoanPaymentState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contribution volontaire à LocoMotion',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final tip in _tipChoices())
                ChoiceChip(
                  key: Key('tip_choice_${tip.toStringAsFixed(2)}'),
                  label: Text(_money(tip)),
                  selected: state.platformTip == tip,
                  onSelected: state.submitting
                      ? null
                      : (_) => _controller.setPlatformTip(tip),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoice(LoanPaymentState state) {
    final invoice = state.invoice;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (invoice == null || invoice.isEmpty)
            const Text('Aucun montant à payer pour cet emprunt.')
          else
            for (final item in invoice.items) _buildInvoiceRow(item),
          const Divider(),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (state.estimating)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Text(
                  _money(state.amountDue),
                  key: const Key('payment_amount_due'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceRow(InvoiceSummaryItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(item.label)),
          Text(_money(-item.total)),
        ],
      ),
    );
  }

  Widget _buildBalance(LoanPaymentState state) {
    return Row(
      children: [
        const Expanded(child: Text('Solde de votre compte')),
        Text(_money(state.balance ?? 0), key: const Key('payment_balance')),
      ],
    );
  }

  Widget _buildTopUp(LoanPaymentState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Votre solde est insuffisant : ajoutez au moins ${_money(state.missingAmount)}.',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('payment_top_up_amount'),
            controller: _topUpController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            decoration: const InputDecoration(
              labelText: 'Montant à ajouter',
              suffixText: '\$',
            ),
          ),
          const SizedBox(height: 8),
          if (state.paymentMethods.isEmpty)
            const Text(
              'Aucune carte enregistrée. Ajoutez une carte depuis le site web LocoMotion pour approvisionner votre solde.',
              key: Key('payment_no_card'),
              style: TextStyle(color: AppColors.textSecondary),
            )
          else
            DropdownButtonFormField<int>(
              key: const Key('payment_method_select'),
              initialValue: state.selectedPaymentMethodId,
              decoration: const InputDecoration(labelText: 'Carte'),
              items: [
                for (final m in state.paymentMethods)
                  DropdownMenuItem(
                    value: m.id,
                    child: Text('${m.brandDisplay} ${m.maskedNumber}'),
                  ),
              ],
              onChanged: (id) {
                if (id != null) _controller.selectPaymentMethod(id);
              },
            ),
          const SizedBox(height: 6),
          const Text(
            'Des frais de transaction Stripe s\'ajoutent au montant débité ; ils sont calculés par LocoMotion et figurent sur votre facture.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

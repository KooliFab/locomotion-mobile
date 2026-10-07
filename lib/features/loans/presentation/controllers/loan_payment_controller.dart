import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/exceptions.dart';
import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../data/repositories/loan_payment_repository_impl.dart';
import '../../domain/entities/invoice_summary.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_status.dart';
import '../../domain/entities/payment_method_model.dart';
import '../../domain/repositories/loan_payment_repository.dart';
import '../../domain/repositories/loans_repository.dart';
import 'loans_controller.dart';

/// `prepay` for an accepted loan, `pay` for a validated loan (web LoanPaymentBox).
enum LoanPaymentAction { prepay, pay }

class LoanPaymentState {
  final bool loading;
  final double platformTip;
  final InvoiceSummary? invoice;
  final bool estimating;
  final double? balance;
  final List<PaymentMethodModel> paymentMethods;
  final int? selectedPaymentMethodId;
  final bool submitting;
  final String? error;
  final Loan? completedLoan;

  const LoanPaymentState({
    this.loading = true,
    this.platformTip = 0,
    this.invoice,
    this.estimating = false,
    this.balance,
    this.paymentMethods = const [],
    this.selectedPaymentMethodId,
    this.submitting = false,
    this.error,
    this.completedLoan,
  });

  /// Amount owed for the current contribution, as computed by the server.
  double get amountDue => invoice?.amountDue ?? 0;

  /// Amount to add to the balance before the server accepts the payment.
  double get missingAmount {
    final missing = amountDue - (balance ?? 0);
    return missing > 0 ? _roundUpToCent(missing) : 0;
  }

  bool get needsTopUp => missingAmount > 0;

  bool get isDone => completedLoan != null;

  LoanPaymentState copyWith({
    bool? loading,
    double? platformTip,
    InvoiceSummary? invoice,
    bool clearInvoice = false,
    bool? estimating,
    double? balance,
    List<PaymentMethodModel>? paymentMethods,
    int? selectedPaymentMethodId,
    bool? submitting,
    String? error,
    bool clearError = false,
    Loan? completedLoan,
  }) {
    return LoanPaymentState(
      loading: loading ?? this.loading,
      platformTip: platformTip ?? this.platformTip,
      invoice: clearInvoice ? null : (invoice ?? this.invoice),
      estimating: estimating ?? this.estimating,
      balance: balance ?? this.balance,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedPaymentMethodId:
          selectedPaymentMethodId ?? this.selectedPaymentMethodId,
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
      completedLoan: completedLoan ?? this.completedLoan,
    );
  }
}

double _roundUpToCent(double value) => (value * 100).ceil() / 100;

/// Initial contribution, following the web payment box.
double initialPlatformTip(Loan loan) {
  if (loan.isExemptFromContributions) return 0;
  final tip = loan.platformTip;
  if (tip != null && tip > 0) return tip;
  return loan.desiredContribution ?? 0;
}

class LoanPaymentController extends Notifier<LoanPaymentState> {
  LoanPaymentController(this.loanId);

  final int loanId;

  late LoanPaymentRepository _repository;
  late LoansRepository _loansRepository;
  int _estimateRequestId = 0;

  @override
  LoanPaymentState build() {
    _repository = ref.watch(loanPaymentRepositoryProvider);
    _loansRepository = ref.watch(loansRepositoryProvider);
    return const LoanPaymentState();
  }

  /// Loads balance, saved cards and the invoice for the initial contribution.
  Future<void> load(Loan loan) async {
    final tip = initialPlatformTip(loan);
    state = LoanPaymentState(loading: true, platformTip: tip);
    try {
      final results = await Future.wait([
        ref.read(userBalanceControllerProvider.future),
        _repository.getPaymentMethods(),
      ]);
      final methods = results[1] as List<PaymentMethodModel>;
      final defaultMethod = methods.where((m) => m.isDefault).firstOrNull;
      state = state.copyWith(
        loading: false,
        balance: results[0] as double,
        paymentMethods: methods,
        selectedPaymentMethodId: (defaultMethod ?? methods.firstOrNull)?.id,
        invoice: loan.borrowerInvoice,
      );
      await _estimate(tip);
    } catch (e) {
      state = state.copyWith(loading: false, error: _messageOf(e));
    }
  }

  Future<void> setPlatformTip(double tip) async {
    final normalized = math.max(0.0, (tip * 100).roundToDouble() / 100);
    if (normalized == state.platformTip && state.invoice != null) return;
    state = state.copyWith(platformTip: normalized, clearError: true);
    await _estimate(normalized);
  }

  void selectPaymentMethod(int id) {
    state = state.copyWith(selectedPaymentMethodId: id);
  }

  Future<void> _estimate(double tip) async {
    final requestId = ++_estimateRequestId;
    state = state.copyWith(estimating: true);
    try {
      final invoice = await _repository.estimateBorrowerInvoice(
        loanId: loanId,
        platformTip: tip,
      );
      if (requestId != _estimateRequestId) return;
      state = invoice == null
          ? state.copyWith(estimating: false, clearInvoice: true)
          : state.copyWith(estimating: false, invoice: invoice);
    } catch (e) {
      if (requestId != _estimateRequestId) return;
      state = state.copyWith(estimating: false, error: _messageOf(e));
    }
  }

  /// Tops up the balance when needed, then prepays or pays the loan.
  ///
  /// The top-up is a separate server operation: if it succeeds but the loan
  /// action fails, the balance already covers the amount and a retry does not
  /// charge the card again.
  Future<bool> submit({
    required LoanPaymentAction action,
    double? topUpAmount,
  }) async {
    if (state.submitting || state.estimating) return false;
    state = state.copyWith(submitting: true, clearError: true);

    try {
      if (state.needsTopUp) {
        final amount = topUpAmount ?? state.missingAmount;
        if (amount < state.missingAmount) {
          throw ValidationException(
            message:
                'Le montant ajouté doit être d\'au moins ${state.missingAmount.toStringAsFixed(2)} \$.',
          );
        }
        if (state.selectedPaymentMethodId == null) {
          throw const ValidationException(
            message:
                'Aucune carte enregistrée. Ajoutez une carte depuis le site web LocoMotion.',
          );
        }
        final newBalance = await _repository.addToBalance(
          amount: amount,
          paymentMethodId: state.selectedPaymentMethodId,
        );
        ref.invalidate(userBalanceControllerProvider);
        state = state.copyWith(balance: newBalance);
      }

      final loan = action == LoanPaymentAction.prepay
          ? await _repository.prepay(
              loanId: loanId,
              platformTip: state.platformTip,
            )
          : await _repository.pay(
              loanId: loanId,
              platformTip: state.platformTip,
            );
      _onCompleted(loan);
      return true;
    } catch (e) {
      // The server may have applied the action before the error reached us.
      final recovered = await _reloadIfApplied(action);
      if (recovered) return true;
      state = state.copyWith(submitting: false, error: _messageOf(e));
      return false;
    }
  }

  Future<bool> _reloadIfApplied(LoanPaymentAction action) async {
    try {
      final loan = await _loansRepository.getLoanDetail(loanId);
      final applied = action == LoanPaymentAction.prepay
          ? loan.parsedStatus != LoanStatus.accepted &&
                loan.parsedStatus != LoanStatus.requested
          : loan.parsedStatus == LoanStatus.completed;
      if (applied) {
        _onCompleted(loan);
        return true;
      }
    } catch (_) {}
    return false;
  }

  void _onCompleted(Loan loan) {
    invalidateLoanViews(ref, loanId: loanId, loanableId: loan.loanableId);
    ref.invalidate(userBalanceControllerProvider);
    state = state.copyWith(submitting: false, completedLoan: loan);
  }

  String _messageOf(Object e) {
    if (e is AppException) return e.message;
    return e.toString().replaceFirst('Exception: ', '');
  }
}

final loanPaymentControllerProvider = NotifierProvider.autoDispose
    .family<LoanPaymentController, LoanPaymentState, int>(
      LoanPaymentController.new,
    );

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/repositories/loan_inspection_repository.dart';
import '../../domain/repositories/loans_repository.dart';
import 'loan_inspection_providers.dart';
import 'loans_controller.dart';

sealed class LoanSettleState {
  const LoanSettleState();
}

class LoanSettleInitial extends LoanSettleState {
  const LoanSettleInitial();
}

class LoanSettleProcessing extends LoanSettleState {
  final String message;
  const LoanSettleProcessing({this.message = 'Règlement final en cours...'});
}

class LoanSettleSuccess extends LoanSettleState {
  final Map<String, dynamic> responseData;
  Map<String, dynamic> get data => responseData;
  const LoanSettleSuccess(this.responseData);
}

class LoanSettleError extends LoanSettleState {
  final String message;
  const LoanSettleError(this.message);
}

class LoanSettleController extends Notifier<LoanSettleState> {
  late final LoanInspectionRepository _inspectionRepository;
  late final LoansRepository _loansRepository;

  @override
  LoanSettleState build() {
    _inspectionRepository = ref.watch(loanInspectionRepositoryProvider);
    _loansRepository = ref.watch(loansRepositoryProvider);
    return const LoanSettleInitial();
  }

  Future<bool> settleLoan({
    required int loanId,
    bool releaseDeposit = true,
    int incidentClaimCents = 0,
  }) async {
    state = const LoanSettleProcessing();

    try {
      final response = await _inspectionRepository.settleLoan(
        loanId: loanId,
        releaseDeposit: releaseDeposit,
        incidentClaimCents: incidentClaimCents,
      );

      // Invalidate loan details and list
      invalidateLoanViews(ref, loanId: loanId);

      state = LoanSettleSuccess(response);
      return true;
    } catch (e) {
      // Check server status in case of timeout
      try {
        final refreshed = await _loansRepository.getLoanDetail(loanId);
        if (refreshed.paidAt != null) {
          invalidateLoanViews(ref, loanId: loanId);
          state = LoanSettleSuccess({
            'status': 'completed',
            'paid_at': refreshed.paidAt?.toIso8601String(),
          });
          return true;
        }
      } catch (_) {}

      final String errorMessage = e is AppException
          ? e.message
          : (e is Exception
                ? e.toString().replaceFirst('Exception: ', '')
                : e.toString());
      state = LoanSettleError('Erreur lors du règlement final : $errorMessage');
      return false;
    }
  }

  void reset() {
    state = const LoanSettleInitial();
  }
}

final loanSettleControllerProvider =
    NotifierProvider<LoanSettleController, LoanSettleState>(
      LoanSettleController.new,
    );

import '../entities/loan.dart';

abstract class LoansRepository {
  Future<List<Loan>> getMyLoans();
  Future<Loan> createLoan({
    required int loanableId,
    required DateTime startAt,
    required DateTime endAt,
  });
  Future<void> cancelLoan(int loanId);
  Future<void> returnLoan(int loanId);
}

import '../entities/loan.dart';
import '../entities/loan_creation_request.dart';
import '../entities/loans_dashboard.dart';

abstract class LoansRepository {
  Future<LoansDashboard> getDashboard();
  Future<Loan> createLoan(LoanCreationRequest request);
  Future<List<Loan>> getMyLoans();
}

import 'dart:io';

import '../entities/extension_estimate.dart';
import '../entities/loan.dart';
import '../entities/loan_comment.dart';
import '../entities/loan_creation_request.dart';
import '../entities/loan_dates_update_request.dart';
import '../entities/loan_factors_update.dart';
import '../entities/loan_pagination.dart';
import '../entities/loans_dashboard.dart';

abstract class LoansRepository {
  Future<LoansDashboard> getDashboard();
  Future<Loan> createLoan(LoanCreationRequest request);
  Future<List<Loan>> getMyLoans();
  Future<Loan> getLoanDetail(int id);
  Future<LoanPagination> getLoansPage({
    int page = 1,
    int perPage = 10,
    String? status,
    int? borrowerUserId,
  });
  Future<Loan> cancelLoan(int id);
  Future<Loan> acceptLoan(int id, {String? comment});
  Future<Loan> rejectLoan(int id, {String? comment});
  Future<Loan> validateLoan(int id);
  Future<Loan> updateLoanDates(int id, LoanDatesUpdateRequest request);
  Future<LoanComment> addComment(int id, String text);
  Future<Loan> requestExtension(int id, int extensionDurationInMinutes);
  Future<Loan> acceptExtension(int id);
  Future<Loan> rejectExtension(int id);
  Future<Loan> cancelExtension(int id);
  Future<ExtensionEstimate> getExtensionEstimate(int id, int durationInMinutes);
  Future<Loan> updateFactors(int id, LoanFactorsUpdate update);
  Future<Loan> endLoanEarly(int id);
  Future<Map<String, dynamic>> uploadImage(File file, String field);
}

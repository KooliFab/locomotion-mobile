import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_comment.dart';
import '../../domain/entities/loan_creation_request.dart';
import '../../domain/entities/loan_dates_update_request.dart';
import '../../domain/entities/loan_pagination.dart';
import '../../domain/entities/loans_dashboard.dart';
import '../../domain/repositories/loans_repository.dart';
import '../datasources/loans_remote_data_source.dart';

class LoansRepositoryImpl implements LoansRepository {
  final LoansRemoteDataSource _remoteDataSource;

  const LoansRepositoryImpl(this._remoteDataSource);

  @override
  Future<LoansDashboard> getDashboard() {
    return _remoteDataSource.getDashboard();
  }

  @override
  Future<Loan> createLoan(LoanCreationRequest request) {
    return _remoteDataSource.createLoan(request);
  }

  @override
  Future<List<Loan>> getMyLoans() {
    return _remoteDataSource.getMyLoans();
  }

  @override
  Future<Loan> getLoanDetail(int id) {
    return _remoteDataSource.getLoanDetail(id);
  }

  @override
  Future<LoanPagination> getLoansPage({
    int page = 1,
    int perPage = 10,
    String? status,
    int? borrowerUserId,
  }) {
    return _remoteDataSource.getLoansPage(
      page: page,
      perPage: perPage,
      status: status,
      borrowerUserId: borrowerUserId,
    );
  }

  @override
  Future<Loan> cancelLoan(int id) {
    return _remoteDataSource.cancelLoan(id);
  }

  @override
  Future<Loan> acceptLoan(int id, {String? comment}) {
    return _remoteDataSource.acceptLoan(id, comment: comment);
  }

  @override
  Future<Loan> rejectLoan(int id, {String? comment}) {
    return _remoteDataSource.rejectLoan(id, comment: comment);
  }

  @override
  Future<Loan> updateLoanDates(int id, LoanDatesUpdateRequest request) {
    return _remoteDataSource.updateLoanDates(id, request);
  }

  @override
  Future<LoanComment> addComment(int id, String text) {
    return _remoteDataSource.addComment(id, text);
  }
}

import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_creation_request.dart';
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
}

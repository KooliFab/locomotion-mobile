import '../../domain/entities/loan.dart';
import '../../domain/repositories/loans_repository.dart';
import '../datasources/loans_remote_data_source.dart';

class LoansRepositoryImpl implements LoansRepository {
  final LoansRemoteDataSource _remoteDataSource;

  const LoansRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Loan>> getMyLoans() {
    return _remoteDataSource.getMyLoans();
  }

  @override
  Future<Loan> createLoan({
    required int loanableId,
    required DateTime startAt,
    required DateTime endAt,
  }) {
    return _remoteDataSource.createLoan(
      loanableId: loanableId,
      startAt: startAt,
      endAt: endAt,
    );
  }

  @override
  Future<void> cancelLoan(int loanId) {
    return _remoteDataSource.cancelLoan(loanId);
  }

  @override
  Future<void> returnLoan(int loanId) {
    return _remoteDataSource.returnLoan(loanId);
  }
}

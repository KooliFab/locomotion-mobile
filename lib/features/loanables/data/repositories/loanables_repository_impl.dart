import '../../domain/entities/loanable.dart';
import '../../domain/repositories/loanables_repository.dart';
import '../datasources/loanables_remote_data_source.dart';

class LoanablesRepositoryImpl implements LoanablesRepository {
  final LoanablesRemoteDataSource _remoteDataSource;

  const LoanablesRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Loanable>> getLoanables({String? type, int? communityId}) {
    return _remoteDataSource.getLoanables(type: type, communityId: communityId);
  }

  @override
  Future<Loanable> getLoanableDetails(int id) {
    return _remoteDataSource.getLoanableDetails(id);
  }
}

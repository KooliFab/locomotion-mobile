import '../../domain/entities/loanable.dart';
import '../../domain/entities/loanable_availability.dart';
import '../../domain/repositories/loanables_repository.dart';
import '../datasources/loanables_remote_data_source.dart';

class LoanablesRepositoryImpl implements LoanablesRepository {
  final LoanablesRemoteDataSource _remoteDataSource;

  const LoanablesRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Loanable>> getLoanables({
    String? type,
    int? communityId,
    int? page,
  }) {
    return _remoteDataSource.getLoanables(
      type: type,
      communityId: communityId,
      page: page,
    );
  }

  @override
  Future<Loanable> getLoanableDetails(int id) {
    return _remoteDataSource.getLoanableDetails(id);
  }

  @override
  Future<List<LoanableAvailabilityInterval>> getAvailability(
    int loanableId, {
    required String start,
    required String end,
  }) {
    return _remoteDataSource.getAvailability(
      loanableId,
      start: start,
      end: end,
    );
  }
}

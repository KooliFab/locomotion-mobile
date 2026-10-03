import '../../domain/entities/departure_draft.dart';
import '../../domain/repositories/departure_draft_repository.dart';
import '../datasources/departure_draft_local_data_source.dart';

class DepartureDraftRepositoryImpl implements DepartureDraftRepository {
  final DepartureDraftLocalDataSource _localDataSource;

  const DepartureDraftRepositoryImpl(this._localDataSource);

  @override
  Future<void> saveDraft(DepartureDraft draft) =>
      _localDataSource.saveDraft(draft);

  @override
  Future<DepartureDraft?> getDraft({
    required int userId,
    required int loanId,
  }) =>
      _localDataSource.getDraft(userId: userId, loanId: loanId);

  @override
  Future<void> clearDraft({
    required int userId,
    required int loanId,
  }) =>
      _localDataSource.clearDraft(userId: userId, loanId: loanId);
}

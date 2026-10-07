import '../../domain/entities/return_draft.dart';
import '../../domain/repositories/return_draft_repository.dart';
import '../datasources/return_draft_local_data_source.dart';

class ReturnDraftRepositoryImpl implements ReturnDraftRepository {
  final ReturnDraftLocalDataSource _localDataSource;

  const ReturnDraftRepositoryImpl(this._localDataSource);

  @override
  Future<void> saveDraft(ReturnDraft draft) =>
      _localDataSource.saveDraft(draft);

  @override
  Future<ReturnDraft?> getDraft({required int userId, required int loanId}) =>
      _localDataSource.getDraft(userId: userId, loanId: loanId);

  @override
  Future<void> clearDraft({required int userId, required int loanId}) =>
      _localDataSource.clearDraft(userId: userId, loanId: loanId);
}

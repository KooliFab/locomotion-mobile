import '../entities/return_draft.dart';

abstract class ReturnDraftRepository {
  Future<void> saveDraft(ReturnDraft draft);
  Future<ReturnDraft?> getDraft({required int userId, required int loanId});
  Future<void> clearDraft({required int userId, required int loanId});
}

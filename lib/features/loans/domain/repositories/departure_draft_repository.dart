import '../entities/departure_draft.dart';

abstract class DepartureDraftRepository {
  Future<void> saveDraft(DepartureDraft draft);
  Future<DepartureDraft?> getDraft({required int userId, required int loanId});
  Future<void> clearDraft({required int userId, required int loanId});
}

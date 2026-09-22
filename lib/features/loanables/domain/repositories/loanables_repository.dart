import '../entities/loanable.dart';
import '../entities/loanable_availability.dart';

abstract class LoanablesRepository {
  Future<List<Loanable>> getLoanables({
    String? type,
    int? communityId,
    int? page,
  });
  Future<Loanable> getLoanableDetails(int id);
  Future<List<LoanableAvailabilityInterval>> getAvailability(
    int loanableId, {
    required String start,
    required String end,
  });
}

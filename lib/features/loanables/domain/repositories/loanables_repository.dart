import '../entities/loanable.dart';

abstract class LoanablesRepository {
  Future<List<Loanable>> getLoanables({String? type, int? communityId});
  Future<Loanable> getLoanableDetails(int id);
}

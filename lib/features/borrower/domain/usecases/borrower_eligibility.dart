import '../entities/borrower.dart';

/// Business rule for borrower eligibility to request a loan.
///
/// This rule is LOCAL ONLY and does NOT replace the authorization check
/// performed by Laravel on POST /loans. It is used to inform the user
/// before they attempt to fill a reservation form (Lots 2 & 3).
class BorrowerEligibility {
  /// Returns true if the user is eligible to request a loan for [loanableType].
  ///
  /// For 'car' and 'car_trailer': requires [borrower.validated == true].
  /// For 'bike' and 'trailer': not blocked locally (no explicit backend rule).
  /// Any other type: defaults to true (conservatively allows, backend decides).
  static bool canRequest(String loanableType, Borrower? borrower) {
    switch (loanableType) {
      case 'car':
      case 'car_trailer':
        return borrower?.validated == true;
      case 'bike':
      case 'trailer':
        // No local blocking rule — backend will authorize on loan creation.
        return true;
      default:
        // Unknown type: allow locally, defer to backend.
        return true;
    }
  }
}

import 'loanable_availability.dart';

/// Both availability windows for one bounded period:
/// `responseMode=available` and `responseMode=unavailable`.
///
/// Fetched together so an unavailable slot can never be painted as available.
class LoanableAvailabilityWindow {
  final List<LoanableAvailabilityInterval> available;
  final List<LoanableAvailabilityInterval> unavailable;

  const LoanableAvailabilityWindow({
    required this.available,
    required this.unavailable,
  });

  bool get isEmpty => available.isEmpty && unavailable.isEmpty;

  /// All events sorted by raw start, for day-by-day rendering.
  List<LoanableAvailabilityInterval> get all {
    final merged = [...available, ...unavailable];
    merged.sort((a, b) {
      final sa = a.rawStart ?? '';
      final sb = b.rawStart ?? '';
      return sa.compareTo(sb);
    });
    return merged;
  }
}

import '../entities/availability_config.dart';
import '../entities/conflicting_loan.dart';
import '../../../loanables/domain/entities/loanable_availability.dart';

abstract class AvailabilityRepository {
  Future<AvailabilityConfig> getAvailabilityConfig(int vehicleId);

  Future<List<ConflictingLoan>> checkConflicts(
    int vehicleId, {
    required String availabilityMode,
    required String availabilityJson,
  });

  Future<void> saveAvailabilityConfig(
    int vehicleId, {
    required String availabilityMode,
    required String availabilityJson,
    String? lockVersion,
  });

  Future<List<LoanableAvailabilityInterval>> previewAvailability(
    int vehicleId, {
    required String start,
    required String end,
    required String availabilityMode,
    required String availabilityJson,
    String? timezone,
  });
}

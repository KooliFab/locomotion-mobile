import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../loanables/domain/entities/vehicle_local_dates.dart';
import 'transport_alternative.dart';

part 'loan_draft.freezed.dart';

@freezed
abstract class LoanDraft with _$LoanDraft {
  const factory LoanDraft({
    required int loanableId,
    required String loanableName,
    required String loanableType,
    int? communityId,
    String? communityName,
    String? vehicleTimezone,
    int? minLoanDurationInMinutes,
    int? maxLoanDurationInMinutes,

    // Step 1: Schedule
    String? departureDate, // yyyy-MM-dd in vehicle timezone
    String? departureTime, // HH:mm in vehicle timezone
    int? durationInMinutes,

    // Step 2: Trip details
    int? estimatedDistance,
    TransportAlternative? alternativeTo,
    String? alternativeToOther,
    String? messageForOwner,
  }) = _LoanDraft;

  const LoanDraft._();

  /// Computed vehicle-local departure string formatted as `Y-m-d H:i:00`
  String? get departureAtString {
    if (departureDate == null || departureTime == null) return null;
    final time = departureTime!.length == 5
        ? '${departureTime!}:00'
        : departureTime!;
    return '${departureDate!} $time';
  }

  /// Validation of departure slot and duration
  String? get scheduleValidationError {
    if (departureDate == null || departureDate!.isEmpty) {
      return 'Veuillez sélectionner une date de départ.';
    }
    if (departureTime == null || departureTime!.isEmpty) {
      return 'Veuillez sélectionner une heure de départ.';
    }
    // Validate past departure against vehicle-local current date & time
    final vehicleToday = VehicleLocalDates.nowYmdInZone(vehicleTimezone);
    if (departureDate!.compareTo(vehicleToday) < 0) {
      return 'La date de départ ne peut pas être dans le passé.';
    }
    if (durationInMinutes == null || durationInMinutes! <= 0) {
      return 'Veuillez sélectionner une durée valide.';
    }
    if (minLoanDurationInMinutes != null &&
        durationInMinutes! < minLoanDurationInMinutes!) {
      return 'La durée minimale pour ce véhicule est de $minLoanDurationInMinutes minutes.';
    }
    if (maxLoanDurationInMinutes != null &&
        durationInMinutes! > maxLoanDurationInMinutes!) {
      return 'La durée maximale pour ce véhicule est de $maxLoanDurationInMinutes minutes.';
    }
    return null;
  }

  /// Validation of trip details
  String? get tripDetailsValidationError {
    if (estimatedDistance == null || estimatedDistance! <= 0) {
      return 'Veuillez renseigner une distance estimée (en km).';
    }
    if (alternativeTo == null) {
      return 'Veuillez préciser le mode de transport remplacé.';
    }
    if (alternativeTo == TransportAlternative.other &&
        (alternativeToOther == null || alternativeToOther!.trim().isEmpty)) {
      return 'Veuillez préciser l\'autre mode de transport remplacé.';
    }
    return null;
  }

  /// Full draft validation error before submission
  String? get fullValidationError =>
      scheduleValidationError ?? tripDetailsValidationError;

  bool get isValid => fullValidationError == null;
}

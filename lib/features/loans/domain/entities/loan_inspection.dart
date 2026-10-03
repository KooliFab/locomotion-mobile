import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_inspection.freezed.dart';
part 'loan_inspection.g.dart';

@freezed
abstract class LoanInspection with _$LoanInspection {
  const factory LoanInspection({
    @JsonKey(name: 'loan_id') required int loanId,
    @JsonKey(name: 'inspection_type') required String inspectionType,
    @JsonKey(name: 'odometer_km') int? odometerKm,
    @JsonKey(name: 'fuel_battery_level_percent') int? fuelBatteryLevelPercent,
    @JsonKey(name: 'cleanliness_rating') int? cleanlinessRating,
    @Default({}) Map<String, dynamic> checklist,
    @Default({}) Map<String, String> photos,
    @JsonKey(name: 'existing_damages_notes') String? existingDamagesNotes,
    @JsonKey(name: 'sealed_hash') String? sealedHash,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'loan_status') String? loanStatus,
  }) = _LoanInspection;

  factory LoanInspection.fromJson(Map<String, dynamic> json) =>
      _$LoanInspectionFromJson(json);
}

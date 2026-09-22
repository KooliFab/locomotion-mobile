import 'package:freezed_annotation/freezed_annotation.dart';

part 'loanable_incident.freezed.dart';
part 'loanable_incident.g.dart';

@freezed
abstract class LoanableIncident with _$LoanableIncident {
  const factory LoanableIncident({
    required int id,
    String? status,
    @JsonKey(name: 'incident_type') String? incidentType,
    @JsonKey(name: 'blocking_until') DateTime? blockingUntil,
    @JsonKey(name: 'is_blocking') @Default(false) bool isBlocking,
    @JsonKey(name: 'start_at') DateTime? startAt,
    @JsonKey(name: 'loan_id') int? loanId,
    @JsonKey(name: 'loanable_id') int? loanableId,
    String? title,
    String? description,
  }) = _LoanableIncident;

  factory LoanableIncident.fromJson(Map<String, dynamic> json) =>
      _$LoanableIncidentFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_dates_update_request.freezed.dart';
part 'loan_dates_update_request.g.dart';

@freezed
abstract class LoanDatesUpdateRequest with _$LoanDatesUpdateRequest {
  const LoanDatesUpdateRequest._();

  const factory LoanDatesUpdateRequest({
    /// Wall-clock string formatted as `Y-m-d H:i:s` in the vehicle's timezone.
    /// Never send UTC or device-local timestamps here.
    @JsonKey(name: 'departure_at') required String departureAt,
    @JsonKey(name: 'duration_in_minutes') required int durationInMinutes,
  }) = _LoanDatesUpdateRequest;

  factory LoanDatesUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$LoanDatesUpdateRequestFromJson(json);
}

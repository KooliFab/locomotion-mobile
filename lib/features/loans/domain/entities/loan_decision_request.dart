import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_decision_request.freezed.dart';
part 'loan_decision_request.g.dart';

@freezed
abstract class LoanDecisionRequest with _$LoanDecisionRequest {
  const LoanDecisionRequest._();

  const factory LoanDecisionRequest({
    /// Optional comment sent when accepting or rejecting a loan.
    @JsonKey(includeIfNull: false) String? comment,
  }) = _LoanDecisionRequest;

  factory LoanDecisionRequest.fromJson(Map<String, dynamic> json) =>
      _$LoanDecisionRequestFromJson(json);
}

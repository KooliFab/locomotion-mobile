import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_creation_request.freezed.dart';
part 'loan_creation_request.g.dart';

@freezed
abstract class LoanCreationRequest with _$LoanCreationRequest {
  const factory LoanCreationRequest({
    @JsonKey(name: 'loanable_id') required int loanableId,
    @JsonKey(name: 'borrower_user_id') required int borrowerUserId,
    @JsonKey(name: 'departure_at') required String departureAt,
    @JsonKey(name: 'duration_in_minutes') required int durationInMinutes,
    @JsonKey(name: 'estimated_distance') required int estimatedDistance,
    @JsonKey(name: 'alternative_to') required String alternativeTo,
    @JsonKey(name: 'alternative_to_other') String? alternativeToOther,
    @JsonKey(name: 'message_for_owner') String? messageForOwner,
    @JsonKey(name: 'community_id') int? communityId,
  }) = _LoanCreationRequest;

  factory LoanCreationRequest.fromJson(Map<String, dynamic> json) =>
      _$LoanCreationRequestFromJson(json);
}

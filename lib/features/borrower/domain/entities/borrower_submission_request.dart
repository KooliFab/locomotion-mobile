import 'package:freezed_annotation/freezed_annotation.dart';

part 'borrower_submission_request.freezed.dart';
part 'borrower_submission_request.g.dart';

/// Reference to an uploaded file for submission payload.
@freezed
abstract class FileIdRef with _$FileIdRef {
  const factory FileIdRef({required int id}) = _FileIdRef;
  factory FileIdRef.fromJson(Map<String, dynamic> json) =>
      _$FileIdRefFromJson(json);
}

/// Payload for PUT /users/{userId}/borrower/submit.
/// Never expose driversLicenseNumber in toString or logs.
@freezed
abstract class BorrowerSubmissionRequest with _$BorrowerSubmissionRequest {
  const BorrowerSubmissionRequest._();

  @JsonSerializable(explicitToJson: true)
  const factory BorrowerSubmissionRequest({
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'drivers_license_number')
    required String driversLicenseNumber,
    @JsonKey(name: 'has_not_been_sued_last_ten_years')
    required bool hasNotBeenSuedLastTenYears,
    required List<FileIdRef> gaa,
    required List<FileIdRef> saaq,
  }) = _BorrowerSubmissionRequest;

  @override
  String toString() =>
      'BorrowerSubmissionRequest(userId: $userId, '
      'hasNotBeenSuedLastTenYears: $hasNotBeenSuedLastTenYears, '
      'gaa: ${gaa.length} file(s), saaq: ${saaq.length} file(s))';

  factory BorrowerSubmissionRequest.fromJson(Map<String, dynamic> json) =>
      _$BorrowerSubmissionRequestFromJson(json);
}

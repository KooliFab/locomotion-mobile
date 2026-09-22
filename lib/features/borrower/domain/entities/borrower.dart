import 'package:freezed_annotation/freezed_annotation.dart';
import 'uploaded_file_ref.dart';

part 'borrower.freezed.dart';
part 'borrower.g.dart';

@freezed
abstract class Borrower with _$Borrower {
  const Borrower._();

  const factory Borrower({
    @JsonKey(name: 'user_id') required int userId,
    @Default(false) bool approved,
    @Default(false) bool suspended,
    @Default(false) bool validated,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'approved_at') DateTime? approvedAt,
    @JsonKey(name: 'suspended_at') DateTime? suspendedAt,
    // Conditional fields — only present when viewer has 'view-license' permission
    @JsonKey(name: 'drivers_license_number') String? driversLicenseNumber,
    @JsonKey(name: 'has_not_been_sued_last_ten_years')
    bool? hasNotBeenSuedLastTenYears,
    @Default([]) List<UploadedFileRef> gaa,
    @Default([]) List<UploadedFileRef> saaq,
  }) = _Borrower;

  /// Never expose driversLicenseNumber in toString or logs.
  @override
  String toString() =>
      'Borrower(userId: $userId, approved: $approved, suspended: $suspended, '
      'validated: $validated, submittedAt: $submittedAt)';

  factory Borrower.fromJson(Map<String, dynamic> json) =>
      _$BorrowerFromJson(json);
}

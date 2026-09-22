import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../borrower/domain/entities/borrower.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String email,

    /// Backend field: 'name' (prénom)
    @JsonKey(name: 'name') String? firstName,

    /// Backend field: 'last_name' (nom de famille)
    @JsonKey(name: 'last_name') String? lastName,
    String? phone,
    @JsonKey(name: 'email_verified_at') DateTime? emailVerifiedAt,
    int? currentCommunityId,

    /// Full borrower dossier from BorrowerResource — never infer state from
    /// a single boolean. Use BorrowerStatus.from(user.borrower) instead.
    Borrower? borrower,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

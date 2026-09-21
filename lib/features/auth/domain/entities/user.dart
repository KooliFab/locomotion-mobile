import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    String? avatarUrl,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isBorrowerApproved,
    int? currentCommunityId,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

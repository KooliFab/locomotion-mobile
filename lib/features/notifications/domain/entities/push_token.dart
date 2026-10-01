import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_token.freezed.dart';
part 'push_token.g.dart';

@freezed
abstract class PushToken with _$PushToken {
  const PushToken._();

  const factory PushToken({
    int? id,
    required String token,
    required String platform,
    @JsonKey(name: 'installation_id') required String installationId,
    @JsonKey(name: 'app_version') String? appVersion,
    @JsonKey(name: 'last_active_at') DateTime? lastActiveAt,
  }) = _PushToken;

  factory PushToken.fromJson(Map<String, dynamic> json) =>
      _$PushTokenFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'loanable_image.dart';
import 'loanable_incident.dart';

part 'loanable.freezed.dart';
part 'loanable.g.dart';

@freezed
abstract class Loanable with _$Loanable {
  const Loanable._();

  const factory Loanable({
    required int id,
    required String name,
    required String type, // 'bike', 'car', 'trailer', 'car_trailer'
    @JsonKey(name: 'sharing_mode') String? sharingMode,
    @JsonKey(name: 'availability_status') String? availabilityStatus,
    @JsonKey(name: 'availability_mode') String? availabilityMode,
    String? timezone,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'location_description') String? locationDescription,
    String? comments,
    String? instructions,
    @JsonKey(name: 'return_instructions') String? returnInstructions,
    @JsonKey(name: 'min_loan_duration_in_minutes')
    int? minLoanDurationInMinutes,
    @JsonKey(name: 'max_loan_duration_in_minutes')
    int? maxLoanDurationInMinutes,
    LoanableImage? image,
    @Default([]) List<LoanableImage> images,
    @JsonKey(name: 'active_incidents')
    @Default([])
    List<LoanableIncident> activeIncidents,
    Map<String, dynamic>? details,
    @JsonKey(name: 'community_ids') List<int>? communityIds,
    @JsonKey(name: 'community_name') String? communityName,
    @JsonKey(name: 'community_id') int? communityId,
    @JsonKey(name: 'merged_user_roles')
    List<Map<String, dynamic>>? mergedUserRoles,
    // Convenience / legacy compatibility fields
    String? description,
    String? address,
    String? imageUrl,
  }) = _Loanable;

  /// Backend values: `has_availabilities` / `no_availabilities` / …
  /// Also tolerate legacy `'available'` from older fixtures.
  /// Unknown/null status is NOT treated as available.
  bool get isAvailable =>
      availabilityStatus == 'has_availabilities' ||
      availabilityStatus == 'available';

  factory Loanable.fromJson(Map<String, dynamic> json) =>
      _$LoanableFromJson(_preprocessJson(json));

  static Map<String, dynamic> _preprocessJson(Map<String, dynamic> json) {
    final copy = Map<String, dynamic>.from(json);

    // Parse position: [lat, lng] or {"lat": ..., "lng": ...}
    double? lat;
    double? lng;
    final pos = copy['position'];
    if (pos is List && pos.length >= 2) {
      lat = (pos[0] as num?)?.toDouble();
      lng = (pos[1] as num?)?.toDouble();
    } else if (copy['position_google'] is Map) {
      final posGoogle = copy['position_google'] as Map<String, dynamic>;
      lat = (posGoogle['lat'] as num?)?.toDouble();
      lng = (posGoogle['lng'] as num?)?.toDouble();
    } else {
      lat = (copy['latitude'] as num?)?.toDouble();
      lng = (copy['longitude'] as num?)?.toDouble();
    }

    copy['latitude'] = lat;
    copy['longitude'] = lng;

    return copy;
  }
}

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
    // Convenience / legacy compatibility fields
    String? description,
    String? address,
    String? imageUrl,
  }) = _Loanable;

  bool get isAvailable => availabilityStatus == 'available';

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

    // Resolve community name & id from library or community_ids if missing
    if (copy['community_id'] == null) {
      if (copy['library'] is Map && copy['library']['community_id'] != null) {
        copy['community_id'] = copy['library']['community_id'];
      } else if (copy['community_ids'] is List &&
          (copy['community_ids'] as List).isNotEmpty) {
        copy['community_id'] = (copy['community_ids'] as List).first;
      }
    }
    if (copy['community_name'] == null && copy['library'] is Map) {
      copy['community_name'] = copy['library']['name'] as String?;
    }

    // Populate fallback description / address if not explicitly present
    copy['description'] ??= copy['location_description'] ?? copy['comments'];
    copy['address'] ??= copy['location_description'];

    // Map single image if provided
    if (copy['image'] is Map<String, dynamic>) {
      final img = copy['image'] as Map<String, dynamic>;
      if (img['id'] != null) {
        copy['imageUrl'] ??= '/images/${img['id']}';
      }
    }

    return copy;
  }
}

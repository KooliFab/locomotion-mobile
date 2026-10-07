import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../loanables/domain/entities/loanable_image.dart';

part 'fleet_vehicle.freezed.dart';
part 'fleet_vehicle.g.dart';

@freezed
abstract class FleetVehicle with _$FleetVehicle {
  const FleetVehicle._();

  const factory FleetVehicle({
    required int id,
    required String name,
    required String type, // 'bike', 'car', 'trailer', 'car_trailer'
    @JsonKey(name: 'sharing_mode') String? sharingMode,
    @JsonKey(name: 'availability_mode') String? availabilityMode,
    @JsonKey(name: 'availability_status') String? availabilityStatus,
    @JsonKey(name: 'location_description') String? locationDescription,
    @JsonKey(name: 'published') @Default(false) bool published,
    @JsonKey(name: 'is_suspended') @Default(false) bool isSuspended,
    @JsonKey(name: 'suspended_at') DateTime? suspendedAt,
    @JsonKey(name: 'suspension_reason') String? suspensionReason,
    @JsonKey(name: 'active_loans_count') @Default(0) int activeLoansCount,
    @JsonKey(name: 'confirmed_future_loans_count')
    @Default(0)
    int confirmedFutureLoansCount,
    @JsonKey(name: 'pending_requests_count')
    @Default(0)
    int pendingRequestsCount,
    @JsonKey(name: 'future_loans_count') @Default(0) int futureLoansCount,
    @JsonKey(name: 'min_loan_duration_in_minutes')
    int? minLoanDurationInMinutes,
    @JsonKey(name: 'max_loan_duration_in_minutes')
    int? maxLoanDurationInMinutes,
    @JsonKey(name: 'timezone') String? timezone,
    @JsonKey(name: 'user_role') String? userRole,
    @JsonKey(name: 'updated_at') String? updatedAt,
    String? comments,
    String? instructions,
    @JsonKey(name: 'return_instructions') String? returnInstructions,
    @JsonKey(name: 'trusted_borrower_instructions')
    String? trustedBorrowerInstructions,
    double? latitude,
    double? longitude,
    LoanableImage? image,
    @Default([]) List<LoanableImage> images,
    Map<String, dynamic>? details,
    Map<String, dynamic>? community,
  }) = _FleetVehicle;

  bool get isDraft => !published;
  bool get hasActiveLoans => activeLoansCount > 0;
  bool get hasFutureLoans => futureLoansCount > 0;
  bool get isCar => type == 'car';
  bool get isBike => type == 'bike';
  bool get isTrailer => type == 'trailer' || type == 'car_trailer';

  factory FleetVehicle.fromJson(Map<String, dynamic> json) =>
      _$FleetVehicleFromJson(_preprocessJson(json));

  static Map<String, dynamic> _preprocessJson(Map<String, dynamic> json) {
    final copy = Map<String, dynamic>.from(json);

    // Handle position: [lat, lng] or {"lat": ..., "lng": ...}
    final pos = copy['position'];
    if (pos is List && pos.length >= 2) {
      copy['latitude'] = (pos[0] as num).toDouble();
      copy['longitude'] = (pos[1] as num).toDouble();
    } else if (pos is Map) {
      if (pos['lat'] != null) {
        copy['latitude'] = (pos['lat'] as num).toDouble();
      }
      if (pos['lng'] != null) {
        copy['longitude'] = (pos['lng'] as num).toDouble();
      }
      if (pos['latitude'] != null) {
        copy['latitude'] = (pos['latitude'] as num).toDouble();
      }
      if (pos['longitude'] != null) {
        copy['longitude'] = (pos['longitude'] as num).toDouble();
      }
    }

    return copy;
  }
}

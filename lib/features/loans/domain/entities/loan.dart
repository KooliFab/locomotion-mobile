import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../loanables/domain/entities/loanable.dart';
import 'loan_comment.dart';
import 'loan_status.dart';

part 'loan.freezed.dart';
part 'loan.g.dart';

class LoanableConverter
    implements JsonConverter<Loanable?, Map<String, dynamic>?> {
  const LoanableConverter();

  @override
  Loanable? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Loanable.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(Loanable? object) => object?.toJson();
}

@freezed
abstract class Loan with _$Loan {
  const Loan._();

  const factory Loan({
    required int id,
    @JsonKey(name: 'departure_at') required DateTime departureAt,
    @JsonKey(name: 'duration_in_minutes') required int durationInMinutes,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'loanable_id') int? loanableId,
    @JsonKey(name: 'loanable_name') String? loanableName,
    @LoanableConverter() Loanable? loanable,
    @JsonKey(name: 'community_id') int? communityId,
    @JsonKey(name: 'community_name') String? communityName,
    @JsonKey(name: 'borrower_user_id') int? borrowerUserId,
    @JsonKey(name: 'borrower_user_name') String? borrowerUserName,
    @JsonKey(name: 'borrower_user_email') String? borrowerUserEmail,
    @JsonKey(name: 'borrower_user_phone') String? borrowerUserPhone,
    @JsonKey(name: 'accepted_at') DateTime? acceptedAt,
    @JsonKey(name: 'prepaid_at') DateTime? prepaidAt,
    @JsonKey(name: 'canceled_at') DateTime? canceledAt,
    @JsonKey(name: 'actual_return_at') DateTime? actualReturnAt,
    @JsonKey(name: 'borrower_validated_at') DateTime? borrowerValidatedAt,
    @JsonKey(name: 'owner_validated_at') DateTime? ownerValidatedAt,
    @JsonKey(name: 'needs_validation') @Default(false) bool needsValidation,
    @JsonKey(name: 'is_free') @Default(false) bool isFree,
    @JsonKey(name: 'borrower_total') double? borrowerTotal,
    @JsonKey(name: 'owner_total') double? ownerTotal,
    @JsonKey(name: 'owner_action_required')
    @Default(false)
    bool ownerActionRequired,
    @JsonKey(name: 'borrower_action_required')
    @Default(false)
    bool borrowerActionRequired,
    @JsonKey(name: 'is_self_service') @Default(false) bool isSelfService,
    @JsonKey(name: 'estimated_distance') int? estimatedDistance,
    @JsonKey(name: 'actual_distance') int? actualDistance,
    @JsonKey(name: 'mileage_start') int? mileageStart,
    @JsonKey(name: 'mileage_end') int? mileageEnd,
    @JsonKey(name: 'requires_mileage') bool? requiresMileage,
    @JsonKey(name: 'requires_detailed_mileage') bool? requiresDetailedMileage,
    @JsonKey(name: 'alternative_to') String? alternativeTo,
    @JsonKey(name: 'alternative_to_other') String? alternativeToOther,
    String? comment,
    @Default([]) List<LoanComment> comments,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'deposit_status') String? depositStatus,
    @JsonKey(name: 'deposit_authorized_cents') int? depositAuthorizedCents,
    @JsonKey(name: 'deposit_expires_at') DateTime? depositExpiresAt,
    @JsonKey(name: 'departure_inspection_completed')
    @Default(false)
    bool departureInspectionCompleted,
    @JsonKey(name: 'return_inspection_completed')
    @Default(false)
    bool returnInspectionCompleted,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'deposit_released_at') DateTime? depositReleasedAt,
    @JsonKey(name: 'extension_duration_in_minutes')
    int? extensionDurationInMinutes,
    Map<String, dynamic>? inspections,
  }) = _Loan;

  LoanStatus get parsedStatus => LoanStatus.fromString(status);

  bool get hasPendingExtension => extensionDurationInMinutes != null;
  DateTime? get extendedReturnAt => hasPendingExtension
      ? departureAt.add(Duration(minutes: extensionDurationInMinutes!))
      : null;
  int? get pendingExtensionAdditionalMinutes => hasPendingExtension
      ? (extensionDurationInMinutes! - durationInMinutes)
      : null;

  /// Whether an extension can be requested:
  /// Must be ongoing or confirmed (or ended without return inspection completed),
  /// user must be participant, and there must not already be an extension pending.
  bool canRequestExtension(int? currentUserId) {
    if (hasPendingExtension) return false;
    final s = parsedStatus;
    if (s != LoanStatus.ongoing &&
        s != LoanStatus.confirmed &&
        !(s == LoanStatus.ended && !returnInspectionCompleted)) {
      return false;
    }
    final isBorrower =
        borrowerUserId == null ||
        currentUserId == null ||
        borrowerUserId == currentUserId;
    final isOwner = isUserOwner(currentUserId);
    return isBorrower || isOwner;
  }

  /// Whether an extension can be accepted by owner/co-owner
  bool canAcceptExtension(int? currentUserId) {
    if (!hasPendingExtension) return false;
    return isUserOwner(currentUserId);
  }

  /// Whether an extension can be rejected by owner/co-owner
  bool canRejectExtension(int? currentUserId) {
    if (!hasPendingExtension) return false;
    return isUserOwner(currentUserId);
  }

  /// Whether a pending extension can be cancelled by the borrower
  bool canCancelExtension(int? currentUserId) {
    if (!hasPendingExtension) return false;
    final isBorrower =
        borrowerUserId == null ||
        currentUserId == null ||
        borrowerUserId == currentUserId;
    return isBorrower;
  }

  DateTime get startAt => departureAt;
  DateTime get endAt =>
      actualReturnAt ?? departureAt.add(Duration(minutes: durationInMinutes));
  double? get totalCost => borrowerTotal;
  String get displayLoanableName =>
      loanableName ?? loanable?.name ?? 'Véhicule #$loanableId';

  bool get isMotorized => loanable?.type == 'car';

  bool get requiresMileageTracking =>
      requiresMileage ?? (requiresDetailedMileage ?? isMotorized);

  bool get hasAuthorizedDeposit => depositStatus == 'authorized';
  bool get isDepositReleased =>
      depositStatus == 'released' || depositReleasedAt != null;
  bool get isDepositReleaseFailed => depositStatus == 'release_failed';
  double? get depositAuthorizedDollars =>
      depositAuthorizedCents != null ? depositAuthorizedCents! / 100.0 : null;

  /// Whether deposit release can be retried without re-billing
  bool canRetryReleaseDeposit(int? currentUserId) {
    if (paidAt == null && parsedStatus != LoanStatus.completed) {
      return false;
    }
    if (depositStatus != 'release_failed' &&
        depositStatus != 'release_pending') {
      return false;
    }

    final isBorrower =
        borrowerUserId == null ||
        currentUserId == null ||
        borrowerUserId == currentUserId;
    final isOwner = isUserOwner(currentUserId);
    return isBorrower || isOwner;
  }

  /// Borrower can prepay when accepted and not yet prepaid
  bool canBorrowerPrepay(int? currentUserId) {
    if (borrowerUserId != null &&
        currentUserId != null &&
        borrowerUserId != currentUserId) {
      return false;
    }
    return parsedStatus == LoanStatus.accepted && prepaidAt == null;
  }

  /// Whether the vehicle can be returned (return inspection) by borrower or owner.
  bool canReturnVehicle(int? currentUserId) {
    if (returnInspectionCompleted) return false;

    final isBorrower =
        borrowerUserId == null ||
        currentUserId == null ||
        borrowerUserId == currentUserId;
    final isOwner = isUserOwner(currentUserId);
    if (!isBorrower && !isOwner) return false;

    return parsedStatus == LoanStatus.ongoing ||
        parsedStatus == LoanStatus.ended;
  }

  /// Whether the loan can be settled and closed by borrower or owner.
  bool canSettleAndClose(int? currentUserId) {
    if (paidAt != null || parsedStatus == LoanStatus.completed) return false;

    final isBorrower =
        borrowerUserId == null ||
        currentUserId == null ||
        borrowerUserId == currentUserId;
    final isOwner = isUserOwner(currentUserId);
    if (!isBorrower && !isOwner) return false;

    return parsedStatus == LoanStatus.ended ||
        parsedStatus == LoanStatus.validated;
  }

  /// Whether current user can perform final validation on returned loan.
  bool canValidateReturn(int? currentUserId) {
    if (parsedStatus != LoanStatus.ended) return false;

    final isOwner = isUserOwner(currentUserId);
    if (isOwner && ownerValidatedAt == null) return true;

    final isBorrower =
        borrowerUserId == null ||
        currentUserId == null ||
        borrowerUserId == currentUserId;
    if (isBorrower && borrowerValidatedAt == null) return true;

    return false;
  }

  /// Whether the vehicle can be taken over (departure inspection) by the borrower or owner.
  /// Allowed starting 1 hour before departure_at when the loan is confirmed,
  /// or when already ongoing if departure inspection is not yet completed.
  bool canTakeOver(int? currentUserId, {DateTime? now}) {
    if (departureInspectionCompleted) return false;

    final isBorrower =
        borrowerUserId == null ||
        currentUserId == null ||
        borrowerUserId == currentUserId;
    final isOwner = isUserOwner(currentUserId);
    if (!isBorrower && !isOwner) return false;

    if (parsedStatus == LoanStatus.ongoing) return true;

    if (parsedStatus == LoanStatus.confirmed) {
      final currentTime = now ?? DateTime.now();
      final earliestTakeOverTime = departureAt.subtract(
        const Duration(hours: 1),
      );
      return currentTime.isAfter(earliestTakeOverTime) ||
          currentTime.isAtSameMomentAs(earliestTakeOverTime);
    }

    return false;
  }

  /// Earliest moment at which departure inspection can start (1 hour before departure).
  DateTime get earliestDepartureInspectionAt =>
      departureAt.subtract(const Duration(hours: 1));

  /// Checks if current time is within the allowed departure inspection window.
  bool isWithinTakeOverWindow([DateTime? now]) {
    final currentTime = now ?? DateTime.now();
    return currentTime.isAfter(earliestDepartureInspectionAt) ||
        currentTime.isAtSameMomentAs(earliestDepartureInspectionAt);
  }

  /// Determines if the current user has owner access to this loan.
  /// Checks via `loanable.mergedUserRoles` (top-level key as per LoanLoanableResource)
  /// or fallback to `loanable.details['merged_user_roles']`.
  /// Allowed owner roles: 'owner' and 'coowner'.
  bool isUserOwner(int? currentUserId) {
    if (currentUserId == null) return false;

    // Check merged_user_roles directly on loanable
    final directRoles = loanable?.mergedUserRoles;
    if (directRoles != null) {
      for (final r in directRoles) {
        final uid = r['user_id'] ?? (r['user'] is Map ? r['user']['id'] : null);
        final role = r['role']?.toString();
        if (uid == currentUserId && (role == 'owner' || role == 'coowner')) {
          return true;
        }
      }
    }

    // Fallback if roles were embedded in details
    if (loanable?.details != null) {
      final roles = loanable!.details!['merged_user_roles'];
      if (roles is List) {
        for (final r in roles) {
          if (r is Map) {
            final uid =
                r['user_id'] ?? (r['user'] is Map ? r['user']['id'] : null);
            final role = r['role']?.toString();
            if (uid == currentUserId &&
                (role == 'owner' || role == 'coowner')) {
              return true;
            }
          }
        }
      }
    }

    return false;
  }

  Map<String, dynamic>? get _ownerUserRole {
    final directRoles = loanable?.mergedUserRoles;
    if (directRoles != null) {
      for (final r in directRoles) {
        final role = r['role']?.toString();
        if (role == 'owner' || role == 'coowner') {
          return r;
        }
      }
    }
    if (loanable?.details != null) {
      final roles = loanable!.details!['merged_user_roles'];
      if (roles is List) {
        for (final r in roles) {
          if (r is Map<String, dynamic>) {
            final role = r['role']?.toString();
            if (role == 'owner' || role == 'coowner') {
              return r;
            }
          } else if (r is Map) {
            final role = r['role']?.toString();
            if (role == 'owner' || role == 'coowner') {
              return Map<String, dynamic>.from(r);
            }
          }
        }
      }
    }
    return null;
  }

  String? get ownerUserName {
    final r = _ownerUserRole;
    if (r == null) return null;
    if (r['user'] is Map) {
      final u = r['user'] as Map;
      final first = u['first_name']?.toString() ?? '';
      final last = u['last_name']?.toString() ?? '';
      final full = '$first $last'.trim();
      return full.isNotEmpty ? full : u['name']?.toString();
    }
    return r['name']?.toString();
  }

  String? get ownerUserEmail {
    final r = _ownerUserRole;
    if (r == null) return null;
    if (r['user'] is Map) {
      return (r['user'] as Map)['email']?.toString();
    }
    return r['email']?.toString();
  }

  String? get ownerUserPhone {
    final r = _ownerUserRole;
    if (r == null) return null;
    if (r['user'] is Map) {
      return (r['user'] as Map)['phone']?.toString();
    }
    return r['phone']?.toString();
  }

  /// Policy deduction for owner accept:
  /// Laravel LoanPolicy: status must be 'requested', user must be (co)owner or loan admin.
  bool canOwnerAccept(int? currentUserId) {
    if (currentUserId == null) return false;
    if (parsedStatus != LoanStatus.requested) return false;
    return isUserOwner(currentUserId);
  }

  /// Policy deduction for owner reject:
  /// Laravel LoanPolicy: status must be 'requested', user must be (co)owner or loan admin.
  bool canOwnerReject(int? currentUserId) {
    if (currentUserId == null) return false;
    if (parsedStatus != LoanStatus.requested) return false;
    return isUserOwner(currentUserId);
  }

  /// Policy deduction for owner cancel:
  /// Laravel LoanPolicy: loan must be in process ($loan->is_in_process), user must be (co)owner or admin.
  bool canOwnerCancel(int? currentUserId) {
    if (currentUserId == null) return false;
    final s = parsedStatus;
    if (s == LoanStatus.completed ||
        s == LoanStatus.canceled ||
        s == LoanStatus.rejected ||
        s == LoanStatus.unknown) {
      return false;
    }
    return isUserOwner(currentUserId);
  }

  /// Policy deduction for borrower cancel:
  /// Laravel allows cancel if in process (requested -> validated).
  /// For borrower: allowed if free, or not ongoing, or before departure, or has blocking incident.
  /// Refused if ongoing with cost after departure without blocking incident.
  bool canBorrowerCancel(int? currentUserId) {
    if (borrowerUserId != null &&
        currentUserId != null &&
        borrowerUserId != currentUserId) {
      return false;
    }
    final s = parsedStatus;
    // Must be in process
    if (s == LoanStatus.completed ||
        s == LoanStatus.canceled ||
        s == LoanStatus.rejected ||
        s == LoanStatus.unknown) {
      return false;
    }
    if (s == LoanStatus.ongoing) {
      // Must not be ongoing with cost after departure
      if (!isFree && DateTime.now().toUtc().isAfter(departureAt.toUtc())) {
        return false;
      }
    }
    return true;
  }

  /// Roadmap rule: modification des dates avant confirmation (requested ou accepted)
  /// Backend policy allows confirmed too, but resets confirmation to accepted.
  /// In MVP, borrower can update dates when in requested or accepted.
  bool canBorrowerUpdateDates(int? currentUserId) {
    if (borrowerUserId != null &&
        currentUserId != null &&
        borrowerUserId != currentUserId) {
      return false;
    }
    final s = parsedStatus;
    return s == LoanStatus.requested || s == LoanStatus.accepted;
  }

  /// Borrower can comment anytime as long as user is participant
  bool canBorrowerComment(int? currentUserId) {
    if (borrowerUserId != null &&
        currentUserId != null &&
        borrowerUserId != currentUserId) {
      return false;
    }
    return true;
  }

  factory Loan.fromJson(Map<String, dynamic> json) =>
      _$LoanFromJson(_preprocessJson(json));

  static Map<String, dynamic> _preprocessJson(Map<String, dynamic> json) {
    final copy = Map<String, dynamic>.from(json);

    final id = copy['id'];
    if (id == null) {
      throw const FormatException('Champ requis "id" manquant pour le prêt');
    }

    // departure_at: required
    final rawDeparture = copy['departure_at'] ?? copy['start_at'];
    if (rawDeparture == null ||
        (rawDeparture is String && rawDeparture.trim().isEmpty)) {
      throw FormatException(
        'Champ requis "departure_at" manquant pour le prêt #$id',
      );
    }
    if (rawDeparture is String) {
      final parsed = DateTime.tryParse(rawDeparture.replaceAll(' ', 'T'));
      if (parsed == null) {
        throw FormatException(
          'Format de date invalide pour "departure_at" ($rawDeparture) sur le prêt #$id',
        );
      }
      copy['departure_at'] = parsed.toIso8601String();
    }

    // duration_in_minutes: required
    if (copy['duration_in_minutes'] == null) {
      if (copy['end_at'] != null && copy['start_at'] != null) {
        final start = DateTime.tryParse(
          copy['start_at'].toString().replaceAll(' ', 'T'),
        );
        final end = DateTime.tryParse(
          copy['end_at'].toString().replaceAll(' ', 'T'),
        );
        if (start != null && end != null) {
          copy['duration_in_minutes'] = end.difference(start).inMinutes;
        }
      }
    }
    if (copy['duration_in_minutes'] == null) {
      throw FormatException(
        'Champ requis "duration_in_minutes" manquant pour le prêt #$id',
      );
    }

    // status: required
    final rawStatus = copy['status'];
    if (rawStatus == null ||
        (rawStatus is String && rawStatus.trim().isEmpty)) {
      throw FormatException('Champ requis "status" manquant pour le prêt #$id');
    }
    copy['status'] = rawStatus.toString().trim();

    // Resolve loanable info
    if (copy['loanable'] is Map<String, dynamic>) {
      final lMap = copy['loanable'] as Map<String, dynamic>;
      copy['loanable_id'] ??= lMap['id'];
      copy['loanable_name'] ??= lMap['name'];
    }

    // Resolve community info
    if (copy['community'] is Map<String, dynamic>) {
      final cMap = copy['community'] as Map<String, dynamic>;
      copy['community_id'] ??= cMap['id'];
      copy['community_name'] ??= cMap['name'];
    }

    // Resolve borrower info
    if (copy['borrower_user'] is Map<String, dynamic>) {
      final uMap = copy['borrower_user'] as Map<String, dynamic>;
      copy['borrower_user_id'] ??= uMap['id'];
      copy['borrower_user_name'] ??=
          uMap['full_name'] ??
          '${uMap['name'] ?? ''} ${uMap['last_name'] ?? ''}'.trim();
      copy['borrower_user_email'] ??= uMap['email'];
      copy['borrower_user_phone'] ??= uMap['phone'];
    }

    // Parse total
    if (copy['total_cost'] != null && copy['borrower_total'] == null) {
      copy['borrower_total'] = (copy['total_cost'] as num?)?.toDouble();
    }

    // Defensive parsing for comments
    if (copy['comments'] is List) {
      copy['comments'] = (copy['comments'] as List)
          .whereType<Map<String, dynamic>>()
          .map(LoanComment.fromJson)
          .map((c) => c.toJson())
          .toList();
    }

    return copy;
  }
}

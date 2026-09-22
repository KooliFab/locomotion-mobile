import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../loanables/domain/entities/loanable.dart';
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
    @JsonKey(name: 'actual_return_at') DateTime? actualReturnAt,
    @JsonKey(name: 'borrower_validated_at') DateTime? borrowerValidatedAt,
    @JsonKey(name: 'owner_validated_at') DateTime? ownerValidatedAt,
    @JsonKey(name: 'needs_validation') @Default(false) bool needsValidation,
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
    @JsonKey(name: 'alternative_to') String? alternativeTo,
    @JsonKey(name: 'alternative_to_other') String? alternativeToOther,
    String? comment,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Loan;

  LoanStatus get parsedStatus => LoanStatus.fromString(status);

  DateTime get startAt => departureAt;
  DateTime get endAt =>
      actualReturnAt ?? departureAt.add(Duration(minutes: durationInMinutes));
  double? get totalCost => borrowerTotal;
  String get displayLoanableName =>
      loanableName ?? loanable?.name ?? 'Véhicule #$loanableId';

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
    }

    // Parse total
    if (copy['total_cost'] != null && copy['borrower_total'] == null) {
      copy['borrower_total'] = (copy['total_cost'] as num?)?.toDouble();
    }

    return copy;
  }
}

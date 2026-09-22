import 'package:freezed_annotation/freezed_annotation.dart';

part 'loanable_availability.freezed.dart';

@freezed
abstract class LoanableAvailabilityInterval with _$LoanableAvailabilityInterval {
  const LoanableAvailabilityInterval._();

  const factory LoanableAvailabilityInterval({
    required String type,
    required DateTime start,
    required DateTime end,
    required bool isAvailable,
    String? rawStart,
    String? rawEnd,
  }) = _LoanableAvailabilityInterval;

  factory LoanableAvailabilityInterval.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    if (type == null) {
      throw const FormatException(
        'Champ type manquant pour l\'événement de disponibilité',
      );
    }

    final data = json['data'];
    if (data is! Map<String, dynamic> || data['available'] is! bool) {
      throw const FormatException(
        'Événement de disponibilité mal formé: champ data.available manquant ou non-booléen',
      );
    }
    final isAvailable = data['available'] as bool;

    final startStr = json['start'];
    final endStr = json['end'];
    if (startStr is! String || endStr is! String || startStr.isEmpty || endStr.isEmpty) {
      throw const FormatException(
        'Événement de disponibilité mal formé: start ou end manquant ou vide',
      );
    }

    final start = DateTime.tryParse(startStr.replaceAll(' ', 'T'));
    final end = DateTime.tryParse(endStr.replaceAll(' ', 'T'));
    if (start == null || end == null) {
      throw FormatException(
        'Dates d\'événement de disponibilité invalides: start=$startStr, end=$endStr',
      );
    }

    return LoanableAvailabilityInterval(
      type: type.toString(),
      start: start,
      end: end,
      isAvailable: isAvailable,
      rawStart: startStr,
      rawEnd: endStr,
    );
  }
}

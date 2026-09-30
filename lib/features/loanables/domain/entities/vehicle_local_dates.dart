import 'package:timezone/timezone.dart' as tz;

/// Helpers to work with vehicle-local (naive) datetime strings returned by
/// `GET /loanables/{id}/availability`.
///
/// The backend interprets `start`/`end` in the loanable timezone and returns
/// `Y-m-d H:i:s` wall-clock strings without offset. Display must never convert
/// them to the device timezone.
class VehicleLocalDates {
  VehicleLocalDates._();

  static String formatYmd(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Shift a `yyyy-MM-dd` string by [days] using UTC arithmetic so DST on the
  /// device cannot move the wall-clock date.
  static String shiftYmd(String ymd, int days) {
    final parts = ymd.split('-');
    if (parts.length != 3) {
      throw FormatException('Date invalide: $ymd');
    }
    final base = DateTime.utc(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    final shifted = base.add(Duration(days: days));
    return formatYmd(DateTime.utc(shifted.year, shifted.month, shifted.day));
  }

  /// The [count] consecutive days starting at [startYmd] (inclusive).
  static List<String> daysFrom(String startYmd, int count) {
    return List.generate(count, (i) => shiftYmd(startYmd, i));
  }

  /// `HH:mm` extracted from a raw `Y-m-d H:i:s` vehicle-local string.
  static String hhmm(String? raw) {
    if (raw == null || raw.length < 16) return '';
    return raw.substring(11, 16);
  }

  /// `yyyy-MM-dd` day part of a raw vehicle-local string.
  static String dayOf(String? raw) {
    if (raw == null || raw.length < 10) return '';
    return raw.substring(0, 10);
  }

  static const List<String> shortWeekdays = [
    'lun',
    'mar',
    'mer',
    'jeu',
    'ven',
    'sam',
    'dim',
  ];

  static const List<String> shortMonths = [
    'janv',
    'févr',
    'mars',
    'avr',
    'mai',
    'juin',
    'juil',
    'août',
    'sept',
    'oct',
    'nov',
    'déc',
  ];

  /// French `EEE d MMM` label for a `yyyy-MM-dd` string, no locale data needed.
  static String shortLabel(String ymd) {
    final parts = ymd.split('-');
    if (parts.length != 3) return ymd;
    final date = DateTime.utc(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    // DateTime.weekday: Monday=1 … Sunday=7 → shortWeekdays index 0…6
    final weekday = shortWeekdays[date.weekday - 1];
    final month = shortMonths[date.month - 1];
    return '$weekday ${date.day} $month';
  }

  /// Returns `yyyy-MM-dd` for the current instant in the IANA [ianaZone].
  ///
  /// Falls back to the device's local date if [ianaZone] is null, empty, or
  /// unknown to the timezone database (so the app still works without a
  /// timezone value in the vehicle data).
  static String nowYmdInZone(String? ianaZone) {
    if (ianaZone != null && ianaZone.isNotEmpty) {
      try {
        final location = tz.getLocation(ianaZone);
        final now = tz.TZDateTime.now(location);
        return '${now.year.toString().padLeft(4, '0')}-'
            '${now.month.toString().padLeft(2, '0')}-'
            '${now.day.toString().padLeft(2, '0')}';
      } catch (_) {
        // Unknown timezone: fall through to device local
      }
    }
    return formatYmd(DateTime.now());
  }

  /// Splits [interval] into one fragment per calendar day it spans, using the
  /// raw wall-clock strings as boundaries.
  ///
  /// A 7-day continuous availability block (single interval, rawStart on day 1,
  /// rawEnd on day 7) becomes 7 fragments, one per day, so that the per-day
  /// display loop shows each day correctly instead of only the first day.
  ///
  /// Rules:
  /// - If [interval.rawStart] or [interval.rawEnd] is null/malformed, the
  ///   interval is returned as-is (single element list).
  /// - Each fragment keeps [interval.isAvailable] unchanged.
  /// - The first fragment starts at [rawStart]; each subsequent fragment starts
  ///   at `<day> 00:00:00`. The last fragment ends at [rawEnd]; each preceding
  ///   fragment ends at `<day> 23:59:59` (inclusive wall-clock sentinel).
  static List<DayFragment> splitByDay(
    String intervalRawStart,
    String intervalRawEnd,
    bool isAvailable,
    String type,
  ) {
    final startDay = dayOf(intervalRawStart);
    final endDay = dayOf(intervalRawEnd);
    if (startDay.isEmpty || endDay.isEmpty) {
      return [
        DayFragment(
          day: startDay,
          rawStart: intervalRawStart,
          rawEnd: intervalRawEnd,
          isAvailable: isAvailable,
          type: type,
        ),
      ];
    }

    final fragments = <DayFragment>[];
    String current = startDay;

    // Walk day by day from startDay to endDay (inclusive), but stop if we
    // somehow loop more than 365 times (guard against bad data).
    for (int guard = 0; guard < 366; guard++) {
      final isFirst = current == startDay;
      final isLast = current == endDay || current.compareTo(endDay) >= 0;

      final rawStart = isFirst ? intervalRawStart : '$current 00:00:00';
      final rawEnd = isLast ? intervalRawEnd : '$current 23:59:59';

      // If the interval ends precisely at midnight (<day> 00:00:00), the loop
      // arrives on that final day with rawStart == rawEnd == '<day> 00:00:00'.
      // When this is not the first day, this represents the end boundary of the
      // previous day, not a 00:00 - 00:00 slot on the new day. Skip it.
      if (!isFirst && rawEnd == '$current 00:00:00') {
        if (isLast) break;
        current = shiftYmd(current, 1);
        continue;
      }

      fragments.add(
        DayFragment(
          day: current,
          rawStart: rawStart,
          rawEnd: rawEnd,
          isAvailable: isAvailable,
          type: type,
        ),
      );

      if (isLast) break;
      current = shiftYmd(current, 1);
    }

    return fragments;
  }
}

/// A single-day fragment of an availability interval, produced by
/// [VehicleLocalDates.splitByDay].
class DayFragment {
  final String day; // yyyy-MM-dd
  final String rawStart; // Y-m-d H:i:s (vehicle-local)
  final String rawEnd; // Y-m-d H:i:s (vehicle-local)
  final bool isAvailable;
  final String type;

  const DayFragment({
    required this.day,
    required this.rawStart,
    required this.rawEnd,
    required this.isAvailable,
    required this.type,
  });
}

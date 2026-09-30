import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/loanables/domain/entities/vehicle_local_dates.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz_zone;

void main() {
  setUpAll(() {
    // Required by nowYmdInZone to resolve IANA names.
    tz.initializeTimeZones();
  });

  group('VehicleLocalDates', () {
    test('formatYmd pads month and day', () {
      expect(VehicleLocalDates.formatYmd(DateTime(2026, 3, 5)), '2026-03-05');
    });

    test('shiftYmd moves forward across month boundary', () {
      expect(VehicleLocalDates.shiftYmd('2026-01-31', 1), '2026-02-01');
    });

    test('shiftYmd moves backward across year boundary', () {
      expect(VehicleLocalDates.shiftYmd('2026-01-01', -1), '2025-12-31');
    });

    test(
      'shiftYmd by 7 days from a DST-adjacent date stays calendar-correct',
      () {
        // 2026-03-07 + 7d in America/Montreal crosses DST (Mar 8 2026).
        // UTC arithmetic must still land on 2026-03-14.
        expect(VehicleLocalDates.shiftYmd('2026-03-07', 7), '2026-03-14');
        expect(VehicleLocalDates.shiftYmd('2026-11-01', -7), '2026-10-25');
      },
    );

    test('daysFrom returns inclusive consecutive days', () {
      final days = VehicleLocalDates.daysFrom('2026-10-01', 7);
      expect(days.length, 7);
      expect(days.first, '2026-10-01');
      expect(days.last, '2026-10-07');
    });

    test(
      'hhmm and dayOf extract raw wall-clock parts without TZ conversion',
      () {
        const raw = '2026-10-01 08:30:00';
        expect(VehicleLocalDates.hhmm(raw), '08:30');
        expect(VehicleLocalDates.dayOf(raw), '2026-10-01');
        expect(VehicleLocalDates.hhmm(null), '');
        expect(VehicleLocalDates.dayOf(null), '');
        expect(VehicleLocalDates.hhmm('bad'), '');
      },
    );

    test('shortLabel renders French label without locale data', () {
      // 2026-10-01 is a Thursday
      expect(VehicleLocalDates.shortLabel('2026-10-01'), 'jeu 1 oct');
      // 2026-12-25 is a Friday
      expect(VehicleLocalDates.shortLabel('2026-12-25'), 'ven 25 déc');
    });
  });

  group('VehicleLocalDates.nowYmdInZone', () {
    test('returns a valid yyyy-MM-dd string for a known IANA zone', () {
      final result = VehicleLocalDates.nowYmdInZone('America/Montreal');
      expect(result, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    });

    test(
      'respects different timezones across the International Date Line / midnight',
      () {
        final tokyo = tz_zone.getLocation('Asia/Tokyo');
        final honolulu = tz_zone.getLocation('Pacific/Honolulu');

        // Given a specific UTC instant (e.g. 2026-10-01 23:30:00 UTC)
        // In Tokyo (UTC+9), it is 2026-10-02 08:30:00
        // In Honolulu (UTC-10), it is 2026-10-01 13:30:00
        final instantUtc = DateTime.utc(2026, 10, 1, 23, 30, 0);
        final tokyoTime = tz_zone.TZDateTime.from(instantUtc, tokyo);
        final honoluluTime = tz_zone.TZDateTime.from(instantUtc, honolulu);

        expect(VehicleLocalDates.formatYmd(tokyoTime), '2026-10-02');
        expect(VehicleLocalDates.formatYmd(honoluluTime), '2026-10-01');
      },
    );

    test('falls back to device date when zone is null', () {
      final result = VehicleLocalDates.nowYmdInZone(null);
      expect(result, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    });

    test('falls back to device date when zone is empty', () {
      final result = VehicleLocalDates.nowYmdInZone('');
      expect(result, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    });

    test('falls back to device date for unknown zone name', () {
      final result = VehicleLocalDates.nowYmdInZone('Not/ATimezone');
      expect(result, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    });
  });

  group('VehicleLocalDates.splitByDay', () {
    test('single-day interval produces one fragment', () {
      final frags = VehicleLocalDates.splitByDay(
        '2026-10-01 08:00:00',
        '2026-10-01 18:00:00',
        true,
        'availability',
      );
      expect(frags.length, 1);
      expect(frags.first.day, '2026-10-01');
      expect(frags.first.rawStart, '2026-10-01 08:00:00');
      expect(frags.first.rawEnd, '2026-10-01 18:00:00');
      expect(frags.first.isAvailable, isTrue);
    });

    test('multi-day interval spanning 7 days produces 7 fragments', () {
      final frags = VehicleLocalDates.splitByDay(
        '2026-10-01 08:00:00',
        '2026-10-07 20:00:00',
        true,
        'availability',
      );
      expect(frags.length, 7);
      // First fragment keeps original rawStart
      expect(frags.first.rawStart, '2026-10-01 08:00:00');
      expect(frags.first.rawEnd, '2026-10-01 23:59:59');
      // Intermediate fragments use midnight boundaries
      expect(frags[3].day, '2026-10-04');
      expect(frags[3].rawStart, '2026-10-04 00:00:00');
      expect(frags[3].rawEnd, '2026-10-04 23:59:59');
      // Last fragment keeps original rawEnd
      expect(frags.last.day, '2026-10-07');
      expect(frags.last.rawStart, '2026-10-07 00:00:00');
      expect(frags.last.rawEnd, '2026-10-07 20:00:00');
    });

    test('interval crossing month boundary produces correct days', () {
      final frags = VehicleLocalDates.splitByDay(
        '2026-09-30 06:00:00',
        '2026-10-02 12:00:00',
        false,
        'availability',
      );
      expect(frags.length, 3);
      expect(frags.map((f) => f.day).toList(), [
        '2026-09-30',
        '2026-10-01',
        '2026-10-02',
      ]);
      expect(frags.every((f) => !f.isAvailable), isTrue);
    });

    test(
      'interval ending exactly at midnight does not produce 00:00 - 00:00 slot on next day',
      () {
        // 2026-10-01 00:00:00 to 2026-10-02 00:00:00 (e.g. availability_mode=always)
        final frags = VehicleLocalDates.splitByDay(
          '2026-10-01 00:00:00',
          '2026-10-02 00:00:00',
          true,
          'availability',
        );
        expect(frags.length, 1);
        expect(frags.first.day, '2026-10-01');
        expect(frags.first.rawStart, '2026-10-01 00:00:00');
        expect(frags.first.rawEnd, '2026-10-01 23:59:59');

        // Multi-day ending at midnight: 2026-10-01 08:00:00 to 2026-10-03 00:00:00
        final multiDay = VehicleLocalDates.splitByDay(
          '2026-10-01 08:00:00',
          '2026-10-03 00:00:00',
          true,
          'availability',
        );
        expect(multiDay.length, 2);
        expect(multiDay[0].day, '2026-10-01');
        expect(multiDay[1].day, '2026-10-02');
        expect(multiDay[1].rawEnd, '2026-10-02 23:59:59');
      },
    );

    test('malformed rawStart returns single fragment unchanged', () {
      final frags = VehicleLocalDates.splitByDay(
        '',
        '2026-10-01 18:00:00',
        true,
        'availability',
      );
      expect(frags.length, 1);
      expect(frags.first.rawStart, '');
    });
  });
}

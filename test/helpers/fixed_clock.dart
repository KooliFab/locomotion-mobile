import 'package:clock/clock.dart';

/// The "now" the date fixtures were written against: the shared loans
/// fixtures carry absolute dates (departures on 2026-10-10 and 2026-10-15)
/// that real time eventually overtakes.
final DateTime fixtureNow = DateTime.utc(2026, 10, 1, 12);

/// Runs [body] with `clock.now()` frozen at [fixtureNow], so validations that
/// reject past dates keep accepting the fixtures whatever the real date is.
T atFixtureNow<T>(T Function() body) =>
    withClock(Clock.fixed(fixtureNow), body);

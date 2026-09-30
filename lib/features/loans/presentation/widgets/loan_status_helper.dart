import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../loanables/domain/entities/loanable.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_status.dart';

/// Helper to format and display loan dates consistently in the vehicle's timezone.
class LoanDateFormatter {
  LoanDateFormatter._();

  /// Returns the vehicle timezone string if present in loanable.
  static String? getVehicleTimezone(Loan loan, [Loanable? loanable]) {
    return loanable?.timezone ?? loan.loanable?.timezone;
  }

  /// Converts a [DateTime] into a [DateTime] adjusted to [vehicleTimezone].
  ///
  /// If [vehicleTimezone] is provided and valid in the timezone database, returns
  /// a [DateTime] whose wall-clock year/month/day/hour/minute match the vehicle's local time.
  /// Otherwise, falls back to the provided [dt] (or device local if not UTC).
  static DateTime toVehicleDateTime(DateTime dt, String? vehicleTimezone) {
    if (vehicleTimezone != null && vehicleTimezone.isNotEmpty) {
      try {
        final location = tz.getLocation(vehicleTimezone);
        final tzDateTime = tz.TZDateTime.from(dt, location);
        return DateTime(
          tzDateTime.year,
          tzDateTime.month,
          tzDateTime.day,
          tzDateTime.hour,
          tzDateTime.minute,
          tzDateTime.second,
        );
      } catch (_) {
        // Unknown or uninitialized timezone: fall back to dt
      }
    }
    return dt;
  }

  /// Formats an instant [dt] into a readable string in the vehicle timezone if available.
  static String formatInVehicleZone(
    DateTime? dt, {
    String? vehicleTimezone,
    String pattern = 'dd/MM/yyyy HH:mm',
  }) {
    if (dt == null) return '—';
    final adjusted = toVehicleDateTime(dt, vehicleTimezone);
    final d = adjusted.day.toString().padLeft(2, '0');
    final m = adjusted.month.toString().padLeft(2, '0');
    final y = adjusted.year.toString().padLeft(4, '0');
    final hh = adjusted.hour.toString().padLeft(2, '0');
    final mm = adjusted.minute.toString().padLeft(2, '0');

    if (pattern == 'dd/MM/yyyy HH:mm') {
      return '$d/$m/$y $hh:$mm';
    }
    try {
      final formatter = DateFormat(pattern);
      return formatter.format(adjusted);
    } catch (_) {
      return '$d/$m/$y $hh:$mm';
    }
  }

  /// Formats a time range (start -> end) in vehicle timezone
  static String formatRange(Loan loan, {String? vehicleTimezone}) {
    final tz = vehicleTimezone ?? getVehicleTimezone(loan);
    final startStr = formatInVehicleZone(loan.startAt, vehicleTimezone: tz);
    final endStr = formatInVehicleZone(loan.endAt, vehicleTimezone: tz);
    return '$startStr → $endStr';
  }
}

/// Helper for loan status UI styling (labels, colors, badges).
class LoanStatusHelper {
  LoanStatusHelper._();

  static String label(LoanStatus status) {
    switch (status) {
      case LoanStatus.requested:
        return 'En attente';
      case LoanStatus.accepted:
        return 'Acceptée';
      case LoanStatus.confirmed:
        return 'Confirmée';
      case LoanStatus.ongoing:
        return 'En cours';
      case LoanStatus.ended:
        return 'Véhicule rendu';
      case LoanStatus.validated:
        return 'Validée';
      case LoanStatus.completed:
        return 'Terminée';
      case LoanStatus.canceled:
        return 'Annulée';
      case LoanStatus.rejected:
        return 'Refusée';
      case LoanStatus.unknown:
        return 'Statut indéterminé';
    }
  }

  static Color backgroundColor(LoanStatus status) {
    switch (status) {
      case LoanStatus.requested:
        return const Color(0xFFFEF3C7); // amber-100
      case LoanStatus.accepted:
      case LoanStatus.confirmed:
        return const Color(0xFFDBEAFE); // blue-100
      case LoanStatus.ongoing:
        return const Color(0xFFD1FAE5); // emerald-100
      case LoanStatus.ended:
      case LoanStatus.validated:
        return const Color(0xFFE0E7FF); // indigo-100
      case LoanStatus.completed:
        return const Color(0xFFF3F4F6); // gray-100
      case LoanStatus.canceled:
      case LoanStatus.rejected:
        return const Color(0xFFFEE2E2); // red-100
      case LoanStatus.unknown:
        return const Color(0xFFF3F4F6); // neutral gray
    }
  }

  static Color foregroundColor(LoanStatus status) {
    switch (status) {
      case LoanStatus.requested:
        return const Color(0xFF92400E); // amber-800
      case LoanStatus.accepted:
      case LoanStatus.confirmed:
        return const Color(0xFF1E40AF); // blue-800
      case LoanStatus.ongoing:
        return const Color(0xFF065F46); // emerald-800
      case LoanStatus.ended:
      case LoanStatus.validated:
        return const Color(0xFF3730A3); // indigo-800
      case LoanStatus.completed:
        return const Color(0xFF4B5563); // gray-700
      case LoanStatus.canceled:
      case LoanStatus.rejected:
        return const Color(0xFF991B1B); // red-800
      case LoanStatus.unknown:
        return const Color(0xFF6B7280); // gray-500
    }
  }

  static IconData icon(LoanStatus status) {
    switch (status) {
      case LoanStatus.requested:
        return Icons.hourglass_top_rounded;
      case LoanStatus.accepted:
        return Icons.thumb_up_alt_outlined;
      case LoanStatus.confirmed:
        return Icons.check_circle_outline_rounded;
      case LoanStatus.ongoing:
        return Icons.directions_car_rounded;
      case LoanStatus.ended:
        return Icons.assignment_turned_in_outlined;
      case LoanStatus.validated:
        return Icons.verified_outlined;
      case LoanStatus.completed:
        return Icons.task_alt_rounded;
      case LoanStatus.canceled:
        return Icons.cancel_outlined;
      case LoanStatus.rejected:
        return Icons.block_flipped;
      case LoanStatus.unknown:
        return Icons.help_outline_rounded;
    }
  }
}

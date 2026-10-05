import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/borrower/presentation/controllers/borrower_controller.dart';
import '../../features/fleet/presentation/controllers/fleet_controller.dart';
import '../../features/incidents/presentation/controllers/incidents_list_controller.dart';
import '../../features/loans/presentation/controllers/loans_controller.dart';
import '../../features/profile/presentation/controllers/profile_controller.dart';

/// Centralized helper to invalidate all private user session scopes.
///
/// Ensures that when a user logs out or switches accounts within the same
/// [ProviderContainer] or [ProviderScope], no cached private data
/// (loans, fleet, balance, incidents, borrower dossier) persists across sessions.
void resetUserSessionState(dynamic ref) {
  ref.invalidate(loansDashboardControllerProvider);
  ref.invalidate(myLoansControllerProvider);
  ref.invalidate(cancelledOrRejectedLoansProvider);
  ref.invalidate(ownerFleetControllerProvider);
  ref.invalidate(userBalanceControllerProvider);
  ref.invalidate(incidentsListControllerProvider);
  ref.invalidate(borrowerControllerProvider);
}

import 'package:flutter_riverpod/misc.dart' show ProviderOrFamily;
import '../../features/borrower/presentation/controllers/borrower_controller.dart';
import '../../features/communities/presentation/controllers/communities_controller.dart';
import '../../features/fleet/presentation/controllers/fleet_controller.dart';
import '../../features/incidents/presentation/controllers/incidents_list_controller.dart';
import '../../features/loanables/presentation/controllers/loanables_controller.dart';
import '../../features/loans/presentation/controllers/loans_controller.dart';
import '../../features/profile/presentation/controllers/profile_controller.dart';

/// Centralized helper to invalidate all private user session scopes.
///
/// Ensures that when a user logs out or switches accounts within the same
/// [ProviderContainer] or [ProviderScope], no cached private data
/// (loans, fleet, balance, incidents, borrower dossier, communities and the
/// community-scoped vehicle search) persists across sessions.
///
/// Takes `ref.invalidate` or `container.invalidate`.
void resetUserSessionState(
  void Function(ProviderOrFamily provider) invalidate,
) {
  invalidate(loansDashboardControllerProvider);
  invalidate(myLoansControllerProvider);
  invalidate(cancelledOrRejectedLoansProvider);
  invalidate(loanDetailProvider);
  invalidate(ownerFleetControllerProvider);
  invalidate(fleetVehicleDetailProvider);
  invalidate(userBalanceControllerProvider);
  invalidate(incidentsListControllerProvider);
  invalidate(borrowerControllerProvider);
  invalidate(communitiesListControllerProvider);
  invalidate(selectedLoanableCommunityProvider);
  invalidate(selectedLoanableTypeProvider);
  invalidate(loanablesListControllerProvider);
}

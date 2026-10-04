import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/borrower/presentation/screens/borrower_form_screen.dart';
import '../../features/borrower/presentation/screens/borrower_screen.dart';
import '../../features/communities/presentation/screens/communities_screen.dart';
import '../../features/loanables/presentation/screens/explore_screen.dart';
import '../../features/loanables/presentation/screens/loanable_detail_screen.dart';
import '../../features/loanables/presentation/controllers/loanables_controller.dart';
import '../../features/loanables/domain/entities/loanable.dart';
import '../../features/loans/domain/entities/loan.dart';
import '../../features/loans/presentation/screens/loan_departure_inspection_screen.dart';
import '../../features/loans/presentation/screens/loan_return_inspection_screen.dart';
import '../../features/loans/presentation/screens/loan_detail_screen.dart';
import '../../features/loans/presentation/screens/loan_reservation_screen.dart';
import '../../features/loans/presentation/screens/loan_success_screen.dart';
import '../../features/loans/presentation/screens/loans_list_screen.dart';
import '../../features/loans/presentation/screens/loans_screen.dart';
import '../../features/fleet/domain/entities/fleet_vehicle.dart';
import '../../features/fleet/presentation/screens/owner_fleet_screen.dart';
import '../../features/fleet/presentation/screens/owner_vehicle_detail_screen.dart';
import '../../features/fleet/presentation/screens/vehicle_form_screen.dart';
import '../../features/fleet/presentation/screens/vehicle_preview_screen.dart';
import '../../features/availability/presentation/screens/vehicle_availability_screen.dart';
import '../../features/incidents/presentation/screens/incident_detail_screen.dart';
import '../../features/incidents/presentation/screens/incident_report_screen.dart';
import '../../features/incidents/presentation/screens/incidents_list_screen.dart';
import '../../features/notifications/presentation/controllers/notifications_controller.dart';
import '../../features/profile/presentation/screens/payment_methods_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../theme/app_colors.dart';
import 'routes.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
final rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>(
  debugLabel: 'rootScaffoldMessenger',
);

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authNotifier = ValueNotifier<AsyncValue<dynamic>>(const AsyncLoading());
  ref.listen(authControllerProvider, (_, next) {
    authNotifier.value = next;
  });

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.explore,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isLoggedIn = authState.value != null;
      final isLoggingIn =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      if (!isLoggedIn && !isLoggingIn) {
        return AppRoutes.login;
      }
      if (isLoggedIn && isLoggingIn) {
        final notifState = ref.read(notificationsControllerProvider);
        if (notifState.pendingRedirectPath != null) {
          final target = notifState.pendingRedirectPath!;
          ref
              .read(notificationsControllerProvider.notifier)
              .consumePendingRedirect();
          return target;
        }
        return AppRoutes.explore;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainScaffold(currentPath: state.matchedLocation, child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.explore,
            builder: (context, state) => const ExploreScreen(),
          ),
          GoRoute(
            path: AppRoutes.loans,
            builder: (context, state) => const LoansScreen(),
          ),
          GoRoute(
            path: AppRoutes.communities,
            builder: (context, state) => const CommunitiesScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.borrower,
            builder: (context, state) => const BorrowerScreen(),
          ),
          GoRoute(
            path: AppRoutes.borrowerForm,
            builder: (context, state) => const BorrowerFormScreen(),
          ),
          GoRoute(
            path: AppRoutes.paymentMethods,
            builder: (context, state) => const PaymentMethodsScreen(),
          ),
          GoRoute(
            path: AppRoutes.loanableDetail,
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              if (id == null || id <= 0) {
                return const _InvalidLoanableIdScreen();
              }
              return LoanableDetailScreen(loanableId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.loanReservation,
            builder: (context, state) {
              final extra = state.extra;
              if (extra is Loanable) {
                return LoanReservationScreen(loanable: extra);
              }
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              if (id == null || id <= 0) {
                return const _InvalidLoanableIdScreen();
              }
              return _LoanableReservationLoaderScreen(loanableId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.loanSuccess,
            builder: (context, state) {
              final extra = state.extra;
              if (extra is Loan) {
                return LoanSuccessScreen(loan: extra);
              }
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              return Scaffold(
                appBar: AppBar(title: const Text('Confirmation')),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Demande #${id ?? ""} enregistrée.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.go(AppRoutes.loans),
                        child: const Text('Voir mes réservations'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          GoRoute(
            path: AppRoutes.loansList,
            builder: (context, state) {
              final status = state.uri.queryParameters['status'];
              return LoansListScreen(initialStatus: status);
            },
          ),
          GoRoute(
            path: AppRoutes.loanDetail,
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              if (id == null || id <= 0) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Réservation')),
                  body: const Center(
                    child: Text('Identifiant de réservation invalide.'),
                  ),
                );
              }
              final extra = state.extra;
              return LoanDetailScreen(
                loanId: id,
                initialLoan: extra is Loan ? extra : null,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.loanDeparture,
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              if (id == null || id <= 0) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Prise en charge')),
                  body: const Center(
                    child: Text('Identifiant de réservation invalide.'),
                  ),
                );
              }
              final extra = state.extra;
              return LoanDepartureInspectionScreen(
                loanId: id,
                initialLoan: extra is Loan ? extra : null,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.loanReturn,
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              if (id == null || id <= 0) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Restitution')),
                  body: const Center(
                    child: Text('Identifiant de réservation invalide.'),
                  ),
                );
              }
              final extra = state.extra;
              return LoanReturnInspectionScreen(
                loanId: id,
                initialLoan: extra is Loan ? extra : null,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.fleet,
            builder: (context, state) => const OwnerFleetScreen(),
          ),
          GoRoute(
            path: AppRoutes.fleetCreate,
            builder: (context, state) => const VehicleFormScreen(),
          ),
          GoRoute(
            path: AppRoutes.fleetDetail,
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              if (id == null || id <= 0) {
                return const _InvalidLoanableIdScreen();
              }
              return OwnerVehicleDetailScreen(vehicleId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.fleetEdit,
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              if (id == null || id <= 0) {
                return const _InvalidLoanableIdScreen();
              }
              final extra = state.extra;
              return VehicleFormScreen(
                vehicleId: id,
                initialVehicle: extra is FleetVehicle ? extra : null,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.fleetPreview,
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              if (id == null || id <= 0) {
                return const _InvalidLoanableIdScreen();
              }
              return VehiclePreviewScreen(vehicleId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.fleetAvailability,
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              if (id == null || id <= 0) {
                return const _InvalidLoanableIdScreen();
              }
              return VehicleAvailabilityScreen(vehicleId: id);
            },
          ),
          GoRoute(
            path: AppRoutes.incidents,
            builder: (context, state) {
              final loanId = int.tryParse(state.uri.queryParameters['loan_id'] ?? '');
              final loanableId = int.tryParse(state.uri.queryParameters['loanable_id'] ?? '');
              return IncidentsListScreen(loanId: loanId, loanableId: loanableId);
            },
          ),
          GoRoute(
            path: AppRoutes.incidentReport,
            builder: (context, state) {
              final loanableId = int.tryParse(state.uri.queryParameters['loanable_id'] ?? '') ?? 0;
              final vehicleName = state.uri.queryParameters['vehicle_name'];
              final loanId = int.tryParse(state.uri.queryParameters['loan_id'] ?? '');
              final ownerName = state.uri.queryParameters['owner_name'];
              final ownerPhone = state.uri.queryParameters['owner_phone'];
              final ownerEmail = state.uri.queryParameters['owner_email'];
              return IncidentReportScreen(
                loanableId: loanableId,
                vehicleName: vehicleName,
                loanId: loanId,
                ownerName: ownerName,
                ownerPhone: ownerPhone,
                ownerEmail: ownerEmail,
              );
            },
          ),
          GoRoute(
            path: AppRoutes.incidentDetail,
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              if (id == null || id <= 0) {
                return const Scaffold(
                  body: Center(child: Text('Identifiant d\'incident invalide.')),
                );
              }
              return IncidentDetailScreen(incidentId: id);
            },
          ),
        ],
      ),
    ],
  );
}

class _InvalidLoanableIdScreen extends StatelessWidget {
  const _InvalidLoanableIdScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Véhicule')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Identifiant de véhicule invalide.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

class _LoanableReservationLoaderScreen extends ConsumerWidget {
  final int loanableId;

  const _LoanableReservationLoaderScreen({required this.loanableId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loanableAsync = ref.watch(loanableDetailProvider(loanableId));

    return loanableAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Réservation')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppColors.danger,
                ),
                const SizedBox(height: 12),
                Text(
                  'Impossible de charger le véhicule #$loanableId',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.invalidate(loanableDetailProvider(loanableId)),
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (loanable) => LoanReservationScreen(loanable: loanable),
    );
  }
}

class MainScaffold extends StatelessWidget {
  final String currentPath;
  final Widget child;

  const MainScaffold({
    super.key,
    required this.currentPath,
    required this.child,
  });

  int _calculateSelectedIndex() {
    if (currentPath.startsWith(AppRoutes.loans)) return 1;
    if (currentPath.startsWith(AppRoutes.communities)) return 2;
    if (currentPath.startsWith(AppRoutes.profile)) return 3;
    return 0; // explore
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.explore);
        break;
      case 1:
        context.go(AppRoutes.loans);
        break;
      case 2:
        context.go(AppRoutes.communities);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex();

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(context, index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore_rounded),
              label: 'Explorer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_month_rounded),
              label: 'Réservations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined),
              activeIcon: Icon(Icons.groups_rounded),
              label: 'Communautés',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

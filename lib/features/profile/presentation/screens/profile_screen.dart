import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../borrower/domain/entities/borrower_status.dart';
import '../../../notifications/presentation/controllers/notifications_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref
          .read(notificationsControllerProvider.notifier)
          .refreshPermissionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;
    final balanceAsync = ref.watch(userBalanceControllerProvider);
    final borrowerStatus = BorrowerStatusX.from(user?.borrower);
    final notifState = ref.watch(notificationsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mon Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // User Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user?.firstName?.isNotEmpty == true
                          ? user!.firstName![0].toUpperCase()
                          : (user?.email.isNotEmpty == true
                                ? user!.email[0].toUpperCase()
                                : 'L'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user != null &&
                                  (user.firstName != null ||
                                      user.lastName != null)
                              ? '${user.firstName ?? ''} ${user.lastName ?? ''}'
                                    .trim()
                              : 'Membre LocoMotion',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? 'Non connecté',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _BorrowerStatusBadge(status: borrowerStatus),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Solde / Balance
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Solde du compte',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Crédits disponibles',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  balanceAsync.when(
                    data: (balance) => Text(
                      '${balance.toStringAsFixed(2)} \$',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    loading: () => const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (_, _) => const Text(
                      '0.00 \$',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Menu Sections
          _buildMenuSection([
            _MenuItem(
              icon: Icons.shield_outlined,
              title: 'Dossier conducteur & Permis',
              subtitle: borrowerStatus.label,
              onTap: () => context.push(AppRoutes.borrower),
            ),
            _MenuItem(
              icon: Icons.credit_card_outlined,
              title: 'Moyens de paiement',
              subtitle: 'Cartes bancaires & Stripe',
              onTap: () => context.push(AppRoutes.paymentMethods),
            ),
          ]),
          const SizedBox(height: 16),

          // Notifications Push
          _buildMenuSection([
            _MenuItem(
              icon: notifState.isPermissionGranted
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_off_outlined,
              iconColor: notifState.isPermissionGranted
                  ? AppColors.primary
                  : AppColors.warning,
              title: 'Notifications push',
              subtitle: notifState.isPermissionGranted
                  ? 'Activées'
                  : 'Notifications désactivées',
              onTap: () async {
                if (!notifState.isPermissionGranted) {
                  final granted = await ref
                      .read(notificationsControllerProvider.notifier)
                      .requestPermission();
                  if (!granted) {
                    try {
                      await AppSettings.openAppSettings(
                        type: AppSettingsType.notification,
                      );
                    } catch (_) {
                      await AppSettings.openAppSettings();
                    }
                  }
                }
              },
            ),
          ]),
          const SizedBox(height: 16),

          _buildMenuSection([
            _MenuItem(
              icon: Icons.help_outline_rounded,
              title: 'Aide & Signalement',
              subtitle: 'Signaler un incident',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.logout_rounded,
              title: 'Déconnexion',
              textColor: AppColors.danger,
              iconColor: AppColors.danger,
              onTap: () => _showLogoutDialog(context),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildMenuSection(List<_MenuItem> items) {
    return Card(
      child: Column(
        children: items.map((item) {
          return ListTile(
            leading: Icon(
              item.icon,
              color: item.iconColor ?? AppColors.textPrimary,
            ),
            title: Text(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: item.textColor ?? AppColors.textPrimary,
              ),
            ),
            subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
            ),
            onTap: item.onTap,
          );
        }).toList(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text(
          'Voulez-vous vraiment vous déconnecter de LocoMotion ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(authControllerProvider.notifier).logout();
            },
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
  }
}

class _BorrowerStatusBadge extends StatelessWidget {
  final BorrowerStatus status;

  const _BorrowerStatusBadge({required this.status});

  Color get _bgColor {
    switch (status) {
      case BorrowerStatus.validated:
        return AppColors.successBg;
      case BorrowerStatus.suspended:
      case BorrowerStatus.checkRequired:
        return AppColors.dangerBg;
      case BorrowerStatus.pending:
        return AppColors.warningBg;
      case BorrowerStatus.incomplete:
        return AppColors.warningBg;
    }
  }

  Color get _textColor {
    switch (status) {
      case BorrowerStatus.validated:
        return AppColors.success;
      case BorrowerStatus.suspended:
      case BorrowerStatus.checkRequired:
        return AppColors.danger;
      case BorrowerStatus.pending:
      case BorrowerStatus.incomplete:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: _textColor,
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.textColor,
    this.iconColor,
  });
}

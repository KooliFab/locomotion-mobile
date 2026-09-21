import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;
    final balanceAsync = ref.watch(userBalanceControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
      ),
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
                          : (user?.email.isNotEmpty == true ? user!.email[0].toUpperCase() : 'L'),
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
                          user != null && (user.firstName != null || user.lastName != null)
                              ? '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim()
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: user?.isBorrowerApproved == true
                                ? AppColors.successBg
                                : AppColors.warningBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            user?.isBorrowerApproved == true
                                ? 'Emprunteur validé'
                                : 'Validation en attente',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: user?.isBorrowerApproved == true
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                        ),
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
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Crédits disponibles',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                    error: (_, _) => const Text('0.00 \$', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Menu Sections
          _buildMenuSection([
            _MenuItem(
              icon: Icons.credit_card_rounded,
              title: 'Moyens de paiement',
              subtitle: 'Gérer vos cartes Stripe',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.receipt_long_rounded,
              title: 'Factures',
              subtitle: 'Historique des reçus',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.shield_outlined,
              title: 'Dossier conducteur & Permis',
              subtitle: 'Pièces justificatives',
              onTap: () {},
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
              onTap: () => _showLogoutDialog(context, ref),
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
            leading: Icon(item.icon, color: item.iconColor ?? AppColors.textPrimary),
            title: Text(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: item.textColor ?? AppColors.textPrimary,
              ),
            ),
            subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            onTap: item.onTap,
          );
        }).toList(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Voulez-vous vraiment vous déconnecter de LocoMotion ?'),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/borrower_status.dart';

class BorrowerScreen extends ConsumerWidget {
  const BorrowerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;
    final borrower = user?.borrower;
    final status = BorrowerStatusX.from(borrower);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dossier conducteur & Permis'),
        leading: BackButton(onPressed: () => context.go(AppRoutes.profile)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StatusCard(status: status, submittedAt: borrower?.submittedAt),
            const SizedBox(height: 24),
            _ActionButton(status: status),
            if (status == BorrowerStatus.suspended) ...[
              const SizedBox(height: 16),
              _SupportCard(),
            ],
            if (status == BorrowerStatus.checkRequired) ...[
              const SizedBox(height: 16),
              _CheckRequiredCard(),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final BorrowerStatus status;
  final DateTime? submittedAt;

  const _StatusCard({required this.status, this.submittedAt});

  Color get _cardColor {
    switch (status) {
      case BorrowerStatus.validated:
        return AppColors.successBg;
      case BorrowerStatus.suspended:
      case BorrowerStatus.checkRequired:
        return AppColors.dangerBg;
      case BorrowerStatus.pending:
        return AppColors.warningBg;
      case BorrowerStatus.incomplete:
        return AppColors.surface;
    }
  }

  Color get _iconColor {
    switch (status) {
      case BorrowerStatus.validated:
        return AppColors.success;
      case BorrowerStatus.suspended:
      case BorrowerStatus.checkRequired:
        return AppColors.danger;
      case BorrowerStatus.pending:
        return AppColors.warning;
      case BorrowerStatus.incomplete:
        return AppColors.textSecondary;
    }
  }

  IconData get _icon {
    switch (status) {
      case BorrowerStatus.validated:
        return Icons.verified_rounded;
      case BorrowerStatus.suspended:
        return Icons.block_rounded;
      case BorrowerStatus.checkRequired:
        return Icons.warning_amber_rounded;
      case BorrowerStatus.pending:
        return Icons.hourglass_empty_rounded;
      case BorrowerStatus.incomplete:
        return Icons.assignment_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? formattedDate;
    if (submittedAt != null) {
      try {
        formattedDate = DateFormat(
          'd MMMM yyyy',
          'fr_CA',
        ).format(submittedAt!.toLocal());
      } catch (_) {
        formattedDate = DateFormat('yyyy-MM-dd').format(submittedAt!.toLocal());
      }
    }

    return Card(
      color: _cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _iconColor.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(_icon, size: 48, color: _iconColor),
            const SizedBox(height: 12),
            Text(
              status.label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _iconColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            if (formattedDate != null) ...[
              const SizedBox(height: 12),
              Text(
                'Soumis le $formattedDate',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final BorrowerStatus status;

  const _ActionButton({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case BorrowerStatus.incomplete:
        return ElevatedButton.icon(
          onPressed: () => context.push(AppRoutes.borrowerForm),
          icon: const Icon(Icons.edit_document),
          label: const Text('Compléter mon dossier'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        );
      case BorrowerStatus.pending:
        return OutlinedButton.icon(
          onPressed: () => context.push(AppRoutes.borrowerForm),
          icon: const Icon(Icons.visibility_outlined),
          label: const Text('Consulter les informations envoyées'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        );
      case BorrowerStatus.validated:
        return const SizedBox.shrink();
      case BorrowerStatus.suspended:
      case BorrowerStatus.checkRequired:
        return const SizedBox.shrink();
    }
  }
}

class _SupportCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 0,
      color: AppColors.surface,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.support_agent_rounded, color: AppColors.primary),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Contactez le support LocoMotion pour plus d\'informations sur la suspension de votre dossier.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckRequiredCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 0,
      color: AppColors.warningBg,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: AppColors.warning),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Une vérification manuelle est requise. Un état inattendu a été détecté et enregistré.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

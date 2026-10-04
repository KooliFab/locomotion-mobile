import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EmergencyDisclaimerCard extends StatelessWidget {
  final String? ownerName;
  final String? ownerPhone;
  final String? ownerEmail;

  const EmergencyDisclaimerCard({
    super.key,
    this.ownerName,
    this.ownerPhone,
    this.ownerEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('emergency_disclaimer_card'),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warning,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Consignes d\'urgence & assistance',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Ce formulaire sert à consigner un incident pour les gestionnaires et le propriétaire. Il ne constitue pas un service de dépannage ou d\'urgence garanti.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(Icons.phone_in_talk_rounded, color: AppColors.danger, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Urgence vitale ou danger : 112 (Europe) / 911 (Am. Nord)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.danger,
                        ),
                  ),
                ),
              ],
            ),
          ),
          if (ownerName != null || ownerPhone != null || ownerEmail != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 6),
            Text(
              'Contact du propriétaire :',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 4),
            if (ownerName != null && ownerName!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      ownerName!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            if (ownerPhone != null && ownerPhone!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    SelectableText(
                      ownerPhone!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            if (ownerEmail != null && ownerEmail!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.mail_outline, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    SelectableText(
                      ownerEmail!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

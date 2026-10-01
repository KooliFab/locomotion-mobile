import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/maps/adaptive_map_widget.dart';
import '../../../../core/maps/map_marker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../borrower/domain/entities/borrower_status.dart';
import '../../domain/entities/loanable.dart';
import '../../domain/entities/loanable_incident.dart';
import '../../domain/entities/vehicle_local_dates.dart';
import '../controllers/loanables_controller.dart';
import '../widgets/loanable_image_widget.dart';

const int _availabilityWindowDays = 7;

class LoanableDetailScreen extends ConsumerWidget {
  final int loanableId;

  const LoanableDetailScreen({super.key, required this.loanableId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(loanableDetailProvider(loanableId));

    return Scaffold(
      appBar: AppBar(title: const Text('Véhicule')),
      body: AsyncValueWidget<Loanable>(
        value: detailAsync,
        onRetry: () => ref.invalidate(loanableDetailProvider(loanableId)),
        data: (detail) => _DetailBody(loanableId: loanableId, detail: detail),
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  final int loanableId;
  final Loanable detail;

  const _DetailBody({required this.loanableId, required this.detail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = [
      if (detail.image != null) detail.image!,
      ...detail.images.where((img) => img.id != detail.image?.id),
    ];

    final authState = ref.watch(authControllerProvider);
    final user = authState.value;
    final borrower = user?.borrower;
    final borrowerStatus = BorrowerStatusX.from(borrower);
    final isRestrictedType =
        detail.type == 'car' || detail.type == 'car_trailer';
    final canRequest =
        user != null && (!isRestrictedType || borrowerStatus.canReserveCar);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gallery
          SizedBox(
            height: 220,
            child: images.isEmpty
                ? const LoanableImageWidget(image: null, height: 220)
                : PageView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) =>
                        LoanableImageWidget(image: images[index], height: 220),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        detail.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    _StatusBadge(detail: detail),
                  ],
                ),
                if (detail.communityName != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    detail.communityName!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  _typeLabel(detail.type),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),

                // Incidents
                if (detail.activeIncidents.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _IncidentsSection(incidents: detail.activeIncidents),
                ],

                // Location
                const SizedBox(height: 20),
                _sectionTitle('Localisation'),
                if (detail.locationDescription != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    detail.locationDescription!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                if (detail.latitude != null && detail.longitude != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 160,
                      child: AdaptiveMapWidget(
                        initialLatitude: detail.latitude!,
                        initialLongitude: detail.longitude!,
                        initialZoom: 15,
                        markers: [
                          AppMapMarker(
                            id: detail.id.toString(),
                            title: detail.name,
                            snippet:
                                detail.locationDescription ?? detail.address,
                            latitude: detail.latitude!,
                            longitude: detail.longitude!,
                            type: detail.type,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Position non disponible',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),

                // Characteristics
                const SizedBox(height: 20),
                _sectionTitle('Caractéristiques'),
                const SizedBox(height: 8),
                if (detail.details != null && detail.details!.isNotEmpty)
                  ...detail.details!.entries
                      .where((e) => e.key != 'report')
                      .map(
                        (e) => _detailRow(
                          _characteristicLabel(e.key),
                          _formatCharacteristicValue(e.value),
                        ),
                      )
                else
                  const Text(
                    'Aucune caractéristique renseignée.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                  ),

                if (detail.minLoanDurationInMinutes != null ||
                    detail.maxLoanDurationInMinutes != null) ...[
                  const SizedBox(height: 12),
                  if (detail.minLoanDurationInMinutes != null)
                    _detailRow(
                      'Durée minimale',
                      '${detail.minLoanDurationInMinutes} min',
                    ),
                  if (detail.maxLoanDurationInMinutes != null)
                    _detailRow(
                      'Durée maximale',
                      '${detail.maxLoanDurationInMinutes} min',
                    ),
                ],

                // Comments / instructions
                if (detail.comments != null &&
                    detail.comments!.trim().isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _sectionTitle('Notes'),
                  const SizedBox(height: 6),
                  Text(
                    detail.comments!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
                if (detail.instructions != null &&
                    detail.instructions!.trim().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _sectionTitle('Instructions'),
                  const SizedBox(height: 6),
                  Text(
                    detail.instructions!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
                if (detail.returnInstructions != null &&
                    detail.returnInstructions!.trim().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _sectionTitle('Retour du véhicule'),
                  const SizedBox(height: 6),
                  Text(
                    detail.returnInstructions!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],

                // Availability
                const SizedBox(height: 24),
                _sectionTitle('Disponibilités'),
                if (detail.timezone != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Fuseau du véhicule : ${detail.timezone}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                _AvailabilitySection(
                  loanableId: loanableId,
                  timezone: detail.timezone,
                ),

                // CTA
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canRequest
                        ? () {
                            context.push(
                              AppRoutes.loanReservationPath(detail.id),
                              extra: detail,
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Continuer vers la demande'),
                  ),
                ),
                const SizedBox(height: 8),
                if (authState.isLoading)
                  const SizedBox.shrink()
                else if (authState.hasError)
                  const Text(
                    'Impossible de vérifier votre statut d\'éligibilité pour le moment.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  )
                else if (!canRequest)
                  Text(
                    user == null
                        ? 'Connectez-vous pour pouvoir réserver ce véhicule.'
                        : (borrowerStatus == BorrowerStatus.pending
                              ? 'Votre dossier emprunteur est en cours de validation.'
                              : 'Vous n\'êtes pas encore éligible pour ce type de véhicule. '
                                    'Complétez votre profil emprunteur pour demander une validation.'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.warning.withValues(alpha: 0.9),
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _typeLabel(String type) {
    switch (type) {
      case 'car':
        return 'Voiture';
      case 'bike':
        return 'Vélo / Cargo';
      case 'trailer':
        return 'Remorque';
      case 'car_trailer':
        return 'Remorque auto';
      default:
        return type;
    }
  }

  static String _characteristicLabel(String key) {
    switch (key) {
      case 'brand':
        return 'Marque';
      case 'model':
        return 'Modèle';
      case 'year':
      case 'year_of_circulation':
        return 'Année';
      case 'seats':
        return 'Places assises';
      case 'transmission':
      case 'transmission_mode':
        return 'Boîte de vitesses';
      case 'engine':
        return 'Motorisation';
      case 'plate_number':
        return 'Immatriculation';
      case 'size':
        return 'Taille';
      case 'bike_type':
        return 'Type de vélo';
      case 'maximum_charge':
        return 'Charge maximale';
      case 'dimensions':
        return 'Dimensions';
      case 'papers_location':
        return 'Emplacement des papiers';
      case 'insurer':
        return 'Assureur';
      case 'has_informed_insurer':
        return 'Assureur informé';
      case 'pricing_category':
        return 'Catégorie tarifaire';
      case 'value_category':
        return 'Catégorie de valeur';
      case 'has_onboard_notebook':
        return 'Carnet de bord';
      case 'has_report_in_notebook':
        return 'Constat dans le carnet';
      default:
        return key.replaceAll('_', ' ');
    }
  }

  static String _formatCharacteristicValue(dynamic val) {
    if (val == null) return '—';
    if (val is bool) return val ? 'Oui' : 'Non';
    if (val is Map) {
      return val.entries
          .where((e) => e.value != null)
          .map(
            (e) =>
                '${_characteristicLabel(e.key.toString())}: ${_formatCharacteristicValue(e.value)}',
          )
          .join(', ');
    }
    if (val is List) {
      return val.map((e) => _formatCharacteristicValue(e)).join(', ');
    }
    if (val is String) {
      switch (val) {
        case 'automatic':
          return 'Automatique';
        case 'manual':
          return 'Manuelle';
        case 'electric':
          return 'Électrique';
        case 'hybrid':
          return 'Hybride';
        case 'gasoline':
        case 'gas':
          return 'Essence';
        case 'diesel':
          return 'Diesel';
        default:
          return val;
      }
    }
    return val.toString();
  }
}

class _StatusBadge extends StatelessWidget {
  final Loanable detail;

  const _StatusBadge({required this.detail});

  @override
  Widget build(BuildContext context) {
    final status = detail.availabilityStatus;
    if (status == null) {
      return const SizedBox.shrink();
    }
    final available = detail.isAvailable;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: available ? AppColors.successBg : AppColors.warningBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        available ? 'Disponible' : 'Indisponible',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: available ? AppColors.success : AppColors.warning,
        ),
      ),
    );
  }
}

class _IncidentsSection extends StatelessWidget {
  final List<LoanableIncident> incidents;

  const _IncidentsSection({required this.incidents});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warning,
                size: 18,
              ),
              SizedBox(width: 6),
              Text(
                'Incident(s) actuel(s)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...incidents.map((incident) {
            final type = incident.incidentType ?? 'Incident';
            final isBlocking = incident.isBlocking;
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      type,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  if (isBlocking)
                    const Text(
                      'Bloquant',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.danger,
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _AvailabilitySection extends ConsumerWidget {
  final int loanableId;
  final String? timezone;

  const _AvailabilitySection({required this.loanableId, this.timezone});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodStart = ref.watch(
      loanableAvailabilityPeriodProvider(loanableId, timezone: timezone),
    );
    final periodEnd = VehicleLocalDates.shiftYmd(
      periodStart,
      _availabilityWindowDays,
    );
    final start = '$periodStart 00:00:00';
    final end = '$periodEnd 00:00:00';

    final windowAsync = ref.watch(
      loanableAvailabilityWindowProvider(loanableId, start, end),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Legend
        Row(
          children: [
            _legendDot(AppColors.success),
            const SizedBox(width: 6),
            const Text(
              'Disponible',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 14),
            _legendDot(AppColors.warning),
            const SizedBox(width: 6),
            const Text(
              'Indisponible',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            IconButton(
              onPressed: () => ref
                  .read(
                    loanableAvailabilityPeriodProvider(
                      loanableId,
                      timezone: timezone,
                    ).notifier,
                  )
                  .shift(-_availabilityWindowDays),
              icon: const Icon(Icons.chevron_left_rounded),
              tooltip: 'Période précédente',
            ),
            Expanded(
              child: Text(
                '${VehicleLocalDates.shortLabel(periodStart)} → '
                '${VehicleLocalDates.shortLabel(VehicleLocalDates.shiftYmd(periodStart, _availabilityWindowDays - 1))}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            IconButton(
              onPressed: () => ref
                  .read(
                    loanableAvailabilityPeriodProvider(
                      loanableId,
                      timezone: timezone,
                    ).notifier,
                  )
                  .shift(_availabilityWindowDays),
              icon: const Icon(Icons.chevron_right_rounded),
              tooltip: 'Période suivante',
            ),
          ],
        ),
        const SizedBox(height: 8),
        windowAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
          error: (e, _) {
            final message = e is AppException
                ? e.message
                : (e.toString().startsWith('Exception: ')
                      ? e.toString().substring(11)
                      : 'Une erreur est survenue lors de la récupération des disponibilités.');
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.dangerBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Impossible de charger les disponibilités : $message',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: const BorderSide(color: AppColors.danger),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => ref.invalidate(
                      loanableAvailabilityWindowProvider(
                        loanableId,
                        start,
                        end,
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text(
                      'Réessayer',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          },
          data: (window) {
            if (window.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Aucune donnée de disponibilité pour cette période.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              );
            }
            final days = VehicleLocalDates.daysFrom(
              periodStart,
              _availabilityWindowDays,
            );
            // Expand every interval into per-day fragments so that a single
            // multi-day block (e.g. available Mon–Sun) appears on all 7 days
            // instead of only Monday.
            final fragmentsByDay = <String, List<DayFragment>>{};
            for (final interval in window.all) {
              final rawStart = interval.rawStart;
              final rawEnd = interval.rawEnd;
              if (rawStart == null || rawEnd == null) continue;
              final frags = VehicleLocalDates.splitByDay(
                rawStart,
                rawEnd,
                interval.isAvailable,
                interval.type,
              );
              for (final frag in frags) {
                fragmentsByDay.putIfAbsent(frag.day, () => []).add(frag);
              }
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: days.map((day) {
                final dayFragments = fragmentsByDay[day] ?? [];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        VehicleLocalDates.shortLabel(day),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (dayFragments.isEmpty)
                        const Text(
                          'Aucun créneau renvoyé',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        )
                      else
                        ...dayFragments.map((f) => _slotRow(f)),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _slotRow(DayFragment f) {
    final start = VehicleLocalDates.hhmm(f.rawStart);
    final end = VehicleLocalDates.hhmm(f.rawEnd);
    final available = f.isAvailable;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: available ? AppColors.success : AppColors.warning,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$start – $end',
            style: TextStyle(
              fontSize: 13,
              color: available
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: available ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            available ? 'Disponible' : 'Indisponible',
            style: TextStyle(
              fontSize: 12,
              color: available ? AppColors.success : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

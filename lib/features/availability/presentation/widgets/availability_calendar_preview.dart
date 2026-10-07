import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../loanables/domain/entities/loanable_availability.dart';
import '../../../loanables/presentation/controllers/loanables_controller.dart';
import '../../domain/entities/availability_config.dart';

class AvailabilityCalendarPreview extends ConsumerStatefulWidget {
  final AvailabilityConfig config;

  const AvailabilityCalendarPreview({super.key, required this.config});

  @override
  ConsumerState<AvailabilityCalendarPreview> createState() =>
      _AvailabilityCalendarPreviewState();
}

class _AvailabilityCalendarPreviewState
    extends ConsumerState<AvailabilityCalendarPreview> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final startStr = DateFormat('yyyy-MM-dd').format(_focusedMonth);
    // Laravel uses exclusive end [start, end). To include the entire last day of the month,
    // request the 1st day of the following month:
    final firstDayNextMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      1,
    );
    final endStr = DateFormat('yyyy-MM-dd').format(firstDayNextMonth);

    final windowAsync = ref.watch(
      loanableAvailabilityWindowProvider(
        widget.config.vehicleId,
        startStr,
        endStr,
      ),
    );

    return Column(
      children: [
        // Month Navigation
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
              ),
              Text(
                DateFormat(
                  'MMMM yyyy',
                  'fr_FR',
                ).format(_focusedMonth).toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
              ),
            ],
          ),
        ),

        // Day Headers
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WeekdayHeader('Lun'),
              _WeekdayHeader('Mar'),
              _WeekdayHeader('Mer'),
              _WeekdayHeader('Jeu'),
              _WeekdayHeader('Ven'),
              _WeekdayHeader('Sam'),
              _WeekdayHeader('Dim'),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Calendar Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: windowAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Erreur aperçu : $err'),
              ),
            ),
            data: (window) {
              return _buildGrid(window.unavailable);
            },
          ),
        ),

        const SizedBox(height: 16),
        // Legend
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(AppColors.card, AppColors.border, 'Disponible'),
              const SizedBox(width: 16),
              _buildLegendItem(
                AppColors.warning.withValues(alpha: 0.2),
                AppColors.warning,
                'Indisponible',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(List<LoanableAvailabilityInterval> unavailableIntervals) {
    final firstDayOfWeek = _focusedMonth.weekday; // 1 = Monday, 7 = Sunday
    final daysInMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    ).day;
    final totalCells = ((daysInMonth + firstDayOfWeek - 1) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.1,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNumber = index - (firstDayOfWeek - 1) + 1;
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final dayStart = DateTime(
          _focusedMonth.year,
          _focusedMonth.month,
          dayNumber,
          0,
          0,
          0,
        );
        final dayEnd = dayStart.add(const Duration(days: 1));

        // Check if the 24-hour day overlaps with any unavailable interval [interval.start, interval.end)
        final isUnavailable = unavailableIntervals.any((interval) {
          return interval.start.isBefore(dayEnd) &&
              interval.end.isAfter(dayStart);
        });

        return Container(
          decoration: BoxDecoration(
            color: isUnavailable
                ? AppColors.warning.withValues(alpha: 0.15)
                : AppColors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isUnavailable ? AppColors.warning : AppColors.border,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$dayNumber',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isUnavailable ? AppColors.warning : AppColors.textPrimary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(Color bg, Color border, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  final String label;
  const _WeekdayHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

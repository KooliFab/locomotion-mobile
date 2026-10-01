import 'package:flutter/material.dart';
import '../../domain/entities/loan.dart';
import 'loan_status_helper.dart';

class LoanTimelineWidget extends StatelessWidget {
  final Loan loan;

  const LoanTimelineWidget({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    // Only build items for timestamps that ACTUALLY exist in the loan data from Laravel
    final events = <_TimelineItem>[];

    if (loan.createdAt != null) {
      events.add(
        _TimelineItem(
          title: 'Demande créée',
          subtitle: LoanDateFormatter.formatInVehicleZone(loan.createdAt),
          icon: Icons.create_outlined,
          color: Colors.blueGrey,
          isCompleted: true,
        ),
      );
    }

    if (loan.acceptedAt != null) {
      events.add(
        _TimelineItem(
          title: 'Demande acceptée par le propriétaire',
          subtitle: LoanDateFormatter.formatInVehicleZone(loan.acceptedAt),
          icon: Icons.thumb_up_alt_rounded,
          color: Colors.green,
          isCompleted: true,
        ),
      );
    }

    if (loan.prepaidAt != null) {
      events.add(
        _TimelineItem(
          title: 'Prépaiement confirmé',
          subtitle: LoanDateFormatter.formatInVehicleZone(loan.prepaidAt),
          icon: Icons.payment_rounded,
          color: Colors.indigo,
          isCompleted: true,
        ),
      );
    }

    // Notice: There is no rejected_at in Laravel LoanResource!
    // If loan is rejected, display the rejection event without an invented timestamp.
    if (loan.parsedStatus.value == 'rejected') {
      events.add(
        const _TimelineItem(
          title: 'Demande refusée par le propriétaire',
          subtitle: 'Réservation refusée',
          icon: Icons.cancel_rounded,
          color: Colors.red,
          isCompleted: true,
        ),
      );
    }

    if (loan.canceledAt != null) {
      events.add(
        _TimelineItem(
          title: 'Réservation annulée',
          subtitle: LoanDateFormatter.formatInVehicleZone(loan.canceledAt),
          icon: Icons.cancel_outlined,
          color: Colors.red,
          isCompleted: true,
        ),
      );
    }

    if (loan.actualReturnAt != null &&
        loan.parsedStatus.value != 'requested' &&
        loan.parsedStatus.value != 'canceled') {
      events.add(
        _TimelineItem(
          title: 'Véhicule retourné',
          subtitle: LoanDateFormatter.formatInVehicleZone(loan.actualReturnAt),
          icon: Icons.assignment_turned_in_rounded,
          color: Colors.teal,
          isCompleted: true,
        ),
      );
    }

    if (loan.ownerValidatedAt != null) {
      events.add(
        _TimelineItem(
          title: 'Validation par le propriétaire',
          subtitle: LoanDateFormatter.formatInVehicleZone(
            loan.ownerValidatedAt,
          ),
          icon: Icons.verified_user_rounded,
          color: Colors.purple,
          isCompleted: true,
        ),
      );
    }

    if (loan.borrowerValidatedAt != null) {
      events.add(
        _TimelineItem(
          title: 'Validation par l\'emprunteur',
          subtitle: LoanDateFormatter.formatInVehicleZone(
            loan.borrowerValidatedAt,
          ),
          icon: Icons.done_all_rounded,
          color: Colors.blue,
          isCompleted: true,
        ),
      );
    }

    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.timeline_rounded, size: 20, color: Colors.blueGrey),
                SizedBox(width: 8),
                Text(
                  'Historique de la réservation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final item = events[index];
                final isLast = index == events.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: item.color.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(item.icon, size: 16, color: item.color),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 32,
                            color: Colors.grey.shade300,
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (item.subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                item.subtitle!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final bool isCompleted;

  const _TimelineItem({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    this.isCompleted = false,
  });
}

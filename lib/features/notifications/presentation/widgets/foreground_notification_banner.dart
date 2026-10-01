import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/push_payload.dart';

class ForegroundNotificationBanner {
  static void show(
    BuildContext? context, {
    required PushPayload payload,
  }) {
    final messenger = (context != null ? ScaffoldMessenger.maybeOf(context) : null) ??
        rootScaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              payload.title ?? 'LocoMotion',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(payload.body ?? 'Activité sur votre réservation'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Voir',
          onPressed: () {
            final targetContext = context ?? rootNavigatorKey.currentContext;
            if (targetContext != null) {
              targetContext.push('/loans/${payload.loanId}');
            }
          },
        ),
      ),
    );
  }
}

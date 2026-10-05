import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';
import 'core/config/env.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/notifications/domain/entities/push_payload.dart';
import 'features/notifications/presentation/controllers/notifications_controller.dart';
import 'features/notifications/presentation/widgets/foreground_notification_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Validate configuration for current environment
  AppConfig.validate();

  // Initialise locale data for intl DateFormat
  try {
    await initializeDateFormatting('fr_CA', null);
    await initializeDateFormatting('fr', null);
  } catch (e) {
    debugPrint('[intl] initializeDateFormatting failed: $e');
  }

  // Initialise Firebase if available (non-fatal if missing config or in test)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('[Firebase] initializeApp skipped or failed: $e');
  }

  // Initialise the timezone database so VehicleLocalDates.nowYmdInZone()
  // can resolve any IANA zone without a network call.
  tz.initializeTimeZones();
  try {
    final tzInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
  } catch (_) {
    // Non-fatal: falls back to UTC if the platform call fails.
  }

  runApp(const ProviderScope(child: LocoMotionApp()));
}

class LocoMotionApp extends ConsumerStatefulWidget {
  const LocoMotionApp({super.key});

  @override
  ConsumerState<LocoMotionApp> createState() => _LocoMotionAppState();
}

class _LocoMotionAppState extends ConsumerState<LocoMotionApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(notificationsControllerProvider.notifier)
          .initialize(
            onForegroundPayload: (payload) {
              final context = rootNavigatorKey.currentContext;
              if (context != null) {
                ForegroundNotificationBanner.show(context, payload: payload);
              }
            },
            onOpenPayload: (payload) {
              final context = rootNavigatorKey.currentContext;
              if (context != null) {
                if (payload.eventType == PushEventType.incidentCreated &&
                    payload.incidentId != null) {
                  context.push('/incidents/${payload.incidentId}');
                } else if (payload.loanId != null) {
                  context.push('/loans/${payload.loanId}');
                }
              }
            },
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'LocoMotion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
    );
  }
}

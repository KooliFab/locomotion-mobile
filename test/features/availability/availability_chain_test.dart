import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/network_providers.dart';
import 'package:mobile/features/availability/domain/entities/availability_rule.dart';
import 'package:mobile/features/availability/presentation/controllers/vehicle_availability_controller.dart';

class _MockHttpAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;

  _MockHttpAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _jsonResponse(dynamic data, int statusCode) {
  final raw = jsonEncode(data);
  return ResponseBody.fromString(
    raw,
    statusCode,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

void main() {
  const vehicleId = 42;

  const testRule = AvailabilityRule(
    id: 'rule-1',
    type: 'dates',
    scope: ['2026-10-15'],
    period: '09:00-17:00',
    available: false,
    title: 'Garage',
  );

  group(
    'R16 - Full Chain Tests: Dio -> ApiClient -> DataSource -> Repository -> Controller',
    () {
      test(
        '409 Conflict translates through chain, sets error message, and invalidates lock version',
        () async {
          int configFetchCount = 0;
          String currentLockVersion = '2026-10-05T00:00:00Z';

          final adapter = _MockHttpAdapter((options) async {
            // Pre-flight check
            if (options.path.contains('/loans/unavailable')) {
              return _jsonResponse([], 200);
            }

            // Vehicle details GET
            if (options.path == '/loanables/$vehicleId' &&
                options.method == 'GET') {
              configFetchCount++;
              return _jsonResponse({
                'data': {
                  'id': vehicleId,
                  'availability_mode': 'manual',
                  'availability_json': '[]',
                  'updated_at': currentLockVersion,
                },
              }, 200);
            }

            // Vehicle update PUT
            if (options.path == '/loanables/$vehicleId' &&
                options.method == 'PUT') {
              final ifMatch = options.headers['If-Match'];
              if (ifMatch != '"$currentLockVersion"') {
                return _jsonResponse({
                  'message':
                      'Ce véhicule a été modifié par un autre utilisateur. Veuillez recharger la page.',
                }, 409);
              }
              return _jsonResponse({
                'loanable': {'id': vehicleId},
              }, 200);
            }

            return _jsonResponse({}, 404);
          });

          final dio = Dio(BaseOptions(baseUrl: 'https://api.locomotion.test'));
          dio.httpClientAdapter = adapter;
          final apiClient = ApiClient.withDio(dio);

          final container = ProviderContainer(
            overrides: [apiClientProvider.overrideWithValue(apiClient)],
          );
          addTearDown(container.dispose);

          // 1. Initial config fetch
          final initialConfig = await container.read(
            vehicleAvailabilityConfigProvider(vehicleId).future,
          );
          expect(initialConfig.lockVersion, equals('2026-10-05T00:00:00Z'));
          expect(configFetchCount, equals(1));

          // 2. Simulate another user modifying the vehicle on the backend (lock version changes)
          currentLockVersion = '2026-10-05T01:30:00Z';

          // 3. Attempt to save new rules with old lock version
          final controller = container.read(
            vehicleAvailabilityControllerProvider(vehicleId).notifier,
          );
          final success = await controller.saveRules([testRule]);

          // Save must fail due to 409
          expect(success, isFalse);

          final state = container.read(
            vehicleAvailabilityControllerProvider(vehicleId),
          );
          expect(state.isSubmitting, isFalse);
          expect(
            state.errorMessage,
            equals(
              'Ce véhicule a été modifié par un autre utilisateur. Veuillez recharger la page.',
            ),
          );

          // 4. Verify optimistic lock recovery: related providers were invalidated!
          // Reading config future again must reload and fetch the fresh lock version
          final refreshedConfig = await container.read(
            vehicleAvailabilityConfigProvider(vehicleId).future,
          );
          expect(configFetchCount, equals(2));
          expect(refreshedConfig.lockVersion, equals('2026-10-05T01:30:00Z'));

          // 5. Subsequent save with fresh lock version succeeds!
          final retrySuccess = await controller.saveRules([testRule]);
          expect(retrySuccess, isTrue);
        },
      );

      test(
        '422 Validation conflict translates through chain and populates activeConflicts in state',
        () async {
          final adapter = _MockHttpAdapter((options) async {
            // Pre-flight check simulates a race condition where preflight passed:
            if (options.path.contains('/loans/unavailable')) {
              return _jsonResponse([], 200);
            }

            // Vehicle details GET
            if (options.path == '/loanables/$vehicleId' &&
                options.method == 'GET') {
              return _jsonResponse({
                'data': {
                  'id': vehicleId,
                  'availability_mode': 'manual',
                  'availability_json': '[]',
                  'updated_at': '2026-10-05T00:00:00Z',
                },
              }, 200);
            }

            // Vehicle update PUT returns 422 with conflicting loans
            if (options.path == '/loanables/$vehicleId' &&
                options.method == 'PUT') {
              return _jsonResponse({
                'message':
                    'Cette modification de disponibilité entre en conflit avec une ou plusieurs réservations existantes.',
                'conflicts': [
                  {
                    'id': 101,
                    'departure_at': '2026-10-15T09:00:00Z',
                    'actual_return_at': '2026-10-15T11:00:00Z',
                    'borrower_name': 'Sophie Martin',
                    'status': 'confirmed',
                  },
                  {
                    'id': 102,
                    'departure_at': '2026-10-15T14:00:00Z',
                    'actual_return_at': '2026-10-15T16:00:00Z',
                    'borrower_user': {'name': 'Marc Tremblay'},
                    'status': 'accepted',
                  },
                ],
              }, 422);
            }

            return _jsonResponse({}, 404);
          });

          final dio = Dio(BaseOptions(baseUrl: 'https://api.locomotion.test'));
          dio.httpClientAdapter = adapter;
          final apiClient = ApiClient.withDio(dio);

          final container = ProviderContainer(
            overrides: [apiClientProvider.overrideWithValue(apiClient)],
          );
          addTearDown(container.dispose);

          final controller = container.read(
            vehicleAvailabilityControllerProvider(vehicleId).notifier,
          );

          final success = await controller.saveRules([testRule]);

          expect(success, isFalse);

          final state = container.read(
            vehicleAvailabilityControllerProvider(vehicleId),
          );
          expect(state.isSubmitting, isFalse);
          expect(
            state.errorMessage,
            equals(
              'Cette modification de disponibilité entre en conflit avec une ou plusieurs réservations existantes.',
            ),
          );

          // Verify that conflicting loans are fully preserved and parsed
          expect(state.activeConflicts.length, equals(2));
          expect(state.activeConflicts[0].id, equals(101));
          expect(
            state.activeConflicts[0].borrowerName,
            equals('Sophie Martin'),
          );
          expect(state.activeConflicts[0].status, equals('confirmed'));

          expect(state.activeConflicts[1].id, equals(102));
          expect(
            state.activeConflicts[1].borrowerName,
            equals('Marc Tremblay'),
          );
          expect(state.activeConflicts[1].status, equals('accepted'));
        },
      );
    },
  );
}

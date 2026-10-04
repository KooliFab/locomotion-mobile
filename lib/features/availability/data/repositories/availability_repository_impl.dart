import 'dart:convert';
import 'package:dio/dio.dart';
import '../../domain/entities/availability_config.dart';
import '../../domain/entities/availability_rule.dart';
import '../../domain/entities/conflicting_loan.dart';
import '../../domain/repositories/availability_repository.dart';
import '../datasources/availability_remote_data_source.dart';
import '../../../loanables/domain/entities/loanable_availability.dart';

class AvailabilityConflictException implements Exception {
  final String message;
  final List<ConflictingLoan> conflicts;

  AvailabilityConflictException({
    required this.message,
    this.conflicts = const [],
  });

  @override
  String toString() => message;
}

class AvailabilityOptimisticLockException implements Exception {
  final String message;

  AvailabilityOptimisticLockException([
    this.message = 'Ce véhicule a été modifié par un autre utilisateur. Veuillez recharger la page.',
  ]);

  @override
  String toString() => message;
}

class AvailabilityRepositoryImpl implements AvailabilityRepository {
  final AvailabilityRemoteDataSource _remoteDataSource;

  AvailabilityRepositoryImpl(this._remoteDataSource);

  @override
  Future<AvailabilityConfig> getAvailabilityConfig(int vehicleId) async {
    final raw = await _remoteDataSource.getVehicleRaw(vehicleId);

    final mode = (raw['availability_mode'] as String?) ?? 'always';
    final jsonStr = (raw['availability_json'] as String?) ?? '[]';
    final timezone = raw['timezone'] as String?;
    final lockVersion = raw['updated_at'] as String?;

    List<AvailabilityRule> rules = [];
    try {
      final decoded = jsonDecode(jsonStr);
      if (decoded is List) {
        rules = decoded
            .map((e) => AvailabilityRule.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      rules = [];
    }

    return AvailabilityConfig(
      vehicleId: vehicleId,
      availabilityMode: mode,
      rules: rules,
      timezone: timezone,
      lockVersion: lockVersion,
    );
  }

  @override
  Future<List<ConflictingLoan>> checkConflicts(
    int vehicleId, {
    required String availabilityMode,
    required String availabilityJson,
  }) async {
    final rawList = await _remoteDataSource.getLoansUnavailable(
      vehicleId,
      availabilityMode: availabilityMode,
      availabilityJson: availabilityJson,
    );

    return rawList
        .map((e) => ConflictingLoan.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveAvailabilityConfig(
    int vehicleId, {
    required String availabilityMode,
    required String availabilityJson,
    String? lockVersion,
  }) async {
    try {
      await _remoteDataSource.updateLoanable(
        vehicleId,
        {
          'availability_mode': availabilityMode,
          'availability_json': availabilityJson,
        },
        lockVersion: lockVersion,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw AvailabilityOptimisticLockException();
      }
      if (e.response?.statusCode == 422) {
        final data = e.response?.data;
        List<ConflictingLoan> conflicts = [];
        String message = 'Cette modification de disponibilité entre en conflit avec des réservations existantes.';
        if (data is Map<String, dynamic>) {
          if (data['message'] != null) {
            message = data['message'].toString();
          }
          if (data['conflicts'] is List) {
            conflicts = (data['conflicts'] as List)
                .map((c) => ConflictingLoan.fromJson(c as Map<String, dynamic>))
                .toList();
          }
        }
        throw AvailabilityConflictException(message: message, conflicts: conflicts);
      }
      rethrow;
    }
  }

  @override
  Future<List<LoanableAvailabilityInterval>> previewAvailability(
    int vehicleId, {
    required String start,
    required String end,
    required String availabilityMode,
    required String availabilityJson,
    String? timezone,
  }) async {
    final rawList = await _remoteDataSource.previewAvailability(
      start: start,
      end: end,
      availabilityMode: availabilityMode,
      availabilityJson: availabilityJson,
      timezone: timezone,
    );

    return rawList
        .map((e) => LoanableAvailabilityInterval.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

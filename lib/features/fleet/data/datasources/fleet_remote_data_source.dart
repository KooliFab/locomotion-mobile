// ignore_for_file: use_null_aware_elements

import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/fleet_vehicle.dart';

abstract class FleetRemoteDataSource {
  Future<List<FleetVehicle>> getOwnerFleet();
  Future<FleetVehicle> createVehicle(
    Map<String, dynamic> data, {
    String? idempotencyKey,
  });
  Future<FleetVehicle> updateVehicle(
    int id,
    Map<String, dynamic> data, {
    String? lockVersion,
  });
  Future<void> publishVehicle(int id);
  Future<Map<String, dynamic>> suspendVehicle(
    int id, {
    String? reason,
    bool preserveFuture = true,
  });
  Future<FleetVehicle> unsuspendVehicle(int id);
}

class FleetRemoteDataSourceImpl implements FleetRemoteDataSource {
  final ApiClient _apiClient;

  FleetRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<FleetVehicle>> getOwnerFleet() async {
    final response = await _apiClient.get<dynamic>('/owner/fleet');
    final data = response.data;

    final list = data is List
        ? data
        : (data is Map<String, dynamic> && data['data'] is List)
            ? data['data'] as List
            : <dynamic>[];

    return list
        .map((item) => FleetVehicle.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<FleetVehicle> createVehicle(
    Map<String, dynamic> data, {
    String? idempotencyKey,
  }) async {
    final options = Options(
      headers: {
        if (idempotencyKey != null) 'Idempotency-Key': idempotencyKey,
      },
    );

    final response = await _apiClient.post<dynamic>(
      '/loanables',
      data: {
        ...data,
        if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      },
      options: options,
    );

    final raw = response.data;
    final item = (raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>)
        ? raw['data'] as Map<String, dynamic>
        : raw as Map<String, dynamic>;

    return FleetVehicle.fromJson(item);
  }

  @override
  Future<FleetVehicle> updateVehicle(
    int id,
    Map<String, dynamic> data, {
    String? lockVersion,
  }) async {
    final options = Options(
      headers: {
        if (lockVersion != null) 'If-Match': '"$lockVersion"',
      },
    );

    final response = await _apiClient.put<dynamic>(
      '/loanables/$id',
      data: {
        ...data,
        if (lockVersion != null) 'lock_version': lockVersion,
      },
      options: options,
    );

    final raw = response.data;
    final item = (raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>)
        ? raw['data'] as Map<String, dynamic>
        : (raw is Map<String, dynamic> && raw['loanable'] is Map<String, dynamic>)
            ? raw['loanable'] as Map<String, dynamic>
            : raw as Map<String, dynamic>;

    return FleetVehicle.fromJson(item);
  }

  @override
  Future<void> publishVehicle(int id) async {
    await _apiClient.put<dynamic>('/loanables/$id/publish');
  }

  @override
  Future<Map<String, dynamic>> suspendVehicle(
    int id, {
    String? reason,
    bool preserveFuture = true,
  }) async {
    final response = await _apiClient.put<dynamic>(
      '/loanables/$id/suspend',
      data: {
        if (reason != null && reason.isNotEmpty) 'reason': reason,
        'preserve_future_confirmed_loans': preserveFuture,
      },
    );

    final raw = response.data as Map<String, dynamic>;
    return raw;
  }

  @override
  Future<FleetVehicle> unsuspendVehicle(int id) async {
    final response = await _apiClient.put<dynamic>('/loanables/$id/unsuspend');
    final raw = response.data as Map<String, dynamic>;
    final item = raw['loanable'] is Map<String, dynamic>
        ? raw['loanable'] as Map<String, dynamic>
        : raw;
    return FleetVehicle.fromJson(item);
  }
}

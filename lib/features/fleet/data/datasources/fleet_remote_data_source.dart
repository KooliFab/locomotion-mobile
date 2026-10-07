// ignore_for_file: use_null_aware_elements

import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/fleet_vehicle.dart';

abstract class FleetRemoteDataSource {
  /// Vehicles managed by the user, as listed by the web profile page
  /// (`GET /loanables?for=profile`).
  Future<List<FleetVehicle>> getOwnerFleet();

  /// Full vehicle resource (`GET /loanables/{id}`).
  Future<FleetVehicle> getVehicle(int id);
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
}

class FleetRemoteDataSourceImpl implements FleetRemoteDataSource {
  final ApiClient _apiClient;

  FleetRemoteDataSourceImpl(this._apiClient);

  static const int _pageSize = 50;
  static const int _maxPages = 20;

  @override
  Future<List<FleetVehicle>> getOwnerFleet() async {
    final vehicles = <FleetVehicle>[];
    var page = 1;
    var lastPage = 1;
    do {
      final response = await _apiClient.get<dynamic>(
        '/loanables',
        queryParameters: {
          'for': 'profile',
          'page': page,
          'per_page': _pageSize,
          'relations': 'merged_user_roles.user',
        },
      );
      final data = response.data;
      final list = data is List
          ? data
          : (data is Map<String, dynamic> && data['data'] is List)
          ? data['data'] as List
          : <dynamic>[];
      vehicles.addAll(
        list.whereType<Map<String, dynamic>>().map(FleetVehicle.fromJson),
      );
      final meta = data is Map<String, dynamic> ? data['meta'] : null;
      lastPage = meta is Map<String, dynamic>
          ? (meta['last_page'] as num?)?.toInt() ?? page
          : page;
      page++;
    } while (page <= lastPage && page <= _maxPages);
    return vehicles;
  }

  @override
  Future<FleetVehicle> getVehicle(int id) async {
    final response = await _apiClient.get<dynamic>('/loanables/$id');
    final raw = response.data;
    final item =
        (raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>)
        ? raw['data'] as Map<String, dynamic>
        : raw as Map<String, dynamic>;
    return FleetVehicle.fromJson(item);
  }

  @override
  Future<FleetVehicle> createVehicle(
    Map<String, dynamic> data, {
    String? idempotencyKey,
  }) async {
    final options = Options(
      headers: {if (idempotencyKey != null) 'Idempotency-Key': idempotencyKey},
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
    final item =
        (raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>)
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
      headers: {if (lockVersion != null) 'If-Match': '"$lockVersion"'},
    );

    final response = await _apiClient.put<dynamic>(
      '/loanables/$id',
      data: {...data, if (lockVersion != null) 'lock_version': lockVersion},
      options: options,
    );

    final raw = response.data;
    final item =
        (raw is Map<String, dynamic> && raw['data'] is Map<String, dynamic>)
        ? raw['data'] as Map<String, dynamic>
        : (raw is Map<String, dynamic> &&
              raw['loanable'] is Map<String, dynamic>)
        ? raw['loanable'] as Map<String, dynamic>
        : raw as Map<String, dynamic>;

    return FleetVehicle.fromJson(item);
  }

  @override
  Future<void> publishVehicle(int id) async {
    await _apiClient.put<dynamic>('/loanables/$id/publish');
  }
}

import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

abstract class AvailabilityRemoteDataSource {
  Future<Map<String, dynamic>> getVehicleRaw(int vehicleId);

  Future<List<dynamic>> getLoansUnavailable(
    int vehicleId, {
    required String availabilityMode,
    required String availabilityJson,
  });

  Future<List<dynamic>> previewAvailability({
    required String start,
    required String end,
    required String availabilityMode,
    required String availabilityJson,
    String? timezone,
  });

  Future<Map<String, dynamic>> updateLoanable(
    int vehicleId,
    Map<String, dynamic> data, {
    String? lockVersion,
  });
}

class AvailabilityRemoteDataSourceImpl implements AvailabilityRemoteDataSource {
  final ApiClient _apiClient;

  AvailabilityRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, dynamic>> getVehicleRaw(int vehicleId) async {
    final response = await _apiClient.get<dynamic>('/loanables/$vehicleId');
    final raw = response.data;
    if (raw is Map<String, dynamic>) {
      if (raw['data'] is Map<String, dynamic>) {
        return raw['data'] as Map<String, dynamic>;
      }
      return raw;
    }
    return <String, dynamic>{};
  }

  @override
  Future<List<dynamic>> getLoansUnavailable(
    int vehicleId, {
    required String availabilityMode,
    required String availabilityJson,
  }) async {
    final response = await _apiClient.get<dynamic>(
      '/loanables/$vehicleId/loans/unavailable',
      queryParameters: {
        'availability_mode': availabilityMode,
        'availability_json': availabilityJson,
      },
    );

    final raw = response.data;
    if (raw is List) {
      return raw;
    }
    if (raw is Map<String, dynamic> && raw['data'] is List) {
      return raw['data'] as List;
    }
    return [];
  }

  @override
  Future<List<dynamic>> previewAvailability({
    required String start,
    required String end,
    required String availabilityMode,
    required String availabilityJson,
    String? timezone,
  }) async {
    final response = await _apiClient.get<dynamic>(
      '/loanables/availability',
      queryParameters: {
        'start': start,
        'end': end,
        'responseMode': 'available',
        'availability_mode': availabilityMode,
        'availability_json': availabilityJson,
        'timezone': ?timezone,
      },
    );

    final raw = response.data;
    if (raw is List) {
      return raw;
    }
    if (raw is Map<String, dynamic> && raw['data'] is List) {
      return raw['data'] as List;
    }
    return [];
  }

  @override
  Future<Map<String, dynamic>> updateLoanable(
    int vehicleId,
    Map<String, dynamic> data, {
    String? lockVersion,
  }) async {
    final options = Options(
      headers: {if (lockVersion != null) 'If-Match': '"$lockVersion"'},
    );

    final response = await _apiClient.put<dynamic>(
      '/loanables/$vehicleId',
      data: {...data, 'lock_version': ?lockVersion},
      options: options,
    );

    final raw = response.data;
    if (raw is Map<String, dynamic>) {
      if (raw['loanable'] is Map<String, dynamic>) {
        return raw['loanable'] as Map<String, dynamic>;
      }
      if (raw['data'] is Map<String, dynamic>) {
        return raw['data'] as Map<String, dynamic>;
      }
      return raw;
    }
    return <String, dynamic>{};
  }
}

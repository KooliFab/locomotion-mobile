import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/loan_inspection.dart';

abstract class LoanInspectionRemoteDataSource {
  Future<int> uploadInspectionPhoto({
    required File file,
    required String field,
  });

  Future<LoanInspection> submitDepartureInspection({
    required int loanId,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  });

  Future<LoanInspection?> getDepartureInspection(int loanId);
}

class LoanInspectionRemoteDataSourceImpl
    implements LoanInspectionRemoteDataSource {
  final ApiClient _apiClient;

  const LoanInspectionRemoteDataSourceImpl(this._apiClient);

  @override
  Future<int> uploadInspectionPhoto({
    required File file,
    required String field,
  }) async {
    final filename = file.path.split('/').last;
    final formData = FormData.fromMap({
      'field': field,
      field: await MultipartFile.fromFile(
        file.path,
        filename: filename,
      ),
    });

    final response = await _apiClient.post(
      ApiEndpoints.images,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {'Accept': 'application/json'},
      ),
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
      final id = inner['id'];
      if (id is int) return id;
      if (id is String) return int.tryParse(id) ?? 0;
    }

    throw const ServerException(
      message: 'Format de réponse invalide lors du téléversement de la photo.',
    );
  }

  @override
  Future<LoanInspection> submitDepartureInspection({
    required int loanId,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  }) async {
    final options = Options(
      headers: {
        'Accept': 'application/json',
        if (idempotencyKey != null && idempotencyKey.isNotEmpty)
          'Idempotency-Key': idempotencyKey,
      },
    );

    final response = await _apiClient.post(
      ApiEndpoints.loanDepartureInspection(loanId),
      data: payload,
      options: options,
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
      return LoanInspection.fromJson(inner);
    }

    throw const ServerException(
      message: 'Format de réponse invalide lors de la validation du départ.',
    );
  }

  @override
  Future<LoanInspection?> getDepartureInspection(int loanId) async {
    final response = await _apiClient.get(
      ApiEndpoints.loanInspections(loanId),
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final inner = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;
      final departure = inner['departure'];
      if (departure is Map<String, dynamic>) {
        return LoanInspection.fromJson(departure);
      }
    }
    return null;
  }
}

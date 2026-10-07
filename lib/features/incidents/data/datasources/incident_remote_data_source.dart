import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/incident_category.dart';

abstract class IncidentRemoteDataSource {
  Future<List<Map<String, dynamic>>> getIncidents({
    int? loanId,
    int? loanableId,
    String? status,
  });

  Future<Map<String, dynamic>> getIncidentDetail(int incidentId);

  Future<Map<String, dynamic>> createIncident({
    required int loanableId,
    int? loanId,
    required IncidentCategory category,
    required String description,
    List<int> imageIds = const [],
    String? idempotencyKey,
  });

  Future<Map<String, dynamic>> addNote({
    required int incidentId,
    required String text,
  });

  Future<Map<String, dynamic>> resolveIncident(int incidentId);

  Future<Map<String, dynamic>> reopenIncident(int incidentId);

  Future<int> uploadImage(String filePath);
}

class IncidentRemoteDataSourceImpl implements IncidentRemoteDataSource {
  final ApiClient _apiClient;

  const IncidentRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<Map<String, dynamic>>> getIncidents({
    int? loanId,
    int? loanableId,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{
      'per_page': 50,
      'relations':
          'assignee.avatar,reportedByUser.avatar,resolvedByUser.avatar,notes.author.avatar,loanable,images',
    };
    if (loanId != null) queryParams['loan_id'] = loanId;
    if (loanableId != null) queryParams['loanable_id'] = loanableId;
    if (status != null) queryParams['status'] = status;

    final response = await _apiClient.get<dynamic>(
      ApiEndpoints.incidents,
      queryParameters: queryParams,
    );

    final raw = response.data;
    if (raw is Map<String, dynamic> && raw['data'] is List) {
      return (raw['data'] as List).whereType<Map<String, dynamic>>().toList();
    }
    if (raw is List) {
      return raw.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  @override
  Future<Map<String, dynamic>> getIncidentDetail(int incidentId) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.incidentDetail(incidentId),
      );
      final raw = response.data;
      if (raw is Map<String, dynamic>) {
        if (raw['data'] is Map<String, dynamic>) {
          return raw['data'] as Map<String, dynamic>;
        }
        return raw;
      }
    } on ServerException catch (e) {
      // Fallback: If 404 (endpoint not supported by older servers), query via list
      if (e.statusCode == 404) {
        final list = await getIncidents();
        final match = list.firstWhere(
          (m) => m['id'] == incidentId,
          orElse: () => throw const ServerException(
            message: 'Incident introuvable.',
            statusCode: 404,
          ),
        );
        return match;
      }
      rethrow;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final list = await getIncidents();
        final match = list.firstWhere(
          (m) => m['id'] == incidentId,
          orElse: () => throw const ServerException(
            message: 'Incident introuvable.',
            statusCode: 404,
          ),
        );
        return match;
      }
      rethrow;
    }
    throw const ServerException(
      message: 'Format de réponse invalide pour l\'incident.',
    );
  }

  @override
  Future<Map<String, dynamic>> createIncident({
    required int loanableId,
    int? loanId,
    required IncidentCategory category,
    required String description,
    List<int> imageIds = const [],
    String? idempotencyKey,
  }) async {
    // Construct structured comments with category prefix and photos reference
    final buffer = StringBuffer();
    buffer.write('${category.prefix} ');
    buffer.write(description.trim());
    if (imageIds.isNotEmpty) {
      buffer.write('\n[Preuves: ');
      buffer.write(imageIds.map((id) => 'image_id#$id').join(', '));
      buffer.write(']');
    }

    final payload = <String, dynamic>{
      'loanable_id': loanableId,
      'incident_type': category.backendType,
      'comments_on_incident': buffer.toString(),
      'show_details_to_blocked_borrowers': true,
      if (imageIds.isNotEmpty) 'image_ids': imageIds,
      'idempotency_key': ?idempotencyKey,
      'loan_id': ?loanId,
    };

    final options = idempotencyKey != null
        ? Options(headers: {'Idempotency-Key': idempotencyKey})
        : null;

    final response = await _apiClient.post<dynamic>(
      ApiEndpoints.incidents,
      data: payload,
      options: options,
    );

    final raw = response.data;
    if (raw is Map<String, dynamic>) {
      if (raw['data'] is Map<String, dynamic>) {
        return raw['data'] as Map<String, dynamic>;
      }
      return raw;
    }
    throw const ServerException(
      message: 'Erreur lors de la création de l\'incident.',
    );
  }

  @override
  Future<Map<String, dynamic>> addNote({
    required int incidentId,
    required String text,
  }) async {
    final response = await _apiClient.post<dynamic>(
      ApiEndpoints.incidentNotes(incidentId),
      data: {'text': text},
    );

    final raw = response.data;
    if (raw is Map<String, dynamic>) {
      if (raw['data'] is Map<String, dynamic>) {
        return raw['data'] as Map<String, dynamic>;
      }
      return raw;
    }
    throw const ServerException(message: 'Erreur lors de l\'ajout de la note.');
  }

  @override
  Future<Map<String, dynamic>> resolveIncident(int incidentId) async {
    final response = await _apiClient.put<dynamic>(
      ApiEndpoints.incidentComplete(incidentId),
    );

    final raw = response.data;
    if (raw is Map<String, dynamic>) {
      if (raw['data'] is Map<String, dynamic>) {
        return raw['data'] as Map<String, dynamic>;
      }
      return raw;
    }
    throw const ServerException(
      message: 'Erreur lors de la résolution de l\'incident.',
    );
  }

  @override
  Future<Map<String, dynamic>> reopenIncident(int incidentId) async {
    final response = await _apiClient.put<dynamic>(
      ApiEndpoints.incidentReopen(incidentId),
    );

    final raw = response.data;
    if (raw is Map<String, dynamic>) {
      if (raw['data'] is Map<String, dynamic>) {
        return raw['data'] as Map<String, dynamic>;
      }
      return raw;
    }
    throw const ServerException(
      message: 'Erreur lors de la réouverture de l\'incident.',
    );
  }

  @override
  Future<int> uploadImage(String filePath) async {
    final file = File(filePath);
    final filename = filePath.split(Platform.pathSeparator).last;
    final formData = FormData.fromMap({
      'field': 'image',
      'image': await MultipartFile.fromFile(file.path, filename: filename),
    });

    final response = await _apiClient.post<dynamic>(
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
}

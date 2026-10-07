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
    int? incidentId,
  });

  Future<Map<String, dynamic>> getIncidentDetail(int incidentId);

  Future<Map<String, dynamic>> createIncident({
    required int loanableId,
    int? loanId,
    required IncidentCategory category,
    required String description,
    String? idempotencyKey,
  });

  Future<Map<String, dynamic>> addNote({
    required int incidentId,
    required String text,
  });

  Future<Map<String, dynamic>> resolveIncident(int incidentId);

  Future<Map<String, dynamic>> reopenIncident(int incidentId);
}

class IncidentRemoteDataSourceImpl implements IncidentRemoteDataSource {
  final ApiClient _apiClient;

  const IncidentRemoteDataSourceImpl(this._apiClient);

  /// Relations allowed by `IncidentController@index` on the server.
  static const String _relations =
      'assignee.avatar,reportedByUser.avatar,resolvedByUser.avatar,notes.author.avatar,loanable';

  @override
  Future<List<Map<String, dynamic>>> getIncidents({
    int? loanId,
    int? loanableId,
    String? status,
    int? incidentId,
  }) async {
    final queryParams = <String, dynamic>{
      'per_page': incidentId != null ? 1 : 50,
      'relations': _relations,
    };
    if (incidentId != null) queryParams['id'] = incidentId;
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

  /// There is no `GET /incidents/{id}`: the incident is read through the
  /// filtered list, as the web app does.
  @override
  Future<Map<String, dynamic>> getIncidentDetail(int incidentId) async {
    final list = await getIncidents(incidentId: incidentId);
    final match = list.where((m) => m['id'] == incidentId).firstOrNull;
    if (match == null) {
      throw const ServerException(
        message: 'Incident introuvable.',
        statusCode: 404,
      );
    }
    return match;
  }

  @override
  Future<Map<String, dynamic>> createIncident({
    required int loanableId,
    int? loanId,
    required IncidentCategory category,
    required String description,
    String? idempotencyKey,
  }) async {
    // Structured comments with the category prefix
    final buffer = StringBuffer();
    buffer.write('${category.prefix} ');
    buffer.write(description.trim());

    final payload = <String, dynamic>{
      'loanable_id': loanableId,
      'incident_type': category.backendType,
      'comments_on_incident': buffer.toString(),
      'show_details_to_blocked_borrowers': true,
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
}

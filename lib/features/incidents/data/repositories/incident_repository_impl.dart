import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_providers.dart';
import '../../domain/entities/incident.dart';
import '../../domain/entities/incident_category.dart';
import '../../domain/entities/incident_note.dart';
import '../../domain/repositories/incident_repository.dart';
import '../datasources/incident_remote_data_source.dart';

final incidentRemoteDataSourceProvider = Provider<IncidentRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return IncidentRemoteDataSourceImpl(apiClient);
});

final incidentRepositoryProvider = Provider<IncidentRepository>((ref) {
  final remoteDataSource = ref.watch(incidentRemoteDataSourceProvider);
  return IncidentRepositoryImpl(remoteDataSource);
});

class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentRemoteDataSource _remoteDataSource;

  const IncidentRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Incident>> getIncidents({
    int? loanId,
    int? loanableId,
    String? status,
  }) async {
    final list = await _remoteDataSource.getIncidents(
      loanId: loanId,
      loanableId: loanableId,
      status: status,
    );
    return list.map((json) => Incident.fromJson(json)).toList();
  }

  @override
  Future<Incident> getIncidentDetail(int incidentId) async {
    final json = await _remoteDataSource.getIncidentDetail(incidentId);
    return Incident.fromJson(json);
  }

  @override
  Future<Incident> createIncident({
    required int loanableId,
    int? loanId,
    required IncidentCategory category,
    required String description,
    String? idempotencyKey,
  }) async {
    final json = await _remoteDataSource.createIncident(
      loanableId: loanableId,
      loanId: loanId,
      category: category,
      description: description,
      idempotencyKey: idempotencyKey,
    );
    return Incident.fromJson(json);
  }

  @override
  Future<IncidentNote> addNote(int incidentId, String text) async {
    final json = await _remoteDataSource.addNote(
      incidentId: incidentId,
      text: text,
    );
    return IncidentNote.fromJson(json);
  }

  @override
  Future<Incident> resolveIncident(int incidentId) async {
    final json = await _remoteDataSource.resolveIncident(incidentId);
    return Incident.fromJson(json);
  }

  @override
  Future<Incident> reopenIncident(int incidentId) async {
    final json = await _remoteDataSource.reopenIncident(incidentId);
    return Incident.fromJson(json);
  }
}

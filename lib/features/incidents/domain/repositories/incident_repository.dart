import '../entities/incident.dart';
import '../entities/incident_category.dart';
import '../entities/incident_note.dart';

abstract class IncidentRepository {
  Future<List<Incident>> getIncidents({
    int? loanId,
    int? loanableId,
    String? status,
  });

  Future<Incident> getIncidentDetail(int incidentId);

  Future<Incident> createIncident({
    required int loanableId,
    int? loanId,
    required IncidentCategory category,
    required String description,
    String? idempotencyKey,
  });

  Future<IncidentNote> addNote(int incidentId, String text);

  Future<Incident> resolveIncident(int incidentId);

  Future<Incident> reopenIncident(int incidentId);
}

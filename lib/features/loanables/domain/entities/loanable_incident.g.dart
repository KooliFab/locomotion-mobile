// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loanable_incident.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoanableIncident _$LoanableIncidentFromJson(Map<String, dynamic> json) =>
    _LoanableIncident(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String?,
      incidentType: json['incident_type'] as String?,
      blockingUntil: json['blocking_until'] == null
          ? null
          : DateTime.parse(json['blocking_until'] as String),
      isBlocking: json['is_blocking'] as bool? ?? false,
      startAt: json['start_at'] == null
          ? null
          : DateTime.parse(json['start_at'] as String),
      loanId: (json['loan_id'] as num?)?.toInt(),
      loanableId: (json['loanable_id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$LoanableIncidentToJson(_LoanableIncident instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'incident_type': instance.incidentType,
      'blocking_until': instance.blockingUntil?.toIso8601String(),
      'is_blocking': instance.isBlocking,
      'start_at': instance.startAt?.toIso8601String(),
      'loan_id': instance.loanId,
      'loanable_id': instance.loanableId,
      'title': instance.title,
      'description': instance.description,
    };

import 'package:flutter/foundation.dart';

enum PushEventType {
  loanCreated('loan_created'),
  loanAccepted('loan_accepted'),
  loanRejected('loan_rejected'),
  loanCanceled('loan_canceled'),
  loanCommentAdded('loan_comment_added'),
  loanExtensionRequested('loan_extension_requested'),
  loanExtensionAccepted('loan_extension_accepted'),
  loanExtensionRejected('loan_extension_rejected'),
  incidentCreated('incident_created'),
  unknown('unknown');

  final String value;
  const PushEventType(this.value);

  static PushEventType fromString(String? value) {
    if (value == null) return PushEventType.unknown;
    return PushEventType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PushEventType.unknown,
    );
  }
}

class PushPayload {
  final String schemaVersion;
  final PushEventType eventType;
  final int? loanId;
  final int? incidentId;
  final int? loanableId;
  final String? messageId;
  final String? title;
  final String? body;

  const PushPayload({
    required this.schemaVersion,
    required this.eventType,
    this.loanId,
    this.incidentId,
    this.loanableId,
    this.messageId,
    this.title,
    this.body,
  });

  /// Parse from raw FCM data and notification maps with strict validation.
  /// Returns null if:
  /// - schema_version is not '1'
  /// - event_type is unknown
  /// - loan_id is missing, non-numeric, or <= 0 (for loan events)
  /// - incident_id is missing, non-numeric, or <= 0 (for incident events)
  static PushPayload? tryParse({
    required Map<String, dynamic> data,
    String? messageId,
    String? title,
    String? body,
  }) {
    final schemaVersion = data['schema_version']?.toString();
    if (schemaVersion != '1') {
      debugPrint(
        '[PushNotification] Ignored payload with unsupported schema_version: $schemaVersion',
      );
      return null;
    }

    final rawEventType = data['event_type']?.toString();
    final eventType = PushEventType.fromString(rawEventType);
    if (eventType == PushEventType.unknown) {
      debugPrint(
        '[PushNotification] Ignored payload with unknown event_type: $rawEventType',
      );
      return null;
    }

    final rawLoanId = data['loan_id'];
    final loanId = int.tryParse(rawLoanId?.toString() ?? '');

    final rawIncidentId = data['incident_id'];
    final incidentId = int.tryParse(rawIncidentId?.toString() ?? '');

    final rawLoanableId = data['loanable_id'];
    final loanableId = int.tryParse(rawLoanableId?.toString() ?? '');

    if (eventType == PushEventType.incidentCreated) {
      if (incidentId == null || incidentId <= 0) {
        debugPrint(
          '[PushNotification] Ignored payload with invalid incident_id: $rawIncidentId',
        );
        return null;
      }
    } else {
      if (loanId == null || loanId <= 0) {
        debugPrint(
          '[PushNotification] Ignored payload with invalid loan_id: $rawLoanId',
        );
        return null;
      }
    }

    return PushPayload(
      schemaVersion: schemaVersion!,
      eventType: eventType,
      loanId: loanId,
      incidentId: incidentId,
      loanableId: loanableId,
      messageId: messageId,
      title: title,
      body: body,
    );
  }

  /// Safe string for logging without exposing any sensitive or private data
  String toSafeLogString() {
    final extra = [
      if (incidentId != null) 'incidentId: $incidentId',
      if (loanableId != null) 'loanableId: $loanableId',
    ];
    final extraStr = extra.isNotEmpty ? ', ${extra.join(', ')}' : '';
    return 'PushPayload(schemaVersion: $schemaVersion, eventType: ${eventType.value}, loanId: $loanId$extraStr, messageId: $messageId)';
  }
}

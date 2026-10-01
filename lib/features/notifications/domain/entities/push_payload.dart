import 'package:flutter/foundation.dart';

enum PushEventType {
  loanCreated('loan_created'),
  loanAccepted('loan_accepted'),
  loanRejected('loan_rejected'),
  loanCanceled('loan_canceled'),
  loanCommentAdded('loan_comment_added'),
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
  final int loanId;
  final String? messageId;
  final String? title;
  final String? body;

  const PushPayload({
    required this.schemaVersion,
    required this.eventType,
    required this.loanId,
    this.messageId,
    this.title,
    this.body,
  });

  /// Parse from raw FCM data and notification maps with strict validation.
  /// Returns null if:
  /// - schema_version is not '1'
  /// - event_type is unknown
  /// - loan_id is missing, non-numeric, or <= 0
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
    if (loanId == null || loanId <= 0) {
      debugPrint(
        '[PushNotification] Ignored payload with invalid loan_id: $rawLoanId',
      );
      return null;
    }

    return PushPayload(
      schemaVersion: schemaVersion!,
      eventType: eventType,
      loanId: loanId,
      messageId: messageId,
      title: title,
      body: body,
    );
  }

  /// Safe string for logging without exposing any sensitive or private data
  String toSafeLogString() {
    return 'PushPayload(schemaVersion: $schemaVersion, eventType: ${eventType.value}, loanId: $loanId, messageId: $messageId)';
  }
}

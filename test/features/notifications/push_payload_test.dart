import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/notifications/domain/entities/push_payload.dart';

void main() {
  group('PushPayload parsing and validation', () {
    test('successfully parses valid payload for all supported event types', () {
      final eventTypes = {
        'loan_created': PushEventType.loanCreated,
        'loan_accepted': PushEventType.loanAccepted,
        'loan_rejected': PushEventType.loanRejected,
        'loan_canceled': PushEventType.loanCanceled,
        'loan_comment_added': PushEventType.loanCommentAdded,
        'loan_extension_requested': PushEventType.loanExtensionRequested,
        'loan_extension_accepted': PushEventType.loanExtensionAccepted,
        'loan_extension_rejected': PushEventType.loanExtensionRejected,
      };

      for (final entry in eventTypes.entries) {
        final data = {
          'schema_version': '1',
          'event_type': entry.key,
          'loan_id': '101',
        };

        final payload = PushPayload.tryParse(
          data: data,
          messageId: 'msg_${entry.key}',
          title: 'LocoMotion',
          body: 'Activité sur votre réservation',
        );

        expect(payload, isNotNull);
        expect(payload!.schemaVersion, '1');
        expect(payload.eventType, entry.value);
        expect(payload.loanId, 101);
        expect(payload.messageId, 'msg_${entry.key}');
        expect(payload.title, 'LocoMotion');
        expect(payload.body, 'Activité sur votre réservation');
      }
    });

    test('accepts integer loan_id in data map', () {
      final data = {
        'schema_version': '1',
        'event_type': 'loan_created',
        'loan_id': 42,
      };

      final payload = PushPayload.tryParse(data: data);
      expect(payload, isNotNull);
      expect(payload!.loanId, 42);
    });

    test('rejects payload with unsupported schema_version', () {
      final data = {
        'schema_version': '2',
        'event_type': 'loan_created',
        'loan_id': '42',
      };

      final payload = PushPayload.tryParse(data: data);
      expect(payload, isNull);
    });

    test('rejects payload missing schema_version', () {
      final data = {'event_type': 'loan_created', 'loan_id': '42'};

      final payload = PushPayload.tryParse(data: data);
      expect(payload, isNull);
    });

    test('rejects payload with unknown or excluded event_type', () {
      // loan_updated is explicitly excluded from MVP Lot 6
      final dataUpdated = {
        'schema_version': '1',
        'event_type': 'loan_updated',
        'loan_id': '42',
      };
      expect(PushPayload.tryParse(data: dataUpdated), isNull);

      final dataRandom = {
        'schema_version': '1',
        'event_type': 'unknown_arbitrary_event',
        'loan_id': '42',
      };
      expect(PushPayload.tryParse(data: dataRandom), isNull);
    });

    test('rejects payload with missing or non-positive loan_id', () {
      // Missing
      expect(
        PushPayload.tryParse(
          data: {'schema_version': '1', 'event_type': 'loan_created'},
        ),
        isNull,
      );

      // String non numeric
      expect(
        PushPayload.tryParse(
          data: {
            'schema_version': '1',
            'event_type': 'loan_created',
            'loan_id': 'abc',
          },
        ),
        isNull,
      );

      // <= 0
      expect(
        PushPayload.tryParse(
          data: {
            'schema_version': '1',
            'event_type': 'loan_created',
            'loan_id': '0',
          },
        ),
        isNull,
      );
      expect(
        PushPayload.tryParse(
          data: {
            'schema_version': '1',
            'event_type': 'loan_created',
            'loan_id': '-5',
          },
        ),
        isNull,
      );
    });

    test('toSafeLogString never exposes sensitive info', () {
      final payload = PushPayload.tryParse(
        data: {
          'schema_version': '1',
          'event_type': 'loan_created',
          'loan_id': '55',
        },
        messageId: 'msg_sec_123',
        title: 'LocoMotion',
        body: 'Activité',
      );

      expect(payload, isNotNull);
      final logStr = payload!.toSafeLogString();
      expect(
        logStr,
        contains(
          'PushPayload(schemaVersion: 1, eventType: loan_created, loanId: 55, messageId: msg_sec_123)',
        ),
      );
    });
  });
}

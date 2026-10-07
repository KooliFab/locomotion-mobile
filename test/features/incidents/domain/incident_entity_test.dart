import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/incidents/domain/entities/incident.dart';
import 'package:mobile/features/incidents/domain/entities/incident_category.dart';

void main() {
  group('IncidentCategory', () {
    test('delay maps to general and NEVER to accident', () {
      expect(IncidentCategory.delay.backendType, equals('general'));
      expect(IncidentCategory.delay.requiresSafetyDisclaimer, isFalse);
    });

    test(
      'accident requires safety disclaimer and has accident backendType',
      () {
        expect(IncidentCategory.accident.backendType, equals('accident'));
        expect(IncidentCategory.accident.requiresSafetyDisclaimer, isTrue);
      },
    );

    test('breakdown, puncture, damage map to small_incident', () {
      expect(IncidentCategory.breakdown.backendType, equals('small_incident'));
      expect(IncidentCategory.puncture.backendType, equals('small_incident'));
      expect(IncidentCategory.damage.backendType, equals('small_incident'));
    });

    test('fromBackend resolves known backend types', () {
      expect(
        IncidentCategory.fromBackend('accident'),
        equals(IncidentCategory.accident),
      );
      expect(
        IncidentCategory.fromBackend('delay'),
        equals(IncidentCategory.delay),
      );
      expect(
        IncidentCategory.fromBackend('breakdown'),
        equals(IncidentCategory.breakdown),
      );
      expect(
        IncidentCategory.fromBackend('puncture'),
        equals(IncidentCategory.puncture),
      );
      expect(
        IncidentCategory.fromBackend('small_incident'),
        equals(IncidentCategory.damage),
      );
      expect(
        IncidentCategory.fromBackend('unknown_value'),
        equals(IncidentCategory.other),
      );
    });
  });

  group('Incident Entity JSON & Helpers', () {
    test('parses incident JSON and extracts photo IDs and clean comments', () {
      final json = {
        'id': 42,
        'incident_type': 'small_incident',
        'status': 'in_process',
        'comments_on_incident':
            '[CREVAISON] Pneu arrière crevé sur le trajet retour. [Preuves: image_id#101, image_id#102]',
        'loan_id': 7,
        'loanable_id': 15,
        'loanable_name': 'Vélo Cargo Pro',
        'reported_by_user_id': 99,
        'assignee_user_id': 10,
        'assignee': {
          'id': 10,
          'name': 'Propriétaire Alice',
          'email': 'alice@example.com',
        },
        'reported_by_user': {
          'id': 99,
          'name': 'Emprunteur Bob',
          'email': 'bob@example.com',
        },
        'loanable': {
          'id': 15,
          'name': 'Vélo Cargo Pro',
          'type': 'bike',
          'merged_user_roles': [
            {'user_id': 10, 'role': 'owner'},
            {'user_id': 11, 'role': 'coowner'},
            {'user_id': 12, 'role': 'manager'},
          ],
        },
        'images': [
          {'id': 101, 'field': 'incident_proof'},
          {'id': 102, 'field': 'incident_proof'},
        ],
        'notes': [
          {
            'id': 1,
            'incident_id': 42,
            'user_id': 99,
            'note': 'Rapatriement à pied jusqu\'au garage.',
            'created_at': '2026-10-04T12:00:00Z',
            'author': {'id': 99, 'name': 'Emprunteur Bob'},
          },
        ],
      };

      final incident = Incident.fromJson(json);

      expect(incident.id, equals(42));
      expect(incident.category, equals(IncidentCategory.puncture));
      expect(incident.photoImageIds, equals([101, 102]));
      expect(incident.photos.length, equals(2));
      expect(incident.photos.first.id, equals(101));
      expect(incident.canResolveServer, isNull);
      expect(incident.canAddNoteServer, isNull);
      expect(
        incident.cleanComments,
        equals('Pneu arrière crevé sur le trajet retour.'),
      );
      expect(incident.isInProcess, isTrue);
      expect(incident.isResolved, isFalse);
      expect(incident.notes.length, equals(1));
      expect(incident.notes.first.authorName, equals('Emprunteur Bob'));

      // Policy helpers: borrower cannot resolve
      expect(incident.canResolve(99), isFalse);

      // Owner can resolve
      expect(incident.canResolve(10), isTrue);

      // Co-owner can resolve
      expect(incident.canResolve(11), isTrue);

      // Manager can resolve
      expect(incident.canResolve(12), isTrue);

      // Admin can resolve even if not in roles
      expect(incident.canResolve(999, isAdmin: true), isTrue);

      // Both can add notes
      expect(incident.canAddNote(99), isTrue);
      expect(incident.canAddNote(10), isTrue);
      expect(incident.canAddNote(11), isTrue);
      expect(incident.canAddNote(12), isTrue);
      expect(incident.canAddNote(999, isAdmin: true), isTrue);
      // Unrelated user cannot add note
      expect(incident.canAddNote(555), isFalse);

      // Server permissions take precedence when provided
      final incidentWithServerPerms = Incident.fromJson({
        ...json,
        'can_resolve': true,
        'can_add_note': false,
      });
      expect(incidentWithServerPerms.canResolveServer, isTrue);
      expect(incidentWithServerPerms.canAddNoteServer, isFalse);
      // Even borrower can resolve if server explicitly authorizes
      expect(incidentWithServerPerms.canResolve(99), isTrue);
      // And even owner cannot add note if server explicitly disallows
      expect(incidentWithServerPerms.canAddNote(10), isFalse);
    });

    test('handles clean comments when no proof tags or prefix present', () {
      final json = {
        'id': 10,
        'incident_type': 'general',
        'status': 'completed',
        'comments_on_incident': 'Simple retard de 15 minutes prévu.',
        'loanable_id': 3,
      };

      final incident = Incident.fromJson(json);
      expect(
        incident.cleanComments,
        equals('Simple retard de 15 minutes prévu.'),
      );
      expect(incident.photoImageIds, isEmpty);
      expect(incident.isResolved, isTrue);
    });
  });
}

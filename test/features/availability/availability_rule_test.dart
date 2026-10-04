import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/availability/domain/entities/availability_config.dart';
import 'package:mobile/features/availability/domain/entities/availability_rule.dart';

void main() {
  group('AvailabilityRule', () {
    test('parses punctual single-day rule correctly', () {
      final json = {
        'id': 'rule-1',
        'type': 'dates',
        'scope': ['2026-10-15'],
        'period': '09:00-17:00',
        'available': false,
        'title': 'Rendez-vous médical',
      };

      final rule = AvailabilityRule.fromJson(json);

      expect(rule.id, 'rule-1');
      expect(rule.type, 'dates');
      expect(rule.isPunctual, isTrue);
      expect(rule.isRecurringWeekly, isFalse);
      expect(rule.isAllDay, isFalse);
      expect(rule.title, 'Rendez-vous médical');
      expect(rule.startTime, '09:00');
      expect(rule.endTime, '17:00');
      expect(rule.formattedSummary, contains('2026-10-15'));
      expect(rule.formattedSummary, contains('09:00 à 17:00'));
    });

    test('parses punctual multi-day rule correctly', () {
      final json = {
        'id': 'rule-2',
        'type': 'dateRange',
        'scope': ['2026-10-15', '2026-10-20'],
        'period': '00:00-24:00',
        'available': false,
      };

      final rule = AvailabilityRule.fromJson(json);

      expect(rule.id, 'rule-2');
      expect(rule.type, 'dateRange');
      expect(rule.isPunctual, isTrue);
      expect(rule.isAllDay, isTrue);
      expect(rule.formattedSummary, contains('Du 2026-10-15 au 2026-10-20'));
      expect(rule.formattedSummary, contains('toute la journée'));
    });

    test('parses weekly recurring rule correctly', () {
      final json = {
        'id': 'rule-3',
        'type': 'weekdays',
        'scope': ['MO', 'FR'],
        'period': '18:00-24:00',
        'available': false,
        'title': 'Week-end réservé famille',
      };

      final rule = AvailabilityRule.fromJson(json);

      expect(rule.id, 'rule-3');
      expect(rule.isRecurringWeekly, isTrue);
      expect(rule.isPunctual, isFalse);
      expect(rule.title, 'Week-end réservé famille');
      expect(rule.formattedSummary, contains('lundi, vendredi'));
      expect(rule.formattedSummary, contains('18:00 à 24:00'));
    });

    test('roundtrips to JSON while preserving custom attributes', () {
      final json = {
        'id': 'custom-42',
        'type': 'dates',
        'scope': ['2026-11-01'],
        'period': '00:00-24:00',
        'available': false,
        'custom_metadata': {'priority': 'high', 'source': 'sync_cal'},
      };

      final rule = AvailabilityRule.fromJson(json);
      expect(rule.rawJson['custom_metadata'], {'priority': 'high', 'source': 'sync_cal'});

      final serialized = rule.toJson();
      expect(serialized['id'], 'custom-42');
      expect(serialized['custom_metadata'], {'priority': 'high', 'source': 'sync_cal'});
      expect(serialized['scope'], ['2026-11-01']);
    });

    test('flags unknown rule types as customServerRule', () {
      final json = {
        'id': 'unknown-99',
        'type': 'complex_rule_engine',
        'scope': [],
      };

      final rule = AvailabilityRule.fromJson(json);
      expect(rule.isCustomServerRule, isTrue);
      expect(rule.isPunctual, isFalse);
      expect(rule.isRecurringWeekly, isFalse);
      expect(rule.formattedSummary, contains('Règle serveur (complex_rule_engine)'));
    });

    test('flags multi-dates batch as non-editable in-app to protect existing dates', () {
      final multiJson = {
        'id': 'multi-date-batch',
        'type': 'dates',
        'scope': ['2026-10-15', '2026-10-16', '2026-10-17'],
        'period': '00:00-24:00',
        'available': false,
      };

      final multiRule = AvailabilityRule.fromJson(multiJson);
      expect(multiRule.isMultiDatesBatch, isTrue);
      expect(multiRule.isEditableInApp, isFalse);

      final singleJson = {
        'id': 'single-date',
        'type': 'dates',
        'scope': ['2026-10-15'],
        'period': '00:00-24:00',
        'available': false,
      };

      final singleRule = AvailabilityRule.fromJson(singleJson);
      expect(singleRule.isMultiDatesBatch, isFalse);
      expect(singleRule.isEditableInApp, isTrue);
    });

    test('createContinuousBlock decomposes multi-day partial hours into contiguously simplify-able daily slices', () {
      final slices = AvailabilityRule.createContinuousBlock(
        baseId: 'test-block',
        startDate: DateTime(2026, 10, 15),
        endDate: DateTime(2026, 10, 17),
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        isAllDay: false,
        title: 'Voyage professionnel',
      );

      expect(slices.length, 3);
      final day1 = slices[0];
      final day2 = slices[1];
      final day3 = slices[2];

      expect(day1.groupId, 'test-block');
      expect(day1.groupRole, 'start');
      expect(day1.scope, ['2026-10-15']);
      expect(day1.period, '14:00-24:00');
      expect(day1.title, 'Voyage professionnel');

      expect(day2.groupId, 'test-block');
      expect(day2.groupRole, 'middle');
      expect(day2.scope, ['2026-10-16']);
      expect(day2.period, '00:00-24:00');

      expect(day3.groupId, 'test-block');
      expect(day3.groupRole, 'end');
      expect(day3.scope, ['2026-10-17']);
      expect(day3.period, '00:00-11:00');
    });

    test('createContinuousBlock handles 2-day partial hours block without middle days', () {
      final slices = AvailabilityRule.createContinuousBlock(
        baseId: 'two-day-block',
        startDate: DateTime(2026, 10, 15),
        endDate: DateTime(2026, 10, 16),
        startTime: const TimeOfDay(hour: 18, minute: 30),
        endTime: const TimeOfDay(hour: 8, minute: 15),
        isAllDay: false,
      );

      expect(slices.length, 2);
      expect(slices[0].period, '18:30-24:00');
      expect(slices[0].groupRole, 'start');
      expect(slices[1].period, '00:00-08:15');
      expect(slices[1].groupRole, 'end');
    });

    test('newId generates distinct identifier strings', () {
      final id1 = AvailabilityRule.newId();
      final id2 = AvailabilityRule.newId();
      expect(id1.isNotEmpty, isTrue);
      expect(id2.isNotEmpty, isTrue);
      expect(id1, isNot(equals(id2)));
    });
  });

  group('AvailabilityConfig', () {
    const puncRule = AvailabilityRule(
      id: 'punc-1',
      type: 'dates',
      scope: ['2026-10-15'],
      period: '08:00-12:00',
    );

    const recRule = AvailabilityRule(
      id: 'rec-1',
      type: 'weekdays',
      scope: ['SA', 'SU'],
      period: '00:00-24:00',
    );

    const customRule = AvailabilityRule(
      id: 'custom-1',
      type: 'advanced_exclusion_filter',
      scope: ['winter_break'],
      isCustomServerRule: true,
    );

    test('categorizes rules accurately into punctual, recurring, and custom', () {
      const config = AvailabilityConfig(
        vehicleId: 10,
        availabilityMode: 'always',
        rules: [puncRule, recRule, customRule],
        lockVersion: '2026-10-04T12:00:00Z',
      );

      expect(config.isAlwaysMode, isTrue);
      expect(config.isNeverMode, isFalse);
      expect(config.punctualRules.length, 1);
      expect(config.punctualRules.first.id, 'punc-1');
      expect(config.recurringRules.length, 1);
      expect(config.recurringRules.first.id, 'rec-1');
      expect(config.customServerRules.length, 1);
      expect(config.customServerRules.first.id, 'custom-1');
    });

    test('identifies isNeverMode correctly', () {
      const config = AvailabilityConfig(
        vehicleId: 10,
        availabilityMode: 'never',
        rules: [],
      );

      expect(config.isNeverMode, isTrue);
      expect(config.isAlwaysMode, isFalse);
    });
  });
}

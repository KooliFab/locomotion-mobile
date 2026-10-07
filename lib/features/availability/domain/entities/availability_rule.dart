import 'dart:math';
import 'package:flutter/material.dart';

class AvailabilityRule {
  final String id;
  final String type; // 'dates', 'dateRange', 'weekdays'
  final List<String> scope;
  final String period; // e.g. '00:00-24:00' or '09:00-17:00'
  final bool available; // false when defining unavailabilities in 'always' mode
  final String? title;
  final Map<String, dynamic> rawJson;
  final bool isCustomServerRule;

  const AvailabilityRule({
    required this.id,
    required this.type,
    required this.scope,
    this.period = '00:00-24:00',
    this.available = false,
    this.title,
    this.rawJson = const {},
    this.isCustomServerRule = false,
  });

  bool get isAllDay =>
      period == '00:00-24:00' ||
      period == '00:00:00-24:00:00' ||
      period == '00:00-00:00' ||
      period == '00:00:00-00:00:00';

  bool get isPunctual => type == 'dates' || type == 'dateRange';
  bool get isRecurringWeekly => type == 'weekdays';

  String? get groupId => rawJson['group_id'] as String?;
  String? get groupRole => rawJson['group_role'] as String?;
  bool get isMultiDatesBatch => type == 'dates' && scope.length > 1;
  bool get isEditableInApp => !isCustomServerRule && !isMultiDatesBatch;

  String get startTime {
    final parts = period.split('-');
    if (parts.isNotEmpty) {
      final s = parts[0].trim();
      return s.length >= 5 ? s.substring(0, 5) : s;
    }
    return '00:00';
  }

  String get endTime {
    final parts = period.split('-');
    if (parts.length >= 2) {
      final e = parts[1].trim();
      return e.length >= 5 ? e.substring(0, 5) : e;
    }
    return '24:00';
  }

  static List<AvailabilityRule> createContinuousBlock({
    required String baseId,
    required DateTime startDate,
    required DateTime endDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required bool isAllDay,
    String? title,
  }) {
    String formatDate(DateTime d) {
      final y = d.year.toString().padLeft(4, '0');
      final m = d.month.toString().padLeft(2, '0');
      final day = d.day.toString().padLeft(2, '0');
      return '$y-$m-$day';
    }

    String formatTime(TimeOfDay t) {
      final h = t.hour.toString().padLeft(2, '0');
      final m = t.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }

    final startStr = formatDate(startDate);
    final endStr = formatDate(endDate);

    if (isAllDay) {
      if (startStr == endStr) {
        return [
          AvailabilityRule(
            id: baseId,
            type: 'dates',
            scope: [startStr],
            period: '00:00-24:00',
            available: false,
            title: title,
          ),
        ];
      }
      return [
        AvailabilityRule(
          id: baseId,
          type: 'dateRange',
          scope: [startStr, endStr],
          period: '00:00-24:00',
          available: false,
          title: title,
        ),
      ];
    }

    final startTimeStr = formatTime(startTime);
    final endTimeStr = formatTime(endTime);

    if (startStr == endStr) {
      return [
        AvailabilityRule(
          id: baseId,
          type: 'dates',
          scope: [startStr],
          period: '$startTimeStr-$endTimeStr',
          available: false,
          title: title,
        ),
      ];
    }

    // Continuous multi-day block with partial hours:
    // Decompose into:
    // 1. Day 1: startTime -> 24:00
    // 2. Intermediate days: 00:00 -> 24:00
    // 3. Day N: 00:00 -> endTime
    final List<AvailabilityRule> rules = [];
    final groupId = baseId;
    final summary = 'Du $startStr $startTimeStr au $endStr $endTimeStr';

    // Day 1
    rules.add(
      AvailabilityRule(
        id: '$baseId-part-0',
        type: 'dates',
        scope: [startStr],
        period: '$startTimeStr-24:00',
        available: false,
        title: title,
        rawJson: {
          'group_id': groupId,
          'group_role': 'start',
          'group_summary': summary,
        },
      ),
    );

    // Intermediate days
    var cur = startDate.add(const Duration(days: 1));
    int partIndex = 1;
    while (DateTime(
      cur.year,
      cur.month,
      cur.day,
    ).isBefore(DateTime(endDate.year, endDate.month, endDate.day))) {
      final curStr = formatDate(cur);
      rules.add(
        AvailabilityRule(
          id: '$baseId-part-$partIndex',
          type: 'dates',
          scope: [curStr],
          period: '00:00-24:00',
          available: false,
          title: title,
          rawJson: {
            'group_id': groupId,
            'group_role': 'middle',
            'group_summary': summary,
          },
        ),
      );
      cur = cur.add(const Duration(days: 1));
      partIndex++;
    }

    // Last day
    rules.add(
      AvailabilityRule(
        id: '$baseId-part-$partIndex',
        type: 'dates',
        scope: [endStr],
        period: '00:00-$endTimeStr',
        available: false,
        title: title,
        rawJson: {
          'group_id': groupId,
          'group_role': 'end',
          'group_summary': summary,
        },
      ),
    );

    return rules;
  }

  static String _dayCodeToFrench(String code) {
    switch (code.toUpperCase()) {
      case 'MO':
        return 'lundi';
      case 'TU':
        return 'mardi';
      case 'WE':
        return 'mercredi';
      case 'TH':
        return 'jeudi';
      case 'FR':
        return 'vendredi';
      case 'SA':
        return 'samedi';
      case 'SU':
        return 'dimanche';
      default:
        return code;
    }
  }

  String get formattedSummary {
    if (isCustomServerRule) {
      return 'Règle serveur ($type)';
    }

    if (groupId != null && rawJson['group_summary'] != null) {
      return '${rawJson['group_summary']} (bloc continu)';
    }

    final timeSuffix = isAllDay
        ? ' (toute la journée)'
        : ' ($startTime à $endTime)';

    if (type == 'weekdays') {
      final days = scope.map(_dayCodeToFrench).join(', ');
      return 'Chaque $days$timeSuffix';
    }

    if (type == 'dateRange' && scope.length >= 2) {
      return 'Du ${scope.first} au ${scope.last}$timeSuffix';
    }

    if (type == 'dates') {
      if (scope.length == 1) {
        return 'Le ${scope.first}$timeSuffix';
      }
      return 'Les ${scope.join(', ')}$timeSuffix';
    }

    return '$type : ${scope.join(', ')}$timeSuffix';
  }

  factory AvailabilityRule.fromJson(Map<String, dynamic> json) {
    final type = (json['type'] as String?) ?? 'dates';
    final isKnown =
        type == 'dates' || type == 'dateRange' || type == 'weekdays';

    final scopeList =
        (json['scope'] as List?)?.map((e) => e.toString()).toList() ?? [];

    return AvailabilityRule(
      id: json['id']?.toString() ?? _generateUuidV4(),
      type: type,
      scope: scopeList,
      period: (json['period'] as String?) ?? '00:00-24:00',
      available: (json['available'] as bool?) ?? false,
      title: json['title']?.toString() ?? json['label']?.toString(),
      rawJson: Map<String, dynamic>.from(json),
      isCustomServerRule: !isKnown,
    );
  }

  Map<String, dynamic> toJson() {
    if (isCustomServerRule) {
      return rawJson;
    }

    final out = Map<String, dynamic>.from(rawJson);
    out['id'] = id;
    out['type'] = type;
    out['scope'] = scope;
    out['period'] = period;
    out['available'] = available;
    if (title != null && title!.isNotEmpty) {
      out['title'] = title;
    }
    return out;
  }

  AvailabilityRule copyWith({
    String? id,
    String? type,
    List<String>? scope,
    String? period,
    bool? available,
    String? title,
    Map<String, dynamic>? rawJson,
    bool? isCustomServerRule,
  }) {
    return AvailabilityRule(
      id: id ?? this.id,
      type: type ?? this.type,
      scope: scope ?? this.scope,
      period: period ?? this.period,
      available: available ?? this.available,
      title: title ?? this.title,
      rawJson: rawJson ?? this.rawJson,
      isCustomServerRule: isCustomServerRule ?? this.isCustomServerRule,
    );
  }

  static String newId() => _generateUuidV4();

  static String _generateUuidV4() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}

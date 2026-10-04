import 'availability_rule.dart';

class AvailabilityConfig {
  final int vehicleId;
  final String availabilityMode; // 'always' or 'never'
  final List<AvailabilityRule> rules;
  final String? timezone;
  final String? lockVersion; // updated_at

  const AvailabilityConfig({
    required this.vehicleId,
    required this.availabilityMode,
    required this.rules,
    this.timezone,
    this.lockVersion,
  });

  bool get isAlwaysMode => availabilityMode == 'always';
  bool get isNeverMode => availabilityMode == 'never';

  List<AvailabilityRule> get punctualRules {
    final seenGroups = <String>{};
    final list = <AvailabilityRule>[];

    for (final r in rules) {
      if (!r.isPunctual || r.isCustomServerRule) continue;
      if (r.groupId != null) {
        if (seenGroups.contains(r.groupId)) continue;
        seenGroups.add(r.groupId!);
      }
      list.add(r);
    }
    return list;
  }

  List<AvailabilityRule> get recurringRules =>
      rules.where((r) => r.isRecurringWeekly && !r.isCustomServerRule).toList();

  List<AvailabilityRule> get customServerRules =>
      rules.where((r) => r.isCustomServerRule).toList();
}

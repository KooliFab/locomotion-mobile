import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_providers.dart';
import '../../data/datasources/availability_remote_data_source.dart';
import '../../data/repositories/availability_repository_impl.dart';
import '../../domain/entities/availability_config.dart';
import '../../domain/entities/availability_rule.dart';
import '../../domain/entities/conflicting_loan.dart';
import '../../domain/repositories/availability_repository.dart';
import '../../../fleet/presentation/controllers/fleet_controller.dart';
import '../../../loanables/presentation/controllers/loanables_controller.dart';

final availabilityRemoteDataSourceProvider = Provider<AvailabilityRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AvailabilityRemoteDataSourceImpl(apiClient);
});

final availabilityRepositoryProvider = Provider<AvailabilityRepository>((ref) {
  final ds = ref.watch(availabilityRemoteDataSourceProvider);
  return AvailabilityRepositoryImpl(ds);
});

final vehicleAvailabilityConfigProvider =
    FutureProvider.family<AvailabilityConfig, int>((ref, vehicleId) async {
  final repo = ref.watch(availabilityRepositoryProvider);
  return repo.getAvailabilityConfig(vehicleId);
});

class VehicleAvailabilityState {
  final bool isSubmitting;
  final String? errorMessage;
  final List<ConflictingLoan> activeConflicts;

  const VehicleAvailabilityState({
    this.isSubmitting = false,
    this.errorMessage,
    this.activeConflicts = const [],
  });

  VehicleAvailabilityState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    List<ConflictingLoan>? activeConflicts,
  }) {
    return VehicleAvailabilityState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
      activeConflicts: activeConflicts ?? this.activeConflicts,
    );
  }
}

class VehicleAvailabilityNotifier extends Notifier<VehicleAvailabilityState> {
  final int vehicleId;

  VehicleAvailabilityNotifier(this.vehicleId);

  @override
  VehicleAvailabilityState build() {
    return const VehicleAvailabilityState();
  }

  AvailabilityRepository get _repository =>
      ref.read(availabilityRepositoryProvider);

  Future<List<ConflictingLoan>> checkConflictsForDraftRules(
    List<AvailabilityRule> draftRules, {
    String? ruleToReplaceId,
    String? groupToReplaceId,
  }) async {
    final currentConfig =
        await ref.read(vehicleAvailabilityConfigProvider(vehicleId).future);

    final List<AvailabilityRule> candidateRules = [];

    for (final r in currentConfig.rules) {
      if (ruleToReplaceId != null && r.id == ruleToReplaceId) {
        continue;
      }
      if (groupToReplaceId != null && r.groupId == groupToReplaceId) {
        continue;
      }
      candidateRules.add(r);
    }

    candidateRules.addAll(draftRules);

    final jsonStr = jsonEncode(candidateRules.map((r) => r.toJson()).toList());

    return _repository.checkConflicts(
      vehicleId,
      availabilityMode: currentConfig.availabilityMode,
      availabilityJson: jsonStr,
    );
  }

  Future<List<ConflictingLoan>> checkConflictsForDraftRule(
    AvailabilityRule draftRule, {
    String? ruleToReplaceId,
  }) {
    return checkConflictsForDraftRules(
      [draftRule],
      ruleToReplaceId: ruleToReplaceId,
      groupToReplaceId: draftRule.groupId,
    );
  }

  Future<bool> saveRules(
    List<AvailabilityRule> newRules, {
    String? ruleToReplaceId,
    String? groupToReplaceId,
  }) async {
    // Re-entrancy guard
    if (state.isSubmitting) return false;
    state = state.copyWith(isSubmitting: true, errorMessage: null, activeConflicts: []);

    try {
      final currentConfig =
          await ref.read(vehicleAvailabilityConfigProvider(vehicleId).future);

      final List<AvailabilityRule> updatedRules = [];
      for (final r in currentConfig.rules) {
        if (ruleToReplaceId != null && r.id == ruleToReplaceId) {
          continue;
        }
        if (groupToReplaceId != null && r.groupId == groupToReplaceId) {
          continue;
        }
        updatedRules.add(r);
      }
      updatedRules.addAll(newRules);

      final jsonStr = jsonEncode(updatedRules.map((r) => r.toJson()).toList());

      // Pre-flight check
      final conflicts = await _repository.checkConflicts(
        vehicleId,
        availabilityMode: currentConfig.availabilityMode,
        availabilityJson: jsonStr,
      );

      if (conflicts.isNotEmpty) {
        state = state.copyWith(
          isSubmitting: false,
          activeConflicts: conflicts,
          errorMessage:
              'Impossible d\'enregistrer : ce créneau entre en conflit avec ${conflicts.length} réservation(s) existante(s).',
        );
        return false;
      }

      await _repository.saveAvailabilityConfig(
        vehicleId,
        availabilityMode: currentConfig.availabilityMode,
        availabilityJson: jsonStr,
        lockVersion: currentConfig.lockVersion,
      );

      _invalidateRelatedProviders();
      state = state.copyWith(isSubmitting: false);
      return true;
    } on AvailabilityConflictException catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        activeConflicts: e.conflicts,
        errorMessage: e.message,
      );
      return false;
    } on AvailabilityOptimisticLockException catch (e) {
      _invalidateRelatedProviders();
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Erreur lors de l\'enregistrement : $e',
      );
      return false;
    }
  }

  Future<bool> addRule(AvailabilityRule newRule) => saveRules([newRule]);

  Future<bool> updateRule(AvailabilityRule updatedRule) => saveRules(
        [updatedRule],
        ruleToReplaceId: updatedRule.id,
        groupToReplaceId: updatedRule.groupId,
      );

  Future<bool> deleteRule(String ruleId, {String? groupId}) async {
    // Re-entrancy guard
    if (state.isSubmitting) return false;
    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final currentConfig =
          await ref.read(vehicleAvailabilityConfigProvider(vehicleId).future);

      final updatedRules = currentConfig.rules.where((r) {
        if (r.id == ruleId) return false;
        if (groupId != null && r.groupId == groupId) return false;
        return true;
      }).toList();

      final jsonStr = jsonEncode(updatedRules.map((r) => r.toJson()).toList());

      await _repository.saveAvailabilityConfig(
        vehicleId,
        availabilityMode: currentConfig.availabilityMode,
        availabilityJson: jsonStr,
        lockVersion: currentConfig.lockVersion,
      );

      _invalidateRelatedProviders();
      state = state.copyWith(isSubmitting: false);
      return true;
    } on AvailabilityOptimisticLockException catch (e) {
      _invalidateRelatedProviders();
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Erreur lors de la suppression : $e',
      );
      return false;
    }
  }

  void _invalidateRelatedProviders() {
    ref.invalidate(vehicleAvailabilityConfigProvider(vehicleId));
    ref.invalidate(fleetVehicleDetailProvider(vehicleId));
    ref.invalidate(ownerFleetControllerProvider);
    ref.invalidate(loanableDetailProvider(vehicleId));
    ref.invalidate(loanableAvailabilityPeriodProvider(vehicleId));
    ref.invalidate(loanableAvailabilityWindowProvider);
    ref.invalidate(loanablesListControllerProvider);
  }
}

final vehicleAvailabilityControllerProvider =
    NotifierProvider.family<VehicleAvailabilityNotifier, VehicleAvailabilityState, int>(
  (vehicleId) => VehicleAvailabilityNotifier(vehicleId),
);

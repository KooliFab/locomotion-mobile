import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../loans/presentation/controllers/loans_controller.dart';
import '../../../loanables/presentation/controllers/loanables_controller.dart';
import '../../data/repositories/incident_repository_impl.dart';
import '../../domain/entities/incident.dart';
import '../../domain/repositories/incident_repository.dart';
import 'incidents_list_controller.dart';

class IncidentDetailState {
  final bool isLoading;
  final bool isAddingNote;
  final bool isResolving;
  final bool isReopening;
  final Incident? incident;
  final String? errorMessage;

  const IncidentDetailState({
    this.isLoading = false,
    this.isAddingNote = false,
    this.isResolving = false,
    this.isReopening = false,
    this.incident,
    this.errorMessage,
  });

  IncidentDetailState copyWith({
    bool? isLoading,
    bool? isAddingNote,
    bool? isResolving,
    bool? isReopening,
    Incident? incident,
    String? errorMessage,
    bool clearError = false,
  }) {
    return IncidentDetailState(
      isLoading: isLoading ?? this.isLoading,
      isAddingNote: isAddingNote ?? this.isAddingNote,
      isResolving: isResolving ?? this.isResolving,
      isReopening: isReopening ?? this.isReopening,
      incident: incident ?? this.incident,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class IncidentDetailController extends Notifier<IncidentDetailState> {
  final int incidentId;

  IncidentDetailController(this.incidentId);

  @override
  IncidentDetailState build() {
    Future.microtask(loadIncident);
    return const IncidentDetailState(isLoading: true);
  }

  IncidentRepository get _repository => ref.read(incidentRepositoryProvider);

  Future<void> loadIncident() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final incident = await _repository.getIncidentDetail(incidentId);
      state = state.copyWith(isLoading: false, incident: incident);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Impossible de charger les détails de l\'incident : $e',
      );
    }
  }

  Future<bool> addNote(String text) async {
    if (state.isAddingNote || text.trim().isEmpty) return false;
    state = state.copyWith(isAddingNote: true, clearError: true);

    try {
      final note = await _repository.addNote(incidentId, text.trim());
      if (state.incident != null) {
        final updatedNotes = [...state.incident!.notes, note];
        state = state.copyWith(
          isAddingNote: false,
          incident: state.incident!.copyWith(notes: updatedNotes),
        );
      } else {
        state = state.copyWith(isAddingNote: false);
      }
      return true;
    } catch (e) {
      state = state.copyWith(
        isAddingNote: false,
        errorMessage: 'Erreur lors de l\'ajout de la note : $e',
      );
      return false;
    }
  }

  Future<bool> resolve() async {
    if (state.isResolving) return false;
    state = state.copyWith(isResolving: true, clearError: true);

    try {
      final resolved = await _repository.resolveIncident(incidentId);
      state = state.copyWith(
        isResolving: false,
        incident: resolved,
      );

      // Invalidate relevant views
      if (resolved.loanId != null) {
        ref.invalidate(loanDetailProvider(resolved.loanId!));
        ref.invalidate(loanIncidentsListProvider(resolved.loanId!));
      }
      if (resolved.loanableId != null) {
        ref.invalidate(loanableDetailProvider(resolved.loanableId!));
        ref.invalidate(vehicleIncidentsListProvider(resolved.loanableId!));
      }
      ref.invalidate(incidentsListControllerProvider);

      return true;
    } catch (e) {
      state = state.copyWith(
        isResolving: false,
        errorMessage: 'Erreur lors de la résolution : $e',
      );
      return false;
    }
  }

  Future<bool> reopen() async {
    if (state.isReopening) return false;
    state = state.copyWith(isReopening: true, clearError: true);

    try {
      final reopened = await _repository.reopenIncident(incidentId);
      state = state.copyWith(
        isReopening: false,
        incident: reopened,
      );

      if (reopened.loanId != null) {
        ref.invalidate(loanDetailProvider(reopened.loanId!));
        ref.invalidate(loanIncidentsListProvider(reopened.loanId!));
      }
      if (reopened.loanableId != null) {
        ref.invalidate(loanableDetailProvider(reopened.loanableId!));
        ref.invalidate(vehicleIncidentsListProvider(reopened.loanableId!));
      }
      ref.invalidate(incidentsListControllerProvider);

      return true;
    } catch (e) {
      state = state.copyWith(
        isReopening: false,
        errorMessage: 'Erreur lors de la réouverture : $e',
      );
      return false;
    }
  }
}

final incidentDetailControllerProvider =
    NotifierProvider.family<IncidentDetailController, IncidentDetailState, int>(
  (incidentId) => IncidentDetailController(incidentId),
);

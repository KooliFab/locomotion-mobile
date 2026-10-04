import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/incident_repository_impl.dart';
import '../../domain/entities/incident.dart';
import '../../domain/repositories/incident_repository.dart';

class IncidentsListState {
  final bool isLoading;
  final List<Incident> incidents;
  final String? errorMessage;
  final String? filterStatus;

  const IncidentsListState({
    this.isLoading = false,
    this.incidents = const [],
    this.errorMessage,
    this.filterStatus,
  });

  List<Incident> get filteredIncidents {
    if (filterStatus == null || filterStatus!.isEmpty) {
      return incidents;
    }
    return incidents.where((i) => i.status == filterStatus).toList();
  }

  IncidentsListState copyWith({
    bool? isLoading,
    List<Incident>? incidents,
    String? errorMessage,
    bool clearError = false,
    String? filterStatus,
    bool clearFilter = false,
  }) {
    return IncidentsListState(
      isLoading: isLoading ?? this.isLoading,
      incidents: incidents ?? this.incidents,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      filterStatus: clearFilter ? null : (filterStatus ?? this.filterStatus),
    );
  }
}

class IncidentsListController extends Notifier<IncidentsListState> {
  final int? loanId;
  final int? loanableId;

  IncidentsListController({
    this.loanId,
    this.loanableId,
  });

  @override
  IncidentsListState build() {
    Future.microtask(loadIncidents);
    return const IncidentsListState(isLoading: true);
  }

  IncidentRepository get _repository => ref.read(incidentRepositoryProvider);

  Future<void> loadIncidents() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final incidents = await _repository.getIncidents(
        loanId: loanId,
        loanableId: loanableId,
      );
      state = state.copyWith(
        isLoading: false,
        incidents: incidents,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Impossible de charger les incidents : $e',
      );
    }
  }

  void setFilter(String? status) {
    state = state.copyWith(
      filterStatus: status,
      clearFilter: status == null,
    );
  }
}

final incidentsListControllerProvider =
    NotifierProvider<IncidentsListController, IncidentsListState>(
  IncidentsListController.new,
);

final vehicleIncidentsListProvider =
    NotifierProvider.family<IncidentsListController, IncidentsListState, int>(
  (loanableId) => IncidentsListController(loanableId: loanableId),
);

final loanIncidentsListProvider =
    NotifierProvider.family<IncidentsListController, IncidentsListState, int>(
  (loanId) => IncidentsListController(loanId: loanId),
);

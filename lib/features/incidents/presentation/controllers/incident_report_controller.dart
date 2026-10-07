import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/exceptions.dart';
import '../../../loans/presentation/controllers/loans_controller.dart';
import '../../../loanables/presentation/controllers/loanables_controller.dart';
import '../../data/repositories/incident_repository_impl.dart';
import '../../domain/entities/incident.dart';
import '../../domain/entities/incident_category.dart';
import '../../domain/repositories/incident_repository.dart';
import 'incidents_list_controller.dart';

class IncidentReportState {
  final IncidentCategory? selectedCategory;
  final String description;
  final bool isSubmitting;
  final bool isUploadingPhoto;
  final List<int> uploadedImageIds;
  final List<String> localPhotoPaths;
  final String? errorMessage;
  final bool safetyAcknowledged;
  final Incident? createdIncident;
  final String idempotencyKey;
  final bool hasUnknownResult;
  final bool isReconciling;

  const IncidentReportState({
    this.selectedCategory,
    this.description = '',
    this.isSubmitting = false,
    this.isUploadingPhoto = false,
    this.uploadedImageIds = const [],
    this.localPhotoPaths = const [],
    this.errorMessage,
    this.safetyAcknowledged = false,
    this.createdIncident,
    this.idempotencyKey = '',
    this.hasUnknownResult = false,
    this.isReconciling = false,
  });

  bool get canSubmit {
    if (isSubmitting || isUploadingPhoto || isReconciling) return false;
    if (selectedCategory == null) return false;
    if (description.trim().length < 10) return false;
    if (selectedCategory!.requiresSafetyDisclaimer && !safetyAcknowledged) {
      return false;
    }
    return true;
  }

  IncidentReportState copyWith({
    IncidentCategory? selectedCategory,
    String? description,
    bool? isSubmitting,
    bool? isUploadingPhoto,
    List<int>? uploadedImageIds,
    List<String>? localPhotoPaths,
    String? errorMessage,
    bool clearError = false,
    bool? safetyAcknowledged,
    Incident? createdIncident,
    String? idempotencyKey,
    bool? hasUnknownResult,
    bool? isReconciling,
  }) {
    return IncidentReportState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      description: description ?? this.description,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
      uploadedImageIds: uploadedImageIds ?? this.uploadedImageIds,
      localPhotoPaths: localPhotoPaths ?? this.localPhotoPaths,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      safetyAcknowledged: safetyAcknowledged ?? this.safetyAcknowledged,
      createdIncident: createdIncident ?? this.createdIncident,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      hasUnknownResult: hasUnknownResult ?? this.hasUnknownResult,
      isReconciling: isReconciling ?? this.isReconciling,
    );
  }
}

String _generateIdempotencyKey() {
  final now = DateTime.now().microsecondsSinceEpoch;
  final rand = Random().nextInt(1000000);
  return 'inc_${now}_$rand';
}

class IncidentReportController extends Notifier<IncidentReportState> {
  @override
  IncidentReportState build() =>
      IncidentReportState(idempotencyKey: _generateIdempotencyKey());

  IncidentRepository get _repository => ref.read(incidentRepositoryProvider);

  void setCategory(IncidentCategory category) {
    state = state.copyWith(
      selectedCategory: category,
      clearError: true,
      safetyAcknowledged: category.requiresSafetyDisclaimer
          ? state.safetyAcknowledged
          : false,
    );
  }

  void setDescription(String description) {
    state = state.copyWith(description: description, clearError: true);
  }

  void setSafetyAcknowledged(bool value) {
    state = state.copyWith(safetyAcknowledged: value, clearError: true);
  }

  Future<void> attachPhoto(String filePath) async {
    if (state.isUploadingPhoto) return;
    state = state.copyWith(isUploadingPhoto: true, clearError: true);

    try {
      final imageId = await _repository.uploadImage(filePath);
      state = state.copyWith(
        isUploadingPhoto: false,
        uploadedImageIds: [...state.uploadedImageIds, imageId],
        localPhotoPaths: [...state.localPhotoPaths, filePath],
      );
    } catch (e) {
      state = state.copyWith(
        isUploadingPhoto: false,
        errorMessage: 'Échec de l\'envoi de la photo : $e',
      );
    }
  }

  void removePhoto(int index) {
    if (index < 0 || index >= state.localPhotoPaths.length) return;
    final updatedPaths = List<String>.from(state.localPhotoPaths)
      ..removeAt(index);
    final updatedIds = List<int>.from(state.uploadedImageIds);
    if (index < updatedIds.length) {
      updatedIds.removeAt(index);
    }
    state = state.copyWith(
      localPhotoPaths: updatedPaths,
      uploadedImageIds: updatedIds,
    );
  }

  Future<Incident?> submit({required int loanableId, int? loanId}) async {
    // Non-reentrant guard
    if (state.isSubmitting || state.isReconciling) return null;

    if (state.selectedCategory == null) {
      state = state.copyWith(
        errorMessage: 'Veuillez sélectionner un motif d\'incident.',
      );
      return null;
    }

    if (state.description.trim().length < 10) {
      state = state.copyWith(
        errorMessage:
            'Veuillez saisir une description détaillée (au moins 10 caractères).',
      );
      return null;
    }

    if (state.selectedCategory!.requiresSafetyDisclaimer &&
        !state.safetyAcknowledged) {
      state = state.copyWith(
        errorMessage:
            'Veuillez confirmer que vous êtes en sécurité et que les secours ont été prévenus si nécessaire.',
      );
      return null;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final incident = await _repository.createIncident(
        loanableId: loanableId,
        loanId: loanId,
        category: state.selectedCategory!,
        description: state.description,
        imageIds: state.uploadedImageIds,
        idempotencyKey: state.idempotencyKey,
      );

      // Invalidate relevant views
      if (loanId != null) {
        ref.invalidate(loanDetailProvider(loanId));
        ref.invalidate(loanIncidentsListProvider(loanId));
      }
      ref.invalidate(loanableDetailProvider(loanableId));
      ref.invalidate(vehicleIncidentsListProvider(loanableId));
      ref.invalidate(incidentsListControllerProvider);

      state = state.copyWith(
        isSubmitting: false,
        hasUnknownResult: false,
        createdIncident: incident,
      );

      return incident;
    } on NetworkException {
      state = state.copyWith(
        isSubmitting: false,
        hasUnknownResult: true,
        errorMessage:
            'Délai d\'attente dépassé ou coupure réseau. Votre signalement a peut-être déjà été enregistré.',
      );
      return null;
    } catch (e) {
      final isTimeout = e.toString().toLowerCase().contains('timeout');
      state = state.copyWith(
        isSubmitting: false,
        hasUnknownResult: isTimeout,
        errorMessage: isTimeout
            ? 'Délai d\'attente dépassé. Votre signalement a peut-être déjà été enregistré.'
            : 'Erreur lors du signalement : $e',
      );
      return null;
    }
  }

  Future<Incident?> reconcile({required int loanableId, int? loanId}) async {
    state = state.copyWith(isReconciling: true, clearError: true);
    try {
      final list = await _repository.getIncidents(
        loanId: loanId,
        loanableId: loanableId,
      );
      final recent = list
          .where(
            (i) =>
                i.loanableId == loanableId &&
                (loanId == null || i.loanId == loanId) &&
                i.cleanComments.contains(state.description.trim()),
          )
          .firstOrNull;

      if (recent != null) {
        state = state.copyWith(
          isReconciling: false,
          hasUnknownResult: false,
          createdIncident: recent,
        );
        return recent;
      }

      state = state.copyWith(isReconciling: false);
      return await submit(loanableId: loanableId, loanId: loanId);
    } catch (e) {
      state = state.copyWith(
        isReconciling: false,
        errorMessage: 'Impossible de vérifier le statut auprès du serveur : $e',
      );
      return null;
    }
  }

  void reset() {
    state = IncidentReportState(idempotencyKey: _generateIdempotencyKey());
  }
}

final incidentReportControllerProvider =
    NotifierProvider.autoDispose<IncidentReportController, IncidentReportState>(
      IncidentReportController.new,
    );

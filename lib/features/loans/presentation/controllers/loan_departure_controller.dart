import 'dart:io';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/departure_draft.dart';
import '../../domain/entities/loan_inspection.dart';
import '../../domain/repositories/departure_draft_repository.dart';
import '../../domain/repositories/loan_inspection_repository.dart';
import '../../domain/repositories/loans_repository.dart';
import 'loan_inspection_providers.dart';
import 'loans_controller.dart';

class DepartureInspectionState {
  final DepartureDraft draft;
  final bool isLoading;
  final bool isSubmitting;
  final LoanInspection? submissionSuccess;
  final String? errorMessage;
  final bool canSubmit;

  const DepartureInspectionState({
    required this.draft,
    this.isLoading = false,
    this.isSubmitting = false,
    this.submissionSuccess,
    this.errorMessage,
    this.canSubmit = false,
  });

  bool get isUploading =>
      draft.photos.values.any((p) => p.status == DraftPhotoStatus.uploading);

  DepartureInspectionState copyWith({
    DepartureDraft? draft,
    bool? isLoading,
    bool? isSubmitting,
    LoanInspection? submissionSuccess,
    String? errorMessage,
    bool clearError = false,
    bool? canSubmit,
  }) {
    return DepartureInspectionState(
      draft: draft ?? this.draft,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      canSubmit: canSubmit ?? this.canSubmit,
    );
  }
}

class LoanDepartureController
    extends Notifier<DepartureInspectionState> {
  final int targetLoanId;

  late final DepartureDraftRepository _draftRepository;
  late final LoanInspectionRepository _inspectionRepository;
  late final LoansRepository _loansRepository;

  LoanDepartureController(this.targetLoanId);

  @override
  DepartureInspectionState build() {
    _draftRepository = ref.watch(departureDraftRepositoryProvider);
    _inspectionRepository = ref.watch(loanInspectionRepositoryProvider);
    _loansRepository = ref.watch(loansRepositoryProvider);

    return DepartureInspectionState(
      draft: DepartureDraft(userId: 0, loanId: targetLoanId),
      isLoading: true,
    );
  }

  Future<void> initialize({
    required int userId,
    required int loanId,
    required bool requiresMileage,
    int? initialOdometer,
  }) async {
    if (loanId != targetLoanId) {
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final existingDraft = await _draftRepository.getDraft(
        userId: userId,
        loanId: targetLoanId,
      );

      if (existingDraft != null) {
        // Issue 3: Transform interrupted 'uploading' photos into recoverable 'error' state
        final sanitizedPhotos = <String, DraftPhotoEntry>{};
        var hasInterruptedUploads = false;

        for (final entry in existingDraft.photos.entries) {
          if (entry.value.status == DraftPhotoStatus.uploading) {
            hasInterruptedUploads = true;
            sanitizedPhotos[entry.key] = entry.value.copyWith(
              status: DraftPhotoStatus.error,
              errorMessage:
                  'Téléversement interrompu. Appuyez sur réessayer.',
            );
          } else {
            sanitizedPhotos[entry.key] = entry.value;
          }
        }

        final recoveredDraft = hasInterruptedUploads
            ? existingDraft.copyWith(photos: sanitizedPhotos)
            : existingDraft;

        if (hasInterruptedUploads) {
          await _draftRepository.saveDraft(recoveredDraft);
        }

        state = DepartureInspectionState(
          draft: recoveredDraft,
          isLoading: false,
          errorMessage: hasInterruptedUploads
              ? 'Téléversement interrompu. Veuillez réessayer.'
              : null,
          canSubmit: recoveredDraft.isReadyForSubmission(
            requiresMileage: requiresMileage,
          ),
        );
        return;
      }

      // Initialize initial default draft
      final defaultPhotos = <String, DraftPhotoEntry>{
        'front': const DraftPhotoEntry(field: 'front'),
        'back': const DraftPhotoEntry(field: 'back'),
        'left_side': const DraftPhotoEntry(field: 'left_side'),
        'right_side': const DraftPhotoEntry(field: 'right_side'),
      };
      if (requiresMileage) {
        defaultPhotos['dashboard_odometer'] =
            const DraftPhotoEntry(field: 'dashboard_odometer');
      }

      final defaultChecklist = requiresMileage
          ? {
              'key_present': true,
              'insurance_paper_present': true,
              'charging_cable_present': true,
              'spare_wheel_present': true,
            }
          : {
              'lock_present': true,
              'lock_key_present': true,
            };

      final newDraft = DepartureDraft(
        userId: userId,
        loanId: targetLoanId,
        odometerKm: initialOdometer,
        fuelBatteryLevelPercent: 80,
        cleanlinessRating: 4,
        checklist: defaultChecklist,
        photos: defaultPhotos,
        updatedAt: DateTime.now(),
      );

      await _draftRepository.saveDraft(newDraft);

      state = DepartureInspectionState(
        draft: newDraft,
        isLoading: false,
        canSubmit: newDraft.isReadyForSubmission(requiresMileage: requiresMileage),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Impossible de charger le brouillon : ${e.toString()}',
      );
    }
  }

  void updateOdometer(int? km, bool requiresMileage) {
    final updated = state.draft.copyWith(
      odometerKm: km,
      updatedAt: DateTime.now(),
    );
    _persistDraft(updated, requiresMileage);
  }

  void updateFuelBattery(int percent, bool requiresMileage) {
    final updated = state.draft.copyWith(
      fuelBatteryLevelPercent: percent.clamp(0, 100),
      updatedAt: DateTime.now(),
    );
    _persistDraft(updated, requiresMileage);
  }

  void updateCleanliness(int rating, bool requiresMileage) {
    final updated = state.draft.copyWith(
      cleanlinessRating: rating.clamp(1, 5),
      updatedAt: DateTime.now(),
    );
    _persistDraft(updated, requiresMileage);
  }

  void toggleChecklistItem(String key, bool value, bool requiresMileage) {
    final checklist = Map<String, bool>.from(state.draft.checklist);
    checklist[key] = value;
    final updated = state.draft.copyWith(
      checklist: checklist,
      updatedAt: DateTime.now(),
    );
    _persistDraft(updated, requiresMileage);
  }

  void updateExistingDamages(String notes, bool requiresMileage) {
    final updated = state.draft.copyWith(
      existingDamagesNotes: notes,
      updatedAt: DateTime.now(),
    );
    _persistDraft(updated, requiresMileage);
  }

  Future<void> attachAndUploadPhoto({
    required String field,
    required File file,
    required bool requiresMileage,
  }) async {
    final uploadLoanId = targetLoanId;
    final uploadUserId = state.draft.userId;

    final photos = Map<String, DraftPhotoEntry>.from(state.draft.photos);
    photos[field] = DraftPhotoEntry(
      field: field,
      localPath: file.path,
      status: DraftPhotoStatus.uploading,
    );

    final draftUploading = state.draft.copyWith(
      photos: photos,
      updatedAt: DateTime.now(),
    );
    state = state.copyWith(
      draft: draftUploading,
      clearError: true,
      canSubmit: false,
    );
    await _draftRepository.saveDraft(draftUploading);

    try {
      final imageId = await _inspectionRepository.uploadInspectionPhoto(
        file: file,
        field: field,
      );

      // Issue 2: Discard obsolete response if loan or user context has changed
      if (targetLoanId != uploadLoanId ||
          state.draft.userId != uploadUserId ||
          state.draft.loanId != uploadLoanId) {
        return;
      }

      final photosUploaded = Map<String, DraftPhotoEntry>.from(state.draft.photos);
      photosUploaded[field] = DraftPhotoEntry(
        field: field,
        localPath: file.path,
        status: DraftPhotoStatus.uploaded,
        imageId: imageId,
      );

      final finalDraft = state.draft.copyWith(
        photos: photosUploaded,
        updatedAt: DateTime.now(),
      );
      await _draftRepository.saveDraft(finalDraft);

      state = state.copyWith(
        draft: finalDraft,
        canSubmit:
            finalDraft.isReadyForSubmission(requiresMileage: requiresMileage),
      );
    } catch (e) {
      // Discard obsolete error callback if loan context changed
      if (targetLoanId != uploadLoanId ||
          state.draft.userId != uploadUserId ||
          state.draft.loanId != uploadLoanId) {
        return;
      }

      final photosError = Map<String, DraftPhotoEntry>.from(state.draft.photos);
      photosError[field] = DraftPhotoEntry(
        field: field,
        localPath: file.path,
        status: DraftPhotoStatus.error,
        errorMessage: 'Échec de l\'envoi de la photo.',
      );

      final errorDraft = state.draft.copyWith(
        photos: photosError,
        updatedAt: DateTime.now(),
      );
      await _draftRepository.saveDraft(errorDraft);

      state = state.copyWith(
        draft: errorDraft,
        errorMessage:
            'Erreur lors du téléversement de la photo ($field). Veuillez réessayer.',
        canSubmit: false,
      );
    }
  }

  Future<void> retryUpload({
    required String field,
    required bool requiresMileage,
  }) async {
    final entry = state.draft.photos[field];
    if (entry?.localPath == null) return;
    final file = File(entry!.localPath!);
    if (!file.existsSync()) return;

    await attachAndUploadPhoto(
      field: field,
      file: file,
      requiresMileage: requiresMileage,
    );
  }

  void removePhoto(String field, bool requiresMileage) {
    final photos = Map<String, DraftPhotoEntry>.from(state.draft.photos);
    photos.remove(field);
    final updated = state.draft.copyWith(
      photos: photos,
      updatedAt: DateTime.now(),
    );
    _persistDraft(updated, requiresMileage);
  }

  Future<void> submitDeparture({
    required int loanId,
    required bool requiresMileage,
  }) async {
    if (!state.draft.isReadyForSubmission(requiresMileage: requiresMileage)) {
      state = state.copyWith(
        errorMessage:
            'Veuillez renseigner toutes les informations et photos obligatoires.',
      );
      return;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      final idempotencyKey = _generateUuidV4();
      final payload = <String, dynamic>{
        if (requiresMileage && state.draft.odometerKm != null)
          'odometer_km': state.draft.odometerKm,
        'fuel_battery_level_percent': state.draft.fuelBatteryLevelPercent,
        'cleanliness_rating': state.draft.cleanlinessRating,
        'checklist': state.draft.checklist,
        'photos': state.draft.photos.entries
            .where((e) => e.value.imageId != null)
            .map((e) => {'field': e.key, 'image_id': e.value.imageId!})
            .toList(),
        if (state.draft.existingDamagesNotes != null &&
            state.draft.existingDamagesNotes!.trim().isNotEmpty)
          'existing_damages_notes': state.draft.existingDamagesNotes!.trim(),
      };

      final inspection =
          await _inspectionRepository.submitDepartureInspection(
        loanId: targetLoanId,
        payload: payload,
        idempotencyKey: idempotencyKey,
      );

      // Clean up local draft and its photo files
      await _draftRepository.clearDraft(
        userId: state.draft.userId,
        loanId: targetLoanId,
      );

      // Invalidate loan cache and refresh detail
      ref.invalidate(loanDetailProvider(targetLoanId));

      state = state.copyWith(
        isSubmitting: false,
        submissionSuccess: inspection,
      );
    } catch (e) {
      // In case of timeout or failure, check if the server already recorded the inspection
      await checkServerStatus(targetLoanId, originalError: e.toString());
    }
  }

  Future<void> checkServerStatus(int loanId, {String? originalError}) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final refreshed = await _loansRepository.getLoanDetail(loanId);

      // Issue 1: Strictly require departureInspectionCompleted == true (do NOT treat ongoing alone as success)
      if (refreshed.departureInspectionCompleted) {
        // Server already recorded the inspection
        await _draftRepository.clearDraft(
          userId: state.draft.userId,
          loanId: targetLoanId,
        );
        ref.invalidate(loanDetailProvider(loanId));

        final syntheticInspection = LoanInspection(
          loanId: loanId,
          inspectionType: 'departure',
          odometerKm: refreshed.mileageStart,
          loanStatus: refreshed.status,
        );

        state = state.copyWith(
          isSubmitting: false,
          submissionSuccess: syntheticInspection,
        );
        return;
      }

      // If departure inspection is not recorded on server, keep draft and show clear error
      final message = originalError != null
          ? 'L\'état des lieux n\'a pas été enregistré par le serveur. Vos saisies ont été conservées. ($originalError)'
          : 'L\'état des lieux n\'a pas été enregistré par le serveur. Vos saisies ont été conservées.';
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: message,
      );
    } catch (_) {
      final message = originalError != null
          ? 'L\'état des lieux n\'a pas été enregistré par le serveur. ($originalError)'
          : 'Erreur réseau lors de la vérification du statut du serveur.';
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: message,
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  void _persistDraft(DepartureDraft draft, bool requiresMileage) {
    state = state.copyWith(
      draft: draft,
      canSubmit: draft.isReadyForSubmission(requiresMileage: requiresMileage),
    );
    _draftRepository.saveDraft(draft);
  }

  static String _generateUuidV4() {
    final random = Random.secure();
    final values = List<int>.generate(16, (_) => random.nextInt(256));
    values[6] = (values[6] & 0x0f) | 0x40; // RFC 4122 v4
    values[8] = (values[8] & 0x3f) | 0x80; // RFC 4122 variant
    final hex = values.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20, 32)}';
  }
}

final loanDepartureControllerProvider =
    NotifierProvider.family<LoanDepartureController, DepartureInspectionState, int>(
  (loanId) => LoanDepartureController(loanId),
);

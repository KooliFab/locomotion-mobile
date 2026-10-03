import 'dart:io';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/departure_draft.dart';
import '../../domain/entities/loan_inspection.dart';
import '../../domain/entities/return_draft.dart';
import '../../domain/repositories/loan_inspection_repository.dart';
import '../../domain/repositories/loans_repository.dart';
import '../../domain/repositories/return_draft_repository.dart';
import 'loan_inspection_providers.dart';
import 'loans_controller.dart';

class ReturnInspectionState {
  final ReturnDraft draft;
  final bool isLoading;
  final bool isSubmitting;
  final LoanInspection? submissionSuccess;
  final String? errorMessage;
  final bool canSubmit;

  const ReturnInspectionState({
    required this.draft,
    this.isLoading = false,
    this.isSubmitting = false,
    this.submissionSuccess,
    this.errorMessage,
    this.canSubmit = false,
  });

  bool get isUploading =>
      draft.photos.values.any((p) => p.status == DraftPhotoStatus.uploading) ||
      (draft.signaturePhoto?.status == DraftPhotoStatus.uploading);

  ReturnInspectionState copyWith({
    ReturnDraft? draft,
    bool? isLoading,
    bool? isSubmitting,
    LoanInspection? submissionSuccess,
    String? errorMessage,
    bool clearError = false,
    bool? canSubmit,
  }) {
    return ReturnInspectionState(
      draft: draft ?? this.draft,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      canSubmit: canSubmit ?? this.canSubmit,
    );
  }
}

class LoanReturnController extends Notifier<ReturnInspectionState> {
  final int targetLoanId;

  late final ReturnDraftRepository _draftRepository;
  late final LoanInspectionRepository _inspectionRepository;
  late final LoansRepository _loansRepository;

  LoanReturnController(this.targetLoanId);

  @override
  ReturnInspectionState build() {
    _draftRepository = ref.watch(returnDraftRepositoryProvider);
    _inspectionRepository = ref.watch(loanInspectionRepositoryProvider);
    _loansRepository = ref.watch(loansRepositoryProvider);

    return ReturnInspectionState(
      draft: ReturnDraft(userId: 0, loanId: targetLoanId),
      isLoading: true,
    );
  }

  Future<void> initialize({
    required int userId,
    required int loanId,
    required bool requiresMileage,
    int? mileageStart,
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
        // Transform interrupted 'uploading' photos into recoverable 'error' state
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

        DraftPhotoEntry? sanitizedSignature = existingDraft.signaturePhoto;
        if (sanitizedSignature?.status == DraftPhotoStatus.uploading) {
          hasInterruptedUploads = true;
          sanitizedSignature = sanitizedSignature!.copyWith(
            status: DraftPhotoStatus.error,
            errorMessage: 'Téléversement interrompu. Appuyez sur réessayer.',
          );
        }

        final recoveredDraft = hasInterruptedUploads
            ? existingDraft.copyWith(
                photos: sanitizedPhotos,
                signaturePhoto: sanitizedSignature,
              )
            : existingDraft;

        if (hasInterruptedUploads) {
          await _draftRepository.saveDraft(recoveredDraft);
        }

        state = ReturnInspectionState(
          draft: recoveredDraft,
          isLoading: false,
          errorMessage: hasInterruptedUploads
              ? 'Téléversement interrompu. Veuillez réessayer.'
              : null,
          canSubmit: recoveredDraft.isReadyForSubmission(
            requiresMileage: requiresMileage,
            mileageStart: mileageStart,
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
              'key_returned': true,
              'clean_inside': true,
              'clean_outside': true,
              'fuel_battery_level_ok': true,
            }
          : {
              'lock_secured': true,
              'key_returned': true,
            };

      final newDraft = ReturnDraft(
        userId: userId,
        loanId: targetLoanId,
        odometerKm: initialOdometer ?? mileageStart,
        fuelBatteryLevelPercent: 80,
        cleanlinessRating: 4,
        checklist: defaultChecklist,
        photos: defaultPhotos,
        updatedAt: DateTime.now(),
      );

      await _draftRepository.saveDraft(newDraft);

      state = ReturnInspectionState(
        draft: newDraft,
        isLoading: false,
        canSubmit: newDraft.isReadyForSubmission(
          requiresMileage: requiresMileage,
          mileageStart: mileageStart,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Impossible de charger le brouillon : ${e.toString()}',
      );
    }
  }

  void updateOdometer(int? km, bool requiresMileage, int? mileageStart) {
    String? validationError;
    if (requiresMileage && km != null && mileageStart != null && km < mileageStart) {
      validationError =
          'Le kilométrage de retour ($km km) ne peut pas être inférieur au départ ($mileageStart km).';
    }

    final updated = state.draft.copyWith(
      odometerKm: km,
      updatedAt: DateTime.now(),
    );
    _persistDraft(
      updated,
      requiresMileage,
      mileageStart,
      overrideErrorMessage: validationError,
    );
  }

  void updateFuelBattery(int percent, bool requiresMileage, int? mileageStart) {
    final updated = state.draft.copyWith(
      fuelBatteryLevelPercent: percent.clamp(0, 100),
      updatedAt: DateTime.now(),
    );
    _persistDraft(updated, requiresMileage, mileageStart);
  }

  void updateCleanliness(int rating, bool requiresMileage, int? mileageStart) {
    final updated = state.draft.copyWith(
      cleanlinessRating: rating.clamp(1, 5),
      updatedAt: DateTime.now(),
    );
    _persistDraft(updated, requiresMileage, mileageStart);
  }

  void toggleChecklistItem(
    String key,
    bool value,
    bool requiresMileage,
    int? mileageStart,
  ) {
    final checklist = Map<String, bool>.from(state.draft.checklist);
    checklist[key] = value;
    final updated = state.draft.copyWith(
      checklist: checklist,
      updatedAt: DateTime.now(),
    );
    _persistDraft(updated, requiresMileage, mileageStart);
  }

  void toggleNewDamages(
    bool declared,
    bool requiresMileage,
    int? mileageStart,
  ) {
    final updated = state.draft.copyWith(
      newDamagesDeclared: declared,
      updatedAt: DateTime.now(),
    );
    _persistDraft(updated, requiresMileage, mileageStart);
  }

  void updateComments(
    String comments,
    bool requiresMileage,
    int? mileageStart,
  ) {
    final updated = state.draft.copyWith(
      comments: comments,
      updatedAt: DateTime.now(),
    );
    _persistDraft(updated, requiresMileage, mileageStart);
  }

  void updateSignerFullName(
    String fullName,
    bool requiresMileage,
    int? mileageStart,
  ) {
    final updated = state.draft.copyWith(
      signerFullName: fullName,
      updatedAt: DateTime.now(),
    );
    _persistDraft(updated, requiresMileage, mileageStart);
  }

  Future<void> attachAndUploadPhoto({
    required String field,
    required File file,
    required bool requiresMileage,
    int? mileageStart,
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

      // Discard obsolete response if loan or user context has changed
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
        canSubmit: finalDraft.isReadyForSubmission(
          requiresMileage: requiresMileage,
          mileageStart: mileageStart,
        ),
      );
    } catch (e) {
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

  Future<void> attachAndUploadSignature({
    required File file,
    required bool requiresMileage,
    int? mileageStart,
  }) async {
    final uploadLoanId = targetLoanId;
    final uploadUserId = state.draft.userId;

    final signatureUploading = DraftPhotoEntry(
      field: 'return_signature',
      localPath: file.path,
      status: DraftPhotoStatus.uploading,
    );

    final draftUploading = state.draft.copyWith(
      signaturePhoto: signatureUploading,
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
        field: 'return_signature',
      );

      if (targetLoanId != uploadLoanId ||
          state.draft.userId != uploadUserId ||
          state.draft.loanId != uploadLoanId) {
        return;
      }

      final signatureUploaded = DraftPhotoEntry(
        field: 'return_signature',
        localPath: file.path,
        status: DraftPhotoStatus.uploaded,
        imageId: imageId,
      );

      final finalDraft = state.draft.copyWith(
        signaturePhoto: signatureUploaded,
        updatedAt: DateTime.now(),
      );
      await _draftRepository.saveDraft(finalDraft);

      state = state.copyWith(
        draft: finalDraft,
        canSubmit: finalDraft.isReadyForSubmission(
          requiresMileage: requiresMileage,
          mileageStart: mileageStart,
        ),
      );
    } catch (e) {
      if (targetLoanId != uploadLoanId ||
          state.draft.userId != uploadUserId ||
          state.draft.loanId != uploadLoanId) {
        return;
      }

      final signatureError = DraftPhotoEntry(
        field: 'return_signature',
        localPath: file.path,
        status: DraftPhotoStatus.error,
        errorMessage: 'Échec de l\'envoi de la signature.',
      );

      final errorDraft = state.draft.copyWith(
        signaturePhoto: signatureError,
        updatedAt: DateTime.now(),
      );
      await _draftRepository.saveDraft(errorDraft);

      state = state.copyWith(
        draft: errorDraft,
        errorMessage:
            'Erreur lors du téléversement de la signature. Veuillez réessayer.',
        canSubmit: false,
      );
    }
  }

  Future<void> retryUpload({
    required String field,
    required bool requiresMileage,
    int? mileageStart,
  }) async {
    if (field == 'return_signature') {
      final entry = state.draft.signaturePhoto;
      if (entry?.localPath == null) return;
      final file = File(entry!.localPath!);
      if (!file.existsSync()) return;

      await attachAndUploadSignature(
        file: file,
        requiresMileage: requiresMileage,
        mileageStart: mileageStart,
      );
      return;
    }

    final entry = state.draft.photos[field];
    if (entry?.localPath == null) return;
    final file = File(entry!.localPath!);
    if (!file.existsSync()) return;

    await attachAndUploadPhoto(
      field: field,
      file: file,
      requiresMileage: requiresMileage,
      mileageStart: mileageStart,
    );
  }

  void removePhoto(String field, bool requiresMileage, int? mileageStart) {
    if (field == 'return_signature') {
      final updated = state.draft.copyWith(
        signaturePhoto: null,
        updatedAt: DateTime.now(),
      );
      _persistDraft(updated, requiresMileage, mileageStart);
      return;
    }

    final photos = Map<String, DraftPhotoEntry>.from(state.draft.photos);
    photos.remove(field);
    final updated = state.draft.copyWith(
      photos: photos,
      updatedAt: DateTime.now(),
    );
    _persistDraft(updated, requiresMileage, mileageStart);
  }

  Future<void> submitReturn({
    required int loanId,
    required bool requiresMileage,
    int? mileageStart,
  }) async {
    if (!state.draft.isReadyForSubmission(
      requiresMileage: requiresMileage,
      mileageStart: mileageStart,
    )) {
      state = state.copyWith(
        errorMessage:
            'Veuillez renseigner toutes les informations et photos obligatoires.',
      );
      return;
    }

    if (requiresMileage &&
        mileageStart != null &&
        state.draft.odometerKm != null &&
        state.draft.odometerKm! < mileageStart) {
      state = state.copyWith(
        errorMessage:
            'Le kilométrage de retour (${state.draft.odometerKm} km) ne peut pas être inférieur au départ ($mileageStart km).',
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
        if (state.draft.signaturePhoto?.imageId != null) ...{
          'signature_image_id': state.draft.signaturePhoto!.imageId,
          'signature': {
            'image_id': state.draft.signaturePhoto!.imageId,
            'raw_svg_or_png_image_id': state.draft.signaturePhoto!.imageId,
            'signer_full_name': state.draft.signerFullName?.trim(),
            'signed_at': DateTime.now().toUtc().toIso8601String(),
          },
        },
        if (state.draft.signerFullName != null &&
            state.draft.signerFullName!.trim().isNotEmpty)
          'signer_full_name': state.draft.signerFullName!.trim(),
        'new_damages_declared': state.draft.newDamagesDeclared,
        if (state.draft.comments != null &&
            state.draft.comments!.trim().isNotEmpty)
          'comments': state.draft.comments!.trim(),
      };

      final inspection =
          await _inspectionRepository.submitReturnInspection(
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
      // In case of timeout or failure, check if the server already recorded the return inspection
      await checkServerStatus(targetLoanId, originalError: e.toString());
    }
  }

  Future<void> checkServerStatus(int loanId, {String? originalError}) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final refreshed = await _loansRepository.getLoanDetail(loanId);

      if (refreshed.returnInspectionCompleted) {
        // Server already recorded the inspection
        await _draftRepository.clearDraft(
          userId: state.draft.userId,
          loanId: targetLoanId,
        );
        ref.invalidate(loanDetailProvider(loanId));

        final syntheticInspection = LoanInspection(
          loanId: loanId,
          inspectionType: 'return',
          odometerKm: refreshed.mileageEnd,
          loanStatus: refreshed.status,
        );

        state = state.copyWith(
          isSubmitting: false,
          submissionSuccess: syntheticInspection,
        );
        return;
      }

      final message = originalError != null
          ? 'L\'état des lieux de retour n\'a pas été enregistré par le serveur. Vos saisies ont été conservées. ($originalError)'
          : 'L\'état des lieux de retour n\'a pas été enregistré par le serveur. Vos saisies ont été conservées.';
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: message,
      );
    } catch (_) {
      final message = originalError != null
          ? 'L\'état des lieux de retour n\'a pas été enregistré par le serveur. ($originalError)'
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

  void _persistDraft(
    ReturnDraft draft,
    bool requiresMileage,
    int? mileageStart, {
    String? overrideErrorMessage,
  }) {
    state = state.copyWith(
      draft: draft,
      canSubmit: draft.isReadyForSubmission(
        requiresMileage: requiresMileage,
        mileageStart: mileageStart,
      ),
      errorMessage: overrideErrorMessage,
      clearError: overrideErrorMessage == null,
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

final loanReturnControllerProvider =
    NotifierProvider.family<LoanReturnController, ReturnInspectionState, int>(
  (loanId) => LoanReturnController(loanId),
);

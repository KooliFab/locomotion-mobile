import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/inspection_photo_service.dart';
import '../../../../core/services/photo_capture_coordinator.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_factors_update.dart';
import '../../domain/repositories/loans_repository.dart';
import 'loans_controller.dart';

/// Image fields accepted by `PUT /loans/{id}/factors` (`*_id` suffix on save).
abstract class LoanFactorsImageField {
  static const mileageStart = 'mileage_start_image';
  static const mileageEnd = 'mileage_end_image';
  static const expense = 'expense_image';
}

/// Result of a picture capture + upload for one factors field.
sealed class FactorsPhotoResult {
  const FactorsPhotoResult();
}

class FactorsPhotoUploaded extends FactorsPhotoResult {
  final String field;
  final Map<String, dynamic> image;
  const FactorsPhotoUploaded(this.field, this.image);
}

class FactorsPhotoCancelled extends FactorsPhotoResult {
  const FactorsPhotoCancelled();
}

class FactorsPhotoFailed extends FactorsPhotoResult {
  final String message;
  const FactorsPhotoFailed(this.message);
}

/// Return information of a loan (mileage, expenses and their pictures),
/// saved with the existing `PUT /loans/{id}/factors` used by the web app.
class LoanFactorsController {
  LoanFactorsController(this._ref, this._repository, this._coordinator);

  final Ref _ref;
  final LoansRepository _repository;
  final PhotoCaptureCoordinator _coordinator;

  Future<FactorsPhotoResult> captureAndUpload({
    required int userId,
    required int loanId,
    required String field,
    ImageSource source = ImageSource.camera,
  }) async {
    final result = await _coordinator.capture(
      context: PendingPhotoCapture(
        userId: userId,
        loanId: loanId,
        phase: PhotoCapturePhase.loanFactors,
        field: field,
        startedAt: DateTime.now(),
      ),
      source: source,
    );
    return switch (result) {
      PhotoCaptureSuccess(:final file) => _upload(file, field),
      PhotoCaptureCancelled() => const FactorsPhotoCancelled(),
      PhotoCapturePermissionDenied(:final message) => FactorsPhotoFailed(
        message,
      ),
      PhotoCaptureFailure(:final message) => FactorsPhotoFailed(message),
    };
  }

  /// Uploads a picture taken before Android destroyed the activity, if any.
  Future<FactorsPhotoResult?> recoverLostCapture({
    required int userId,
    required int loanId,
  }) async {
    final recovered = await _coordinator.recover(
      userId: userId,
      loanId: loanId,
      phase: PhotoCapturePhase.loanFactors,
    );
    if (recovered == null) return null;
    final file = recovered.file;
    if (file == null) {
      return FactorsPhotoFailed(
        recovered.errorMessage ?? 'Impossible de récupérer la photo.',
      );
    }
    return _upload(file, recovered.context.field);
  }

  Future<FactorsPhotoResult> _upload(File file, String field) async {
    try {
      final image = await _repository.uploadImage(file, field);
      return FactorsPhotoUploaded(field, image);
    } catch (e) {
      return FactorsPhotoFailed('Échec du téléversement de la photo : $e');
    }
  }

  Future<Loan> save(int loanId, LoanFactorsUpdate update) async {
    final loan = await _repository.updateFactors(loanId, update);
    invalidateLoanViews(_ref, loanId: loanId, loanableId: loan.loanableId);
    return loan;
  }
}

final loanFactorsControllerProvider =
    Provider.autoDispose<LoanFactorsController>(
      (ref) => LoanFactorsController(
        ref,
        ref.watch(loansRepositoryProvider),
        ref.watch(photoCaptureCoordinatorProvider),
      ),
    );

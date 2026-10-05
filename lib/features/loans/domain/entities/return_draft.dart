import 'package:freezed_annotation/freezed_annotation.dart';
import 'departure_draft.dart';

part 'return_draft.freezed.dart';
part 'return_draft.g.dart';

@freezed
abstract class ReturnDraft with _$ReturnDraft {
  const factory ReturnDraft({
    required int userId,
    required int loanId,
    int? odometerKm,
    @Default(80) int fuelBatteryLevelPercent,
    @Default(4) int cleanlinessRating,
    @Default({}) Map<String, bool> checklist,
    @Default(false) bool newDamagesDeclared,
    String? comments,
    DraftPhotoEntry? signaturePhoto,
    String? signerFullName,
    @Default({}) Map<String, DraftPhotoEntry> photos,
    DateTime? updatedAt,
  }) = _ReturnDraft;

  const ReturnDraft._();

  factory ReturnDraft.fromJson(Map<String, dynamic> json) =>
      _$ReturnDraftFromJson(json);

  /// Check if the draft is complete and ready for final submission
  bool isReadyForSubmission({
    required bool requiresMileage,
    required int? mileageStart,
    bool isMotorized = true,
  }) {
    if (requiresMileage) {
      if (odometerKm == null || odometerKm! < 0) return false;
      if (mileageStart != null && odometerKm! < mileageStart) return false;
    }

    final requiredFields = isMotorized
        ? [
            'front',
            'back',
            'left_side',
            'right_side',
            if (requiresMileage) 'dashboard_odometer',
          ]
        : <String>[];

    if (isMotorized) {
      for (final f in requiredFields) {
        final photo = photos[f];
        if (photo == null ||
            photo.status != DraftPhotoStatus.uploaded ||
            photo.imageId == null) {
          return false;
        }
      }
    } else {
      // Non-motorized vehicle (Bike / Trailer / CarTrailer): at least 'front' or 'overall_view' photo
      final front = photos['front'] ?? photos['overall_view'];
      if (front == null ||
          front.status != DraftPhotoStatus.uploaded ||
          front.imageId == null) {
        return false;
      }
      if (requiresMileage) {
        final odoPhoto = photos['dashboard_odometer'];
        if (odoPhoto == null ||
            odoPhoto.status != DraftPhotoStatus.uploaded ||
            odoPhoto.imageId == null) {
          return false;
        }
      }
    }

    return true;
  }
}

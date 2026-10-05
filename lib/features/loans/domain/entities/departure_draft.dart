import 'package:freezed_annotation/freezed_annotation.dart';

part 'departure_draft.freezed.dart';
part 'departure_draft.g.dart';

enum DraftPhotoStatus {
  notTaken,
  uploading,
  uploaded,
  error,
}

@freezed
abstract class DraftPhotoEntry with _$DraftPhotoEntry {
  const factory DraftPhotoEntry({
    required String field,
    String? localPath,
    @Default(DraftPhotoStatus.notTaken) DraftPhotoStatus status,
    int? imageId,
    String? errorMessage,
  }) = _DraftPhotoEntry;

  factory DraftPhotoEntry.fromJson(Map<String, dynamic> json) =>
      _$DraftPhotoEntryFromJson(json);
}

@freezed
abstract class DepartureDraft with _$DepartureDraft {
  const factory DepartureDraft({
    required int userId,
    required int loanId,
    int? odometerKm,
    @Default(80) int fuelBatteryLevelPercent,
    @Default(4) int cleanlinessRating,
    @Default({}) Map<String, bool> checklist,
    String? existingDamagesNotes,
    @Default({}) Map<String, DraftPhotoEntry> photos,
    DateTime? updatedAt,
  }) = _DepartureDraft;

  const DepartureDraft._();

  factory DepartureDraft.fromJson(Map<String, dynamic> json) =>
      _$DepartureDraftFromJson(json);

  /// Check if the draft is complete and ready for final submission
  bool isReadyForSubmission({
    required bool requiresMileage,
    bool isMotorized = true,
  }) {
    if (requiresMileage) {
      if (odometerKm == null || odometerKm! < 0) return false;
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

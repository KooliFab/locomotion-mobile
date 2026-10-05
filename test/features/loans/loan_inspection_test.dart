import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/loans/domain/entities/departure_draft.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_inspection.dart';

void main() {
  group('LoanInspection & DepartureDraft Domain Tests', () {
    test('LoanInspection deserialization matches backend format', () {
      final json = {
        'loan_id': 42,
        'inspection_type': 'departure',
        'odometer_km': 125000,
        'fuel_battery_level_percent': 85,
        'cleanliness_rating': 4,
        'checklist': {'key_present': true},
        'photos': {'front': '/api/v1/images/501'},
        'existing_damages_notes': 'Petite rayure pare-choc',
        'sealed_hash': 'abcdef1234567890',
        'created_at': '2026-10-03T11:00:00.000Z',
        'loan_status': 'ongoing',
      };

      final inspection = LoanInspection.fromJson(json);

      expect(inspection.loanId, 42);
      expect(inspection.inspectionType, 'departure');
      expect(inspection.odometerKm, 125000);
      expect(inspection.fuelBatteryLevelPercent, 85);
      expect(inspection.cleanlinessRating, 4);
      expect(inspection.checklist['key_present'], true);
      expect(inspection.photos['front'], '/api/v1/images/501');
      expect(inspection.sealedHash, 'abcdef1234567890');
      expect(inspection.loanStatus, 'ongoing');
    });

    test('DepartureDraft isReadyForSubmission for motorized car', () {
      var draft = const DepartureDraft(userId: 1, loanId: 42, odometerKm: null);

      // Incomplete without odometer
      expect(draft.isReadyForSubmission(requiresMileage: true), false);

      // Odometer present but no photos uploaded
      draft = draft.copyWith(odometerKm: 125000);
      expect(draft.isReadyForSubmission(requiresMileage: true), false);

      // 4 photos uploaded, missing dashboard_odometer
      draft = draft.copyWith(
        photos: {
          'front': const DraftPhotoEntry(
            field: 'front',
            status: DraftPhotoStatus.uploaded,
            imageId: 101,
          ),
          'back': const DraftPhotoEntry(
            field: 'back',
            status: DraftPhotoStatus.uploaded,
            imageId: 102,
          ),
          'left_side': const DraftPhotoEntry(
            field: 'left_side',
            status: DraftPhotoStatus.uploaded,
            imageId: 103,
          ),
          'right_side': const DraftPhotoEntry(
            field: 'right_side',
            status: DraftPhotoStatus.uploaded,
            imageId: 104,
          ),
        },
      );
      expect(draft.isReadyForSubmission(requiresMileage: true), false);

      // All 5 photos uploaded
      final completePhotos = Map<String, DraftPhotoEntry>.from(draft.photos);
      completePhotos['dashboard_odometer'] = const DraftPhotoEntry(
        field: 'dashboard_odometer',
        status: DraftPhotoStatus.uploaded,
        imageId: 105,
      );
      draft = draft.copyWith(photos: completePhotos);

      expect(draft.isReadyForSubmission(requiresMileage: true), true);
    });

    test('DepartureDraft isReadyForSubmission for non-motorized bike', () {
      var draft = const DepartureDraft(
        userId: 1,
        loanId: 88,
        odometerKm: null, // Bike does not require odometer
      );

      // No photos -> not ready
      expect(
        draft.isReadyForSubmission(requiresMileage: false, isMotorized: false),
        false,
      );

      // Front photo uploaded -> ready
      draft = draft.copyWith(
        photos: {
          'front': const DraftPhotoEntry(
            field: 'front',
            status: DraftPhotoStatus.uploaded,
            imageId: 201,
          ),
        },
      );
      expect(
        draft.isReadyForSubmission(requiresMileage: false, isMotorized: false),
        true,
      );
    });

    test('Loan.canTakeOver logic', () {
      final now = DateTime.now();
      var loan = Loan(
        id: 42,
        departureAt: now.add(const Duration(minutes: 30)),
        durationInMinutes: 120,
        loanableId: 1,
        status: 'confirmed',
        borrowerUserId: 10,
        departureInspectionCompleted: false,
      );

      // Borrower can take over
      expect(loan.canTakeOver(10), true);

      // Stranger cannot take over
      expect(loan.canTakeOver(999), false);

      // If already completed, cannot take over again
      loan = loan.copyWith(departureInspectionCompleted: true);
      expect(loan.canTakeOver(10), false);

      // If status is requested (not yet confirmed/prepaid), cannot take over
      loan = loan.copyWith(
        status: 'requested',
        departureInspectionCompleted: false,
      );
      expect(loan.canTakeOver(10), false);
    });
  });
}

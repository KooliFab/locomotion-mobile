import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/loans/domain/entities/departure_draft.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_comment.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_dates_update_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_inspection.dart';
import 'package:mobile/features/loans/domain/entities/loan_pagination.dart';
import 'package:mobile/features/loans/domain/entities/loans_dashboard.dart';
import 'package:mobile/features/loans/domain/repositories/departure_draft_repository.dart';
import 'package:mobile/features/loans/domain/repositories/loan_inspection_repository.dart';
import 'package:mobile/features/loans/domain/repositories/loans_repository.dart';
import 'package:mobile/features/loans/presentation/controllers/loan_departure_controller.dart';
import 'package:mobile/features/loans/presentation/controllers/loan_inspection_providers.dart';
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';

class FakeDepartureDraftRepository implements DepartureDraftRepository {
  final Map<String, DepartureDraft> _drafts = {};
  bool clearDraftCalled = false;

  @override
  Future<void> saveDraft(DepartureDraft draft) async {
    _drafts['${draft.userId}_${draft.loanId}'] = draft;
  }

  @override
  Future<DepartureDraft?> getDraft({required int userId, required int loanId}) async {
    return _drafts['${userId}_$loanId'];
  }

  @override
  Future<void> clearDraft({required int userId, required int loanId}) async {
    clearDraftCalled = true;
    _drafts.remove('${userId}_$loanId');
  }
}

class FakeLoanInspectionRepository implements LoanInspectionRepository {
  bool uploadShouldFail = false;
  bool submitShouldFail = false;
  int uploadedPhotoId = 888;
  Map<String, dynamic>? lastSubmittedPayload;
  String? lastSubmittedIdempotencyKey;

  @override
  Future<int> uploadInspectionPhoto({required File file, required String field}) async {
    if (uploadShouldFail) {
      throw Exception('Photo upload failed: Network Error');
    }
    return uploadedPhotoId;
  }

  @override
  Future<LoanInspection> submitDepartureInspection({
    required int loanId,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  }) async {
    if (submitShouldFail) {
      throw Exception('Inspection conflict: already completed');
    }
    lastSubmittedPayload = payload;
    lastSubmittedIdempotencyKey = idempotencyKey;

    return LoanInspection(
      loanId: loanId,
      inspectionType: 'departure',
      odometerKm: payload['odometer_km'] as int?,
      fuelBatteryLevelPercent: payload['fuel_battery_level_percent'] as int?,
      cleanlinessRating: payload['cleanliness_rating'] as int?,
      checklist: payload['checklist'] is Map<String, dynamic>
          ? payload['checklist'] as Map<String, dynamic>
          : {},
      photos: {},
      existingDamagesNotes: payload['existing_damages_notes'] as String?,
      sealedHash: 'sealed_hash_abc_123',
    );
  }

  @override
  Future<LoanInspection?> getDepartureInspection(int loanId) async => null;

  @override
  Future<LoanInspection> submitReturnInspection({
    required int loanId,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<LoanInspection?> getReturnInspection(int loanId) async => null;

  @override
  Future<Map<String, dynamic>> settleLoan({
    required int loanId,
    bool releaseDeposit = true,
    int incidentClaimCents = 0,
  }) async {
    throw UnimplementedError();
  }
}

class FakeLoansRepository implements LoansRepository {
  int? lastRefreshedLoanId;
  bool returnCompletedInspection = true;
  String returnStatus = 'ongoing';

  @override
  Future<Loan> getLoanDetail(int id) async {
    lastRefreshedLoanId = id;
    return Loan(
      id: id,
      departureAt: DateTime.now(),
      durationInMinutes: 60,
      status: returnStatus,
      departureInspectionCompleted: returnCompletedInspection,
    );
  }

  @override
  Future<Loan> acceptLoan(int id, {String? comment}) {
    throw UnimplementedError();
  }

  @override
  Future<Loan> cancelLoan(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Loan> validateLoan(int id) {
    throw UnimplementedError();
  }

  @override
  Future<LoanComment> addComment(int id, String text) {
    throw UnimplementedError();
  }

  @override
  Future<Loan> createLoan(LoanCreationRequest request) {
    throw UnimplementedError();
  }

  @override
  Future<LoansDashboard> getDashboard() {
    throw UnimplementedError();
  }

  @override
  Future<List<Loan>> getMyLoans() {
    throw UnimplementedError();
  }

  @override
  Future<LoanPagination> getLoansPage({
    int page = 1,
    int perPage = 10,
    String? status,
    int? borrowerUserId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Loan> rejectLoan(int id, {String? comment}) {
    throw UnimplementedError();
  }

  @override
  Future<Loan> updateLoanDates(int id, LoanDatesUpdateRequest request) {
    throw UnimplementedError();
  }
}

void main() {
  group('LoanDepartureController', () {
    late ProviderContainer container;
    late FakeDepartureDraftRepository fakeDraftRepo;
    late FakeLoanInspectionRepository fakeInspectionRepo;
    late FakeLoansRepository fakeLoansRepo;

    setUp(() {
      fakeDraftRepo = FakeDepartureDraftRepository();
      fakeInspectionRepo = FakeLoanInspectionRepository();
      fakeLoansRepo = FakeLoansRepository();

      container = ProviderContainer(
        overrides: [
          departureDraftRepositoryProvider.overrideWithValue(fakeDraftRepo),
          loanInspectionRepositoryProvider.overrideWithValue(fakeInspectionRepo),
          loansRepositoryProvider.overrideWithValue(fakeLoansRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initializes default draft with checklist for motorized vehicle', () async {
      final controller = container.read(loanDepartureControllerProvider(42).notifier);

      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: true,
        initialOdometer: 110000,
      );

      final state = container.read(loanDepartureControllerProvider(42));
      expect(state.isLoading, isFalse);
      expect(state.draft.loanId, 42);
      expect(state.draft.userId, 1);
      expect(state.draft.odometerKm, 110000);
      expect(state.draft.checklist.containsKey('key_present'), isTrue);
      expect(state.draft.checklist.containsKey('insurance_paper_present'), isTrue);
      expect(state.canSubmit, isFalse); // Photos not yet added
    });

    test('initializes from existing persisted draft', () async {
      await fakeDraftRepo.saveDraft(
        const DepartureDraft(
          userId: 1,
          loanId: 42,
          odometerKm: 125000,
          cleanlinessRating: 5,
        ),
      );

      final controller = container.read(loanDepartureControllerProvider(42).notifier);
      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: true,
      );

      final state = container.read(loanDepartureControllerProvider(42));
      expect(state.draft.odometerKm, 125000);
      expect(state.draft.cleanlinessRating, 5);
    });

    test('recovers interrupted uploading photos on initialization into recoverable error state', () async {
      // Draft had a photo uploading when app closed
      await fakeDraftRepo.saveDraft(
        const DepartureDraft(
          userId: 1,
          loanId: 42,
          photos: {
            'front': DraftPhotoEntry(
              field: 'front',
              localPath: '/tmp/front.jpg',
              status: DraftPhotoStatus.uploading,
            ),
          },
        ),
      );

      final controller = container.read(loanDepartureControllerProvider(42).notifier);
      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: false,
      );

      final state = container.read(loanDepartureControllerProvider(42));
      expect(state.draft.photos['front']?.status, DraftPhotoStatus.error);
      expect(state.draft.photos['front']?.errorMessage, contains('interrompu'));
      expect(state.errorMessage, contains('interrompu'));
      expect(state.canSubmit, isFalse);
    });

    test('updating fields modifies draft and updates canSubmit', () async {
      final controller = container.read(loanDepartureControllerProvider(42).notifier);
      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: false, // Bike only requires front photo
      );

      controller.updateCleanliness(3, false);
      controller.updateFuelBattery(90, false);
      controller.toggleChecklistItem('equipment_present', true, false);
      controller.updateExistingDamages('Selle légèrement usée', false);

      var state = container.read(loanDepartureControllerProvider(42));
      expect(state.draft.cleanlinessRating, 3);
      expect(state.draft.fuelBatteryLevelPercent, 90);
      expect(state.draft.checklist['equipment_present'], isTrue);
      expect(state.draft.existingDamagesNotes, 'Selle légèrement usée');
    });

    test('photo upload success lifecycle', () async {
      final controller = container.read(loanDepartureControllerProvider(42).notifier);
      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: false,
      );

      final tempDir = Directory.systemTemp.createTempSync();
      final tempFile = File('${tempDir.path}/test_bike.jpg')..writeAsStringSync('fake');

      fakeInspectionRepo.uploadedPhotoId = 777;
      await controller.attachAndUploadPhoto(
        field: 'front',
        file: tempFile,
        requiresMileage: false,
      );

      final state = container.read(loanDepartureControllerProvider(42));
      expect(state.draft.photos['front']?.status, DraftPhotoStatus.uploaded);
      expect(state.draft.photos['front']?.imageId, 777);
      expect(state.canSubmit, isTrue); // Non-motorized vehicle with front photo is ready!

      tempDir.deleteSync(recursive: true);
    });

    test('photo upload failure marks status as error and allows retry', () async {
      final controller = container.read(loanDepartureControllerProvider(42).notifier);
      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: false,
      );

      final tempDir = Directory.systemTemp.createTempSync();
      final tempFile = File('${tempDir.path}/test_err.jpg')..writeAsStringSync('fake');

      fakeInspectionRepo.uploadShouldFail = true;
      await controller.attachAndUploadPhoto(
        field: 'front',
        file: tempFile,
        requiresMileage: false,
      );

      var state = container.read(loanDepartureControllerProvider(42));
      expect(state.draft.photos['front']?.status, DraftPhotoStatus.error);
      expect(state.canSubmit, isFalse);

      // Now retry with failure resolved
      fakeInspectionRepo.uploadShouldFail = false;
      fakeInspectionRepo.uploadedPhotoId = 778;
      await controller.retryUpload(
        field: 'front',
        requiresMileage: false,
      );

      state = container.read(loanDepartureControllerProvider(42));
      expect(state.draft.photos['front']?.status, DraftPhotoStatus.uploaded);
      expect(state.draft.photos['front']?.imageId, 778);

      // Removing photo
      controller.removePhoto('front', false);
      state = container.read(loanDepartureControllerProvider(42));
      expect(state.draft.photos.containsKey('front'), isFalse);

      tempDir.deleteSync(recursive: true);
    });

    test('submitDeparture succeeds, clears draft, and updates loan', () async {
      final controller = container.read(loanDepartureControllerProvider(42).notifier);
      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: false,
      );

      final tempDir = Directory.systemTemp.createTempSync();
      final tempFile = File('${tempDir.path}/front.jpg')..writeAsStringSync('fake');
      await controller.attachAndUploadPhoto(field: 'front', file: tempFile, requiresMileage: false);

      await controller.submitDeparture(
        loanId: 42,
        requiresMileage: false,
      );

      final state = container.read(loanDepartureControllerProvider(42));
      expect(state.isSubmitting, isFalse);
      expect(state.errorMessage, isNull);
      expect(state.submissionSuccess, isNotNull);
      expect(state.submissionSuccess!.sealedHash, 'sealed_hash_abc_123');
      expect(fakeDraftRepo.clearDraftCalled, isTrue);

      tempDir.deleteSync(recursive: true);
    });

    test('submitDeparture fails if draft is incomplete', () async {
      final controller = container.read(loanDepartureControllerProvider(42).notifier);
      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: true, // Motorized requires 5 photos and odometer
      );

      await controller.submitDeparture(
        loanId: 42,
        requiresMileage: true,
      );

      final state = container.read(loanDepartureControllerProvider(42));
      expect(state.errorMessage, contains('obligatoires'));
      expect(state.submissionSuccess, isNull);
    });

    test('submitDeparture recovers when server status has departureInspectionCompleted == true', () async {
      final controller = container.read(loanDepartureControllerProvider(42).notifier);
      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: false,
      );

      final tempDir = Directory.systemTemp.createTempSync();
      final tempFile = File('${tempDir.path}/front.jpg')..writeAsStringSync('fake');
      await controller.attachAndUploadPhoto(field: 'front', file: tempFile, requiresMileage: false);

      fakeInspectionRepo.submitShouldFail = true;
      fakeLoansRepo.returnCompletedInspection = true;
      fakeLoansRepo.returnStatus = 'ongoing';

      await controller.submitDeparture(
        loanId: 42,
        requiresMileage: false,
      );

      final state = container.read(loanDepartureControllerProvider(42));
      expect(state.isSubmitting, isFalse);
      expect(state.submissionSuccess, isNotNull);
      expect(fakeDraftRepo.clearDraftCalled, isTrue);
      expect(fakeLoansRepo.lastRefreshedLoanId, 42);

      tempDir.deleteSync(recursive: true);
    });

    test('submitDeparture preserves draft and does not report success when server inspection is not completed', () async {
      final controller = container.read(loanDepartureControllerProvider(42).notifier);
      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: false,
      );

      final tempDir = Directory.systemTemp.createTempSync();
      final tempFile = File('${tempDir.path}/front.jpg')..writeAsStringSync('fake');
      await controller.attachAndUploadPhoto(field: 'front', file: tempFile, requiresMileage: false);

      fakeInspectionRepo.submitShouldFail = true;
      fakeDraftRepo.clearDraftCalled = false;
      fakeLoansRepo.returnCompletedInspection = false; // Ongoing but inspection not completed!
      fakeLoansRepo.returnStatus = 'ongoing';

      await controller.submitDeparture(
        loanId: 42,
        requiresMileage: false,
      );

      final state = container.read(loanDepartureControllerProvider(42));
      expect(state.isSubmitting, isFalse);
      expect(state.submissionSuccess, isNull);
      expect(fakeDraftRepo.clearDraftCalled, isFalse); // DRAFT PRESERVED
      expect(state.errorMessage, contains("L'état des lieux n'a pas été enregistré"));

      tempDir.deleteSync(recursive: true);
    });

    test('controller instances are isolated per loanId and obsolete photo uploads do not bleed', () async {
      final controller42 = container.read(loanDepartureControllerProvider(42).notifier);
      final controller43 = container.read(loanDepartureControllerProvider(43).notifier);

      await controller42.initialize(userId: 1, loanId: 42, requiresMileage: false);
      await controller43.initialize(userId: 1, loanId: 43, requiresMileage: false);

      final state42Initial = container.read(loanDepartureControllerProvider(42));
      final state43Initial = container.read(loanDepartureControllerProvider(43));
      expect(state42Initial.draft.loanId, 42);
      expect(state43Initial.draft.loanId, 43);

      final tempDir = Directory.systemTemp.createTempSync();
      final tempFile = File('${tempDir.path}/front42.jpg')..writeAsStringSync('photo for loan 42');

      await controller42.attachAndUploadPhoto(
        field: 'front',
        file: tempFile,
        requiresMileage: false,
      );

      final state42After = container.read(loanDepartureControllerProvider(42));
      final state43After = container.read(loanDepartureControllerProvider(43));

      // Loan 42 has photo 'front' uploaded with imageId
      expect(state42After.draft.photos['front']?.status, DraftPhotoStatus.uploaded);
      expect(state42After.draft.photos['front']?.imageId, 888);
      // Loan 43 photo 'front' was not modified and has no imageId
      expect(state43After.draft.photos['front']?.status, DraftPhotoStatus.notTaken);
      expect(state43After.draft.photos['front']?.imageId, isNull);

      tempDir.deleteSync(recursive: true);
    });
  });
}

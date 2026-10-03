import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/loans/domain/entities/departure_draft.dart';
import 'package:mobile/features/loans/domain/entities/extension_estimate.dart';
import 'package:mobile/features/loans/domain/entities/loan.dart';
import 'package:mobile/features/loans/domain/entities/loan_comment.dart';
import 'package:mobile/features/loans/domain/entities/loan_creation_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_dates_update_request.dart';
import 'package:mobile/features/loans/domain/entities/loan_inspection.dart';
import 'package:mobile/features/loans/domain/entities/loan_pagination.dart';
import 'package:mobile/features/loans/domain/entities/loans_dashboard.dart';
import 'package:mobile/features/loans/domain/entities/return_draft.dart';
import 'package:mobile/features/loans/domain/repositories/loan_inspection_repository.dart';
import 'package:mobile/features/loans/domain/repositories/loans_repository.dart';
import 'package:mobile/features/loans/domain/repositories/return_draft_repository.dart';
import 'package:mobile/features/loans/presentation/controllers/loan_inspection_providers.dart';
import 'package:mobile/features/loans/presentation/controllers/loan_return_controller.dart';
import 'package:mobile/features/loans/presentation/controllers/loans_controller.dart';

class FakeReturnDraftRepository implements ReturnDraftRepository {
  final Map<String, ReturnDraft> _drafts = {};
  bool clearDraftCalled = false;

  @override
  Future<ReturnDraft?> getDraft({required int userId, required int loanId}) async {
    return _drafts['${userId}_$loanId'];
  }

  @override
  Future<void> saveDraft(ReturnDraft draft) async {
    _drafts['${draft.userId}_${draft.loanId}'] = draft;
  }

  @override
  Future<void> clearDraft({required int userId, required int loanId}) async {
    clearDraftCalled = true;
    _drafts.remove('${userId}_$loanId');
  }
}

class FakeReturnInspectionRepository implements LoanInspectionRepository {
  bool uploadShouldFail = false;
  bool submitShouldFail = false;
  int uploadedPhotoId = 777;
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
    throw UnimplementedError();
  }

  @override
  Future<LoanInspection?> getDepartureInspection(int loanId) async => null;

  @override
  Future<LoanInspection> submitReturnInspection({
    required int loanId,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  }) async {
    if (submitShouldFail) {
      throw Exception('Return inspection conflict: already recorded');
    }
    lastSubmittedPayload = payload;
    lastSubmittedIdempotencyKey = idempotencyKey;

    return LoanInspection(
      loanId: loanId,
      inspectionType: 'return',
      odometerKm: payload['odometer_km'] as int?,
      fuelBatteryLevelPercent: payload['fuel_battery_level_percent'] as int?,
      cleanlinessRating: payload['cleanliness_rating'] as int?,
      checklist: payload['checklist'] is Map<String, dynamic>
          ? payload['checklist'] as Map<String, dynamic>
          : {},
      photos: {},
      existingDamagesNotes: payload['new_damages_notes'] as String?,
      sealedHash: 'sealed_return_hash_xyz_789',
    );
  }

  @override
  Future<LoanInspection?> getReturnInspection(int loanId) async => null;

  @override
  Future<Map<String, dynamic>> settleLoan({
    required int loanId,
    bool releaseDeposit = true,
    int incidentClaimCents = 0,
  }) async {
    return {'status': 'completed'};
  }
}

class FakeReturnLoansRepository implements LoansRepository {
  int? lastRefreshedLoanId;
  bool returnCompletedInspection = true;
  String returnStatus = 'ended';

  @override
  Future<Loan> getLoanDetail(int id) async {
    lastRefreshedLoanId = id;
    return Loan(
      id: id,
      departureAt: DateTime.now(),
      durationInMinutes: 60,
      status: returnStatus,
      returnInspectionCompleted: returnCompletedInspection,
    );
  }

  @override
  Future<Loan> acceptLoan(int id, {String? comment}) => throw UnimplementedError();
  @override
  Future<Loan> cancelLoan(int id) => throw UnimplementedError();
  @override
  Future<Loan> validateLoan(int id) => throw UnimplementedError();
  @override
  Future<LoanComment> addComment(int id, String text) => throw UnimplementedError();
  @override
  Future<Loan> createLoan(LoanCreationRequest request) => throw UnimplementedError();
  @override
  Future<LoansDashboard> getDashboard() => throw UnimplementedError();
  @override
  Future<List<Loan>> getMyLoans() => throw UnimplementedError();
  @override
  Future<LoanPagination> getLoansPage({
    int page = 1,
    int perPage = 10,
    String? status,
    int? borrowerUserId,
  }) => throw UnimplementedError();
  @override
  Future<Loan> rejectLoan(int id, {String? comment}) => throw UnimplementedError();
  @override
  Future<Loan> updateLoanDates(int id, LoanDatesUpdateRequest request) => throw UnimplementedError();

  @override
  Future<Loan> requestExtension(int id, int extensionDurationInMinutes) => throw UnimplementedError();
  @override
  Future<Loan> acceptExtension(int id) => throw UnimplementedError();
  @override
  Future<Loan> rejectExtension(int id) => throw UnimplementedError();
  @override
  Future<Loan> cancelExtension(int id) => throw UnimplementedError();
  @override
  Future<ExtensionEstimate> getExtensionEstimate(int id, int durationInMinutes) => throw UnimplementedError();
}

void main() {
  late ProviderContainer container;
  late FakeReturnDraftRepository fakeDraftRepo;
  late FakeReturnInspectionRepository fakeInspectionRepo;
  late FakeReturnLoansRepository fakeLoansRepo;

  setUp(() {
    fakeDraftRepo = FakeReturnDraftRepository();
    fakeInspectionRepo = FakeReturnInspectionRepository();
    fakeLoansRepo = FakeReturnLoansRepository();

    container = ProviderContainer(
      overrides: [
        returnDraftRepositoryProvider.overrideWithValue(fakeDraftRepo),
        loanInspectionRepositoryProvider.overrideWithValue(fakeInspectionRepo),
        loansRepositoryProvider.overrideWithValue(fakeLoansRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('LoanReturnController Unit Tests', () {
    test('initializes default draft for motorized vehicle with 5 photo slots', () async {
      final controller =
          container.read(loanReturnControllerProvider(42).notifier);

      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: true,
        mileageStart: 120000,
        initialOdometer: 120000,
      );

      final state = container.read(loanReturnControllerProvider(42));
      expect(state.isLoading, isFalse);
      expect(state.draft.loanId, 42);
      expect(state.draft.userId, 1);
      expect(state.draft.odometerKm, 120000);
      expect(state.draft.fuelBatteryLevelPercent, 80);
      expect(state.draft.cleanlinessRating, 4);
      expect(state.draft.photos.containsKey('dashboard_odometer'), isTrue);
      expect(state.draft.photos.containsKey('front'), isTrue);
      expect(state.draft.photos.containsKey('back'), isTrue);
      expect(state.draft.photos.containsKey('left_side'), isTrue);
      expect(state.draft.photos.containsKey('right_side'), isTrue);
      expect(state.canSubmit, isFalse); // Photos not uploaded yet
    });

    test('initializes default draft for non-motorized vehicle without odometer requirement', () async {
      final controller =
          container.read(loanReturnControllerProvider(43).notifier);

      await controller.initialize(
        userId: 1,
        loanId: 43,
        requiresMileage: false,
      );

      final state = container.read(loanReturnControllerProvider(43));
      expect(state.isLoading, isFalse);
      expect(state.draft.photos.containsKey('dashboard_odometer'), isFalse);
      expect(state.draft.photos.containsKey('front'), isTrue);
      expect(state.draft.checklist.containsKey('lock_secured'), isTrue);
    });

    test('validates odometer: allows 0 km driven, but prevents negative mileage', () async {
      final controller =
          container.read(loanReturnControllerProvider(42).notifier);

      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: true,
        mileageStart: 1000,
      );

      // Attempt lower odometer
      controller.updateOdometer(999, true, 1000);
      var state = container.read(loanReturnControllerProvider(42));
      expect(state.errorMessage, contains('ne peut pas être inférieur'));
      expect(state.canSubmit, isFalse);

      // Same as start (0 km return arbitrage)
      controller.updateOdometer(1000, true, 1000);
      state = container.read(loanReturnControllerProvider(42));
      expect(state.errorMessage, isNull);
    });

    test('photo upload updates entry to uploaded and handles errors', () async {
      final tempDir = Directory.systemTemp.createTempSync('lot11_photo_test');
      final tempFile = File('${tempDir.path}/front.jpg');
      await tempFile.writeAsString('bytes');

      final controller =
          container.read(loanReturnControllerProvider(42).notifier);

      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: true,
        mileageStart: 500,
      );

      // Success upload
      await controller.attachAndUploadPhoto(
        field: 'front',
        file: tempFile,
        requiresMileage: true,
        mileageStart: 500,
      );

      var state = container.read(loanReturnControllerProvider(42));
      expect(state.draft.photos['front']?.status, DraftPhotoStatus.uploaded);
      expect(state.draft.photos['front']?.imageId, 777);

      // Fail upload
      fakeInspectionRepo.uploadShouldFail = true;
      await controller.attachAndUploadPhoto(
        field: 'back',
        file: tempFile,
        requiresMileage: true,
        mileageStart: 500,
      );

      state = container.read(loanReturnControllerProvider(42));
      expect(state.draft.photos['back']?.status, DraftPhotoStatus.error);
      expect(state.errorMessage, contains('Erreur lors du téléversement'));

      tempDir.deleteSync(recursive: true);
    });

    test('signature upload attaches return_signature photo', () async {
      final tempDir = Directory.systemTemp.createTempSync('lot11_sig_test');
      final tempFile = File('${tempDir.path}/signature.png');
      await tempFile.writeAsString('signature');

      final controller =
          container.read(loanReturnControllerProvider(42).notifier);

      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: true,
        mileageStart: 500,
      );

      await controller.attachAndUploadSignature(
        file: tempFile,
        requiresMileage: true,
        mileageStart: 500,
      );

      final state = container.read(loanReturnControllerProvider(42));
      expect(state.draft.signaturePhoto?.status, DraftPhotoStatus.uploaded);
      expect(state.draft.signaturePhoto?.imageId, 777);

      tempDir.deleteSync(recursive: true);
    });

    test('submitReturn posts inspection, clears local draft, and produces sealed hash', () async {
      final controller =
          container.read(loanReturnControllerProvider(42).notifier);

      // Prepopulate valid draft with all 5 uploaded photos
      const validDraft = ReturnDraft(
        userId: 1,
        loanId: 42,
        odometerKm: 550,
        fuelBatteryLevelPercent: 90,
        cleanlinessRating: 5,
        checklist: {'key_returned': true},
        photos: {
          'dashboard_odometer': DraftPhotoEntry(
            field: 'dashboard_odometer',
            status: DraftPhotoStatus.uploaded,
            imageId: 1,
          ),
          'front': DraftPhotoEntry(
            field: 'front',
            status: DraftPhotoStatus.uploaded,
            imageId: 2,
          ),
          'back': DraftPhotoEntry(
            field: 'back',
            status: DraftPhotoStatus.uploaded,
            imageId: 3,
          ),
          'left_side': DraftPhotoEntry(
            field: 'left_side',
            status: DraftPhotoStatus.uploaded,
            imageId: 4,
          ),
          'right_side': DraftPhotoEntry(
            field: 'right_side',
            status: DraftPhotoStatus.uploaded,
            imageId: 5,
          ),
        },
      );
      await fakeDraftRepo.saveDraft(validDraft);

      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: true,
        mileageStart: 500,
      );

      var state = container.read(loanReturnControllerProvider(42));
      expect(state.canSubmit, isTrue);

      await controller.submitReturn(
        loanId: 42,
        requiresMileage: true,
        mileageStart: 500,
      );

      state = container.read(loanReturnControllerProvider(42));
      expect(state.isSubmitting, isFalse);
      expect(state.submissionSuccess, isNotNull);
      expect(state.submissionSuccess!.sealedHash, 'sealed_return_hash_xyz_789');
      expect(fakeDraftRepo.clearDraftCalled, isTrue);
      expect(fakeInspectionRepo.lastSubmittedPayload?['odometer_km'], 550);
    });

    test('checkServerStatus recovers inspection when server has recorded returnInspectionCompleted', () async {
      final controller =
          container.read(loanReturnControllerProvider(42).notifier);

      await controller.initialize(
        userId: 1,
        loanId: 42,
        requiresMileage: true,
        mileageStart: 500,
      );

      fakeLoansRepo.returnCompletedInspection = true;
      await controller.checkServerStatus(42);

      final state = container.read(loanReturnControllerProvider(42));
      expect(state.submissionSuccess, isNotNull);
      expect(state.submissionSuccess!.inspectionType, 'return');
      expect(fakeDraftRepo.clearDraftCalled, isTrue);
    });
  });
}

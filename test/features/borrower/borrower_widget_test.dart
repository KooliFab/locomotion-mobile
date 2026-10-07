import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/error/exceptions.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/borrower/domain/entities/borrower.dart';
import 'package:mobile/features/borrower/domain/entities/borrower_submission_request.dart';
import 'package:mobile/features/borrower/domain/entities/uploaded_file_ref.dart';
import 'package:mobile/features/borrower/domain/repositories/borrower_repository.dart';
import 'package:mobile/features/borrower/presentation/controllers/borrower_controller.dart';
import 'package:mobile/features/borrower/presentation/screens/borrower_form_screen.dart';
import 'package:mobile/features/borrower/presentation/screens/borrower_screen.dart';
import 'package:mobile/features/profile/presentation/controllers/profile_controller.dart';
import 'package:mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

base class FakePlatformFile extends PlatformFile {
  FakePlatformFile({required this.name, required String path})
    : uri = Uri.file(path);

  @override
  final String name;

  @override
  final Uri uri;

  @override
  XFile get xFile => XFile(path ?? '');

  @override
  int? lengthSync() => 100;

  @override
  Future<int?> length() async => 100;

  @override
  Future<Uint8List> readAsBytes() async => Uint8List(0);

  @override
  Stream<Uint8List> readAsByteStream() => const Stream.empty();
}

/// Fake platform for FilePicker
class _FakeFilePickerPlatform extends FilePickerPlatform
    with MockPlatformInterfaceMixin {
  PlatformFile? fileToReturn;

  _FakeFilePickerPlatform({this.fileToReturn});

  @override
  Future<PlatformFile?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    return fileToReturn;
  }
}

/// Fake repository for borrower tests
class _FakeBorrowerRepository implements BorrowerRepository {
  final Exception? uploadError;
  final Exception? submitError;
  final Completer<UploadedFileRef>? uploadCompleter;
  final List<BorrowerSubmissionRequest> submittedRequests = [];

  _FakeBorrowerRepository({
    this.uploadError,
    this.submitError,
    this.uploadCompleter,
  });

  @override
  Future<UploadedFileRef> uploadFile({
    required String field,
    required File file,
  }) async {
    if (uploadCompleter != null) {
      return uploadCompleter!.future;
    }
    if (uploadError != null) throw uploadError!;
    return UploadedFileRef(
      id: field == 'gaa' ? 101 : 102,
      field: field,
      originalFilename: '${field}_doc.pdf',
    );
  }

  @override
  Future<Borrower> submitBorrower(BorrowerSubmissionRequest request) async {
    if (submitError != null) throw submitError!;
    submittedRequests.add(request);
    return Borrower(
      userId: request.userId,
      approved: false,
      suspended: false,
      validated: false,
      submittedAt: DateTime.now(),
    );
  }
}

/// Fake AuthController providing specific User state
class _FakeAuthController extends AuthController {
  final User? _user;
  _FakeAuthController(this._user);

  @override
  FutureOr<User?> build() => _user;
}

/// Fake UserBalanceController providing constant 0.0
class _FakeUserBalanceController extends UserBalanceController {
  @override
  FutureOr<double> build() => 0.0;
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  const testUser = User(
    id: 42,
    email: 'test@example.com',
    firstName: 'Jean',
    lastName: 'Tremblay',
  );

  Widget createWidgetUnderTest({
    required Widget child,
    User? user,
    BorrowerRepository? borrowerRepo,
  }) {
    return ProviderScope(
      overrides: [
        authControllerProvider.overrideWith(
          () => _FakeAuthController(user ?? testUser),
        ),
        userBalanceControllerProvider.overrideWith(
          () => _FakeUserBalanceController(),
        ),
        if (borrowerRepo != null)
          borrowerRepositoryProvider.overrideWithValue(borrowerRepo),
      ],
      child: MaterialApp(home: child),
    );
  }

  group('ProfileScreen Borrower Badge & Navigation', () {
    testWidgets('shows "À compléter" when borrower dossier is missing', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          child: const ProfileScreen(),
          user: testUser.copyWith(borrower: null),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('À compléter'), findsNWidgets(2)); // badge + subtitle
      expect(find.text('Dossier conducteur & Permis'), findsOneWidget);
    });

    testWidgets('shows "Validé" when borrower is validated', (tester) async {
      final validatedUser = testUser.copyWith(
        borrower: Borrower(
          userId: 42,
          approved: true,
          suspended: false,
          validated: true,
          submittedAt: DateTime(2026, 9, 20),
        ),
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          child: const ProfileScreen(),
          user: validatedUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Validé'), findsNWidgets(2));
    });
  });

  group('BorrowerScreen Status Display', () {
    testWidgets('displays "À compléter" and action button', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(
          child: const BorrowerScreen(),
          user: testUser.copyWith(borrower: null),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('À compléter'), findsOneWidget);
      expect(find.text('Compléter mon dossier'), findsOneWidget);
    });

    testWidgets('displays "En cours de validation" when pending', (
      tester,
    ) async {
      final pendingUser = testUser.copyWith(
        borrower: Borrower(
          userId: 42,
          approved: false,
          suspended: false,
          validated: false,
          submittedAt: DateTime(2026, 9, 20),
        ),
      );

      await tester.pumpWidget(
        createWidgetUnderTest(child: const BorrowerScreen(), user: pendingUser),
      );
      await tester.pumpAndSettle();

      expect(find.text('En cours de validation'), findsOneWidget);
      expect(find.text('Consulter les informations envoyées'), findsOneWidget);
    });

    testWidgets('displays "Validé" when validated', (tester) async {
      final validatedUser = testUser.copyWith(
        borrower: Borrower(
          userId: 42,
          approved: true,
          suspended: false,
          validated: true,
          submittedAt: DateTime(2026, 9, 20),
        ),
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          child: const BorrowerScreen(),
          user: validatedUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Validé'), findsOneWidget);
      expect(
        find.text(
          'Votre dossier est validé. Vous pouvez réserver des véhicules motorisés.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('displays "Suspendu" and support message when suspended', (
      tester,
    ) async {
      final suspendedUser = testUser.copyWith(
        borrower: Borrower(
          userId: 42,
          approved: false,
          suspended: true,
          validated: false,
          submittedAt: DateTime(2026, 9, 20),
        ),
      );

      await tester.pumpWidget(
        createWidgetUnderTest(
          child: const BorrowerScreen(),
          user: suspendedUser,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Suspendu'), findsOneWidget);
      expect(
        find.text(
          'Votre dossier est suspendu. Contactez le support pour plus d\'informations.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Contactez le support LocoMotion'),
        findsOneWidget,
      );
    });
  });

  group('BorrowerFormScreen Form & Upload Flow', () {
    late Directory tempDir;
    late File dummyFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('borrower_test');
      dummyFile = File('${tempDir.path}/permis.pdf');
      await dummyFile.writeAsString('test content');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    testWidgets(
      'submit button is disabled initially and enabled only when all required fields and uploads are complete',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final fakePicker = _FakeFilePickerPlatform(
          fileToReturn: FakePlatformFile(
            name: 'permis.pdf',
            path: dummyFile.path,
          ),
        );
        FilePickerPlatform.instance = fakePicker;

        final fakeRepo = _FakeBorrowerRepository();

        await tester.pumpWidget(
          createWidgetUnderTest(
            child: const BorrowerFormScreen(),
            borrowerRepo: fakeRepo,
          ),
        );
        await tester.pumpAndSettle();

        // Check initial elements
        expect(find.text('Compléter mon dossier'), findsOneWidget);
        expect(find.text('Numéro de permis de conduire'), findsOneWidget);
        expect(
          find.text(
            'J\'atteste ne pas avoir fait l\'objet de poursuites judiciaires au cours des dix dernières années.',
          ),
          findsOneWidget,
        );

        // Submit button exists and is disabled
        final submitButtonFinder = find.widgetWithText(
          ElevatedButton,
          'Soumettre le dossier',
        );
        expect(submitButtonFinder, findsOneWidget);
        var submitButton = tester.widget<ElevatedButton>(submitButtonFinder);
        expect(submitButton.onPressed, isNull);

        // Fill license number
        await tester.enterText(
          find.byType(TextFormField).first,
          'T1234-567890-12',
        );
        await tester.pumpAndSettle();

        // Toggle attestation checkbox
        await tester.tap(find.byType(CheckboxListTile));
        await tester.pumpAndSettle();

        // Still disabled because GAA and SAAQ files are not uploaded
        submitButton = tester.widget<ElevatedButton>(submitButtonFinder);
        expect(submitButton.onPressed, isNull);

        // Upload GAA file
        final gaaUploadButton = find.widgetWithText(
          OutlinedButton,
          'Ajouter un fichier GAA',
        );
        await tester.tap(gaaUploadButton);
        await tester.pumpAndSettle();

        // Still disabled because SAAQ is missing
        submitButton = tester.widget<ElevatedButton>(submitButtonFinder);
        expect(submitButton.onPressed, isNull);

        // Upload SAAQ file
        final saaqUploadButton = find.widgetWithText(
          OutlinedButton,
          'Ajouter un fichier SAAQ',
        );
        await tester.tap(saaqUploadButton);
        await tester.pumpAndSettle();

        // Now all required fields and files are complete -> Submit button is enabled!
        submitButton = tester.widget<ElevatedButton>(submitButtonFinder);
        expect(submitButton.onPressed, isNotNull);

        // Submit the form
        await tester.tap(submitButtonFinder);
        await tester.pumpAndSettle();

        // Verify request was sent to repository
        expect(fakeRepo.submittedRequests.length, 1);
        final sent = fakeRepo.submittedRequests.first;
        expect(sent.userId, 42);
        expect(sent.driversLicenseNumber, 'T1234-567890-12');
        expect(sent.hasNotBeenSuedLastTenYears, true);
        expect(sent.gaa.first.id, 101);
        expect(sent.saaq.first.id, 102);
      },
    );

    testWidgets(
      'validation error 422 displays error without losing form inputs',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final fakePicker = _FakeFilePickerPlatform(
          fileToReturn: FakePlatformFile(
            name: 'permis.pdf',
            path: dummyFile.path,
          ),
        );
        FilePickerPlatform.instance = fakePicker;

        final fakeRepo = _FakeBorrowerRepository(
          submitError: const ValidationException(
            message: 'Les documents fournis sont invalides.',
            errors: {
              'drivers_license_number': ['Numéro invalide'],
            },
          ),
        );

        await tester.pumpWidget(
          createWidgetUnderTest(
            child: const BorrowerFormScreen(),
            borrowerRepo: fakeRepo,
          ),
        );
        await tester.pumpAndSettle();

        // Fill form
        await tester.enterText(
          find.byType(TextFormField).first,
          'T1234-567890-12',
        );
        await tester.tap(find.byType(CheckboxListTile));
        await tester.pumpAndSettle();

        // Upload both files
        await tester.tap(
          find.widgetWithText(OutlinedButton, 'Ajouter un fichier GAA'),
        );
        await tester.pumpAndSettle();
        await tester.tap(
          find.widgetWithText(OutlinedButton, 'Ajouter un fichier SAAQ'),
        );
        await tester.pumpAndSettle();

        // Submit
        final submitButton = find.widgetWithText(
          ElevatedButton,
          'Soumettre le dossier',
        );
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // Verify error message is displayed
        expect(
          find.text('Les documents fournis sont invalides.'),
          findsOneWidget,
        );
        // Verify license input value was PRESERVED
        expect(find.text('T1234-567890-12'), findsOneWidget);
      },
    );

    testWidgets(
      'displays upload error and does not allow submission on file upload failure',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final fakePicker = _FakeFilePickerPlatform(
          fileToReturn: FakePlatformFile(
            name: 'permis.pdf',
            path: dummyFile.path,
          ),
        );
        FilePickerPlatform.instance = fakePicker;

        final fakeRepo = _FakeBorrowerRepository(
          uploadError: const NetworkException(message: 'Upload error network'),
        );

        await tester.pumpWidget(
          createWidgetUnderTest(
            child: const BorrowerFormScreen(),
            borrowerRepo: fakeRepo,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.widgetWithText(OutlinedButton, 'Ajouter un fichier GAA'),
        );
        await tester.pumpAndSettle();

        // Verify upload error message is displayed in file tile
        expect(find.text('Erreur réseau — réessayez.'), findsOneWidget);

        // Verify submit button is disabled
        final submitButton = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Soumettre le dossier'),
        );
        expect(submitButton.onPressed, isNull);
      },
    );

    testWidgets(
      'R24: navigating away while file upload is in flight completes gracefully without setState lifecycle errors',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final fakePicker = _FakeFilePickerPlatform(
          fileToReturn: FakePlatformFile(
            name: 'permis.pdf',
            path: dummyFile.path,
          ),
        );
        FilePickerPlatform.instance = fakePicker;

        final completer = Completer<UploadedFileRef>();
        final fakeRepo = _FakeBorrowerRepository(uploadCompleter: completer);

        await tester.pumpWidget(
          createWidgetUnderTest(
            child: const BorrowerFormScreen(),
            borrowerRepo: fakeRepo,
          ),
        );
        await tester.pumpAndSettle();

        // Start file pick and upload
        await tester.tap(
          find.widgetWithText(OutlinedButton, 'Ajouter un fichier GAA'),
        );
        await tester.pump(); // initiates _pickFile and starts _uploadFile

        // Verify file was added locally and is uploading
        expect(find.text('permis.pdf'), findsOneWidget);

        // User navigates away / unmounts the form screen before upload completes
        await tester.pumpWidget(
          createWidgetUnderTest(
            child: const Scaffold(body: Text('Different Screen')),
            borrowerRepo: fakeRepo,
          ),
        );
        await tester.pump();

        // Now future completes after the screen is unmounted
        completer.complete(
          const UploadedFileRef(
            id: 101,
            field: 'gaa',
            originalFilename: 'permis.pdf',
          ),
        );
        await tester.pumpAndSettle();

        // Verify no exception was thrown and we are on the new screen
        expect(find.text('Different Screen'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'R24: navigating away while file upload fails completes gracefully without setState lifecycle errors',
      (tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final fakePicker = _FakeFilePickerPlatform(
          fileToReturn: FakePlatformFile(
            name: 'permis.pdf',
            path: dummyFile.path,
          ),
        );
        FilePickerPlatform.instance = fakePicker;

        final completer = Completer<UploadedFileRef>();
        final fakeRepo = _FakeBorrowerRepository(uploadCompleter: completer);

        await tester.pumpWidget(
          createWidgetUnderTest(
            child: const BorrowerFormScreen(),
            borrowerRepo: fakeRepo,
          ),
        );
        await tester.pumpAndSettle();

        // Start file pick and upload
        await tester.tap(
          find.widgetWithText(OutlinedButton, 'Ajouter un fichier GAA'),
        );
        await tester.pump();

        // Unmount
        await tester.pumpWidget(
          createWidgetUnderTest(
            child: const Scaffold(body: Text('Different Screen')),
            borrowerRepo: fakeRepo,
          ),
        );
        await tester.pump();

        // Future completes with an error while unmounted
        completer.completeError(
          const NetworkException(message: 'Upload failed after unmount'),
        );
        await tester.pumpAndSettle();

        expect(find.text('Different Screen'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });
}

import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/network_providers.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/datasources/borrower_remote_data_source.dart';
import '../../data/repositories/borrower_repository_impl.dart';
import '../../domain/entities/borrower.dart';
import '../../domain/entities/borrower_submission_request.dart';
import '../../domain/entities/uploaded_file_ref.dart';
import '../../domain/repositories/borrower_repository.dart';

part 'borrower_controller.g.dart';

@Riverpod(keepAlive: true)
BorrowerRemoteDataSource borrowerRemoteDataSource(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BorrowerRemoteDataSourceImpl(apiClient);
}

@Riverpod(keepAlive: true)
BorrowerRepository borrowerRepository(Ref ref) {
  final remoteDataSource = ref.watch(borrowerRemoteDataSourceProvider);
  return BorrowerRepositoryImpl(remoteDataSource: remoteDataSource);
}

@Riverpod(keepAlive: true)
class BorrowerController extends _$BorrowerController {
  @override
  Borrower? build() {
    // Derive from authController — no separate network call needed.
    // AuthController already fetches FullUserResource which includes borrower.
    final authState = ref.watch(authControllerProvider);
    return authState.value?.borrower;
  }

  /// Upload a file (GAA or SAAQ) to POST /files.
  /// Returns the [UploadedFileRef] on success.
  /// Throws on network errors — do NOT mark upload successful if exception.
  Future<UploadedFileRef> uploadFile({
    required String field,
    required File file,
  }) async {
    final repo = ref.read(borrowerRepositoryProvider);
    return repo.uploadFile(field: field, file: file);
  }

  /// Submit the borrower dossier via PUT /users/{userId}/borrower/submit.
  /// On success, refreshes the full user so authController reflects new state.
  /// Throws on 401/403/422/network — do NOT mark submitted if exception.
  Future<void> submit(BorrowerSubmissionRequest request) async {
    final repo = ref.read(borrowerRepositoryProvider);
    // This will throw on any error — callers must handle exceptions.
    await repo.submitBorrower(request);
    // Refresh the full user to get updated borrower state from backend.
    ref.invalidate(authControllerProvider);
  }
}

import 'dart:io';
import '../entities/borrower.dart';
import '../entities/borrower_submission_request.dart';
import '../entities/uploaded_file_ref.dart';

abstract class BorrowerRepository {
  /// Upload a file to POST /files (multipart).
  /// [field] must be 'gaa' or 'saaq'. The file part key equals [field].
  Future<UploadedFileRef> uploadFile({
    required String field,
    required File file,
  });

  /// Submit the borrower dossier via PUT /users/{userId}/borrower/submit.
  /// Throws [UnauthorizedException] on 401, [ForbiddenException] on 403,
  /// [ValidationException] on 422, [NetworkException] on network errors.
  Future<Borrower> submitBorrower(BorrowerSubmissionRequest request);
}

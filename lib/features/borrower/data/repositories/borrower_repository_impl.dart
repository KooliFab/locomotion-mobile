import 'dart:io';
import '../../domain/entities/borrower.dart';
import '../../domain/entities/borrower_submission_request.dart';
import '../../domain/entities/uploaded_file_ref.dart';
import '../../domain/repositories/borrower_repository.dart';
import '../datasources/borrower_remote_data_source.dart';

class BorrowerRepositoryImpl implements BorrowerRepository {
  final BorrowerRemoteDataSource remoteDataSource;

  const BorrowerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UploadedFileRef> uploadFile({
    required String field,
    required File file,
  }) {
    return remoteDataSource.uploadFile(field: field, file: file);
  }

  @override
  Future<Borrower> submitBorrower(BorrowerSubmissionRequest request) {
    return remoteDataSource.submitBorrower(request);
  }
}

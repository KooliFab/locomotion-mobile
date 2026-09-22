import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/borrower.dart';
import '../../domain/entities/borrower_submission_request.dart';
import '../../domain/entities/uploaded_file_ref.dart';

abstract class BorrowerRemoteDataSource {
  Future<UploadedFileRef> uploadFile({
    required String field,
    required File file,
  });

  Future<Borrower> submitBorrower(BorrowerSubmissionRequest request);
}

class BorrowerRemoteDataSourceImpl implements BorrowerRemoteDataSource {
  final ApiClient _apiClient;

  const BorrowerRemoteDataSourceImpl(this._apiClient);

  @override
  Future<UploadedFileRef> uploadFile({
    required String field,
    required File file,
  }) async {
    // Per FileController: the 'field' text input and the file part key must
    // share the same value ('gaa' or 'saaq').
    final formData = FormData.fromMap({
      'field': field,
      field: await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    final response = await _apiClient.post(
      ApiEndpoints.files,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        headers: {'Accept': 'application/json'},
      ),
    );

    final responseData = response.data;
    if (responseData is! Map<String, dynamic>) {
      throw const ServerException(message: 'Réponse de téléversement invalide');
    }
    return UploadedFileRef.fromJson(responseData);
  }

  @override
  Future<Borrower> submitBorrower(BorrowerSubmissionRequest request) async {
    // Do NOT log the request payload as it contains driversLicenseNumber
    final response = await _apiClient.put(
      ApiEndpoints.borrowerSubmit(request.userId),
      data: request.toJson(),
    );

    final responseData = response.data;
    if (responseData is! Map<String, dynamic>) {
      throw const ServerException(
        message: 'Réponse de soumission du dossier invalide',
      );
    }
    return Borrower.fromJson(responseData);
  }
}

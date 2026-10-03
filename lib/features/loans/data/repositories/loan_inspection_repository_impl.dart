import 'dart:io';
import '../../domain/entities/loan_inspection.dart';
import '../../domain/repositories/loan_inspection_repository.dart';
import '../datasources/loan_inspection_remote_data_source.dart';

class LoanInspectionRepositoryImpl implements LoanInspectionRepository {
  final LoanInspectionRemoteDataSource _remoteDataSource;

  const LoanInspectionRepositoryImpl(this._remoteDataSource);

  @override
  Future<int> uploadInspectionPhoto({
    required File file,
    required String field,
  }) =>
      _remoteDataSource.uploadInspectionPhoto(file: file, field: field);

  @override
  Future<LoanInspection> submitDepartureInspection({
    required int loanId,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  }) =>
      _remoteDataSource.submitDepartureInspection(
        loanId: loanId,
        payload: payload,
        idempotencyKey: idempotencyKey,
      );

  @override
  Future<LoanInspection?> getDepartureInspection(int loanId) =>
      _remoteDataSource.getDepartureInspection(loanId);
}

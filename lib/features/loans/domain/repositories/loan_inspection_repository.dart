import 'dart:io';
import '../entities/loan_inspection.dart';

abstract class LoanInspectionRepository {
  Future<int> uploadInspectionPhoto({
    required File file,
    required String field,
  });

  Future<LoanInspection> submitDepartureInspection({
    required int loanId,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  });

  Future<LoanInspection?> getDepartureInspection(int loanId);
}

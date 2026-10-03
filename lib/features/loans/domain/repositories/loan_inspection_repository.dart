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

  Future<LoanInspection> submitReturnInspection({
    required int loanId,
    required Map<String, dynamic> payload,
    String? idempotencyKey,
  });

  Future<LoanInspection?> getReturnInspection(int loanId);

  Future<Map<String, dynamic>> settleLoan({
    required int loanId,
    bool releaseDeposit = true,
    int incidentClaimCents = 0,
  });
}


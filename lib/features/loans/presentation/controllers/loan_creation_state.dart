import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/loan.dart';
import '../../domain/entities/loan_draft.dart';

part 'loan_creation_state.freezed.dart';

@freezed
abstract class LoanCreationState with _$LoanCreationState {
  const factory LoanCreationState({
    required LoanDraft draft,
    @Default(0) int currentStep, // 0 = Schedule, 1 = Trip Details, 2 = Summary
    @Default(false) bool isCheckingAvailability,
    @Default(false) bool isSubmitting,
    String? availabilityConflictMessage,
    String? generalError,
    Map<String, String>? fieldErrors,
    Loan? createdLoan,
  }) = _LoanCreationState;
}

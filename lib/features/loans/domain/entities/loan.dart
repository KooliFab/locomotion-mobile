import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan.freezed.dart';
part 'loan.g.dart';

@freezed
abstract class Loan with _$Loan {
  const factory Loan({
    required int id,
    required int loanableId,
    required String loanableName,
    required String status, // 'pending', 'accepted', 'in_progress', 'completed', 'cancelled'
    required DateTime startAt,
    required DateTime endAt,
    double? totalCost,
    String? comment,
  }) = _Loan;

  factory Loan.fromJson(Map<String, dynamic> json) => _$LoanFromJson(json);
}

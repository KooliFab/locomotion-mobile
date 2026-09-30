import 'package:freezed_annotation/freezed_annotation.dart';
import 'loan.dart';

part 'loan_pagination.freezed.dart';

@freezed
abstract class LoanPagination with _$LoanPagination {
  const factory LoanPagination({
    @Default([]) List<Loan> data,
    @Default(1) int currentPage,
    @Default(1) int lastPage,
    @Default(0) int total,
    @Default(10) int perPage,
  }) = _LoanPagination;

  const LoanPagination._();

  bool get hasMore => currentPage < lastPage;
}

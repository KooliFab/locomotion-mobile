import 'package:freezed_annotation/freezed_annotation.dart';
import 'loan.dart';

part 'loans_dashboard.freezed.dart';
part 'loans_dashboard.g.dart';

@freezed
abstract class LoansDashboard with _$LoansDashboard {
  const factory LoansDashboard({
    @Default(LoansDashboardCategory()) LoansDashboardCategory started,
    @Default(LoansDashboardCategory()) LoansDashboardCategory waiting,
    @JsonKey(name: 'need_approval')
    @Default(LoansDashboardCategory())
    LoansDashboardCategory needApproval,
    @Default(LoansDashboardCategory()) LoansDashboardCategory future,
    @Default(LoansDashboardCategory()) LoansDashboardCategory completed,
  }) = _LoansDashboard;

  factory LoansDashboard.fromJson(Map<String, dynamic> json) =>
      _$LoansDashboardFromJson(json);
}

@freezed
abstract class LoansDashboardCategory with _$LoansDashboardCategory {
  const factory LoansDashboardCategory({
    @Default(0) int total,
    @Default([]) List<Loan> loans,
  }) = _LoansDashboardCategory;

  factory LoansDashboardCategory.fromJson(Map<String, dynamic> json) =>
      _$LoansDashboardCategoryFromJson(json);
}

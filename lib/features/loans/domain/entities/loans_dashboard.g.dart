// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loans_dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoansDashboard _$LoansDashboardFromJson(Map<String, dynamic> json) =>
    _LoansDashboard(
      started: json['started'] == null
          ? const LoansDashboardCategory()
          : LoansDashboardCategory.fromJson(
              json['started'] as Map<String, dynamic>,
            ),
      waiting: json['waiting'] == null
          ? const LoansDashboardCategory()
          : LoansDashboardCategory.fromJson(
              json['waiting'] as Map<String, dynamic>,
            ),
      needApproval: json['need_approval'] == null
          ? const LoansDashboardCategory()
          : LoansDashboardCategory.fromJson(
              json['need_approval'] as Map<String, dynamic>,
            ),
      future: json['future'] == null
          ? const LoansDashboardCategory()
          : LoansDashboardCategory.fromJson(
              json['future'] as Map<String, dynamic>,
            ),
      completed: json['completed'] == null
          ? const LoansDashboardCategory()
          : LoansDashboardCategory.fromJson(
              json['completed'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$LoansDashboardToJson(_LoansDashboard instance) =>
    <String, dynamic>{
      'started': instance.started,
      'waiting': instance.waiting,
      'need_approval': instance.needApproval,
      'future': instance.future,
      'completed': instance.completed,
    };

_LoansDashboardCategory _$LoansDashboardCategoryFromJson(
  Map<String, dynamic> json,
) => _LoansDashboardCategory(
  total: (json['total'] as num?)?.toInt() ?? 0,
  loans:
      (json['loans'] as List<dynamic>?)
          ?.map((e) => Loan.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$LoansDashboardCategoryToJson(
  _LoansDashboardCategory instance,
) => <String, dynamic>{'total': instance.total, 'loans': instance.loans};

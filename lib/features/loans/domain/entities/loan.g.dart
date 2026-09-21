// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Loan _$LoanFromJson(Map<String, dynamic> json) => _Loan(
  id: (json['id'] as num).toInt(),
  loanableId: (json['loanableId'] as num).toInt(),
  loanableName: json['loanableName'] as String,
  status: json['status'] as String,
  startAt: DateTime.parse(json['startAt'] as String),
  endAt: DateTime.parse(json['endAt'] as String),
  totalCost: (json['totalCost'] as num?)?.toDouble(),
  comment: json['comment'] as String?,
);

Map<String, dynamic> _$LoanToJson(_Loan instance) => <String, dynamic>{
  'id': instance.id,
  'loanableId': instance.loanableId,
  'loanableName': instance.loanableName,
  'status': instance.status,
  'startAt': instance.startAt.toIso8601String(),
  'endAt': instance.endAt.toIso8601String(),
  'totalCost': instance.totalCost,
  'comment': instance.comment,
};

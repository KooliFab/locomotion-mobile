// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoanComment _$LoanCommentFromJson(Map<String, dynamic> json) => _LoanComment(
  id: (json['id'] as num).toInt(),
  loanId: (json['loan_id'] as num?)?.toInt(),
  authorId: (json['author_id'] as num?)?.toInt(),
  authorName: json['author_name'] as String?,
  text: json['text'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$LoanCommentToJson(_LoanComment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loan_id': instance.loanId,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'text': instance.text,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

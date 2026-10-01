import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_comment.freezed.dart';
part 'loan_comment.g.dart';

@freezed
abstract class LoanComment with _$LoanComment {
  const LoanComment._();

  const factory LoanComment({
    required int id,
    @JsonKey(name: 'loan_id') int? loanId,
    @JsonKey(name: 'author_id') int? authorId,
    @JsonKey(name: 'author_name') String? authorName,
    String? text,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _LoanComment;

  factory LoanComment.fromJson(Map<String, dynamic> json) =>
      _$LoanCommentFromJson(_preprocessJson(json));

  static Map<String, dynamic> _preprocessJson(Map<String, dynamic> json) {
    final copy = Map<String, dynamic>.from(json);
    if (copy['author'] is Map<String, dynamic>) {
      final authorMap = copy['author'] as Map<String, dynamic>;
      copy['author_id'] ??= authorMap['id'];
      copy['author_name'] ??=
          authorMap['full_name'] ??
          '${authorMap['name'] ?? ''} ${authorMap['last_name'] ?? ''}'.trim();
    }
    return copy;
  }
}

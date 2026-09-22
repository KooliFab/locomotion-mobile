import 'package:freezed_annotation/freezed_annotation.dart';

part 'loanable_image.freezed.dart';
part 'loanable_image.g.dart';

@freezed
abstract class LoanableImage with _$LoanableImage {
  const LoanableImage._();

  const factory LoanableImage({
    required int id,
    String? field,
    String? filename,
    @JsonKey(name: 'original_filename') String? originalFilename,
    int? width,
    int? height,
    int? order,
  }) = _LoanableImage;

  factory LoanableImage.fromJson(Map<String, dynamic> json) =>
      _$LoanableImageFromJson(json);

  String buildUrl(String baseUrl, {String? size}) {
    final query = size != null ? '?size=$size' : '';
    return '$baseUrl/images/$id$query';
  }
}

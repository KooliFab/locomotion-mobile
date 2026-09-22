import 'package:freezed_annotation/freezed_annotation.dart';

part 'uploaded_file_ref.freezed.dart';
part 'uploaded_file_ref.g.dart';

@freezed
abstract class UploadedFileRef with _$UploadedFileRef {
  const factory UploadedFileRef({
    required int id,
    @JsonKey(name: 'original_filename') required String originalFilename,
    required String field,
  }) = _UploadedFileRef;

  factory UploadedFileRef.fromJson(Map<String, dynamic> json) =>
      _$UploadedFileRefFromJson(json);
}

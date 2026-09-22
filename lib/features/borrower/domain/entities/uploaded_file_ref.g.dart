// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploaded_file_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UploadedFileRef _$UploadedFileRefFromJson(Map<String, dynamic> json) =>
    _UploadedFileRef(
      id: (json['id'] as num).toInt(),
      originalFilename: json['original_filename'] as String,
      field: json['field'] as String,
    );

Map<String, dynamic> _$UploadedFileRefToJson(_UploadedFileRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'original_filename': instance.originalFilename,
      'field': instance.field,
    };

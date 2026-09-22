// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loanable_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoanableImage _$LoanableImageFromJson(Map<String, dynamic> json) =>
    _LoanableImage(
      id: (json['id'] as num).toInt(),
      field: json['field'] as String?,
      filename: json['filename'] as String?,
      originalFilename: json['original_filename'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      order: (json['order'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoanableImageToJson(_LoanableImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'field': instance.field,
      'filename': instance.filename,
      'original_filename': instance.originalFilename,
      'width': instance.width,
      'height': instance.height,
      'order': instance.order,
    };

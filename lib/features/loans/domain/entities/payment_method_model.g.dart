// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentMethodModel _$PaymentMethodModelFromJson(Map<String, dynamic> json) =>
    _PaymentMethodModel(
      id: (json['id'] as num).toInt(),
      creditCardType: json['credit_card_type'] as String,
      fourLastDigits: json['four_last_digits'] as String,
      country: json['country'] as String?,
      name: json['name'] as String?,
      isDefault: json['is_default'] as bool? ?? false,
      userId: (json['user_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaymentMethodModelToJson(_PaymentMethodModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'credit_card_type': instance.creditCardType,
      'four_last_digits': instance.fourLastDigits,
      'country': instance.country,
      'name': instance.name,
      'is_default': instance.isDefault,
      'user_id': instance.userId,
    };

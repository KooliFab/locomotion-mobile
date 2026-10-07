import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_method_model.freezed.dart';
part 'payment_method_model.g.dart';

@freezed
abstract class PaymentMethodModel with _$PaymentMethodModel {
  const PaymentMethodModel._();

  const factory PaymentMethodModel({
    required int id,
    @JsonKey(name: 'credit_card_type') required String creditCardType,
    @JsonKey(name: 'four_last_digits') required String fourLastDigits,
    @JsonKey(name: 'country') String? country,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'user_id') int? userId,
  }) = _PaymentMethodModel;

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodModelFromJson(json);

  String get maskedNumber => '•••• •••• •••• $fourLastDigits';
  String get brandDisplay =>
      creditCardType.isNotEmpty ? creditCardType : 'Carte';
}

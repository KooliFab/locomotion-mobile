import 'package:freezed_annotation/freezed_annotation.dart';

part 'loanable.freezed.dart';
part 'loanable.g.dart';

@freezed
abstract class Loanable with _$Loanable {
  const factory Loanable({
    required int id,
    required String name,
    required String type, // 'car', 'bike', 'trailer'
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    String? imageUrl,
    @Default(true) bool isAvailable,
    String? communityName,
    int? communityId,
  }) = _Loanable;

  factory Loanable.fromJson(Map<String, dynamic> json) => _$LoanableFromJson(json);
}

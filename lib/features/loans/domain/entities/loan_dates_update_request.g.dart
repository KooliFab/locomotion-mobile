// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_dates_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoanDatesUpdateRequest _$LoanDatesUpdateRequestFromJson(
  Map<String, dynamic> json,
) => _LoanDatesUpdateRequest(
  departureAt: json['departure_at'] as String,
  durationInMinutes: (json['duration_in_minutes'] as num).toInt(),
);

Map<String, dynamic> _$LoanDatesUpdateRequestToJson(
  _LoanDatesUpdateRequest instance,
) => <String, dynamic>{
  'departure_at': instance.departureAt,
  'duration_in_minutes': instance.durationInMinutes,
};

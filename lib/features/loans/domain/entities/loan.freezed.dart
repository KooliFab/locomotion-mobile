// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Loan {

 int get id;@JsonKey(name: 'departure_at') DateTime get departureAt;@JsonKey(name: 'duration_in_minutes') int get durationInMinutes;@JsonKey(name: 'status') String get status;@JsonKey(name: 'loanable_id') int? get loanableId;@JsonKey(name: 'loanable_name') String? get loanableName;@LoanableConverter() Loanable? get loanable;@JsonKey(name: 'community_id') int? get communityId;@JsonKey(name: 'community_name') String? get communityName;@JsonKey(name: 'borrower_user_id') int? get borrowerUserId;@JsonKey(name: 'borrower_user_name') String? get borrowerUserName;@JsonKey(name: 'borrower_user_email') String? get borrowerUserEmail;@JsonKey(name: 'borrower_user_phone') String? get borrowerUserPhone;@JsonKey(name: 'accepted_at') DateTime? get acceptedAt;@JsonKey(name: 'prepaid_at') DateTime? get prepaidAt;@JsonKey(name: 'canceled_at') DateTime? get canceledAt;@JsonKey(name: 'actual_return_at') DateTime? get actualReturnAt;@JsonKey(name: 'borrower_validated_at') DateTime? get borrowerValidatedAt;@JsonKey(name: 'owner_validated_at') DateTime? get ownerValidatedAt;@JsonKey(name: 'needs_validation') bool get needsValidation;@JsonKey(name: 'is_free') bool get isFree;@JsonKey(name: 'borrower_total') double? get borrowerTotal;@JsonKey(name: 'owner_total') double? get ownerTotal;@JsonKey(name: 'owner_action_required') bool get ownerActionRequired;@JsonKey(name: 'borrower_action_required') bool get borrowerActionRequired;@JsonKey(name: 'is_self_service') bool get isSelfService;@JsonKey(name: 'estimated_distance') int? get estimatedDistance;@JsonKey(name: 'actual_distance') int? get actualDistance;@JsonKey(name: 'mileage_start') int? get mileageStart;@JsonKey(name: 'mileage_end') int? get mileageEnd;@JsonKey(name: 'requires_mileage') bool? get requiresMileage;@JsonKey(name: 'requires_detailed_mileage') bool? get requiresDetailedMileage;@JsonKey(name: 'alternative_to') String? get alternativeTo;@JsonKey(name: 'alternative_to_other') String? get alternativeToOther; String? get comment; List<LoanComment> get comments;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'extension_duration_in_minutes') int? get extensionDurationInMinutes;// Payment and return information, as exposed by Laravel LoanResource.
@JsonKey(name: 'platform_tip') double? get platformTip;@JsonKey(name: 'desired_contribution') double? get desiredContribution;@JsonKey(name: 'borrower_may_contribute') bool get borrowerMayContribute;@JsonKey(name: 'borrower_must_pay_compensation') bool get borrowerMustPayCompensation;@JsonKey(name: 'borrower_must_pay_insurance') bool get borrowerMustPayInsurance;@JsonKey(name: 'applicable_amount_types') Map<String, dynamic>? get applicableAmountTypes;@JsonKey(name: 'can_add_expenses') bool get canAddExpenses;@JsonKey(name: 'expenses_amount') double? get expensesAmount;@JsonKey(name: 'mileage_start_image') Map<String, dynamic>? get mileageStartImage;@JsonKey(name: 'mileage_end_image') Map<String, dynamic>? get mileageEndImage;@JsonKey(name: 'expense_image') Map<String, dynamic>? get expenseImage;@JsonKey(name: 'borrower_invoice') Map<String, dynamic>? get borrowerInvoiceJson;
/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanCopyWith<Loan> get copyWith => _$LoanCopyWithImpl<Loan>(this as Loan, _$identity);

  /// Serializes this Loan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loan&&(identical(other.id, id) || other.id == id)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&(identical(other.status, status) || other.status == status)&&(identical(other.loanableId, loanableId) || other.loanableId == loanableId)&&(identical(other.loanableName, loanableName) || other.loanableName == loanableName)&&(identical(other.loanable, loanable) || other.loanable == loanable)&&(identical(other.communityId, communityId) || other.communityId == communityId)&&(identical(other.communityName, communityName) || other.communityName == communityName)&&(identical(other.borrowerUserId, borrowerUserId) || other.borrowerUserId == borrowerUserId)&&(identical(other.borrowerUserName, borrowerUserName) || other.borrowerUserName == borrowerUserName)&&(identical(other.borrowerUserEmail, borrowerUserEmail) || other.borrowerUserEmail == borrowerUserEmail)&&(identical(other.borrowerUserPhone, borrowerUserPhone) || other.borrowerUserPhone == borrowerUserPhone)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.prepaidAt, prepaidAt) || other.prepaidAt == prepaidAt)&&(identical(other.canceledAt, canceledAt) || other.canceledAt == canceledAt)&&(identical(other.actualReturnAt, actualReturnAt) || other.actualReturnAt == actualReturnAt)&&(identical(other.borrowerValidatedAt, borrowerValidatedAt) || other.borrowerValidatedAt == borrowerValidatedAt)&&(identical(other.ownerValidatedAt, ownerValidatedAt) || other.ownerValidatedAt == ownerValidatedAt)&&(identical(other.needsValidation, needsValidation) || other.needsValidation == needsValidation)&&(identical(other.isFree, isFree) || other.isFree == isFree)&&(identical(other.borrowerTotal, borrowerTotal) || other.borrowerTotal == borrowerTotal)&&(identical(other.ownerTotal, ownerTotal) || other.ownerTotal == ownerTotal)&&(identical(other.ownerActionRequired, ownerActionRequired) || other.ownerActionRequired == ownerActionRequired)&&(identical(other.borrowerActionRequired, borrowerActionRequired) || other.borrowerActionRequired == borrowerActionRequired)&&(identical(other.isSelfService, isSelfService) || other.isSelfService == isSelfService)&&(identical(other.estimatedDistance, estimatedDistance) || other.estimatedDistance == estimatedDistance)&&(identical(other.actualDistance, actualDistance) || other.actualDistance == actualDistance)&&(identical(other.mileageStart, mileageStart) || other.mileageStart == mileageStart)&&(identical(other.mileageEnd, mileageEnd) || other.mileageEnd == mileageEnd)&&(identical(other.requiresMileage, requiresMileage) || other.requiresMileage == requiresMileage)&&(identical(other.requiresDetailedMileage, requiresDetailedMileage) || other.requiresDetailedMileage == requiresDetailedMileage)&&(identical(other.alternativeTo, alternativeTo) || other.alternativeTo == alternativeTo)&&(identical(other.alternativeToOther, alternativeToOther) || other.alternativeToOther == alternativeToOther)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other.comments, comments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.extensionDurationInMinutes, extensionDurationInMinutes) || other.extensionDurationInMinutes == extensionDurationInMinutes)&&(identical(other.platformTip, platformTip) || other.platformTip == platformTip)&&(identical(other.desiredContribution, desiredContribution) || other.desiredContribution == desiredContribution)&&(identical(other.borrowerMayContribute, borrowerMayContribute) || other.borrowerMayContribute == borrowerMayContribute)&&(identical(other.borrowerMustPayCompensation, borrowerMustPayCompensation) || other.borrowerMustPayCompensation == borrowerMustPayCompensation)&&(identical(other.borrowerMustPayInsurance, borrowerMustPayInsurance) || other.borrowerMustPayInsurance == borrowerMustPayInsurance)&&const DeepCollectionEquality().equals(other.applicableAmountTypes, applicableAmountTypes)&&(identical(other.canAddExpenses, canAddExpenses) || other.canAddExpenses == canAddExpenses)&&(identical(other.expensesAmount, expensesAmount) || other.expensesAmount == expensesAmount)&&const DeepCollectionEquality().equals(other.mileageStartImage, mileageStartImage)&&const DeepCollectionEquality().equals(other.mileageEndImage, mileageEndImage)&&const DeepCollectionEquality().equals(other.expenseImage, expenseImage)&&const DeepCollectionEquality().equals(other.borrowerInvoiceJson, borrowerInvoiceJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,departureAt,durationInMinutes,status,loanableId,loanableName,loanable,communityId,communityName,borrowerUserId,borrowerUserName,borrowerUserEmail,borrowerUserPhone,acceptedAt,prepaidAt,canceledAt,actualReturnAt,borrowerValidatedAt,ownerValidatedAt,needsValidation,isFree,borrowerTotal,ownerTotal,ownerActionRequired,borrowerActionRequired,isSelfService,estimatedDistance,actualDistance,mileageStart,mileageEnd,requiresMileage,requiresDetailedMileage,alternativeTo,alternativeToOther,comment,const DeepCollectionEquality().hash(comments),createdAt,extensionDurationInMinutes,platformTip,desiredContribution,borrowerMayContribute,borrowerMustPayCompensation,borrowerMustPayInsurance,const DeepCollectionEquality().hash(applicableAmountTypes),canAddExpenses,expensesAmount,const DeepCollectionEquality().hash(mileageStartImage),const DeepCollectionEquality().hash(mileageEndImage),const DeepCollectionEquality().hash(expenseImage),const DeepCollectionEquality().hash(borrowerInvoiceJson)]);

@override
String toString() {
  return 'Loan(id: $id, departureAt: $departureAt, durationInMinutes: $durationInMinutes, status: $status, loanableId: $loanableId, loanableName: $loanableName, loanable: $loanable, communityId: $communityId, communityName: $communityName, borrowerUserId: $borrowerUserId, borrowerUserName: $borrowerUserName, borrowerUserEmail: $borrowerUserEmail, borrowerUserPhone: $borrowerUserPhone, acceptedAt: $acceptedAt, prepaidAt: $prepaidAt, canceledAt: $canceledAt, actualReturnAt: $actualReturnAt, borrowerValidatedAt: $borrowerValidatedAt, ownerValidatedAt: $ownerValidatedAt, needsValidation: $needsValidation, isFree: $isFree, borrowerTotal: $borrowerTotal, ownerTotal: $ownerTotal, ownerActionRequired: $ownerActionRequired, borrowerActionRequired: $borrowerActionRequired, isSelfService: $isSelfService, estimatedDistance: $estimatedDistance, actualDistance: $actualDistance, mileageStart: $mileageStart, mileageEnd: $mileageEnd, requiresMileage: $requiresMileage, requiresDetailedMileage: $requiresDetailedMileage, alternativeTo: $alternativeTo, alternativeToOther: $alternativeToOther, comment: $comment, comments: $comments, createdAt: $createdAt, extensionDurationInMinutes: $extensionDurationInMinutes, platformTip: $platformTip, desiredContribution: $desiredContribution, borrowerMayContribute: $borrowerMayContribute, borrowerMustPayCompensation: $borrowerMustPayCompensation, borrowerMustPayInsurance: $borrowerMustPayInsurance, applicableAmountTypes: $applicableAmountTypes, canAddExpenses: $canAddExpenses, expensesAmount: $expensesAmount, mileageStartImage: $mileageStartImage, mileageEndImage: $mileageEndImage, expenseImage: $expenseImage, borrowerInvoiceJson: $borrowerInvoiceJson)';
}


}

/// @nodoc
abstract mixin class $LoanCopyWith<$Res>  {
  factory $LoanCopyWith(Loan value, $Res Function(Loan) _then) = _$LoanCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'departure_at') DateTime departureAt,@JsonKey(name: 'duration_in_minutes') int durationInMinutes,@JsonKey(name: 'status') String status,@JsonKey(name: 'loanable_id') int? loanableId,@JsonKey(name: 'loanable_name') String? loanableName,@LoanableConverter() Loanable? loanable,@JsonKey(name: 'community_id') int? communityId,@JsonKey(name: 'community_name') String? communityName,@JsonKey(name: 'borrower_user_id') int? borrowerUserId,@JsonKey(name: 'borrower_user_name') String? borrowerUserName,@JsonKey(name: 'borrower_user_email') String? borrowerUserEmail,@JsonKey(name: 'borrower_user_phone') String? borrowerUserPhone,@JsonKey(name: 'accepted_at') DateTime? acceptedAt,@JsonKey(name: 'prepaid_at') DateTime? prepaidAt,@JsonKey(name: 'canceled_at') DateTime? canceledAt,@JsonKey(name: 'actual_return_at') DateTime? actualReturnAt,@JsonKey(name: 'borrower_validated_at') DateTime? borrowerValidatedAt,@JsonKey(name: 'owner_validated_at') DateTime? ownerValidatedAt,@JsonKey(name: 'needs_validation') bool needsValidation,@JsonKey(name: 'is_free') bool isFree,@JsonKey(name: 'borrower_total') double? borrowerTotal,@JsonKey(name: 'owner_total') double? ownerTotal,@JsonKey(name: 'owner_action_required') bool ownerActionRequired,@JsonKey(name: 'borrower_action_required') bool borrowerActionRequired,@JsonKey(name: 'is_self_service') bool isSelfService,@JsonKey(name: 'estimated_distance') int? estimatedDistance,@JsonKey(name: 'actual_distance') int? actualDistance,@JsonKey(name: 'mileage_start') int? mileageStart,@JsonKey(name: 'mileage_end') int? mileageEnd,@JsonKey(name: 'requires_mileage') bool? requiresMileage,@JsonKey(name: 'requires_detailed_mileage') bool? requiresDetailedMileage,@JsonKey(name: 'alternative_to') String? alternativeTo,@JsonKey(name: 'alternative_to_other') String? alternativeToOther, String? comment, List<LoanComment> comments,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'extension_duration_in_minutes') int? extensionDurationInMinutes,@JsonKey(name: 'platform_tip') double? platformTip,@JsonKey(name: 'desired_contribution') double? desiredContribution,@JsonKey(name: 'borrower_may_contribute') bool borrowerMayContribute,@JsonKey(name: 'borrower_must_pay_compensation') bool borrowerMustPayCompensation,@JsonKey(name: 'borrower_must_pay_insurance') bool borrowerMustPayInsurance,@JsonKey(name: 'applicable_amount_types') Map<String, dynamic>? applicableAmountTypes,@JsonKey(name: 'can_add_expenses') bool canAddExpenses,@JsonKey(name: 'expenses_amount') double? expensesAmount,@JsonKey(name: 'mileage_start_image') Map<String, dynamic>? mileageStartImage,@JsonKey(name: 'mileage_end_image') Map<String, dynamic>? mileageEndImage,@JsonKey(name: 'expense_image') Map<String, dynamic>? expenseImage,@JsonKey(name: 'borrower_invoice') Map<String, dynamic>? borrowerInvoiceJson
});


$LoanableCopyWith<$Res>? get loanable;

}
/// @nodoc
class _$LoanCopyWithImpl<$Res>
    implements $LoanCopyWith<$Res> {
  _$LoanCopyWithImpl(this._self, this._then);

  final Loan _self;
  final $Res Function(Loan) _then;

/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? departureAt = null,Object? durationInMinutes = null,Object? status = null,Object? loanableId = freezed,Object? loanableName = freezed,Object? loanable = freezed,Object? communityId = freezed,Object? communityName = freezed,Object? borrowerUserId = freezed,Object? borrowerUserName = freezed,Object? borrowerUserEmail = freezed,Object? borrowerUserPhone = freezed,Object? acceptedAt = freezed,Object? prepaidAt = freezed,Object? canceledAt = freezed,Object? actualReturnAt = freezed,Object? borrowerValidatedAt = freezed,Object? ownerValidatedAt = freezed,Object? needsValidation = null,Object? isFree = null,Object? borrowerTotal = freezed,Object? ownerTotal = freezed,Object? ownerActionRequired = null,Object? borrowerActionRequired = null,Object? isSelfService = null,Object? estimatedDistance = freezed,Object? actualDistance = freezed,Object? mileageStart = freezed,Object? mileageEnd = freezed,Object? requiresMileage = freezed,Object? requiresDetailedMileage = freezed,Object? alternativeTo = freezed,Object? alternativeToOther = freezed,Object? comment = freezed,Object? comments = null,Object? createdAt = freezed,Object? extensionDurationInMinutes = freezed,Object? platformTip = freezed,Object? desiredContribution = freezed,Object? borrowerMayContribute = null,Object? borrowerMustPayCompensation = null,Object? borrowerMustPayInsurance = null,Object? applicableAmountTypes = freezed,Object? canAddExpenses = null,Object? expensesAmount = freezed,Object? mileageStartImage = freezed,Object? mileageEndImage = freezed,Object? expenseImage = freezed,Object? borrowerInvoiceJson = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,departureAt: null == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationInMinutes: null == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,loanableId: freezed == loanableId ? _self.loanableId : loanableId // ignore: cast_nullable_to_non_nullable
as int?,loanableName: freezed == loanableName ? _self.loanableName : loanableName // ignore: cast_nullable_to_non_nullable
as String?,loanable: freezed == loanable ? _self.loanable : loanable // ignore: cast_nullable_to_non_nullable
as Loanable?,communityId: freezed == communityId ? _self.communityId : communityId // ignore: cast_nullable_to_non_nullable
as int?,communityName: freezed == communityName ? _self.communityName : communityName // ignore: cast_nullable_to_non_nullable
as String?,borrowerUserId: freezed == borrowerUserId ? _self.borrowerUserId : borrowerUserId // ignore: cast_nullable_to_non_nullable
as int?,borrowerUserName: freezed == borrowerUserName ? _self.borrowerUserName : borrowerUserName // ignore: cast_nullable_to_non_nullable
as String?,borrowerUserEmail: freezed == borrowerUserEmail ? _self.borrowerUserEmail : borrowerUserEmail // ignore: cast_nullable_to_non_nullable
as String?,borrowerUserPhone: freezed == borrowerUserPhone ? _self.borrowerUserPhone : borrowerUserPhone // ignore: cast_nullable_to_non_nullable
as String?,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,prepaidAt: freezed == prepaidAt ? _self.prepaidAt : prepaidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,canceledAt: freezed == canceledAt ? _self.canceledAt : canceledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,actualReturnAt: freezed == actualReturnAt ? _self.actualReturnAt : actualReturnAt // ignore: cast_nullable_to_non_nullable
as DateTime?,borrowerValidatedAt: freezed == borrowerValidatedAt ? _self.borrowerValidatedAt : borrowerValidatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,ownerValidatedAt: freezed == ownerValidatedAt ? _self.ownerValidatedAt : ownerValidatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,needsValidation: null == needsValidation ? _self.needsValidation : needsValidation // ignore: cast_nullable_to_non_nullable
as bool,isFree: null == isFree ? _self.isFree : isFree // ignore: cast_nullable_to_non_nullable
as bool,borrowerTotal: freezed == borrowerTotal ? _self.borrowerTotal : borrowerTotal // ignore: cast_nullable_to_non_nullable
as double?,ownerTotal: freezed == ownerTotal ? _self.ownerTotal : ownerTotal // ignore: cast_nullable_to_non_nullable
as double?,ownerActionRequired: null == ownerActionRequired ? _self.ownerActionRequired : ownerActionRequired // ignore: cast_nullable_to_non_nullable
as bool,borrowerActionRequired: null == borrowerActionRequired ? _self.borrowerActionRequired : borrowerActionRequired // ignore: cast_nullable_to_non_nullable
as bool,isSelfService: null == isSelfService ? _self.isSelfService : isSelfService // ignore: cast_nullable_to_non_nullable
as bool,estimatedDistance: freezed == estimatedDistance ? _self.estimatedDistance : estimatedDistance // ignore: cast_nullable_to_non_nullable
as int?,actualDistance: freezed == actualDistance ? _self.actualDistance : actualDistance // ignore: cast_nullable_to_non_nullable
as int?,mileageStart: freezed == mileageStart ? _self.mileageStart : mileageStart // ignore: cast_nullable_to_non_nullable
as int?,mileageEnd: freezed == mileageEnd ? _self.mileageEnd : mileageEnd // ignore: cast_nullable_to_non_nullable
as int?,requiresMileage: freezed == requiresMileage ? _self.requiresMileage : requiresMileage // ignore: cast_nullable_to_non_nullable
as bool?,requiresDetailedMileage: freezed == requiresDetailedMileage ? _self.requiresDetailedMileage : requiresDetailedMileage // ignore: cast_nullable_to_non_nullable
as bool?,alternativeTo: freezed == alternativeTo ? _self.alternativeTo : alternativeTo // ignore: cast_nullable_to_non_nullable
as String?,alternativeToOther: freezed == alternativeToOther ? _self.alternativeToOther : alternativeToOther // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,comments: null == comments ? _self.comments : comments // ignore: cast_nullable_to_non_nullable
as List<LoanComment>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,extensionDurationInMinutes: freezed == extensionDurationInMinutes ? _self.extensionDurationInMinutes : extensionDurationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,platformTip: freezed == platformTip ? _self.platformTip : platformTip // ignore: cast_nullable_to_non_nullable
as double?,desiredContribution: freezed == desiredContribution ? _self.desiredContribution : desiredContribution // ignore: cast_nullable_to_non_nullable
as double?,borrowerMayContribute: null == borrowerMayContribute ? _self.borrowerMayContribute : borrowerMayContribute // ignore: cast_nullable_to_non_nullable
as bool,borrowerMustPayCompensation: null == borrowerMustPayCompensation ? _self.borrowerMustPayCompensation : borrowerMustPayCompensation // ignore: cast_nullable_to_non_nullable
as bool,borrowerMustPayInsurance: null == borrowerMustPayInsurance ? _self.borrowerMustPayInsurance : borrowerMustPayInsurance // ignore: cast_nullable_to_non_nullable
as bool,applicableAmountTypes: freezed == applicableAmountTypes ? _self.applicableAmountTypes : applicableAmountTypes // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,canAddExpenses: null == canAddExpenses ? _self.canAddExpenses : canAddExpenses // ignore: cast_nullable_to_non_nullable
as bool,expensesAmount: freezed == expensesAmount ? _self.expensesAmount : expensesAmount // ignore: cast_nullable_to_non_nullable
as double?,mileageStartImage: freezed == mileageStartImage ? _self.mileageStartImage : mileageStartImage // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,mileageEndImage: freezed == mileageEndImage ? _self.mileageEndImage : mileageEndImage // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,expenseImage: freezed == expenseImage ? _self.expenseImage : expenseImage // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,borrowerInvoiceJson: freezed == borrowerInvoiceJson ? _self.borrowerInvoiceJson : borrowerInvoiceJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}
/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoanableCopyWith<$Res>? get loanable {
    if (_self.loanable == null) {
    return null;
  }

  return $LoanableCopyWith<$Res>(_self.loanable!, (value) {
    return _then(_self.copyWith(loanable: value));
  });
}
}


/// Adds pattern-matching-related methods to [Loan].
extension LoanPatterns on Loan {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Loan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Loan() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Loan value)  $default,){
final _that = this;
switch (_that) {
case _Loan():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Loan value)?  $default,){
final _that = this;
switch (_that) {
case _Loan() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'departure_at')  DateTime departureAt, @JsonKey(name: 'duration_in_minutes')  int durationInMinutes, @JsonKey(name: 'status')  String status, @JsonKey(name: 'loanable_id')  int? loanableId, @JsonKey(name: 'loanable_name')  String? loanableName, @LoanableConverter()  Loanable? loanable, @JsonKey(name: 'community_id')  int? communityId, @JsonKey(name: 'community_name')  String? communityName, @JsonKey(name: 'borrower_user_id')  int? borrowerUserId, @JsonKey(name: 'borrower_user_name')  String? borrowerUserName, @JsonKey(name: 'borrower_user_email')  String? borrowerUserEmail, @JsonKey(name: 'borrower_user_phone')  String? borrowerUserPhone, @JsonKey(name: 'accepted_at')  DateTime? acceptedAt, @JsonKey(name: 'prepaid_at')  DateTime? prepaidAt, @JsonKey(name: 'canceled_at')  DateTime? canceledAt, @JsonKey(name: 'actual_return_at')  DateTime? actualReturnAt, @JsonKey(name: 'borrower_validated_at')  DateTime? borrowerValidatedAt, @JsonKey(name: 'owner_validated_at')  DateTime? ownerValidatedAt, @JsonKey(name: 'needs_validation')  bool needsValidation, @JsonKey(name: 'is_free')  bool isFree, @JsonKey(name: 'borrower_total')  double? borrowerTotal, @JsonKey(name: 'owner_total')  double? ownerTotal, @JsonKey(name: 'owner_action_required')  bool ownerActionRequired, @JsonKey(name: 'borrower_action_required')  bool borrowerActionRequired, @JsonKey(name: 'is_self_service')  bool isSelfService, @JsonKey(name: 'estimated_distance')  int? estimatedDistance, @JsonKey(name: 'actual_distance')  int? actualDistance, @JsonKey(name: 'mileage_start')  int? mileageStart, @JsonKey(name: 'mileage_end')  int? mileageEnd, @JsonKey(name: 'requires_mileage')  bool? requiresMileage, @JsonKey(name: 'requires_detailed_mileage')  bool? requiresDetailedMileage, @JsonKey(name: 'alternative_to')  String? alternativeTo, @JsonKey(name: 'alternative_to_other')  String? alternativeToOther,  String? comment,  List<LoanComment> comments, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'extension_duration_in_minutes')  int? extensionDurationInMinutes, @JsonKey(name: 'platform_tip')  double? platformTip, @JsonKey(name: 'desired_contribution')  double? desiredContribution, @JsonKey(name: 'borrower_may_contribute')  bool borrowerMayContribute, @JsonKey(name: 'borrower_must_pay_compensation')  bool borrowerMustPayCompensation, @JsonKey(name: 'borrower_must_pay_insurance')  bool borrowerMustPayInsurance, @JsonKey(name: 'applicable_amount_types')  Map<String, dynamic>? applicableAmountTypes, @JsonKey(name: 'can_add_expenses')  bool canAddExpenses, @JsonKey(name: 'expenses_amount')  double? expensesAmount, @JsonKey(name: 'mileage_start_image')  Map<String, dynamic>? mileageStartImage, @JsonKey(name: 'mileage_end_image')  Map<String, dynamic>? mileageEndImage, @JsonKey(name: 'expense_image')  Map<String, dynamic>? expenseImage, @JsonKey(name: 'borrower_invoice')  Map<String, dynamic>? borrowerInvoiceJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loan() when $default != null:
return $default(_that.id,_that.departureAt,_that.durationInMinutes,_that.status,_that.loanableId,_that.loanableName,_that.loanable,_that.communityId,_that.communityName,_that.borrowerUserId,_that.borrowerUserName,_that.borrowerUserEmail,_that.borrowerUserPhone,_that.acceptedAt,_that.prepaidAt,_that.canceledAt,_that.actualReturnAt,_that.borrowerValidatedAt,_that.ownerValidatedAt,_that.needsValidation,_that.isFree,_that.borrowerTotal,_that.ownerTotal,_that.ownerActionRequired,_that.borrowerActionRequired,_that.isSelfService,_that.estimatedDistance,_that.actualDistance,_that.mileageStart,_that.mileageEnd,_that.requiresMileage,_that.requiresDetailedMileage,_that.alternativeTo,_that.alternativeToOther,_that.comment,_that.comments,_that.createdAt,_that.extensionDurationInMinutes,_that.platformTip,_that.desiredContribution,_that.borrowerMayContribute,_that.borrowerMustPayCompensation,_that.borrowerMustPayInsurance,_that.applicableAmountTypes,_that.canAddExpenses,_that.expensesAmount,_that.mileageStartImage,_that.mileageEndImage,_that.expenseImage,_that.borrowerInvoiceJson);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'departure_at')  DateTime departureAt, @JsonKey(name: 'duration_in_minutes')  int durationInMinutes, @JsonKey(name: 'status')  String status, @JsonKey(name: 'loanable_id')  int? loanableId, @JsonKey(name: 'loanable_name')  String? loanableName, @LoanableConverter()  Loanable? loanable, @JsonKey(name: 'community_id')  int? communityId, @JsonKey(name: 'community_name')  String? communityName, @JsonKey(name: 'borrower_user_id')  int? borrowerUserId, @JsonKey(name: 'borrower_user_name')  String? borrowerUserName, @JsonKey(name: 'borrower_user_email')  String? borrowerUserEmail, @JsonKey(name: 'borrower_user_phone')  String? borrowerUserPhone, @JsonKey(name: 'accepted_at')  DateTime? acceptedAt, @JsonKey(name: 'prepaid_at')  DateTime? prepaidAt, @JsonKey(name: 'canceled_at')  DateTime? canceledAt, @JsonKey(name: 'actual_return_at')  DateTime? actualReturnAt, @JsonKey(name: 'borrower_validated_at')  DateTime? borrowerValidatedAt, @JsonKey(name: 'owner_validated_at')  DateTime? ownerValidatedAt, @JsonKey(name: 'needs_validation')  bool needsValidation, @JsonKey(name: 'is_free')  bool isFree, @JsonKey(name: 'borrower_total')  double? borrowerTotal, @JsonKey(name: 'owner_total')  double? ownerTotal, @JsonKey(name: 'owner_action_required')  bool ownerActionRequired, @JsonKey(name: 'borrower_action_required')  bool borrowerActionRequired, @JsonKey(name: 'is_self_service')  bool isSelfService, @JsonKey(name: 'estimated_distance')  int? estimatedDistance, @JsonKey(name: 'actual_distance')  int? actualDistance, @JsonKey(name: 'mileage_start')  int? mileageStart, @JsonKey(name: 'mileage_end')  int? mileageEnd, @JsonKey(name: 'requires_mileage')  bool? requiresMileage, @JsonKey(name: 'requires_detailed_mileage')  bool? requiresDetailedMileage, @JsonKey(name: 'alternative_to')  String? alternativeTo, @JsonKey(name: 'alternative_to_other')  String? alternativeToOther,  String? comment,  List<LoanComment> comments, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'extension_duration_in_minutes')  int? extensionDurationInMinutes, @JsonKey(name: 'platform_tip')  double? platformTip, @JsonKey(name: 'desired_contribution')  double? desiredContribution, @JsonKey(name: 'borrower_may_contribute')  bool borrowerMayContribute, @JsonKey(name: 'borrower_must_pay_compensation')  bool borrowerMustPayCompensation, @JsonKey(name: 'borrower_must_pay_insurance')  bool borrowerMustPayInsurance, @JsonKey(name: 'applicable_amount_types')  Map<String, dynamic>? applicableAmountTypes, @JsonKey(name: 'can_add_expenses')  bool canAddExpenses, @JsonKey(name: 'expenses_amount')  double? expensesAmount, @JsonKey(name: 'mileage_start_image')  Map<String, dynamic>? mileageStartImage, @JsonKey(name: 'mileage_end_image')  Map<String, dynamic>? mileageEndImage, @JsonKey(name: 'expense_image')  Map<String, dynamic>? expenseImage, @JsonKey(name: 'borrower_invoice')  Map<String, dynamic>? borrowerInvoiceJson)  $default,) {final _that = this;
switch (_that) {
case _Loan():
return $default(_that.id,_that.departureAt,_that.durationInMinutes,_that.status,_that.loanableId,_that.loanableName,_that.loanable,_that.communityId,_that.communityName,_that.borrowerUserId,_that.borrowerUserName,_that.borrowerUserEmail,_that.borrowerUserPhone,_that.acceptedAt,_that.prepaidAt,_that.canceledAt,_that.actualReturnAt,_that.borrowerValidatedAt,_that.ownerValidatedAt,_that.needsValidation,_that.isFree,_that.borrowerTotal,_that.ownerTotal,_that.ownerActionRequired,_that.borrowerActionRequired,_that.isSelfService,_that.estimatedDistance,_that.actualDistance,_that.mileageStart,_that.mileageEnd,_that.requiresMileage,_that.requiresDetailedMileage,_that.alternativeTo,_that.alternativeToOther,_that.comment,_that.comments,_that.createdAt,_that.extensionDurationInMinutes,_that.platformTip,_that.desiredContribution,_that.borrowerMayContribute,_that.borrowerMustPayCompensation,_that.borrowerMustPayInsurance,_that.applicableAmountTypes,_that.canAddExpenses,_that.expensesAmount,_that.mileageStartImage,_that.mileageEndImage,_that.expenseImage,_that.borrowerInvoiceJson);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'departure_at')  DateTime departureAt, @JsonKey(name: 'duration_in_minutes')  int durationInMinutes, @JsonKey(name: 'status')  String status, @JsonKey(name: 'loanable_id')  int? loanableId, @JsonKey(name: 'loanable_name')  String? loanableName, @LoanableConverter()  Loanable? loanable, @JsonKey(name: 'community_id')  int? communityId, @JsonKey(name: 'community_name')  String? communityName, @JsonKey(name: 'borrower_user_id')  int? borrowerUserId, @JsonKey(name: 'borrower_user_name')  String? borrowerUserName, @JsonKey(name: 'borrower_user_email')  String? borrowerUserEmail, @JsonKey(name: 'borrower_user_phone')  String? borrowerUserPhone, @JsonKey(name: 'accepted_at')  DateTime? acceptedAt, @JsonKey(name: 'prepaid_at')  DateTime? prepaidAt, @JsonKey(name: 'canceled_at')  DateTime? canceledAt, @JsonKey(name: 'actual_return_at')  DateTime? actualReturnAt, @JsonKey(name: 'borrower_validated_at')  DateTime? borrowerValidatedAt, @JsonKey(name: 'owner_validated_at')  DateTime? ownerValidatedAt, @JsonKey(name: 'needs_validation')  bool needsValidation, @JsonKey(name: 'is_free')  bool isFree, @JsonKey(name: 'borrower_total')  double? borrowerTotal, @JsonKey(name: 'owner_total')  double? ownerTotal, @JsonKey(name: 'owner_action_required')  bool ownerActionRequired, @JsonKey(name: 'borrower_action_required')  bool borrowerActionRequired, @JsonKey(name: 'is_self_service')  bool isSelfService, @JsonKey(name: 'estimated_distance')  int? estimatedDistance, @JsonKey(name: 'actual_distance')  int? actualDistance, @JsonKey(name: 'mileage_start')  int? mileageStart, @JsonKey(name: 'mileage_end')  int? mileageEnd, @JsonKey(name: 'requires_mileage')  bool? requiresMileage, @JsonKey(name: 'requires_detailed_mileage')  bool? requiresDetailedMileage, @JsonKey(name: 'alternative_to')  String? alternativeTo, @JsonKey(name: 'alternative_to_other')  String? alternativeToOther,  String? comment,  List<LoanComment> comments, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'extension_duration_in_minutes')  int? extensionDurationInMinutes, @JsonKey(name: 'platform_tip')  double? platformTip, @JsonKey(name: 'desired_contribution')  double? desiredContribution, @JsonKey(name: 'borrower_may_contribute')  bool borrowerMayContribute, @JsonKey(name: 'borrower_must_pay_compensation')  bool borrowerMustPayCompensation, @JsonKey(name: 'borrower_must_pay_insurance')  bool borrowerMustPayInsurance, @JsonKey(name: 'applicable_amount_types')  Map<String, dynamic>? applicableAmountTypes, @JsonKey(name: 'can_add_expenses')  bool canAddExpenses, @JsonKey(name: 'expenses_amount')  double? expensesAmount, @JsonKey(name: 'mileage_start_image')  Map<String, dynamic>? mileageStartImage, @JsonKey(name: 'mileage_end_image')  Map<String, dynamic>? mileageEndImage, @JsonKey(name: 'expense_image')  Map<String, dynamic>? expenseImage, @JsonKey(name: 'borrower_invoice')  Map<String, dynamic>? borrowerInvoiceJson)?  $default,) {final _that = this;
switch (_that) {
case _Loan() when $default != null:
return $default(_that.id,_that.departureAt,_that.durationInMinutes,_that.status,_that.loanableId,_that.loanableName,_that.loanable,_that.communityId,_that.communityName,_that.borrowerUserId,_that.borrowerUserName,_that.borrowerUserEmail,_that.borrowerUserPhone,_that.acceptedAt,_that.prepaidAt,_that.canceledAt,_that.actualReturnAt,_that.borrowerValidatedAt,_that.ownerValidatedAt,_that.needsValidation,_that.isFree,_that.borrowerTotal,_that.ownerTotal,_that.ownerActionRequired,_that.borrowerActionRequired,_that.isSelfService,_that.estimatedDistance,_that.actualDistance,_that.mileageStart,_that.mileageEnd,_that.requiresMileage,_that.requiresDetailedMileage,_that.alternativeTo,_that.alternativeToOther,_that.comment,_that.comments,_that.createdAt,_that.extensionDurationInMinutes,_that.platformTip,_that.desiredContribution,_that.borrowerMayContribute,_that.borrowerMustPayCompensation,_that.borrowerMustPayInsurance,_that.applicableAmountTypes,_that.canAddExpenses,_that.expensesAmount,_that.mileageStartImage,_that.mileageEndImage,_that.expenseImage,_that.borrowerInvoiceJson);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Loan extends Loan {
  const _Loan({required this.id, @JsonKey(name: 'departure_at') required this.departureAt, @JsonKey(name: 'duration_in_minutes') required this.durationInMinutes, @JsonKey(name: 'status') required this.status, @JsonKey(name: 'loanable_id') this.loanableId, @JsonKey(name: 'loanable_name') this.loanableName, @LoanableConverter() this.loanable, @JsonKey(name: 'community_id') this.communityId, @JsonKey(name: 'community_name') this.communityName, @JsonKey(name: 'borrower_user_id') this.borrowerUserId, @JsonKey(name: 'borrower_user_name') this.borrowerUserName, @JsonKey(name: 'borrower_user_email') this.borrowerUserEmail, @JsonKey(name: 'borrower_user_phone') this.borrowerUserPhone, @JsonKey(name: 'accepted_at') this.acceptedAt, @JsonKey(name: 'prepaid_at') this.prepaidAt, @JsonKey(name: 'canceled_at') this.canceledAt, @JsonKey(name: 'actual_return_at') this.actualReturnAt, @JsonKey(name: 'borrower_validated_at') this.borrowerValidatedAt, @JsonKey(name: 'owner_validated_at') this.ownerValidatedAt, @JsonKey(name: 'needs_validation') this.needsValidation = false, @JsonKey(name: 'is_free') this.isFree = false, @JsonKey(name: 'borrower_total') this.borrowerTotal, @JsonKey(name: 'owner_total') this.ownerTotal, @JsonKey(name: 'owner_action_required') this.ownerActionRequired = false, @JsonKey(name: 'borrower_action_required') this.borrowerActionRequired = false, @JsonKey(name: 'is_self_service') this.isSelfService = false, @JsonKey(name: 'estimated_distance') this.estimatedDistance, @JsonKey(name: 'actual_distance') this.actualDistance, @JsonKey(name: 'mileage_start') this.mileageStart, @JsonKey(name: 'mileage_end') this.mileageEnd, @JsonKey(name: 'requires_mileage') this.requiresMileage, @JsonKey(name: 'requires_detailed_mileage') this.requiresDetailedMileage, @JsonKey(name: 'alternative_to') this.alternativeTo, @JsonKey(name: 'alternative_to_other') this.alternativeToOther, this.comment, final  List<LoanComment> comments = const [], @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'extension_duration_in_minutes') this.extensionDurationInMinutes, @JsonKey(name: 'platform_tip') this.platformTip, @JsonKey(name: 'desired_contribution') this.desiredContribution, @JsonKey(name: 'borrower_may_contribute') this.borrowerMayContribute = false, @JsonKey(name: 'borrower_must_pay_compensation') this.borrowerMustPayCompensation = false, @JsonKey(name: 'borrower_must_pay_insurance') this.borrowerMustPayInsurance = false, @JsonKey(name: 'applicable_amount_types') final  Map<String, dynamic>? applicableAmountTypes, @JsonKey(name: 'can_add_expenses') this.canAddExpenses = false, @JsonKey(name: 'expenses_amount') this.expensesAmount, @JsonKey(name: 'mileage_start_image') final  Map<String, dynamic>? mileageStartImage, @JsonKey(name: 'mileage_end_image') final  Map<String, dynamic>? mileageEndImage, @JsonKey(name: 'expense_image') final  Map<String, dynamic>? expenseImage, @JsonKey(name: 'borrower_invoice') final  Map<String, dynamic>? borrowerInvoiceJson}): _comments = comments,_applicableAmountTypes = applicableAmountTypes,_mileageStartImage = mileageStartImage,_mileageEndImage = mileageEndImage,_expenseImage = expenseImage,_borrowerInvoiceJson = borrowerInvoiceJson,super._();
  factory _Loan.fromJson(Map<String, dynamic> json) => _$LoanFromJson(json);

@override final  int id;
@override@JsonKey(name: 'departure_at') final  DateTime departureAt;
@override@JsonKey(name: 'duration_in_minutes') final  int durationInMinutes;
@override@JsonKey(name: 'status') final  String status;
@override@JsonKey(name: 'loanable_id') final  int? loanableId;
@override@JsonKey(name: 'loanable_name') final  String? loanableName;
@override@LoanableConverter() final  Loanable? loanable;
@override@JsonKey(name: 'community_id') final  int? communityId;
@override@JsonKey(name: 'community_name') final  String? communityName;
@override@JsonKey(name: 'borrower_user_id') final  int? borrowerUserId;
@override@JsonKey(name: 'borrower_user_name') final  String? borrowerUserName;
@override@JsonKey(name: 'borrower_user_email') final  String? borrowerUserEmail;
@override@JsonKey(name: 'borrower_user_phone') final  String? borrowerUserPhone;
@override@JsonKey(name: 'accepted_at') final  DateTime? acceptedAt;
@override@JsonKey(name: 'prepaid_at') final  DateTime? prepaidAt;
@override@JsonKey(name: 'canceled_at') final  DateTime? canceledAt;
@override@JsonKey(name: 'actual_return_at') final  DateTime? actualReturnAt;
@override@JsonKey(name: 'borrower_validated_at') final  DateTime? borrowerValidatedAt;
@override@JsonKey(name: 'owner_validated_at') final  DateTime? ownerValidatedAt;
@override@JsonKey(name: 'needs_validation') final  bool needsValidation;
@override@JsonKey(name: 'is_free') final  bool isFree;
@override@JsonKey(name: 'borrower_total') final  double? borrowerTotal;
@override@JsonKey(name: 'owner_total') final  double? ownerTotal;
@override@JsonKey(name: 'owner_action_required') final  bool ownerActionRequired;
@override@JsonKey(name: 'borrower_action_required') final  bool borrowerActionRequired;
@override@JsonKey(name: 'is_self_service') final  bool isSelfService;
@override@JsonKey(name: 'estimated_distance') final  int? estimatedDistance;
@override@JsonKey(name: 'actual_distance') final  int? actualDistance;
@override@JsonKey(name: 'mileage_start') final  int? mileageStart;
@override@JsonKey(name: 'mileage_end') final  int? mileageEnd;
@override@JsonKey(name: 'requires_mileage') final  bool? requiresMileage;
@override@JsonKey(name: 'requires_detailed_mileage') final  bool? requiresDetailedMileage;
@override@JsonKey(name: 'alternative_to') final  String? alternativeTo;
@override@JsonKey(name: 'alternative_to_other') final  String? alternativeToOther;
@override final  String? comment;
 final  List<LoanComment> _comments;
@override@JsonKey() List<LoanComment> get comments {
  if (_comments is EqualUnmodifiableListView) return _comments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_comments);
}

@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'extension_duration_in_minutes') final  int? extensionDurationInMinutes;
// Payment and return information, as exposed by Laravel LoanResource.
@override@JsonKey(name: 'platform_tip') final  double? platformTip;
@override@JsonKey(name: 'desired_contribution') final  double? desiredContribution;
@override@JsonKey(name: 'borrower_may_contribute') final  bool borrowerMayContribute;
@override@JsonKey(name: 'borrower_must_pay_compensation') final  bool borrowerMustPayCompensation;
@override@JsonKey(name: 'borrower_must_pay_insurance') final  bool borrowerMustPayInsurance;
 final  Map<String, dynamic>? _applicableAmountTypes;
@override@JsonKey(name: 'applicable_amount_types') Map<String, dynamic>? get applicableAmountTypes {
  final value = _applicableAmountTypes;
  if (value == null) return null;
  if (_applicableAmountTypes is EqualUnmodifiableMapView) return _applicableAmountTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(name: 'can_add_expenses') final  bool canAddExpenses;
@override@JsonKey(name: 'expenses_amount') final  double? expensesAmount;
 final  Map<String, dynamic>? _mileageStartImage;
@override@JsonKey(name: 'mileage_start_image') Map<String, dynamic>? get mileageStartImage {
  final value = _mileageStartImage;
  if (value == null) return null;
  if (_mileageStartImage is EqualUnmodifiableMapView) return _mileageStartImage;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _mileageEndImage;
@override@JsonKey(name: 'mileage_end_image') Map<String, dynamic>? get mileageEndImage {
  final value = _mileageEndImage;
  if (value == null) return null;
  if (_mileageEndImage is EqualUnmodifiableMapView) return _mileageEndImage;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _expenseImage;
@override@JsonKey(name: 'expense_image') Map<String, dynamic>? get expenseImage {
  final value = _expenseImage;
  if (value == null) return null;
  if (_expenseImage is EqualUnmodifiableMapView) return _expenseImage;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _borrowerInvoiceJson;
@override@JsonKey(name: 'borrower_invoice') Map<String, dynamic>? get borrowerInvoiceJson {
  final value = _borrowerInvoiceJson;
  if (value == null) return null;
  if (_borrowerInvoiceJson is EqualUnmodifiableMapView) return _borrowerInvoiceJson;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanCopyWith<_Loan> get copyWith => __$LoanCopyWithImpl<_Loan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoanToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loan&&(identical(other.id, id) || other.id == id)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&(identical(other.status, status) || other.status == status)&&(identical(other.loanableId, loanableId) || other.loanableId == loanableId)&&(identical(other.loanableName, loanableName) || other.loanableName == loanableName)&&(identical(other.loanable, loanable) || other.loanable == loanable)&&(identical(other.communityId, communityId) || other.communityId == communityId)&&(identical(other.communityName, communityName) || other.communityName == communityName)&&(identical(other.borrowerUserId, borrowerUserId) || other.borrowerUserId == borrowerUserId)&&(identical(other.borrowerUserName, borrowerUserName) || other.borrowerUserName == borrowerUserName)&&(identical(other.borrowerUserEmail, borrowerUserEmail) || other.borrowerUserEmail == borrowerUserEmail)&&(identical(other.borrowerUserPhone, borrowerUserPhone) || other.borrowerUserPhone == borrowerUserPhone)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.prepaidAt, prepaidAt) || other.prepaidAt == prepaidAt)&&(identical(other.canceledAt, canceledAt) || other.canceledAt == canceledAt)&&(identical(other.actualReturnAt, actualReturnAt) || other.actualReturnAt == actualReturnAt)&&(identical(other.borrowerValidatedAt, borrowerValidatedAt) || other.borrowerValidatedAt == borrowerValidatedAt)&&(identical(other.ownerValidatedAt, ownerValidatedAt) || other.ownerValidatedAt == ownerValidatedAt)&&(identical(other.needsValidation, needsValidation) || other.needsValidation == needsValidation)&&(identical(other.isFree, isFree) || other.isFree == isFree)&&(identical(other.borrowerTotal, borrowerTotal) || other.borrowerTotal == borrowerTotal)&&(identical(other.ownerTotal, ownerTotal) || other.ownerTotal == ownerTotal)&&(identical(other.ownerActionRequired, ownerActionRequired) || other.ownerActionRequired == ownerActionRequired)&&(identical(other.borrowerActionRequired, borrowerActionRequired) || other.borrowerActionRequired == borrowerActionRequired)&&(identical(other.isSelfService, isSelfService) || other.isSelfService == isSelfService)&&(identical(other.estimatedDistance, estimatedDistance) || other.estimatedDistance == estimatedDistance)&&(identical(other.actualDistance, actualDistance) || other.actualDistance == actualDistance)&&(identical(other.mileageStart, mileageStart) || other.mileageStart == mileageStart)&&(identical(other.mileageEnd, mileageEnd) || other.mileageEnd == mileageEnd)&&(identical(other.requiresMileage, requiresMileage) || other.requiresMileage == requiresMileage)&&(identical(other.requiresDetailedMileage, requiresDetailedMileage) || other.requiresDetailedMileage == requiresDetailedMileage)&&(identical(other.alternativeTo, alternativeTo) || other.alternativeTo == alternativeTo)&&(identical(other.alternativeToOther, alternativeToOther) || other.alternativeToOther == alternativeToOther)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other._comments, _comments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.extensionDurationInMinutes, extensionDurationInMinutes) || other.extensionDurationInMinutes == extensionDurationInMinutes)&&(identical(other.platformTip, platformTip) || other.platformTip == platformTip)&&(identical(other.desiredContribution, desiredContribution) || other.desiredContribution == desiredContribution)&&(identical(other.borrowerMayContribute, borrowerMayContribute) || other.borrowerMayContribute == borrowerMayContribute)&&(identical(other.borrowerMustPayCompensation, borrowerMustPayCompensation) || other.borrowerMustPayCompensation == borrowerMustPayCompensation)&&(identical(other.borrowerMustPayInsurance, borrowerMustPayInsurance) || other.borrowerMustPayInsurance == borrowerMustPayInsurance)&&const DeepCollectionEquality().equals(other._applicableAmountTypes, _applicableAmountTypes)&&(identical(other.canAddExpenses, canAddExpenses) || other.canAddExpenses == canAddExpenses)&&(identical(other.expensesAmount, expensesAmount) || other.expensesAmount == expensesAmount)&&const DeepCollectionEquality().equals(other._mileageStartImage, _mileageStartImage)&&const DeepCollectionEquality().equals(other._mileageEndImage, _mileageEndImage)&&const DeepCollectionEquality().equals(other._expenseImage, _expenseImage)&&const DeepCollectionEquality().equals(other._borrowerInvoiceJson, _borrowerInvoiceJson));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,departureAt,durationInMinutes,status,loanableId,loanableName,loanable,communityId,communityName,borrowerUserId,borrowerUserName,borrowerUserEmail,borrowerUserPhone,acceptedAt,prepaidAt,canceledAt,actualReturnAt,borrowerValidatedAt,ownerValidatedAt,needsValidation,isFree,borrowerTotal,ownerTotal,ownerActionRequired,borrowerActionRequired,isSelfService,estimatedDistance,actualDistance,mileageStart,mileageEnd,requiresMileage,requiresDetailedMileage,alternativeTo,alternativeToOther,comment,const DeepCollectionEquality().hash(_comments),createdAt,extensionDurationInMinutes,platformTip,desiredContribution,borrowerMayContribute,borrowerMustPayCompensation,borrowerMustPayInsurance,const DeepCollectionEquality().hash(_applicableAmountTypes),canAddExpenses,expensesAmount,const DeepCollectionEquality().hash(_mileageStartImage),const DeepCollectionEquality().hash(_mileageEndImage),const DeepCollectionEquality().hash(_expenseImage),const DeepCollectionEquality().hash(_borrowerInvoiceJson)]);

@override
String toString() {
  return 'Loan(id: $id, departureAt: $departureAt, durationInMinutes: $durationInMinutes, status: $status, loanableId: $loanableId, loanableName: $loanableName, loanable: $loanable, communityId: $communityId, communityName: $communityName, borrowerUserId: $borrowerUserId, borrowerUserName: $borrowerUserName, borrowerUserEmail: $borrowerUserEmail, borrowerUserPhone: $borrowerUserPhone, acceptedAt: $acceptedAt, prepaidAt: $prepaidAt, canceledAt: $canceledAt, actualReturnAt: $actualReturnAt, borrowerValidatedAt: $borrowerValidatedAt, ownerValidatedAt: $ownerValidatedAt, needsValidation: $needsValidation, isFree: $isFree, borrowerTotal: $borrowerTotal, ownerTotal: $ownerTotal, ownerActionRequired: $ownerActionRequired, borrowerActionRequired: $borrowerActionRequired, isSelfService: $isSelfService, estimatedDistance: $estimatedDistance, actualDistance: $actualDistance, mileageStart: $mileageStart, mileageEnd: $mileageEnd, requiresMileage: $requiresMileage, requiresDetailedMileage: $requiresDetailedMileage, alternativeTo: $alternativeTo, alternativeToOther: $alternativeToOther, comment: $comment, comments: $comments, createdAt: $createdAt, extensionDurationInMinutes: $extensionDurationInMinutes, platformTip: $platformTip, desiredContribution: $desiredContribution, borrowerMayContribute: $borrowerMayContribute, borrowerMustPayCompensation: $borrowerMustPayCompensation, borrowerMustPayInsurance: $borrowerMustPayInsurance, applicableAmountTypes: $applicableAmountTypes, canAddExpenses: $canAddExpenses, expensesAmount: $expensesAmount, mileageStartImage: $mileageStartImage, mileageEndImage: $mileageEndImage, expenseImage: $expenseImage, borrowerInvoiceJson: $borrowerInvoiceJson)';
}


}

/// @nodoc
abstract mixin class _$LoanCopyWith<$Res> implements $LoanCopyWith<$Res> {
  factory _$LoanCopyWith(_Loan value, $Res Function(_Loan) _then) = __$LoanCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'departure_at') DateTime departureAt,@JsonKey(name: 'duration_in_minutes') int durationInMinutes,@JsonKey(name: 'status') String status,@JsonKey(name: 'loanable_id') int? loanableId,@JsonKey(name: 'loanable_name') String? loanableName,@LoanableConverter() Loanable? loanable,@JsonKey(name: 'community_id') int? communityId,@JsonKey(name: 'community_name') String? communityName,@JsonKey(name: 'borrower_user_id') int? borrowerUserId,@JsonKey(name: 'borrower_user_name') String? borrowerUserName,@JsonKey(name: 'borrower_user_email') String? borrowerUserEmail,@JsonKey(name: 'borrower_user_phone') String? borrowerUserPhone,@JsonKey(name: 'accepted_at') DateTime? acceptedAt,@JsonKey(name: 'prepaid_at') DateTime? prepaidAt,@JsonKey(name: 'canceled_at') DateTime? canceledAt,@JsonKey(name: 'actual_return_at') DateTime? actualReturnAt,@JsonKey(name: 'borrower_validated_at') DateTime? borrowerValidatedAt,@JsonKey(name: 'owner_validated_at') DateTime? ownerValidatedAt,@JsonKey(name: 'needs_validation') bool needsValidation,@JsonKey(name: 'is_free') bool isFree,@JsonKey(name: 'borrower_total') double? borrowerTotal,@JsonKey(name: 'owner_total') double? ownerTotal,@JsonKey(name: 'owner_action_required') bool ownerActionRequired,@JsonKey(name: 'borrower_action_required') bool borrowerActionRequired,@JsonKey(name: 'is_self_service') bool isSelfService,@JsonKey(name: 'estimated_distance') int? estimatedDistance,@JsonKey(name: 'actual_distance') int? actualDistance,@JsonKey(name: 'mileage_start') int? mileageStart,@JsonKey(name: 'mileage_end') int? mileageEnd,@JsonKey(name: 'requires_mileage') bool? requiresMileage,@JsonKey(name: 'requires_detailed_mileage') bool? requiresDetailedMileage,@JsonKey(name: 'alternative_to') String? alternativeTo,@JsonKey(name: 'alternative_to_other') String? alternativeToOther, String? comment, List<LoanComment> comments,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'extension_duration_in_minutes') int? extensionDurationInMinutes,@JsonKey(name: 'platform_tip') double? platformTip,@JsonKey(name: 'desired_contribution') double? desiredContribution,@JsonKey(name: 'borrower_may_contribute') bool borrowerMayContribute,@JsonKey(name: 'borrower_must_pay_compensation') bool borrowerMustPayCompensation,@JsonKey(name: 'borrower_must_pay_insurance') bool borrowerMustPayInsurance,@JsonKey(name: 'applicable_amount_types') Map<String, dynamic>? applicableAmountTypes,@JsonKey(name: 'can_add_expenses') bool canAddExpenses,@JsonKey(name: 'expenses_amount') double? expensesAmount,@JsonKey(name: 'mileage_start_image') Map<String, dynamic>? mileageStartImage,@JsonKey(name: 'mileage_end_image') Map<String, dynamic>? mileageEndImage,@JsonKey(name: 'expense_image') Map<String, dynamic>? expenseImage,@JsonKey(name: 'borrower_invoice') Map<String, dynamic>? borrowerInvoiceJson
});


@override $LoanableCopyWith<$Res>? get loanable;

}
/// @nodoc
class __$LoanCopyWithImpl<$Res>
    implements _$LoanCopyWith<$Res> {
  __$LoanCopyWithImpl(this._self, this._then);

  final _Loan _self;
  final $Res Function(_Loan) _then;

/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? departureAt = null,Object? durationInMinutes = null,Object? status = null,Object? loanableId = freezed,Object? loanableName = freezed,Object? loanable = freezed,Object? communityId = freezed,Object? communityName = freezed,Object? borrowerUserId = freezed,Object? borrowerUserName = freezed,Object? borrowerUserEmail = freezed,Object? borrowerUserPhone = freezed,Object? acceptedAt = freezed,Object? prepaidAt = freezed,Object? canceledAt = freezed,Object? actualReturnAt = freezed,Object? borrowerValidatedAt = freezed,Object? ownerValidatedAt = freezed,Object? needsValidation = null,Object? isFree = null,Object? borrowerTotal = freezed,Object? ownerTotal = freezed,Object? ownerActionRequired = null,Object? borrowerActionRequired = null,Object? isSelfService = null,Object? estimatedDistance = freezed,Object? actualDistance = freezed,Object? mileageStart = freezed,Object? mileageEnd = freezed,Object? requiresMileage = freezed,Object? requiresDetailedMileage = freezed,Object? alternativeTo = freezed,Object? alternativeToOther = freezed,Object? comment = freezed,Object? comments = null,Object? createdAt = freezed,Object? extensionDurationInMinutes = freezed,Object? platformTip = freezed,Object? desiredContribution = freezed,Object? borrowerMayContribute = null,Object? borrowerMustPayCompensation = null,Object? borrowerMustPayInsurance = null,Object? applicableAmountTypes = freezed,Object? canAddExpenses = null,Object? expensesAmount = freezed,Object? mileageStartImage = freezed,Object? mileageEndImage = freezed,Object? expenseImage = freezed,Object? borrowerInvoiceJson = freezed,}) {
  return _then(_Loan(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,departureAt: null == departureAt ? _self.departureAt : departureAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationInMinutes: null == durationInMinutes ? _self.durationInMinutes : durationInMinutes // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,loanableId: freezed == loanableId ? _self.loanableId : loanableId // ignore: cast_nullable_to_non_nullable
as int?,loanableName: freezed == loanableName ? _self.loanableName : loanableName // ignore: cast_nullable_to_non_nullable
as String?,loanable: freezed == loanable ? _self.loanable : loanable // ignore: cast_nullable_to_non_nullable
as Loanable?,communityId: freezed == communityId ? _self.communityId : communityId // ignore: cast_nullable_to_non_nullable
as int?,communityName: freezed == communityName ? _self.communityName : communityName // ignore: cast_nullable_to_non_nullable
as String?,borrowerUserId: freezed == borrowerUserId ? _self.borrowerUserId : borrowerUserId // ignore: cast_nullable_to_non_nullable
as int?,borrowerUserName: freezed == borrowerUserName ? _self.borrowerUserName : borrowerUserName // ignore: cast_nullable_to_non_nullable
as String?,borrowerUserEmail: freezed == borrowerUserEmail ? _self.borrowerUserEmail : borrowerUserEmail // ignore: cast_nullable_to_non_nullable
as String?,borrowerUserPhone: freezed == borrowerUserPhone ? _self.borrowerUserPhone : borrowerUserPhone // ignore: cast_nullable_to_non_nullable
as String?,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,prepaidAt: freezed == prepaidAt ? _self.prepaidAt : prepaidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,canceledAt: freezed == canceledAt ? _self.canceledAt : canceledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,actualReturnAt: freezed == actualReturnAt ? _self.actualReturnAt : actualReturnAt // ignore: cast_nullable_to_non_nullable
as DateTime?,borrowerValidatedAt: freezed == borrowerValidatedAt ? _self.borrowerValidatedAt : borrowerValidatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,ownerValidatedAt: freezed == ownerValidatedAt ? _self.ownerValidatedAt : ownerValidatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,needsValidation: null == needsValidation ? _self.needsValidation : needsValidation // ignore: cast_nullable_to_non_nullable
as bool,isFree: null == isFree ? _self.isFree : isFree // ignore: cast_nullable_to_non_nullable
as bool,borrowerTotal: freezed == borrowerTotal ? _self.borrowerTotal : borrowerTotal // ignore: cast_nullable_to_non_nullable
as double?,ownerTotal: freezed == ownerTotal ? _self.ownerTotal : ownerTotal // ignore: cast_nullable_to_non_nullable
as double?,ownerActionRequired: null == ownerActionRequired ? _self.ownerActionRequired : ownerActionRequired // ignore: cast_nullable_to_non_nullable
as bool,borrowerActionRequired: null == borrowerActionRequired ? _self.borrowerActionRequired : borrowerActionRequired // ignore: cast_nullable_to_non_nullable
as bool,isSelfService: null == isSelfService ? _self.isSelfService : isSelfService // ignore: cast_nullable_to_non_nullable
as bool,estimatedDistance: freezed == estimatedDistance ? _self.estimatedDistance : estimatedDistance // ignore: cast_nullable_to_non_nullable
as int?,actualDistance: freezed == actualDistance ? _self.actualDistance : actualDistance // ignore: cast_nullable_to_non_nullable
as int?,mileageStart: freezed == mileageStart ? _self.mileageStart : mileageStart // ignore: cast_nullable_to_non_nullable
as int?,mileageEnd: freezed == mileageEnd ? _self.mileageEnd : mileageEnd // ignore: cast_nullable_to_non_nullable
as int?,requiresMileage: freezed == requiresMileage ? _self.requiresMileage : requiresMileage // ignore: cast_nullable_to_non_nullable
as bool?,requiresDetailedMileage: freezed == requiresDetailedMileage ? _self.requiresDetailedMileage : requiresDetailedMileage // ignore: cast_nullable_to_non_nullable
as bool?,alternativeTo: freezed == alternativeTo ? _self.alternativeTo : alternativeTo // ignore: cast_nullable_to_non_nullable
as String?,alternativeToOther: freezed == alternativeToOther ? _self.alternativeToOther : alternativeToOther // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,comments: null == comments ? _self._comments : comments // ignore: cast_nullable_to_non_nullable
as List<LoanComment>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,extensionDurationInMinutes: freezed == extensionDurationInMinutes ? _self.extensionDurationInMinutes : extensionDurationInMinutes // ignore: cast_nullable_to_non_nullable
as int?,platformTip: freezed == platformTip ? _self.platformTip : platformTip // ignore: cast_nullable_to_non_nullable
as double?,desiredContribution: freezed == desiredContribution ? _self.desiredContribution : desiredContribution // ignore: cast_nullable_to_non_nullable
as double?,borrowerMayContribute: null == borrowerMayContribute ? _self.borrowerMayContribute : borrowerMayContribute // ignore: cast_nullable_to_non_nullable
as bool,borrowerMustPayCompensation: null == borrowerMustPayCompensation ? _self.borrowerMustPayCompensation : borrowerMustPayCompensation // ignore: cast_nullable_to_non_nullable
as bool,borrowerMustPayInsurance: null == borrowerMustPayInsurance ? _self.borrowerMustPayInsurance : borrowerMustPayInsurance // ignore: cast_nullable_to_non_nullable
as bool,applicableAmountTypes: freezed == applicableAmountTypes ? _self._applicableAmountTypes : applicableAmountTypes // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,canAddExpenses: null == canAddExpenses ? _self.canAddExpenses : canAddExpenses // ignore: cast_nullable_to_non_nullable
as bool,expensesAmount: freezed == expensesAmount ? _self.expensesAmount : expensesAmount // ignore: cast_nullable_to_non_nullable
as double?,mileageStartImage: freezed == mileageStartImage ? _self._mileageStartImage : mileageStartImage // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,mileageEndImage: freezed == mileageEndImage ? _self._mileageEndImage : mileageEndImage // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,expenseImage: freezed == expenseImage ? _self._expenseImage : expenseImage // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,borrowerInvoiceJson: freezed == borrowerInvoiceJson ? _self._borrowerInvoiceJson : borrowerInvoiceJson // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoanableCopyWith<$Res>? get loanable {
    if (_self.loanable == null) {
    return null;
  }

  return $LoanableCopyWith<$Res>(_self.loanable!, (value) {
    return _then(_self.copyWith(loanable: value));
  });
}
}

// dart format on

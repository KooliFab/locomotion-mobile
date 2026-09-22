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

 int get id;@JsonKey(name: 'departure_at') DateTime get departureAt;@JsonKey(name: 'duration_in_minutes') int get durationInMinutes;@JsonKey(name: 'status') String get status;@JsonKey(name: 'loanable_id') int? get loanableId;@JsonKey(name: 'loanable_name') String? get loanableName;@LoanableConverter() Loanable? get loanable;@JsonKey(name: 'community_id') int? get communityId;@JsonKey(name: 'community_name') String? get communityName;@JsonKey(name: 'borrower_user_id') int? get borrowerUserId;@JsonKey(name: 'borrower_user_name') String? get borrowerUserName;@JsonKey(name: 'actual_return_at') DateTime? get actualReturnAt;@JsonKey(name: 'borrower_validated_at') DateTime? get borrowerValidatedAt;@JsonKey(name: 'owner_validated_at') DateTime? get ownerValidatedAt;@JsonKey(name: 'needs_validation') bool get needsValidation;@JsonKey(name: 'borrower_total') double? get borrowerTotal;@JsonKey(name: 'owner_total') double? get ownerTotal;@JsonKey(name: 'owner_action_required') bool get ownerActionRequired;@JsonKey(name: 'borrower_action_required') bool get borrowerActionRequired;@JsonKey(name: 'is_self_service') bool get isSelfService;@JsonKey(name: 'estimated_distance') int? get estimatedDistance;@JsonKey(name: 'actual_distance') int? get actualDistance;@JsonKey(name: 'alternative_to') String? get alternativeTo;@JsonKey(name: 'alternative_to_other') String? get alternativeToOther; String? get comment;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of Loan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanCopyWith<Loan> get copyWith => _$LoanCopyWithImpl<Loan>(this as Loan, _$identity);

  /// Serializes this Loan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loan&&(identical(other.id, id) || other.id == id)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&(identical(other.status, status) || other.status == status)&&(identical(other.loanableId, loanableId) || other.loanableId == loanableId)&&(identical(other.loanableName, loanableName) || other.loanableName == loanableName)&&(identical(other.loanable, loanable) || other.loanable == loanable)&&(identical(other.communityId, communityId) || other.communityId == communityId)&&(identical(other.communityName, communityName) || other.communityName == communityName)&&(identical(other.borrowerUserId, borrowerUserId) || other.borrowerUserId == borrowerUserId)&&(identical(other.borrowerUserName, borrowerUserName) || other.borrowerUserName == borrowerUserName)&&(identical(other.actualReturnAt, actualReturnAt) || other.actualReturnAt == actualReturnAt)&&(identical(other.borrowerValidatedAt, borrowerValidatedAt) || other.borrowerValidatedAt == borrowerValidatedAt)&&(identical(other.ownerValidatedAt, ownerValidatedAt) || other.ownerValidatedAt == ownerValidatedAt)&&(identical(other.needsValidation, needsValidation) || other.needsValidation == needsValidation)&&(identical(other.borrowerTotal, borrowerTotal) || other.borrowerTotal == borrowerTotal)&&(identical(other.ownerTotal, ownerTotal) || other.ownerTotal == ownerTotal)&&(identical(other.ownerActionRequired, ownerActionRequired) || other.ownerActionRequired == ownerActionRequired)&&(identical(other.borrowerActionRequired, borrowerActionRequired) || other.borrowerActionRequired == borrowerActionRequired)&&(identical(other.isSelfService, isSelfService) || other.isSelfService == isSelfService)&&(identical(other.estimatedDistance, estimatedDistance) || other.estimatedDistance == estimatedDistance)&&(identical(other.actualDistance, actualDistance) || other.actualDistance == actualDistance)&&(identical(other.alternativeTo, alternativeTo) || other.alternativeTo == alternativeTo)&&(identical(other.alternativeToOther, alternativeToOther) || other.alternativeToOther == alternativeToOther)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,departureAt,durationInMinutes,status,loanableId,loanableName,loanable,communityId,communityName,borrowerUserId,borrowerUserName,actualReturnAt,borrowerValidatedAt,ownerValidatedAt,needsValidation,borrowerTotal,ownerTotal,ownerActionRequired,borrowerActionRequired,isSelfService,estimatedDistance,actualDistance,alternativeTo,alternativeToOther,comment,createdAt]);

@override
String toString() {
  return 'Loan(id: $id, departureAt: $departureAt, durationInMinutes: $durationInMinutes, status: $status, loanableId: $loanableId, loanableName: $loanableName, loanable: $loanable, communityId: $communityId, communityName: $communityName, borrowerUserId: $borrowerUserId, borrowerUserName: $borrowerUserName, actualReturnAt: $actualReturnAt, borrowerValidatedAt: $borrowerValidatedAt, ownerValidatedAt: $ownerValidatedAt, needsValidation: $needsValidation, borrowerTotal: $borrowerTotal, ownerTotal: $ownerTotal, ownerActionRequired: $ownerActionRequired, borrowerActionRequired: $borrowerActionRequired, isSelfService: $isSelfService, estimatedDistance: $estimatedDistance, actualDistance: $actualDistance, alternativeTo: $alternativeTo, alternativeToOther: $alternativeToOther, comment: $comment, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $LoanCopyWith<$Res>  {
  factory $LoanCopyWith(Loan value, $Res Function(Loan) _then) = _$LoanCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'departure_at') DateTime departureAt,@JsonKey(name: 'duration_in_minutes') int durationInMinutes,@JsonKey(name: 'status') String status,@JsonKey(name: 'loanable_id') int? loanableId,@JsonKey(name: 'loanable_name') String? loanableName,@LoanableConverter() Loanable? loanable,@JsonKey(name: 'community_id') int? communityId,@JsonKey(name: 'community_name') String? communityName,@JsonKey(name: 'borrower_user_id') int? borrowerUserId,@JsonKey(name: 'borrower_user_name') String? borrowerUserName,@JsonKey(name: 'actual_return_at') DateTime? actualReturnAt,@JsonKey(name: 'borrower_validated_at') DateTime? borrowerValidatedAt,@JsonKey(name: 'owner_validated_at') DateTime? ownerValidatedAt,@JsonKey(name: 'needs_validation') bool needsValidation,@JsonKey(name: 'borrower_total') double? borrowerTotal,@JsonKey(name: 'owner_total') double? ownerTotal,@JsonKey(name: 'owner_action_required') bool ownerActionRequired,@JsonKey(name: 'borrower_action_required') bool borrowerActionRequired,@JsonKey(name: 'is_self_service') bool isSelfService,@JsonKey(name: 'estimated_distance') int? estimatedDistance,@JsonKey(name: 'actual_distance') int? actualDistance,@JsonKey(name: 'alternative_to') String? alternativeTo,@JsonKey(name: 'alternative_to_other') String? alternativeToOther, String? comment,@JsonKey(name: 'created_at') DateTime? createdAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? departureAt = null,Object? durationInMinutes = null,Object? status = null,Object? loanableId = freezed,Object? loanableName = freezed,Object? loanable = freezed,Object? communityId = freezed,Object? communityName = freezed,Object? borrowerUserId = freezed,Object? borrowerUserName = freezed,Object? actualReturnAt = freezed,Object? borrowerValidatedAt = freezed,Object? ownerValidatedAt = freezed,Object? needsValidation = null,Object? borrowerTotal = freezed,Object? ownerTotal = freezed,Object? ownerActionRequired = null,Object? borrowerActionRequired = null,Object? isSelfService = null,Object? estimatedDistance = freezed,Object? actualDistance = freezed,Object? alternativeTo = freezed,Object? alternativeToOther = freezed,Object? comment = freezed,Object? createdAt = freezed,}) {
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
as String?,actualReturnAt: freezed == actualReturnAt ? _self.actualReturnAt : actualReturnAt // ignore: cast_nullable_to_non_nullable
as DateTime?,borrowerValidatedAt: freezed == borrowerValidatedAt ? _self.borrowerValidatedAt : borrowerValidatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,ownerValidatedAt: freezed == ownerValidatedAt ? _self.ownerValidatedAt : ownerValidatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,needsValidation: null == needsValidation ? _self.needsValidation : needsValidation // ignore: cast_nullable_to_non_nullable
as bool,borrowerTotal: freezed == borrowerTotal ? _self.borrowerTotal : borrowerTotal // ignore: cast_nullable_to_non_nullable
as double?,ownerTotal: freezed == ownerTotal ? _self.ownerTotal : ownerTotal // ignore: cast_nullable_to_non_nullable
as double?,ownerActionRequired: null == ownerActionRequired ? _self.ownerActionRequired : ownerActionRequired // ignore: cast_nullable_to_non_nullable
as bool,borrowerActionRequired: null == borrowerActionRequired ? _self.borrowerActionRequired : borrowerActionRequired // ignore: cast_nullable_to_non_nullable
as bool,isSelfService: null == isSelfService ? _self.isSelfService : isSelfService // ignore: cast_nullable_to_non_nullable
as bool,estimatedDistance: freezed == estimatedDistance ? _self.estimatedDistance : estimatedDistance // ignore: cast_nullable_to_non_nullable
as int?,actualDistance: freezed == actualDistance ? _self.actualDistance : actualDistance // ignore: cast_nullable_to_non_nullable
as int?,alternativeTo: freezed == alternativeTo ? _self.alternativeTo : alternativeTo // ignore: cast_nullable_to_non_nullable
as String?,alternativeToOther: freezed == alternativeToOther ? _self.alternativeToOther : alternativeToOther // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'departure_at')  DateTime departureAt, @JsonKey(name: 'duration_in_minutes')  int durationInMinutes, @JsonKey(name: 'status')  String status, @JsonKey(name: 'loanable_id')  int? loanableId, @JsonKey(name: 'loanable_name')  String? loanableName, @LoanableConverter()  Loanable? loanable, @JsonKey(name: 'community_id')  int? communityId, @JsonKey(name: 'community_name')  String? communityName, @JsonKey(name: 'borrower_user_id')  int? borrowerUserId, @JsonKey(name: 'borrower_user_name')  String? borrowerUserName, @JsonKey(name: 'actual_return_at')  DateTime? actualReturnAt, @JsonKey(name: 'borrower_validated_at')  DateTime? borrowerValidatedAt, @JsonKey(name: 'owner_validated_at')  DateTime? ownerValidatedAt, @JsonKey(name: 'needs_validation')  bool needsValidation, @JsonKey(name: 'borrower_total')  double? borrowerTotal, @JsonKey(name: 'owner_total')  double? ownerTotal, @JsonKey(name: 'owner_action_required')  bool ownerActionRequired, @JsonKey(name: 'borrower_action_required')  bool borrowerActionRequired, @JsonKey(name: 'is_self_service')  bool isSelfService, @JsonKey(name: 'estimated_distance')  int? estimatedDistance, @JsonKey(name: 'actual_distance')  int? actualDistance, @JsonKey(name: 'alternative_to')  String? alternativeTo, @JsonKey(name: 'alternative_to_other')  String? alternativeToOther,  String? comment, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loan() when $default != null:
return $default(_that.id,_that.departureAt,_that.durationInMinutes,_that.status,_that.loanableId,_that.loanableName,_that.loanable,_that.communityId,_that.communityName,_that.borrowerUserId,_that.borrowerUserName,_that.actualReturnAt,_that.borrowerValidatedAt,_that.ownerValidatedAt,_that.needsValidation,_that.borrowerTotal,_that.ownerTotal,_that.ownerActionRequired,_that.borrowerActionRequired,_that.isSelfService,_that.estimatedDistance,_that.actualDistance,_that.alternativeTo,_that.alternativeToOther,_that.comment,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'departure_at')  DateTime departureAt, @JsonKey(name: 'duration_in_minutes')  int durationInMinutes, @JsonKey(name: 'status')  String status, @JsonKey(name: 'loanable_id')  int? loanableId, @JsonKey(name: 'loanable_name')  String? loanableName, @LoanableConverter()  Loanable? loanable, @JsonKey(name: 'community_id')  int? communityId, @JsonKey(name: 'community_name')  String? communityName, @JsonKey(name: 'borrower_user_id')  int? borrowerUserId, @JsonKey(name: 'borrower_user_name')  String? borrowerUserName, @JsonKey(name: 'actual_return_at')  DateTime? actualReturnAt, @JsonKey(name: 'borrower_validated_at')  DateTime? borrowerValidatedAt, @JsonKey(name: 'owner_validated_at')  DateTime? ownerValidatedAt, @JsonKey(name: 'needs_validation')  bool needsValidation, @JsonKey(name: 'borrower_total')  double? borrowerTotal, @JsonKey(name: 'owner_total')  double? ownerTotal, @JsonKey(name: 'owner_action_required')  bool ownerActionRequired, @JsonKey(name: 'borrower_action_required')  bool borrowerActionRequired, @JsonKey(name: 'is_self_service')  bool isSelfService, @JsonKey(name: 'estimated_distance')  int? estimatedDistance, @JsonKey(name: 'actual_distance')  int? actualDistance, @JsonKey(name: 'alternative_to')  String? alternativeTo, @JsonKey(name: 'alternative_to_other')  String? alternativeToOther,  String? comment, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Loan():
return $default(_that.id,_that.departureAt,_that.durationInMinutes,_that.status,_that.loanableId,_that.loanableName,_that.loanable,_that.communityId,_that.communityName,_that.borrowerUserId,_that.borrowerUserName,_that.actualReturnAt,_that.borrowerValidatedAt,_that.ownerValidatedAt,_that.needsValidation,_that.borrowerTotal,_that.ownerTotal,_that.ownerActionRequired,_that.borrowerActionRequired,_that.isSelfService,_that.estimatedDistance,_that.actualDistance,_that.alternativeTo,_that.alternativeToOther,_that.comment,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'departure_at')  DateTime departureAt, @JsonKey(name: 'duration_in_minutes')  int durationInMinutes, @JsonKey(name: 'status')  String status, @JsonKey(name: 'loanable_id')  int? loanableId, @JsonKey(name: 'loanable_name')  String? loanableName, @LoanableConverter()  Loanable? loanable, @JsonKey(name: 'community_id')  int? communityId, @JsonKey(name: 'community_name')  String? communityName, @JsonKey(name: 'borrower_user_id')  int? borrowerUserId, @JsonKey(name: 'borrower_user_name')  String? borrowerUserName, @JsonKey(name: 'actual_return_at')  DateTime? actualReturnAt, @JsonKey(name: 'borrower_validated_at')  DateTime? borrowerValidatedAt, @JsonKey(name: 'owner_validated_at')  DateTime? ownerValidatedAt, @JsonKey(name: 'needs_validation')  bool needsValidation, @JsonKey(name: 'borrower_total')  double? borrowerTotal, @JsonKey(name: 'owner_total')  double? ownerTotal, @JsonKey(name: 'owner_action_required')  bool ownerActionRequired, @JsonKey(name: 'borrower_action_required')  bool borrowerActionRequired, @JsonKey(name: 'is_self_service')  bool isSelfService, @JsonKey(name: 'estimated_distance')  int? estimatedDistance, @JsonKey(name: 'actual_distance')  int? actualDistance, @JsonKey(name: 'alternative_to')  String? alternativeTo, @JsonKey(name: 'alternative_to_other')  String? alternativeToOther,  String? comment, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Loan() when $default != null:
return $default(_that.id,_that.departureAt,_that.durationInMinutes,_that.status,_that.loanableId,_that.loanableName,_that.loanable,_that.communityId,_that.communityName,_that.borrowerUserId,_that.borrowerUserName,_that.actualReturnAt,_that.borrowerValidatedAt,_that.ownerValidatedAt,_that.needsValidation,_that.borrowerTotal,_that.ownerTotal,_that.ownerActionRequired,_that.borrowerActionRequired,_that.isSelfService,_that.estimatedDistance,_that.actualDistance,_that.alternativeTo,_that.alternativeToOther,_that.comment,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Loan extends Loan {
  const _Loan({required this.id, @JsonKey(name: 'departure_at') required this.departureAt, @JsonKey(name: 'duration_in_minutes') required this.durationInMinutes, @JsonKey(name: 'status') required this.status, @JsonKey(name: 'loanable_id') this.loanableId, @JsonKey(name: 'loanable_name') this.loanableName, @LoanableConverter() this.loanable, @JsonKey(name: 'community_id') this.communityId, @JsonKey(name: 'community_name') this.communityName, @JsonKey(name: 'borrower_user_id') this.borrowerUserId, @JsonKey(name: 'borrower_user_name') this.borrowerUserName, @JsonKey(name: 'actual_return_at') this.actualReturnAt, @JsonKey(name: 'borrower_validated_at') this.borrowerValidatedAt, @JsonKey(name: 'owner_validated_at') this.ownerValidatedAt, @JsonKey(name: 'needs_validation') this.needsValidation = false, @JsonKey(name: 'borrower_total') this.borrowerTotal, @JsonKey(name: 'owner_total') this.ownerTotal, @JsonKey(name: 'owner_action_required') this.ownerActionRequired = false, @JsonKey(name: 'borrower_action_required') this.borrowerActionRequired = false, @JsonKey(name: 'is_self_service') this.isSelfService = false, @JsonKey(name: 'estimated_distance') this.estimatedDistance, @JsonKey(name: 'actual_distance') this.actualDistance, @JsonKey(name: 'alternative_to') this.alternativeTo, @JsonKey(name: 'alternative_to_other') this.alternativeToOther, this.comment, @JsonKey(name: 'created_at') this.createdAt}): super._();
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
@override@JsonKey(name: 'actual_return_at') final  DateTime? actualReturnAt;
@override@JsonKey(name: 'borrower_validated_at') final  DateTime? borrowerValidatedAt;
@override@JsonKey(name: 'owner_validated_at') final  DateTime? ownerValidatedAt;
@override@JsonKey(name: 'needs_validation') final  bool needsValidation;
@override@JsonKey(name: 'borrower_total') final  double? borrowerTotal;
@override@JsonKey(name: 'owner_total') final  double? ownerTotal;
@override@JsonKey(name: 'owner_action_required') final  bool ownerActionRequired;
@override@JsonKey(name: 'borrower_action_required') final  bool borrowerActionRequired;
@override@JsonKey(name: 'is_self_service') final  bool isSelfService;
@override@JsonKey(name: 'estimated_distance') final  int? estimatedDistance;
@override@JsonKey(name: 'actual_distance') final  int? actualDistance;
@override@JsonKey(name: 'alternative_to') final  String? alternativeTo;
@override@JsonKey(name: 'alternative_to_other') final  String? alternativeToOther;
@override final  String? comment;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loan&&(identical(other.id, id) || other.id == id)&&(identical(other.departureAt, departureAt) || other.departureAt == departureAt)&&(identical(other.durationInMinutes, durationInMinutes) || other.durationInMinutes == durationInMinutes)&&(identical(other.status, status) || other.status == status)&&(identical(other.loanableId, loanableId) || other.loanableId == loanableId)&&(identical(other.loanableName, loanableName) || other.loanableName == loanableName)&&(identical(other.loanable, loanable) || other.loanable == loanable)&&(identical(other.communityId, communityId) || other.communityId == communityId)&&(identical(other.communityName, communityName) || other.communityName == communityName)&&(identical(other.borrowerUserId, borrowerUserId) || other.borrowerUserId == borrowerUserId)&&(identical(other.borrowerUserName, borrowerUserName) || other.borrowerUserName == borrowerUserName)&&(identical(other.actualReturnAt, actualReturnAt) || other.actualReturnAt == actualReturnAt)&&(identical(other.borrowerValidatedAt, borrowerValidatedAt) || other.borrowerValidatedAt == borrowerValidatedAt)&&(identical(other.ownerValidatedAt, ownerValidatedAt) || other.ownerValidatedAt == ownerValidatedAt)&&(identical(other.needsValidation, needsValidation) || other.needsValidation == needsValidation)&&(identical(other.borrowerTotal, borrowerTotal) || other.borrowerTotal == borrowerTotal)&&(identical(other.ownerTotal, ownerTotal) || other.ownerTotal == ownerTotal)&&(identical(other.ownerActionRequired, ownerActionRequired) || other.ownerActionRequired == ownerActionRequired)&&(identical(other.borrowerActionRequired, borrowerActionRequired) || other.borrowerActionRequired == borrowerActionRequired)&&(identical(other.isSelfService, isSelfService) || other.isSelfService == isSelfService)&&(identical(other.estimatedDistance, estimatedDistance) || other.estimatedDistance == estimatedDistance)&&(identical(other.actualDistance, actualDistance) || other.actualDistance == actualDistance)&&(identical(other.alternativeTo, alternativeTo) || other.alternativeTo == alternativeTo)&&(identical(other.alternativeToOther, alternativeToOther) || other.alternativeToOther == alternativeToOther)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,departureAt,durationInMinutes,status,loanableId,loanableName,loanable,communityId,communityName,borrowerUserId,borrowerUserName,actualReturnAt,borrowerValidatedAt,ownerValidatedAt,needsValidation,borrowerTotal,ownerTotal,ownerActionRequired,borrowerActionRequired,isSelfService,estimatedDistance,actualDistance,alternativeTo,alternativeToOther,comment,createdAt]);

@override
String toString() {
  return 'Loan(id: $id, departureAt: $departureAt, durationInMinutes: $durationInMinutes, status: $status, loanableId: $loanableId, loanableName: $loanableName, loanable: $loanable, communityId: $communityId, communityName: $communityName, borrowerUserId: $borrowerUserId, borrowerUserName: $borrowerUserName, actualReturnAt: $actualReturnAt, borrowerValidatedAt: $borrowerValidatedAt, ownerValidatedAt: $ownerValidatedAt, needsValidation: $needsValidation, borrowerTotal: $borrowerTotal, ownerTotal: $ownerTotal, ownerActionRequired: $ownerActionRequired, borrowerActionRequired: $borrowerActionRequired, isSelfService: $isSelfService, estimatedDistance: $estimatedDistance, actualDistance: $actualDistance, alternativeTo: $alternativeTo, alternativeToOther: $alternativeToOther, comment: $comment, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$LoanCopyWith<$Res> implements $LoanCopyWith<$Res> {
  factory _$LoanCopyWith(_Loan value, $Res Function(_Loan) _then) = __$LoanCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'departure_at') DateTime departureAt,@JsonKey(name: 'duration_in_minutes') int durationInMinutes,@JsonKey(name: 'status') String status,@JsonKey(name: 'loanable_id') int? loanableId,@JsonKey(name: 'loanable_name') String? loanableName,@LoanableConverter() Loanable? loanable,@JsonKey(name: 'community_id') int? communityId,@JsonKey(name: 'community_name') String? communityName,@JsonKey(name: 'borrower_user_id') int? borrowerUserId,@JsonKey(name: 'borrower_user_name') String? borrowerUserName,@JsonKey(name: 'actual_return_at') DateTime? actualReturnAt,@JsonKey(name: 'borrower_validated_at') DateTime? borrowerValidatedAt,@JsonKey(name: 'owner_validated_at') DateTime? ownerValidatedAt,@JsonKey(name: 'needs_validation') bool needsValidation,@JsonKey(name: 'borrower_total') double? borrowerTotal,@JsonKey(name: 'owner_total') double? ownerTotal,@JsonKey(name: 'owner_action_required') bool ownerActionRequired,@JsonKey(name: 'borrower_action_required') bool borrowerActionRequired,@JsonKey(name: 'is_self_service') bool isSelfService,@JsonKey(name: 'estimated_distance') int? estimatedDistance,@JsonKey(name: 'actual_distance') int? actualDistance,@JsonKey(name: 'alternative_to') String? alternativeTo,@JsonKey(name: 'alternative_to_other') String? alternativeToOther, String? comment,@JsonKey(name: 'created_at') DateTime? createdAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? departureAt = null,Object? durationInMinutes = null,Object? status = null,Object? loanableId = freezed,Object? loanableName = freezed,Object? loanable = freezed,Object? communityId = freezed,Object? communityName = freezed,Object? borrowerUserId = freezed,Object? borrowerUserName = freezed,Object? actualReturnAt = freezed,Object? borrowerValidatedAt = freezed,Object? ownerValidatedAt = freezed,Object? needsValidation = null,Object? borrowerTotal = freezed,Object? ownerTotal = freezed,Object? ownerActionRequired = null,Object? borrowerActionRequired = null,Object? isSelfService = null,Object? estimatedDistance = freezed,Object? actualDistance = freezed,Object? alternativeTo = freezed,Object? alternativeToOther = freezed,Object? comment = freezed,Object? createdAt = freezed,}) {
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
as String?,actualReturnAt: freezed == actualReturnAt ? _self.actualReturnAt : actualReturnAt // ignore: cast_nullable_to_non_nullable
as DateTime?,borrowerValidatedAt: freezed == borrowerValidatedAt ? _self.borrowerValidatedAt : borrowerValidatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,ownerValidatedAt: freezed == ownerValidatedAt ? _self.ownerValidatedAt : ownerValidatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,needsValidation: null == needsValidation ? _self.needsValidation : needsValidation // ignore: cast_nullable_to_non_nullable
as bool,borrowerTotal: freezed == borrowerTotal ? _self.borrowerTotal : borrowerTotal // ignore: cast_nullable_to_non_nullable
as double?,ownerTotal: freezed == ownerTotal ? _self.ownerTotal : ownerTotal // ignore: cast_nullable_to_non_nullable
as double?,ownerActionRequired: null == ownerActionRequired ? _self.ownerActionRequired : ownerActionRequired // ignore: cast_nullable_to_non_nullable
as bool,borrowerActionRequired: null == borrowerActionRequired ? _self.borrowerActionRequired : borrowerActionRequired // ignore: cast_nullable_to_non_nullable
as bool,isSelfService: null == isSelfService ? _self.isSelfService : isSelfService // ignore: cast_nullable_to_non_nullable
as bool,estimatedDistance: freezed == estimatedDistance ? _self.estimatedDistance : estimatedDistance // ignore: cast_nullable_to_non_nullable
as int?,actualDistance: freezed == actualDistance ? _self.actualDistance : actualDistance // ignore: cast_nullable_to_non_nullable
as int?,alternativeTo: freezed == alternativeTo ? _self.alternativeTo : alternativeTo // ignore: cast_nullable_to_non_nullable
as String?,alternativeToOther: freezed == alternativeToOther ? _self.alternativeToOther : alternativeToOther // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

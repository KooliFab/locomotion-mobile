// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_creation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoanCreationState {

 LoanDraft get draft; int get currentStep;// 0 = Schedule, 1 = Trip Details, 2 = Summary
 bool get isCheckingAvailability; bool get isSubmitting; String? get availabilityConflictMessage; String? get generalError; Map<String, String>? get fieldErrors; Loan? get createdLoan;
/// Create a copy of LoanCreationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanCreationStateCopyWith<LoanCreationState> get copyWith => _$LoanCreationStateCopyWithImpl<LoanCreationState>(this as LoanCreationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanCreationState&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.isCheckingAvailability, isCheckingAvailability) || other.isCheckingAvailability == isCheckingAvailability)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.availabilityConflictMessage, availabilityConflictMessage) || other.availabilityConflictMessage == availabilityConflictMessage)&&(identical(other.generalError, generalError) || other.generalError == generalError)&&const DeepCollectionEquality().equals(other.fieldErrors, fieldErrors)&&(identical(other.createdLoan, createdLoan) || other.createdLoan == createdLoan));
}


@override
int get hashCode => Object.hash(runtimeType,draft,currentStep,isCheckingAvailability,isSubmitting,availabilityConflictMessage,generalError,const DeepCollectionEquality().hash(fieldErrors),createdLoan);

@override
String toString() {
  return 'LoanCreationState(draft: $draft, currentStep: $currentStep, isCheckingAvailability: $isCheckingAvailability, isSubmitting: $isSubmitting, availabilityConflictMessage: $availabilityConflictMessage, generalError: $generalError, fieldErrors: $fieldErrors, createdLoan: $createdLoan)';
}


}

/// @nodoc
abstract mixin class $LoanCreationStateCopyWith<$Res>  {
  factory $LoanCreationStateCopyWith(LoanCreationState value, $Res Function(LoanCreationState) _then) = _$LoanCreationStateCopyWithImpl;
@useResult
$Res call({
 LoanDraft draft, int currentStep, bool isCheckingAvailability, bool isSubmitting, String? availabilityConflictMessage, String? generalError, Map<String, String>? fieldErrors, Loan? createdLoan
});


$LoanDraftCopyWith<$Res> get draft;$LoanCopyWith<$Res>? get createdLoan;

}
/// @nodoc
class _$LoanCreationStateCopyWithImpl<$Res>
    implements $LoanCreationStateCopyWith<$Res> {
  _$LoanCreationStateCopyWithImpl(this._self, this._then);

  final LoanCreationState _self;
  final $Res Function(LoanCreationState) _then;

/// Create a copy of LoanCreationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? draft = null,Object? currentStep = null,Object? isCheckingAvailability = null,Object? isSubmitting = null,Object? availabilityConflictMessage = freezed,Object? generalError = freezed,Object? fieldErrors = freezed,Object? createdLoan = freezed,}) {
  return _then(_self.copyWith(
draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as LoanDraft,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,isCheckingAvailability: null == isCheckingAvailability ? _self.isCheckingAvailability : isCheckingAvailability // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,availabilityConflictMessage: freezed == availabilityConflictMessage ? _self.availabilityConflictMessage : availabilityConflictMessage // ignore: cast_nullable_to_non_nullable
as String?,generalError: freezed == generalError ? _self.generalError : generalError // ignore: cast_nullable_to_non_nullable
as String?,fieldErrors: freezed == fieldErrors ? _self.fieldErrors : fieldErrors // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,createdLoan: freezed == createdLoan ? _self.createdLoan : createdLoan // ignore: cast_nullable_to_non_nullable
as Loan?,
  ));
}
/// Create a copy of LoanCreationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoanDraftCopyWith<$Res> get draft {
  
  return $LoanDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of LoanCreationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoanCopyWith<$Res>? get createdLoan {
    if (_self.createdLoan == null) {
    return null;
  }

  return $LoanCopyWith<$Res>(_self.createdLoan!, (value) {
    return _then(_self.copyWith(createdLoan: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoanCreationState].
extension LoanCreationStatePatterns on LoanCreationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanCreationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanCreationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanCreationState value)  $default,){
final _that = this;
switch (_that) {
case _LoanCreationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanCreationState value)?  $default,){
final _that = this;
switch (_that) {
case _LoanCreationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoanDraft draft,  int currentStep,  bool isCheckingAvailability,  bool isSubmitting,  String? availabilityConflictMessage,  String? generalError,  Map<String, String>? fieldErrors,  Loan? createdLoan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanCreationState() when $default != null:
return $default(_that.draft,_that.currentStep,_that.isCheckingAvailability,_that.isSubmitting,_that.availabilityConflictMessage,_that.generalError,_that.fieldErrors,_that.createdLoan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoanDraft draft,  int currentStep,  bool isCheckingAvailability,  bool isSubmitting,  String? availabilityConflictMessage,  String? generalError,  Map<String, String>? fieldErrors,  Loan? createdLoan)  $default,) {final _that = this;
switch (_that) {
case _LoanCreationState():
return $default(_that.draft,_that.currentStep,_that.isCheckingAvailability,_that.isSubmitting,_that.availabilityConflictMessage,_that.generalError,_that.fieldErrors,_that.createdLoan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoanDraft draft,  int currentStep,  bool isCheckingAvailability,  bool isSubmitting,  String? availabilityConflictMessage,  String? generalError,  Map<String, String>? fieldErrors,  Loan? createdLoan)?  $default,) {final _that = this;
switch (_that) {
case _LoanCreationState() when $default != null:
return $default(_that.draft,_that.currentStep,_that.isCheckingAvailability,_that.isSubmitting,_that.availabilityConflictMessage,_that.generalError,_that.fieldErrors,_that.createdLoan);case _:
  return null;

}
}

}

/// @nodoc


class _LoanCreationState implements LoanCreationState {
  const _LoanCreationState({required this.draft, this.currentStep = 0, this.isCheckingAvailability = false, this.isSubmitting = false, this.availabilityConflictMessage, this.generalError, final  Map<String, String>? fieldErrors, this.createdLoan}): _fieldErrors = fieldErrors;
  

@override final  LoanDraft draft;
@override@JsonKey() final  int currentStep;
// 0 = Schedule, 1 = Trip Details, 2 = Summary
@override@JsonKey() final  bool isCheckingAvailability;
@override@JsonKey() final  bool isSubmitting;
@override final  String? availabilityConflictMessage;
@override final  String? generalError;
 final  Map<String, String>? _fieldErrors;
@override Map<String, String>? get fieldErrors {
  final value = _fieldErrors;
  if (value == null) return null;
  if (_fieldErrors is EqualUnmodifiableMapView) return _fieldErrors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  Loan? createdLoan;

/// Create a copy of LoanCreationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanCreationStateCopyWith<_LoanCreationState> get copyWith => __$LoanCreationStateCopyWithImpl<_LoanCreationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanCreationState&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.isCheckingAvailability, isCheckingAvailability) || other.isCheckingAvailability == isCheckingAvailability)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.availabilityConflictMessage, availabilityConflictMessage) || other.availabilityConflictMessage == availabilityConflictMessage)&&(identical(other.generalError, generalError) || other.generalError == generalError)&&const DeepCollectionEquality().equals(other._fieldErrors, _fieldErrors)&&(identical(other.createdLoan, createdLoan) || other.createdLoan == createdLoan));
}


@override
int get hashCode => Object.hash(runtimeType,draft,currentStep,isCheckingAvailability,isSubmitting,availabilityConflictMessage,generalError,const DeepCollectionEquality().hash(_fieldErrors),createdLoan);

@override
String toString() {
  return 'LoanCreationState(draft: $draft, currentStep: $currentStep, isCheckingAvailability: $isCheckingAvailability, isSubmitting: $isSubmitting, availabilityConflictMessage: $availabilityConflictMessage, generalError: $generalError, fieldErrors: $fieldErrors, createdLoan: $createdLoan)';
}


}

/// @nodoc
abstract mixin class _$LoanCreationStateCopyWith<$Res> implements $LoanCreationStateCopyWith<$Res> {
  factory _$LoanCreationStateCopyWith(_LoanCreationState value, $Res Function(_LoanCreationState) _then) = __$LoanCreationStateCopyWithImpl;
@override @useResult
$Res call({
 LoanDraft draft, int currentStep, bool isCheckingAvailability, bool isSubmitting, String? availabilityConflictMessage, String? generalError, Map<String, String>? fieldErrors, Loan? createdLoan
});


@override $LoanDraftCopyWith<$Res> get draft;@override $LoanCopyWith<$Res>? get createdLoan;

}
/// @nodoc
class __$LoanCreationStateCopyWithImpl<$Res>
    implements _$LoanCreationStateCopyWith<$Res> {
  __$LoanCreationStateCopyWithImpl(this._self, this._then);

  final _LoanCreationState _self;
  final $Res Function(_LoanCreationState) _then;

/// Create a copy of LoanCreationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? draft = null,Object? currentStep = null,Object? isCheckingAvailability = null,Object? isSubmitting = null,Object? availabilityConflictMessage = freezed,Object? generalError = freezed,Object? fieldErrors = freezed,Object? createdLoan = freezed,}) {
  return _then(_LoanCreationState(
draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as LoanDraft,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as int,isCheckingAvailability: null == isCheckingAvailability ? _self.isCheckingAvailability : isCheckingAvailability // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,availabilityConflictMessage: freezed == availabilityConflictMessage ? _self.availabilityConflictMessage : availabilityConflictMessage // ignore: cast_nullable_to_non_nullable
as String?,generalError: freezed == generalError ? _self.generalError : generalError // ignore: cast_nullable_to_non_nullable
as String?,fieldErrors: freezed == fieldErrors ? _self._fieldErrors : fieldErrors // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,createdLoan: freezed == createdLoan ? _self.createdLoan : createdLoan // ignore: cast_nullable_to_non_nullable
as Loan?,
  ));
}

/// Create a copy of LoanCreationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoanDraftCopyWith<$Res> get draft {
  
  return $LoanDraftCopyWith<$Res>(_self.draft, (value) {
    return _then(_self.copyWith(draft: value));
  });
}/// Create a copy of LoanCreationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LoanCopyWith<$Res>? get createdLoan {
    if (_self.createdLoan == null) {
    return null;
  }

  return $LoanCopyWith<$Res>(_self.createdLoan!, (value) {
    return _then(_self.copyWith(createdLoan: value));
  });
}
}

// dart format on

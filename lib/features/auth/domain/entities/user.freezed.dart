// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 int get id; String get email;/// Backend field: 'name' (prénom)
@JsonKey(name: 'name') String? get firstName;/// Backend field: 'last_name' (nom de famille)
@JsonKey(name: 'last_name') String? get lastName; String? get phone;@JsonKey(name: 'email_verified_at') DateTime? get emailVerifiedAt; int? get currentCommunityId;/// Full borrower dossier from BorrowerResource — never infer state from
/// a single boolean. Use BorrowerStatus.from(user.borrower) instead.
 Borrower? get borrower;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.emailVerifiedAt, emailVerifiedAt) || other.emailVerifiedAt == emailVerifiedAt)&&(identical(other.currentCommunityId, currentCommunityId) || other.currentCommunityId == currentCommunityId)&&(identical(other.borrower, borrower) || other.borrower == borrower));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,firstName,lastName,phone,emailVerifiedAt,currentCommunityId,borrower);

@override
String toString() {
  return 'User(id: $id, email: $email, firstName: $firstName, lastName: $lastName, phone: $phone, emailVerifiedAt: $emailVerifiedAt, currentCommunityId: $currentCommunityId, borrower: $borrower)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 int id, String email,@JsonKey(name: 'name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String? phone,@JsonKey(name: 'email_verified_at') DateTime? emailVerifiedAt, int? currentCommunityId, Borrower? borrower
});


$BorrowerCopyWith<$Res>? get borrower;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? firstName = freezed,Object? lastName = freezed,Object? phone = freezed,Object? emailVerifiedAt = freezed,Object? currentCommunityId = freezed,Object? borrower = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,emailVerifiedAt: freezed == emailVerifiedAt ? _self.emailVerifiedAt : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,currentCommunityId: freezed == currentCommunityId ? _self.currentCommunityId : currentCommunityId // ignore: cast_nullable_to_non_nullable
as int?,borrower: freezed == borrower ? _self.borrower : borrower // ignore: cast_nullable_to_non_nullable
as Borrower?,
  ));
}
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BorrowerCopyWith<$Res>? get borrower {
    if (_self.borrower == null) {
    return null;
  }

  return $BorrowerCopyWith<$Res>(_self.borrower!, (value) {
    return _then(_self.copyWith(borrower: value));
  });
}
}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String email, @JsonKey(name: 'name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? phone, @JsonKey(name: 'email_verified_at')  DateTime? emailVerifiedAt,  int? currentCommunityId,  Borrower? borrower)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.phone,_that.emailVerifiedAt,_that.currentCommunityId,_that.borrower);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String email, @JsonKey(name: 'name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? phone, @JsonKey(name: 'email_verified_at')  DateTime? emailVerifiedAt,  int? currentCommunityId,  Borrower? borrower)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.phone,_that.emailVerifiedAt,_that.currentCommunityId,_that.borrower);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String email, @JsonKey(name: 'name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? phone, @JsonKey(name: 'email_verified_at')  DateTime? emailVerifiedAt,  int? currentCommunityId,  Borrower? borrower)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.email,_that.firstName,_that.lastName,_that.phone,_that.emailVerifiedAt,_that.currentCommunityId,_that.borrower);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User implements User {
  const _User({required this.id, required this.email, @JsonKey(name: 'name') this.firstName, @JsonKey(name: 'last_name') this.lastName, this.phone, @JsonKey(name: 'email_verified_at') this.emailVerifiedAt, this.currentCommunityId, this.borrower});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  int id;
@override final  String email;
/// Backend field: 'name' (prénom)
@override@JsonKey(name: 'name') final  String? firstName;
/// Backend field: 'last_name' (nom de famille)
@override@JsonKey(name: 'last_name') final  String? lastName;
@override final  String? phone;
@override@JsonKey(name: 'email_verified_at') final  DateTime? emailVerifiedAt;
@override final  int? currentCommunityId;
/// Full borrower dossier from BorrowerResource — never infer state from
/// a single boolean. Use BorrowerStatus.from(user.borrower) instead.
@override final  Borrower? borrower;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.emailVerifiedAt, emailVerifiedAt) || other.emailVerifiedAt == emailVerifiedAt)&&(identical(other.currentCommunityId, currentCommunityId) || other.currentCommunityId == currentCommunityId)&&(identical(other.borrower, borrower) || other.borrower == borrower));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,firstName,lastName,phone,emailVerifiedAt,currentCommunityId,borrower);

@override
String toString() {
  return 'User(id: $id, email: $email, firstName: $firstName, lastName: $lastName, phone: $phone, emailVerifiedAt: $emailVerifiedAt, currentCommunityId: $currentCommunityId, borrower: $borrower)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 int id, String email,@JsonKey(name: 'name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String? phone,@JsonKey(name: 'email_verified_at') DateTime? emailVerifiedAt, int? currentCommunityId, Borrower? borrower
});


@override $BorrowerCopyWith<$Res>? get borrower;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? firstName = freezed,Object? lastName = freezed,Object? phone = freezed,Object? emailVerifiedAt = freezed,Object? currentCommunityId = freezed,Object? borrower = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,emailVerifiedAt: freezed == emailVerifiedAt ? _self.emailVerifiedAt : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,currentCommunityId: freezed == currentCommunityId ? _self.currentCommunityId : currentCommunityId // ignore: cast_nullable_to_non_nullable
as int?,borrower: freezed == borrower ? _self.borrower : borrower // ignore: cast_nullable_to_non_nullable
as Borrower?,
  ));
}

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BorrowerCopyWith<$Res>? get borrower {
    if (_self.borrower == null) {
    return null;
  }

  return $BorrowerCopyWith<$Res>(_self.borrower!, (value) {
    return _then(_self.copyWith(borrower: value));
  });
}
}

// dart format on

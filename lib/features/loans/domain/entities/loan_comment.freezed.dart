// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loan_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoanComment {

 int get id;@JsonKey(name: 'loan_id') int? get loanId;@JsonKey(name: 'author_id') int? get authorId;@JsonKey(name: 'author_name') String? get authorName; String? get text;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of LoanComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoanCommentCopyWith<LoanComment> get copyWith => _$LoanCommentCopyWithImpl<LoanComment>(this as LoanComment, _$identity);

  /// Serializes this LoanComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoanComment&&(identical(other.id, id) || other.id == id)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,loanId,authorId,authorName,text,createdAt,updatedAt);

@override
String toString() {
  return 'LoanComment(id: $id, loanId: $loanId, authorId: $authorId, authorName: $authorName, text: $text, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $LoanCommentCopyWith<$Res>  {
  factory $LoanCommentCopyWith(LoanComment value, $Res Function(LoanComment) _then) = _$LoanCommentCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'loan_id') int? loanId,@JsonKey(name: 'author_id') int? authorId,@JsonKey(name: 'author_name') String? authorName, String? text,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$LoanCommentCopyWithImpl<$Res>
    implements $LoanCommentCopyWith<$Res> {
  _$LoanCommentCopyWithImpl(this._self, this._then);

  final LoanComment _self;
  final $Res Function(LoanComment) _then;

/// Create a copy of LoanComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? loanId = freezed,Object? authorId = freezed,Object? authorName = freezed,Object? text = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,loanId: freezed == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int?,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as int?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoanComment].
extension LoanCommentPatterns on LoanComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoanComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoanComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoanComment value)  $default,){
final _that = this;
switch (_that) {
case _LoanComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoanComment value)?  $default,){
final _that = this;
switch (_that) {
case _LoanComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'loan_id')  int? loanId, @JsonKey(name: 'author_id')  int? authorId, @JsonKey(name: 'author_name')  String? authorName,  String? text, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoanComment() when $default != null:
return $default(_that.id,_that.loanId,_that.authorId,_that.authorName,_that.text,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'loan_id')  int? loanId, @JsonKey(name: 'author_id')  int? authorId, @JsonKey(name: 'author_name')  String? authorName,  String? text, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _LoanComment():
return $default(_that.id,_that.loanId,_that.authorId,_that.authorName,_that.text,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'loan_id')  int? loanId, @JsonKey(name: 'author_id')  int? authorId, @JsonKey(name: 'author_name')  String? authorName,  String? text, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _LoanComment() when $default != null:
return $default(_that.id,_that.loanId,_that.authorId,_that.authorName,_that.text,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoanComment extends LoanComment {
  const _LoanComment({required this.id, @JsonKey(name: 'loan_id') this.loanId, @JsonKey(name: 'author_id') this.authorId, @JsonKey(name: 'author_name') this.authorName, this.text, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt}): super._();
  factory _LoanComment.fromJson(Map<String, dynamic> json) => _$LoanCommentFromJson(json);

@override final  int id;
@override@JsonKey(name: 'loan_id') final  int? loanId;
@override@JsonKey(name: 'author_id') final  int? authorId;
@override@JsonKey(name: 'author_name') final  String? authorName;
@override final  String? text;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of LoanComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoanCommentCopyWith<_LoanComment> get copyWith => __$LoanCommentCopyWithImpl<_LoanComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoanCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoanComment&&(identical(other.id, id) || other.id == id)&&(identical(other.loanId, loanId) || other.loanId == loanId)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,loanId,authorId,authorName,text,createdAt,updatedAt);

@override
String toString() {
  return 'LoanComment(id: $id, loanId: $loanId, authorId: $authorId, authorName: $authorName, text: $text, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LoanCommentCopyWith<$Res> implements $LoanCommentCopyWith<$Res> {
  factory _$LoanCommentCopyWith(_LoanComment value, $Res Function(_LoanComment) _then) = __$LoanCommentCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'loan_id') int? loanId,@JsonKey(name: 'author_id') int? authorId,@JsonKey(name: 'author_name') String? authorName, String? text,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$LoanCommentCopyWithImpl<$Res>
    implements _$LoanCommentCopyWith<$Res> {
  __$LoanCommentCopyWithImpl(this._self, this._then);

  final _LoanComment _self;
  final $Res Function(_LoanComment) _then;

/// Create a copy of LoanComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? loanId = freezed,Object? authorId = freezed,Object? authorName = freezed,Object? text = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_LoanComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,loanId: freezed == loanId ? _self.loanId : loanId // ignore: cast_nullable_to_non_nullable
as int?,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as int?,authorName: freezed == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

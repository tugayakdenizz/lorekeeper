// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_library.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserLibrary {

 String get id; String get userId; List<String> get bookIds; List<String> get favoriteBookIds; List<String> get favoriteAuthorIds; List<String> get followedAuthorIds; List<String> get seriesIds; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of UserLibrary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserLibraryCopyWith<UserLibrary> get copyWith => _$UserLibraryCopyWithImpl<UserLibrary>(this as UserLibrary, _$identity);

  /// Serializes this UserLibrary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserLibrary&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.bookIds, bookIds)&&const DeepCollectionEquality().equals(other.favoriteBookIds, favoriteBookIds)&&const DeepCollectionEquality().equals(other.favoriteAuthorIds, favoriteAuthorIds)&&const DeepCollectionEquality().equals(other.followedAuthorIds, followedAuthorIds)&&const DeepCollectionEquality().equals(other.seriesIds, seriesIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,const DeepCollectionEquality().hash(bookIds),const DeepCollectionEquality().hash(favoriteBookIds),const DeepCollectionEquality().hash(favoriteAuthorIds),const DeepCollectionEquality().hash(followedAuthorIds),const DeepCollectionEquality().hash(seriesIds),createdAt,updatedAt);

@override
String toString() {
  return 'UserLibrary(id: $id, userId: $userId, bookIds: $bookIds, favoriteBookIds: $favoriteBookIds, favoriteAuthorIds: $favoriteAuthorIds, followedAuthorIds: $followedAuthorIds, seriesIds: $seriesIds, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserLibraryCopyWith<$Res>  {
  factory $UserLibraryCopyWith(UserLibrary value, $Res Function(UserLibrary) _then) = _$UserLibraryCopyWithImpl;
@useResult
$Res call({
 String id, String userId, List<String> bookIds, List<String> favoriteBookIds, List<String> favoriteAuthorIds, List<String> followedAuthorIds, List<String> seriesIds, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$UserLibraryCopyWithImpl<$Res>
    implements $UserLibraryCopyWith<$Res> {
  _$UserLibraryCopyWithImpl(this._self, this._then);

  final UserLibrary _self;
  final $Res Function(UserLibrary) _then;

/// Create a copy of UserLibrary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? bookIds = null,Object? favoriteBookIds = null,Object? favoriteAuthorIds = null,Object? followedAuthorIds = null,Object? seriesIds = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,bookIds: null == bookIds ? _self.bookIds : bookIds // ignore: cast_nullable_to_non_nullable
as List<String>,favoriteBookIds: null == favoriteBookIds ? _self.favoriteBookIds : favoriteBookIds // ignore: cast_nullable_to_non_nullable
as List<String>,favoriteAuthorIds: null == favoriteAuthorIds ? _self.favoriteAuthorIds : favoriteAuthorIds // ignore: cast_nullable_to_non_nullable
as List<String>,followedAuthorIds: null == followedAuthorIds ? _self.followedAuthorIds : followedAuthorIds // ignore: cast_nullable_to_non_nullable
as List<String>,seriesIds: null == seriesIds ? _self.seriesIds : seriesIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserLibrary].
extension UserLibraryPatterns on UserLibrary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserLibrary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserLibrary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserLibrary value)  $default,){
final _that = this;
switch (_that) {
case _UserLibrary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserLibrary value)?  $default,){
final _that = this;
switch (_that) {
case _UserLibrary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  List<String> bookIds,  List<String> favoriteBookIds,  List<String> favoriteAuthorIds,  List<String> followedAuthorIds,  List<String> seriesIds,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserLibrary() when $default != null:
return $default(_that.id,_that.userId,_that.bookIds,_that.favoriteBookIds,_that.favoriteAuthorIds,_that.followedAuthorIds,_that.seriesIds,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  List<String> bookIds,  List<String> favoriteBookIds,  List<String> favoriteAuthorIds,  List<String> followedAuthorIds,  List<String> seriesIds,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserLibrary():
return $default(_that.id,_that.userId,_that.bookIds,_that.favoriteBookIds,_that.favoriteAuthorIds,_that.followedAuthorIds,_that.seriesIds,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  List<String> bookIds,  List<String> favoriteBookIds,  List<String> favoriteAuthorIds,  List<String> followedAuthorIds,  List<String> seriesIds,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserLibrary() when $default != null:
return $default(_that.id,_that.userId,_that.bookIds,_that.favoriteBookIds,_that.favoriteAuthorIds,_that.followedAuthorIds,_that.seriesIds,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserLibrary implements UserLibrary {
  const _UserLibrary({required this.id, required this.userId, final  List<String> bookIds = const [], final  List<String> favoriteBookIds = const [], final  List<String> favoriteAuthorIds = const [], final  List<String> followedAuthorIds = const [], final  List<String> seriesIds = const [], this.createdAt, this.updatedAt}): _bookIds = bookIds,_favoriteBookIds = favoriteBookIds,_favoriteAuthorIds = favoriteAuthorIds,_followedAuthorIds = followedAuthorIds,_seriesIds = seriesIds;
  factory _UserLibrary.fromJson(Map<String, dynamic> json) => _$UserLibraryFromJson(json);

@override final  String id;
@override final  String userId;
 final  List<String> _bookIds;
@override@JsonKey() List<String> get bookIds {
  if (_bookIds is EqualUnmodifiableListView) return _bookIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookIds);
}

 final  List<String> _favoriteBookIds;
@override@JsonKey() List<String> get favoriteBookIds {
  if (_favoriteBookIds is EqualUnmodifiableListView) return _favoriteBookIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteBookIds);
}

 final  List<String> _favoriteAuthorIds;
@override@JsonKey() List<String> get favoriteAuthorIds {
  if (_favoriteAuthorIds is EqualUnmodifiableListView) return _favoriteAuthorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_favoriteAuthorIds);
}

 final  List<String> _followedAuthorIds;
@override@JsonKey() List<String> get followedAuthorIds {
  if (_followedAuthorIds is EqualUnmodifiableListView) return _followedAuthorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_followedAuthorIds);
}

 final  List<String> _seriesIds;
@override@JsonKey() List<String> get seriesIds {
  if (_seriesIds is EqualUnmodifiableListView) return _seriesIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seriesIds);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of UserLibrary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserLibraryCopyWith<_UserLibrary> get copyWith => __$UserLibraryCopyWithImpl<_UserLibrary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserLibraryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserLibrary&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other._bookIds, _bookIds)&&const DeepCollectionEquality().equals(other._favoriteBookIds, _favoriteBookIds)&&const DeepCollectionEquality().equals(other._favoriteAuthorIds, _favoriteAuthorIds)&&const DeepCollectionEquality().equals(other._followedAuthorIds, _followedAuthorIds)&&const DeepCollectionEquality().equals(other._seriesIds, _seriesIds)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,const DeepCollectionEquality().hash(_bookIds),const DeepCollectionEquality().hash(_favoriteBookIds),const DeepCollectionEquality().hash(_favoriteAuthorIds),const DeepCollectionEquality().hash(_followedAuthorIds),const DeepCollectionEquality().hash(_seriesIds),createdAt,updatedAt);

@override
String toString() {
  return 'UserLibrary(id: $id, userId: $userId, bookIds: $bookIds, favoriteBookIds: $favoriteBookIds, favoriteAuthorIds: $favoriteAuthorIds, followedAuthorIds: $followedAuthorIds, seriesIds: $seriesIds, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserLibraryCopyWith<$Res> implements $UserLibraryCopyWith<$Res> {
  factory _$UserLibraryCopyWith(_UserLibrary value, $Res Function(_UserLibrary) _then) = __$UserLibraryCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, List<String> bookIds, List<String> favoriteBookIds, List<String> favoriteAuthorIds, List<String> followedAuthorIds, List<String> seriesIds, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$UserLibraryCopyWithImpl<$Res>
    implements _$UserLibraryCopyWith<$Res> {
  __$UserLibraryCopyWithImpl(this._self, this._then);

  final _UserLibrary _self;
  final $Res Function(_UserLibrary) _then;

/// Create a copy of UserLibrary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? bookIds = null,Object? favoriteBookIds = null,Object? favoriteAuthorIds = null,Object? followedAuthorIds = null,Object? seriesIds = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_UserLibrary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,bookIds: null == bookIds ? _self._bookIds : bookIds // ignore: cast_nullable_to_non_nullable
as List<String>,favoriteBookIds: null == favoriteBookIds ? _self._favoriteBookIds : favoriteBookIds // ignore: cast_nullable_to_non_nullable
as List<String>,favoriteAuthorIds: null == favoriteAuthorIds ? _self._favoriteAuthorIds : favoriteAuthorIds // ignore: cast_nullable_to_non_nullable
as List<String>,followedAuthorIds: null == followedAuthorIds ? _self._followedAuthorIds : followedAuthorIds // ignore: cast_nullable_to_non_nullable
as List<String>,seriesIds: null == seriesIds ? _self._seriesIds : seriesIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

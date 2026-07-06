// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingSession {

 String get id; int get pagesRead; DateTime get createdAt;
/// Create a copy of ReadingSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingSessionCopyWith<ReadingSession> get copyWith => _$ReadingSessionCopyWithImpl<ReadingSession>(this as ReadingSession, _$identity);

  /// Serializes this ReadingSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.pagesRead, pagesRead) || other.pagesRead == pagesRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pagesRead,createdAt);

@override
String toString() {
  return 'ReadingSession(id: $id, pagesRead: $pagesRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ReadingSessionCopyWith<$Res>  {
  factory $ReadingSessionCopyWith(ReadingSession value, $Res Function(ReadingSession) _then) = _$ReadingSessionCopyWithImpl;
@useResult
$Res call({
 String id, int pagesRead, DateTime createdAt
});




}
/// @nodoc
class _$ReadingSessionCopyWithImpl<$Res>
    implements $ReadingSessionCopyWith<$Res> {
  _$ReadingSessionCopyWithImpl(this._self, this._then);

  final ReadingSession _self;
  final $Res Function(ReadingSession) _then;

/// Create a copy of ReadingSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pagesRead = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pagesRead: null == pagesRead ? _self.pagesRead : pagesRead // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadingSession].
extension ReadingSessionPatterns on ReadingSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingSession value)  $default,){
final _that = this;
switch (_that) {
case _ReadingSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingSession value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int pagesRead,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingSession() when $default != null:
return $default(_that.id,_that.pagesRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int pagesRead,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ReadingSession():
return $default(_that.id,_that.pagesRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int pagesRead,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ReadingSession() when $default != null:
return $default(_that.id,_that.pagesRead,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadingSession implements ReadingSession {
  const _ReadingSession({required this.id, required this.pagesRead, required this.createdAt});
  factory _ReadingSession.fromJson(Map<String, dynamic> json) => _$ReadingSessionFromJson(json);

@override final  String id;
@override final  int pagesRead;
@override final  DateTime createdAt;

/// Create a copy of ReadingSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingSessionCopyWith<_ReadingSession> get copyWith => __$ReadingSessionCopyWithImpl<_ReadingSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadingSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingSession&&(identical(other.id, id) || other.id == id)&&(identical(other.pagesRead, pagesRead) || other.pagesRead == pagesRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pagesRead,createdAt);

@override
String toString() {
  return 'ReadingSession(id: $id, pagesRead: $pagesRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ReadingSessionCopyWith<$Res> implements $ReadingSessionCopyWith<$Res> {
  factory _$ReadingSessionCopyWith(_ReadingSession value, $Res Function(_ReadingSession) _then) = __$ReadingSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, int pagesRead, DateTime createdAt
});




}
/// @nodoc
class __$ReadingSessionCopyWithImpl<$Res>
    implements _$ReadingSessionCopyWith<$Res> {
  __$ReadingSessionCopyWithImpl(this._self, this._then);

  final _ReadingSession _self;
  final $Res Function(_ReadingSession) _then;

/// Create a copy of ReadingSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pagesRead = null,Object? createdAt = null,}) {
  return _then(_ReadingSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pagesRead: null == pagesRead ? _self.pagesRead : pagesRead // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

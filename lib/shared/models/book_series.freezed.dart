// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_series.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookSeries {

 String get id; String get title; String? get originalTitle; String? get description; String? get coverUrl; String? get universeName; List<String> get bookIds; List<String> get authorIds; bool get isCompleted; DateTime? get createdAt;
/// Create a copy of BookSeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookSeriesCopyWith<BookSeries> get copyWith => _$BookSeriesCopyWithImpl<BookSeries>(this as BookSeries, _$identity);

  /// Serializes this BookSeries to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookSeries&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.universeName, universeName) || other.universeName == universeName)&&const DeepCollectionEquality().equals(other.bookIds, bookIds)&&const DeepCollectionEquality().equals(other.authorIds, authorIds)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,originalTitle,description,coverUrl,universeName,const DeepCollectionEquality().hash(bookIds),const DeepCollectionEquality().hash(authorIds),isCompleted,createdAt);

@override
String toString() {
  return 'BookSeries(id: $id, title: $title, originalTitle: $originalTitle, description: $description, coverUrl: $coverUrl, universeName: $universeName, bookIds: $bookIds, authorIds: $authorIds, isCompleted: $isCompleted, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BookSeriesCopyWith<$Res>  {
  factory $BookSeriesCopyWith(BookSeries value, $Res Function(BookSeries) _then) = _$BookSeriesCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? originalTitle, String? description, String? coverUrl, String? universeName, List<String> bookIds, List<String> authorIds, bool isCompleted, DateTime? createdAt
});




}
/// @nodoc
class _$BookSeriesCopyWithImpl<$Res>
    implements $BookSeriesCopyWith<$Res> {
  _$BookSeriesCopyWithImpl(this._self, this._then);

  final BookSeries _self;
  final $Res Function(BookSeries) _then;

/// Create a copy of BookSeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? originalTitle = freezed,Object? description = freezed,Object? coverUrl = freezed,Object? universeName = freezed,Object? bookIds = null,Object? authorIds = null,Object? isCompleted = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,universeName: freezed == universeName ? _self.universeName : universeName // ignore: cast_nullable_to_non_nullable
as String?,bookIds: null == bookIds ? _self.bookIds : bookIds // ignore: cast_nullable_to_non_nullable
as List<String>,authorIds: null == authorIds ? _self.authorIds : authorIds // ignore: cast_nullable_to_non_nullable
as List<String>,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookSeries].
extension BookSeriesPatterns on BookSeries {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookSeries value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookSeries() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookSeries value)  $default,){
final _that = this;
switch (_that) {
case _BookSeries():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookSeries value)?  $default,){
final _that = this;
switch (_that) {
case _BookSeries() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? originalTitle,  String? description,  String? coverUrl,  String? universeName,  List<String> bookIds,  List<String> authorIds,  bool isCompleted,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookSeries() when $default != null:
return $default(_that.id,_that.title,_that.originalTitle,_that.description,_that.coverUrl,_that.universeName,_that.bookIds,_that.authorIds,_that.isCompleted,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? originalTitle,  String? description,  String? coverUrl,  String? universeName,  List<String> bookIds,  List<String> authorIds,  bool isCompleted,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _BookSeries():
return $default(_that.id,_that.title,_that.originalTitle,_that.description,_that.coverUrl,_that.universeName,_that.bookIds,_that.authorIds,_that.isCompleted,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? originalTitle,  String? description,  String? coverUrl,  String? universeName,  List<String> bookIds,  List<String> authorIds,  bool isCompleted,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _BookSeries() when $default != null:
return $default(_that.id,_that.title,_that.originalTitle,_that.description,_that.coverUrl,_that.universeName,_that.bookIds,_that.authorIds,_that.isCompleted,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookSeries implements BookSeries {
  const _BookSeries({required this.id, required this.title, this.originalTitle, this.description, this.coverUrl, this.universeName, final  List<String> bookIds = const [], final  List<String> authorIds = const [], this.isCompleted = false, this.createdAt}): _bookIds = bookIds,_authorIds = authorIds;
  factory _BookSeries.fromJson(Map<String, dynamic> json) => _$BookSeriesFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? originalTitle;
@override final  String? description;
@override final  String? coverUrl;
@override final  String? universeName;
 final  List<String> _bookIds;
@override@JsonKey() List<String> get bookIds {
  if (_bookIds is EqualUnmodifiableListView) return _bookIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookIds);
}

 final  List<String> _authorIds;
@override@JsonKey() List<String> get authorIds {
  if (_authorIds is EqualUnmodifiableListView) return _authorIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authorIds);
}

@override@JsonKey() final  bool isCompleted;
@override final  DateTime? createdAt;

/// Create a copy of BookSeries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookSeriesCopyWith<_BookSeries> get copyWith => __$BookSeriesCopyWithImpl<_BookSeries>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookSeriesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookSeries&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.universeName, universeName) || other.universeName == universeName)&&const DeepCollectionEquality().equals(other._bookIds, _bookIds)&&const DeepCollectionEquality().equals(other._authorIds, _authorIds)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,originalTitle,description,coverUrl,universeName,const DeepCollectionEquality().hash(_bookIds),const DeepCollectionEquality().hash(_authorIds),isCompleted,createdAt);

@override
String toString() {
  return 'BookSeries(id: $id, title: $title, originalTitle: $originalTitle, description: $description, coverUrl: $coverUrl, universeName: $universeName, bookIds: $bookIds, authorIds: $authorIds, isCompleted: $isCompleted, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BookSeriesCopyWith<$Res> implements $BookSeriesCopyWith<$Res> {
  factory _$BookSeriesCopyWith(_BookSeries value, $Res Function(_BookSeries) _then) = __$BookSeriesCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? originalTitle, String? description, String? coverUrl, String? universeName, List<String> bookIds, List<String> authorIds, bool isCompleted, DateTime? createdAt
});




}
/// @nodoc
class __$BookSeriesCopyWithImpl<$Res>
    implements _$BookSeriesCopyWith<$Res> {
  __$BookSeriesCopyWithImpl(this._self, this._then);

  final _BookSeries _self;
  final $Res Function(_BookSeries) _then;

/// Create a copy of BookSeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? originalTitle = freezed,Object? description = freezed,Object? coverUrl = freezed,Object? universeName = freezed,Object? bookIds = null,Object? authorIds = null,Object? isCompleted = null,Object? createdAt = freezed,}) {
  return _then(_BookSeries(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,universeName: freezed == universeName ? _self.universeName : universeName // ignore: cast_nullable_to_non_nullable
as String?,bookIds: null == bookIds ? _self._bookIds : bookIds // ignore: cast_nullable_to_non_nullable
as List<String>,authorIds: null == authorIds ? _self._authorIds : authorIds // ignore: cast_nullable_to_non_nullable
as List<String>,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

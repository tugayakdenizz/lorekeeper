// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Book {

 String get id; String get title; String? get subtitle; String? get originalTitle; List<String> get authors; String? get description; String? get isbn10; String? get isbn13; String? get googleBooksId; String? get openLibraryId; String? get language; int? get pageCount; DateTime? get publishedDate; String? get publisher; String? get coverUrl; List<String> get categories; double get averageRating; String? get seriesId; int? get volumeNumber; bool get isFavorite; DateTime? get createdAt;
/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookCopyWith<Book> get copyWith => _$BookCopyWithImpl<Book>(this as Book, _$identity);

  /// Serializes this Book to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Book&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&const DeepCollectionEquality().equals(other.authors, authors)&&(identical(other.description, description) || other.description == description)&&(identical(other.isbn10, isbn10) || other.isbn10 == isbn10)&&(identical(other.isbn13, isbn13) || other.isbn13 == isbn13)&&(identical(other.googleBooksId, googleBooksId) || other.googleBooksId == googleBooksId)&&(identical(other.openLibraryId, openLibraryId) || other.openLibraryId == openLibraryId)&&(identical(other.language, language) || other.language == language)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.publishedDate, publishedDate) || other.publishedDate == publishedDate)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.volumeNumber, volumeNumber) || other.volumeNumber == volumeNumber)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,subtitle,originalTitle,const DeepCollectionEquality().hash(authors),description,isbn10,isbn13,googleBooksId,openLibraryId,language,pageCount,publishedDate,publisher,coverUrl,const DeepCollectionEquality().hash(categories),averageRating,seriesId,volumeNumber,isFavorite,createdAt]);

@override
String toString() {
  return 'Book(id: $id, title: $title, subtitle: $subtitle, originalTitle: $originalTitle, authors: $authors, description: $description, isbn10: $isbn10, isbn13: $isbn13, googleBooksId: $googleBooksId, openLibraryId: $openLibraryId, language: $language, pageCount: $pageCount, publishedDate: $publishedDate, publisher: $publisher, coverUrl: $coverUrl, categories: $categories, averageRating: $averageRating, seriesId: $seriesId, volumeNumber: $volumeNumber, isFavorite: $isFavorite, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $BookCopyWith<$Res>  {
  factory $BookCopyWith(Book value, $Res Function(Book) _then) = _$BookCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? subtitle, String? originalTitle, List<String> authors, String? description, String? isbn10, String? isbn13, String? googleBooksId, String? openLibraryId, String? language, int? pageCount, DateTime? publishedDate, String? publisher, String? coverUrl, List<String> categories, double averageRating, String? seriesId, int? volumeNumber, bool isFavorite, DateTime? createdAt
});




}
/// @nodoc
class _$BookCopyWithImpl<$Res>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._self, this._then);

  final Book _self;
  final $Res Function(Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = freezed,Object? originalTitle = freezed,Object? authors = null,Object? description = freezed,Object? isbn10 = freezed,Object? isbn13 = freezed,Object? googleBooksId = freezed,Object? openLibraryId = freezed,Object? language = freezed,Object? pageCount = freezed,Object? publishedDate = freezed,Object? publisher = freezed,Object? coverUrl = freezed,Object? categories = null,Object? averageRating = null,Object? seriesId = freezed,Object? volumeNumber = freezed,Object? isFavorite = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isbn10: freezed == isbn10 ? _self.isbn10 : isbn10 // ignore: cast_nullable_to_non_nullable
as String?,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,googleBooksId: freezed == googleBooksId ? _self.googleBooksId : googleBooksId // ignore: cast_nullable_to_non_nullable
as String?,openLibraryId: freezed == openLibraryId ? _self.openLibraryId : openLibraryId // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,publishedDate: freezed == publishedDate ? _self.publishedDate : publishedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String?,volumeNumber: freezed == volumeNumber ? _self.volumeNumber : volumeNumber // ignore: cast_nullable_to_non_nullable
as int?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Book].
extension BookPatterns on Book {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Book value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Book() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Book value)  $default,){
final _that = this;
switch (_that) {
case _Book():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Book value)?  $default,){
final _that = this;
switch (_that) {
case _Book() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? subtitle,  String? originalTitle,  List<String> authors,  String? description,  String? isbn10,  String? isbn13,  String? googleBooksId,  String? openLibraryId,  String? language,  int? pageCount,  DateTime? publishedDate,  String? publisher,  String? coverUrl,  List<String> categories,  double averageRating,  String? seriesId,  int? volumeNumber,  bool isFavorite,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.originalTitle,_that.authors,_that.description,_that.isbn10,_that.isbn13,_that.googleBooksId,_that.openLibraryId,_that.language,_that.pageCount,_that.publishedDate,_that.publisher,_that.coverUrl,_that.categories,_that.averageRating,_that.seriesId,_that.volumeNumber,_that.isFavorite,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? subtitle,  String? originalTitle,  List<String> authors,  String? description,  String? isbn10,  String? isbn13,  String? googleBooksId,  String? openLibraryId,  String? language,  int? pageCount,  DateTime? publishedDate,  String? publisher,  String? coverUrl,  List<String> categories,  double averageRating,  String? seriesId,  int? volumeNumber,  bool isFavorite,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Book():
return $default(_that.id,_that.title,_that.subtitle,_that.originalTitle,_that.authors,_that.description,_that.isbn10,_that.isbn13,_that.googleBooksId,_that.openLibraryId,_that.language,_that.pageCount,_that.publishedDate,_that.publisher,_that.coverUrl,_that.categories,_that.averageRating,_that.seriesId,_that.volumeNumber,_that.isFavorite,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? subtitle,  String? originalTitle,  List<String> authors,  String? description,  String? isbn10,  String? isbn13,  String? googleBooksId,  String? openLibraryId,  String? language,  int? pageCount,  DateTime? publishedDate,  String? publisher,  String? coverUrl,  List<String> categories,  double averageRating,  String? seriesId,  int? volumeNumber,  bool isFavorite,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Book() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.originalTitle,_that.authors,_that.description,_that.isbn10,_that.isbn13,_that.googleBooksId,_that.openLibraryId,_that.language,_that.pageCount,_that.publishedDate,_that.publisher,_that.coverUrl,_that.categories,_that.averageRating,_that.seriesId,_that.volumeNumber,_that.isFavorite,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Book implements Book {
  const _Book({required this.id, required this.title, this.subtitle, this.originalTitle, required final  List<String> authors, this.description, this.isbn10, this.isbn13, this.googleBooksId, this.openLibraryId, this.language, this.pageCount, this.publishedDate, this.publisher, this.coverUrl, final  List<String> categories = const [], this.averageRating = 0.0, this.seriesId, this.volumeNumber, this.isFavorite = false, this.createdAt}): _authors = authors,_categories = categories;
  factory _Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? subtitle;
@override final  String? originalTitle;
 final  List<String> _authors;
@override List<String> get authors {
  if (_authors is EqualUnmodifiableListView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authors);
}

@override final  String? description;
@override final  String? isbn10;
@override final  String? isbn13;
@override final  String? googleBooksId;
@override final  String? openLibraryId;
@override final  String? language;
@override final  int? pageCount;
@override final  DateTime? publishedDate;
@override final  String? publisher;
@override final  String? coverUrl;
 final  List<String> _categories;
@override@JsonKey() List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey() final  double averageRating;
@override final  String? seriesId;
@override final  int? volumeNumber;
@override@JsonKey() final  bool isFavorite;
@override final  DateTime? createdAt;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookCopyWith<_Book> get copyWith => __$BookCopyWithImpl<_Book>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Book&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.originalTitle, originalTitle) || other.originalTitle == originalTitle)&&const DeepCollectionEquality().equals(other._authors, _authors)&&(identical(other.description, description) || other.description == description)&&(identical(other.isbn10, isbn10) || other.isbn10 == isbn10)&&(identical(other.isbn13, isbn13) || other.isbn13 == isbn13)&&(identical(other.googleBooksId, googleBooksId) || other.googleBooksId == googleBooksId)&&(identical(other.openLibraryId, openLibraryId) || other.openLibraryId == openLibraryId)&&(identical(other.language, language) || other.language == language)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.publishedDate, publishedDate) || other.publishedDate == publishedDate)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.volumeNumber, volumeNumber) || other.volumeNumber == volumeNumber)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,title,subtitle,originalTitle,const DeepCollectionEquality().hash(_authors),description,isbn10,isbn13,googleBooksId,openLibraryId,language,pageCount,publishedDate,publisher,coverUrl,const DeepCollectionEquality().hash(_categories),averageRating,seriesId,volumeNumber,isFavorite,createdAt]);

@override
String toString() {
  return 'Book(id: $id, title: $title, subtitle: $subtitle, originalTitle: $originalTitle, authors: $authors, description: $description, isbn10: $isbn10, isbn13: $isbn13, googleBooksId: $googleBooksId, openLibraryId: $openLibraryId, language: $language, pageCount: $pageCount, publishedDate: $publishedDate, publisher: $publisher, coverUrl: $coverUrl, categories: $categories, averageRating: $averageRating, seriesId: $seriesId, volumeNumber: $volumeNumber, isFavorite: $isFavorite, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$BookCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$BookCopyWith(_Book value, $Res Function(_Book) _then) = __$BookCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? subtitle, String? originalTitle, List<String> authors, String? description, String? isbn10, String? isbn13, String? googleBooksId, String? openLibraryId, String? language, int? pageCount, DateTime? publishedDate, String? publisher, String? coverUrl, List<String> categories, double averageRating, String? seriesId, int? volumeNumber, bool isFavorite, DateTime? createdAt
});




}
/// @nodoc
class __$BookCopyWithImpl<$Res>
    implements _$BookCopyWith<$Res> {
  __$BookCopyWithImpl(this._self, this._then);

  final _Book _self;
  final $Res Function(_Book) _then;

/// Create a copy of Book
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = freezed,Object? originalTitle = freezed,Object? authors = null,Object? description = freezed,Object? isbn10 = freezed,Object? isbn13 = freezed,Object? googleBooksId = freezed,Object? openLibraryId = freezed,Object? language = freezed,Object? pageCount = freezed,Object? publishedDate = freezed,Object? publisher = freezed,Object? coverUrl = freezed,Object? categories = null,Object? averageRating = null,Object? seriesId = freezed,Object? volumeNumber = freezed,Object? isFavorite = null,Object? createdAt = freezed,}) {
  return _then(_Book(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,originalTitle: freezed == originalTitle ? _self.originalTitle : originalTitle // ignore: cast_nullable_to_non_nullable
as String?,authors: null == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<String>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isbn10: freezed == isbn10 ? _self.isbn10 : isbn10 // ignore: cast_nullable_to_non_nullable
as String?,isbn13: freezed == isbn13 ? _self.isbn13 : isbn13 // ignore: cast_nullable_to_non_nullable
as String?,googleBooksId: freezed == googleBooksId ? _self.googleBooksId : googleBooksId // ignore: cast_nullable_to_non_nullable
as String?,openLibraryId: freezed == openLibraryId ? _self.openLibraryId : openLibraryId // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,publishedDate: freezed == publishedDate ? _self.publishedDate : publishedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,seriesId: freezed == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String?,volumeNumber: freezed == volumeNumber ? _self.volumeNumber : volumeNumber // ignore: cast_nullable_to_non_nullable
as int?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

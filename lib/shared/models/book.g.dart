// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Book _$BookFromJson(Map<String, dynamic> json) => _Book(
  id: json['id'] as String,
  title: json['title'] as String,
  subtitle: json['subtitle'] as String?,
  originalTitle: json['originalTitle'] as String?,
  authors: (json['authors'] as List<dynamic>).map((e) => e as String).toList(),
  description: json['description'] as String?,
  isbn10: json['isbn10'] as String?,
  isbn13: json['isbn13'] as String?,
  googleBooksId: json['googleBooksId'] as String?,
  openLibraryId: json['openLibraryId'] as String?,
  language: json['language'] as String?,
  pageCount: (json['pageCount'] as num?)?.toInt(),
  publishedDate: json['publishedDate'] == null
      ? null
      : DateTime.parse(json['publishedDate'] as String),
  publisher: json['publisher'] as String?,
  coverUrl: json['coverUrl'] as String?,
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
  seriesId: json['seriesId'] as String?,
  volumeNumber: (json['volumeNumber'] as num?)?.toInt(),
  isFavorite: json['isFavorite'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BookToJson(_Book instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'originalTitle': instance.originalTitle,
  'authors': instance.authors,
  'description': instance.description,
  'isbn10': instance.isbn10,
  'isbn13': instance.isbn13,
  'googleBooksId': instance.googleBooksId,
  'openLibraryId': instance.openLibraryId,
  'language': instance.language,
  'pageCount': instance.pageCount,
  'publishedDate': instance.publishedDate?.toIso8601String(),
  'publisher': instance.publisher,
  'coverUrl': instance.coverUrl,
  'categories': instance.categories,
  'averageRating': instance.averageRating,
  'seriesId': instance.seriesId,
  'volumeNumber': instance.volumeNumber,
  'isFavorite': instance.isFavorite,
  'createdAt': instance.createdAt?.toIso8601String(),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookSeries _$BookSeriesFromJson(Map<String, dynamic> json) => _BookSeries(
  id: json['id'] as String,
  title: json['title'] as String,
  originalTitle: json['originalTitle'] as String?,
  description: json['description'] as String?,
  coverUrl: json['coverUrl'] as String?,
  universeName: json['universeName'] as String?,
  bookIds:
      (json['bookIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  authorIds:
      (json['authorIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isCompleted: json['isCompleted'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BookSeriesToJson(_BookSeries instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'originalTitle': instance.originalTitle,
      'description': instance.description,
      'coverUrl': instance.coverUrl,
      'universeName': instance.universeName,
      'bookIds': instance.bookIds,
      'authorIds': instance.authorIds,
      'isCompleted': instance.isCompleted,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

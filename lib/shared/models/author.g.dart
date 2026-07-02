// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Author _$AuthorFromJson(Map<String, dynamic> json) => _Author(
  id: json['id'] as String,
  name: json['name'] as String,
  biography: json['biography'] as String?,
  imageUrl: json['imageUrl'] as String?,
  country: json['country'] as String?,
  birthDate: json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String),
  deathDate: json['deathDate'] == null
      ? null
      : DateTime.parse(json['deathDate'] as String),
  website: json['website'] as String?,
  genres:
      (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  bookIds:
      (json['bookIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isFollowed: json['isFollowed'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AuthorToJson(_Author instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'biography': instance.biography,
  'imageUrl': instance.imageUrl,
  'country': instance.country,
  'birthDate': instance.birthDate?.toIso8601String(),
  'deathDate': instance.deathDate?.toIso8601String(),
  'website': instance.website,
  'genres': instance.genres,
  'bookIds': instance.bookIds,
  'isFollowed': instance.isFollowed,
  'createdAt': instance.createdAt?.toIso8601String(),
};

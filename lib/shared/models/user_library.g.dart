// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_library.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserLibrary _$UserLibraryFromJson(Map<String, dynamic> json) => _UserLibrary(
  id: json['id'] as String,
  userId: json['userId'] as String,
  bookIds:
      (json['bookIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  favoriteBookIds:
      (json['favoriteBookIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  favoriteAuthorIds:
      (json['favoriteAuthorIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  followedAuthorIds:
      (json['followedAuthorIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  seriesIds:
      (json['seriesIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserLibraryToJson(_UserLibrary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'bookIds': instance.bookIds,
      'favoriteBookIds': instance.favoriteBookIds,
      'favoriteAuthorIds': instance.favoriteAuthorIds,
      'followedAuthorIds': instance.followedAuthorIds,
      'seriesIds': instance.seriesIds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  id: json['id'] as String,
  bookId: json['bookId'] as String,
  userId: json['userId'] as String,
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
  title: json['title'] as String?,
  content: json['content'] as String?,
  containsSpoilers: json['containsSpoilers'] as bool? ?? false,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'id': instance.id,
  'bookId': instance.bookId,
  'userId': instance.userId,
  'rating': instance.rating,
  'title': instance.title,
  'content': instance.content,
  'containsSpoilers': instance.containsSpoilers,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

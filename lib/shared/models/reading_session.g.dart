// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadingSession _$ReadingSessionFromJson(Map<String, dynamic> json) =>
    _ReadingSession(
      id: json['id'] as String,
      pagesRead: (json['pagesRead'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ReadingSessionToJson(_ReadingSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pagesRead': instance.pagesRead,
      'createdAt': instance.createdAt.toIso8601String(),
    };

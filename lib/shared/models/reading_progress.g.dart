// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadingProgress _$ReadingProgressFromJson(Map<String, dynamic> json) =>
    _ReadingProgress(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      userId: json['userId'] as String,
      status:
          $enumDecodeNullable(_$ReadingStatusEnumMap, json['status']) ??
          ReadingStatus.notStarted,
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt(),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      finishedAt: json['finishedAt'] == null
          ? null
          : DateTime.parse(json['finishedAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$ReadingProgressToJson(_ReadingProgress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'userId': instance.userId,
      'status': _$ReadingStatusEnumMap[instance.status]!,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'progress': instance.progress,
      'startedAt': instance.startedAt?.toIso8601String(),
      'finishedAt': instance.finishedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'note': instance.note,
    };

const _$ReadingStatusEnumMap = {
  ReadingStatus.notStarted: 'notStarted',
  ReadingStatus.reading: 'reading',
  ReadingStatus.finished: 'finished',
  ReadingStatus.paused: 'paused',
  ReadingStatus.abandoned: 'abandoned',
  ReadingStatus.wantToRead: 'wantToRead',
};

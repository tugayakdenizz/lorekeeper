// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserBook _$UserBookFromJson(Map<String, dynamic> json) => _UserBook(
  id: json['id'] as String,
  book: Book.fromJson(json['book'] as Map<String, dynamic>),
  status:
      $enumDecodeNullable(_$UserBookStatusEnumMap, json['status']) ??
      UserBookStatus.wantToRead,
  currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
  isFavorite: json['isFavorite'] as bool? ?? false,
  userRating: (json['userRating'] as num?)?.toDouble(),
  addedAt: json['addedAt'] == null
      ? null
      : DateTime.parse(json['addedAt'] as String),
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  finishedAt: json['finishedAt'] == null
      ? null
      : DateTime.parse(json['finishedAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserBookToJson(_UserBook instance) => <String, dynamic>{
  'id': instance.id,
  'book': instance.book,
  'status': _$UserBookStatusEnumMap[instance.status]!,
  'currentPage': instance.currentPage,
  'isFavorite': instance.isFavorite,
  'userRating': instance.userRating,
  'addedAt': instance.addedAt?.toIso8601String(),
  'startedAt': instance.startedAt?.toIso8601String(),
  'finishedAt': instance.finishedAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

const _$UserBookStatusEnumMap = {
  UserBookStatus.wantToRead: 'wantToRead',
  UserBookStatus.reading: 'reading',
  UserBookStatus.finished: 'finished',
  UserBookStatus.dnf: 'dnf',
};

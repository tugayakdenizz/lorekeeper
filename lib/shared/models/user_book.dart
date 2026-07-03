import 'package:freezed_annotation/freezed_annotation.dart';

import 'book.dart';

part 'user_book.freezed.dart';
part 'user_book.g.dart';

enum UserBookStatus {
  wantToRead,
  reading,
  finished,
  dnf,
}

@freezed
abstract class UserBook with _$UserBook {
  const factory UserBook({
    required String id,
    required Book book,
    @Default(UserBookStatus.wantToRead) UserBookStatus status,
    @Default(0) int currentPage,
    @Default(false) bool isFavorite,
    double? userRating,
    DateTime? addedAt,
    DateTime? startedAt,
    DateTime? finishedAt,
    DateTime? updatedAt,
  }) = _UserBook;

  factory UserBook.fromJson(Map<String, dynamic> json) =>
      _$UserBookFromJson(json);
}
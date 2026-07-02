import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

@freezed
abstract class Book with _$Book {
  const factory Book({
    required String id,
    required String title,
    String? subtitle,
    String? originalTitle,
    required List<String> authors,
    String? description,
    String? isbn10,
    String? isbn13,
    String? googleBooksId,
    String? openLibraryId,
    String? language,
    int? pageCount,
    DateTime? publishedDate,
    String? publisher,
    String? coverUrl,
    @Default([]) List<String> categories,
    @Default(0.0) double averageRating,
    String? seriesId,
    int? volumeNumber,
    @Default(false) bool isFavorite,
    DateTime? createdAt,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);
}
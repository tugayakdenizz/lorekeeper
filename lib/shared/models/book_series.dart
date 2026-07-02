import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_series.freezed.dart';
part 'book_series.g.dart';

@freezed
abstract class BookSeries with _$BookSeries {
  const factory BookSeries({
    required String id,
    required String title,
    String? originalTitle,
    String? description,
    String? coverUrl,
    String? universeName,
    @Default([]) List<String> bookIds,
    @Default([]) List<String> authorIds,
    @Default(false) bool isCompleted,
    DateTime? createdAt,
  }) = _BookSeries;

  factory BookSeries.fromJson(Map<String, dynamic> json) =>
      _$BookSeriesFromJson(json);
}
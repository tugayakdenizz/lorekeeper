import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
abstract class Review with _$Review {
  const factory Review({
    required String id,
    required String bookId,
    required String userId,
    @Default(0.0) double rating,
    String? title,
    String? content,
    @Default(false) bool containsSpoilers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}
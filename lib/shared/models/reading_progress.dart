import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_progress.freezed.dart';
part 'reading_progress.g.dart';

enum ReadingStatus {
  notStarted,
  reading,
  finished,
  paused,
  abandoned,
  wantToRead,
}

@freezed
abstract class ReadingProgress with _$ReadingProgress {
  const factory ReadingProgress({
    required String id,
    required String bookId,
    required String userId,
    @Default(ReadingStatus.notStarted) ReadingStatus status,
    @Default(0) int currentPage,
    int? totalPages,
    @Default(0.0) double progress,
    DateTime? startedAt,
    DateTime? finishedAt,
    DateTime? updatedAt,
    String? note,
  }) = _ReadingProgress;

  factory ReadingProgress.fromJson(Map<String, dynamic> json) =>
      _$ReadingProgressFromJson(json);
}
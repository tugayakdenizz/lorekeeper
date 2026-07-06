import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_session.freezed.dart';
part 'reading_session.g.dart';

@freezed
abstract class ReadingSession with _$ReadingSession {
  const factory ReadingSession({
    required String id,
    required int pagesRead,
    required DateTime createdAt,
  }) = _ReadingSession;

  factory ReadingSession.fromJson(Map<String, dynamic> json) =>
      _$ReadingSessionFromJson(json);
}
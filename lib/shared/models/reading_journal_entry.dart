import 'package:hive/hive.dart';

part 'reading_journal_entry.g.dart';

@HiveType(typeId: 10)
class ReadingJournalEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String bookId;

  @HiveField(2)
  final String bookTitle;

  @HiveField(3)
  final int pagesRead;

  @HiveField(4)
  final DateTime createdAt;

  const ReadingJournalEntry({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.pagesRead,
    required this.createdAt,
  });
}
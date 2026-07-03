class ReadingLog {
  final String id;
  final String bookId;
  final String bookTitle;
  final int pagesRead;
  final DateTime date;

  const ReadingLog({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.pagesRead,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'pagesRead': pagesRead,
      'date': date.toIso8601String(),
    };
  }

  factory ReadingLog.fromJson(Map<String, dynamic> json) {
    return ReadingLog(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      bookTitle: json['bookTitle'] as String,
      pagesRead: json['pagesRead'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
class QuoteEntry {
  final String id;
  final String text;
  final String bookTitle;
  final String author;
  final String themeId;
  final DateTime createdAt;

  const QuoteEntry({required this.id, required this.text, required this.bookTitle, required this.author, required this.themeId, required this.createdAt});

  Map<String, dynamic> toMap() => {
    'id': id,
    'text': text,
    'bookTitle': bookTitle,
    'author': author,
    'themeId': themeId,
    'createdAt': createdAt.toIso8601String(),
  };

  factory QuoteEntry.fromMap(Map<dynamic, dynamic> map) => QuoteEntry(
    id: map['id'] as String? ?? '',
    text: map['text'] as String? ?? '',
    bookTitle: map['bookTitle'] as String? ?? '',
    author: map['author'] as String? ?? '',
    themeId: map['themeId'] as String? ?? 'gothic',
    createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
  );
}

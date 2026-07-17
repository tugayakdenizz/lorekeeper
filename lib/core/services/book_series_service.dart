import '../../shared/models/book.dart';
import '../../shared/models/book_series.dart';
import '../../shared/models/user_book.dart';

class BookSeriesService {
  const BookSeriesService();

  List<Book> orderedBooks({
    required BookSeries series,
    required List<Book> books,
  }) {
    final seriesBooks = books.where((book) {
      return book.seriesId == series.id || series.bookIds.contains(book.id);
    }).toList();

    seriesBooks.sort((a, b) {
      final aVolume = a.volumeNumber;
      final bVolume = b.volumeNumber;

      if (aVolume != null && bVolume != null) {
        return aVolume.compareTo(bVolume);
      }
      if (aVolume != null) return -1;
      if (bVolume != null) return 1;

      final aIndex = series.bookIds.indexOf(a.id);
      final bIndex = series.bookIds.indexOf(b.id);

      if (aIndex >= 0 && bIndex >= 0) return aIndex.compareTo(bIndex);
      if (aIndex >= 0) return -1;
      if (bIndex >= 0) return 1;

      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });

    return seriesBooks;
  }

  SeriesProgressData buildProgress({
    required BookSeries series,
    required List<Book> books,
    required List<UserBook> userBooks,
  }) {
    final ordered = orderedBooks(series: series, books: books);
    final userBookMap = {
      for (final userBook in userBooks) userBook.book.id: userBook,
    };

    final completedBooks = ordered.where((book) {
      return userBookMap[book.id]?.status == UserBookStatus.finished;
    }).toList();

    final readingBooks = ordered.where((book) {
      return userBookMap[book.id]?.status == UserBookStatus.reading;
    }).toList();

    final currentBook = readingBooks.isNotEmpty
        ? readingBooks.first
        : _firstUnfinishedBook(
            orderedBooks: ordered,
            userBookMap: userBookMap,
          );

    final nextBook = _nextBookAfter(
      currentBook: currentBook,
      orderedBooks: ordered,
      userBookMap: userBookMap,
    );

    final totalBooks = ordered.length;
    final completedCount = completedBooks.length;
    final progress =
        totalBooks == 0 ? 0.0 : (completedCount / totalBooks).clamp(0.0, 1.0);

    return SeriesProgressData(
      series: series,
      orderedBooks: ordered,
      completedBooks: completedBooks,
      currentBook: currentBook,
      nextBook: nextBook,
      completedCount: completedCount,
      totalBooks: totalBooks,
      progress: progress,
      isCompleted: totalBooks > 0 && completedCount == totalBooks,
    );
  }

  Book? findNextUnreadBook({
    required BookSeries series,
    required List<Book> books,
    required List<UserBook> userBooks,
  }) {
    final data = buildProgress(
      series: series,
      books: books,
      userBooks: userBooks,
    );
    return data.nextBook ?? data.currentBook;
  }

  Book? _firstUnfinishedBook({
    required List<Book> orderedBooks,
    required Map<String, UserBook> userBookMap,
  }) {
    for (final book in orderedBooks) {
      final userBook = userBookMap[book.id];
      if (userBook == null || userBook.status != UserBookStatus.finished) {
        return book;
      }
    }
    return null;
  }

  Book? _nextBookAfter({
    required Book? currentBook,
    required List<Book> orderedBooks,
    required Map<String, UserBook> userBookMap,
  }) {
    if (orderedBooks.isEmpty) return null;

    if (currentBook == null) {
      return _firstUnfinishedBook(
        orderedBooks: orderedBooks,
        userBookMap: userBookMap,
      );
    }

    final currentIndex =
        orderedBooks.indexWhere((book) => book.id == currentBook.id);

    if (currentIndex < 0 || currentIndex >= orderedBooks.length - 1) {
      return null;
    }

    for (var index = currentIndex + 1; index < orderedBooks.length; index++) {
      final candidate = orderedBooks[index];
      final userBook = userBookMap[candidate.id];

      if (userBook == null || userBook.status != UserBookStatus.finished) {
        return candidate;
      }
    }

    return null;
  }
}

class SeriesProgressData {
  final BookSeries series;
  final List<Book> orderedBooks;
  final List<Book> completedBooks;
  final Book? currentBook;
  final Book? nextBook;
  final int completedCount;
  final int totalBooks;
  final double progress;
  final bool isCompleted;

  const SeriesProgressData({
    required this.series,
    required this.orderedBooks,
    required this.completedBooks,
    required this.currentBook,
    required this.nextBook,
    required this.completedCount,
    required this.totalBooks,
    required this.progress,
    required this.isCompleted,
  });

  int get remainingCount => totalBooks - completedCount;
  int get progressPercent => (progress * 100).round();
  String get progressText => '$completedCount / $totalBooks kitap';
  bool get hasBooks => totalBooks > 0;
}
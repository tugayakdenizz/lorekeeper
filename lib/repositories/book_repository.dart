import '../core/services/google_books_service.dart';
import '../core/services/open_library_service.dart';
import '../shared/models/book.dart';

class BookRepository {
  final OpenLibraryService _openLibrary = OpenLibraryService();
  final GoogleBooksService _googleBooks = GoogleBooksService();

  Future<List<Book>> searchBooks(String query) async {
    final queries = _buildSearchQueries(query);
    final allResults = <Book>[];

    for (final searchQuery in queries) {
      final openLibraryResults = await _openLibrary.searchBooks(searchQuery);
      final googleResults = await _googleBooks.searchBooks(searchQuery);

      allResults.addAll(openLibraryResults);
      allResults.addAll(googleResults);
    }

    return _mergeBooks(allResults);
  }

  List<String> _buildSearchQueries(String query) {
    final trimmed = query.trim();
    final withoutTurkishChars = _removeTurkishChars(trimmed);

    return {
      trimmed,
      withoutTurkishChars,
      '$trimmed kitap',
      '$withoutTurkishChars kitap',
      '$trimmed roman',
      '$withoutTurkishChars roman',
    }.where((q) => q.trim().isNotEmpty).toList();
  }

  String _removeTurkishChars(String value) {
    return value
        .replaceAll('ç', 'c')
        .replaceAll('Ç', 'C')
        .replaceAll('ğ', 'g')
        .replaceAll('Ğ', 'G')
        .replaceAll('ı', 'i')
        .replaceAll('İ', 'I')
        .replaceAll('ö', 'o')
        .replaceAll('Ö', 'O')
        .replaceAll('ş', 's')
        .replaceAll('Ş', 'S')
        .replaceAll('ü', 'u')
        .replaceAll('Ü', 'U');
  }

  List<Book> _mergeBooks(List<Book> books) {
    final Map<String, Book> uniqueBooks = {};

    for (final book in books) {
      final key = _bookKey(book);
      uniqueBooks[key] = book;
    }

    return uniqueBooks.values.toList();
  }

  String _bookKey(Book book) {
    final author = book.authors.isNotEmpty ? book.authors.first : '';
    return '${book.title.toLowerCase()}-${author.toLowerCase()}';
  }
}
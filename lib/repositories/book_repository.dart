import '../core/services/google_books_service.dart';
import '../core/services/open_library_service.dart';
import '../shared/models/book.dart';

class BookRepository {
  final OpenLibraryService _openLibrary = OpenLibraryService();
  final GoogleBooksService _googleBooks = GoogleBooksService();

  Future<List<Book>> searchBooks(String query) async {
    final searchQuery = query.trim();

    if (searchQuery.isEmpty) return [];

    Object? lastError;

    try {
      final openLibraryResults = await _openLibrary.searchBooks(searchQuery);

      if (openLibraryResults.isNotEmpty) {
        return _mergeBooks(openLibraryResults);
      }
    } catch (error) {
      lastError = error;
    }

    try {
      final googleResults = await _googleBooks.searchBooks(searchQuery);

      if (googleResults.isNotEmpty) {
        return _mergeBooks(googleResults);
      }
    } catch (error) {
      lastError = error;
    }

    if (lastError != null) {
      throw lastError;
    }

    return [];
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
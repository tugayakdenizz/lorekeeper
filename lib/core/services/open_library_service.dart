import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../shared/models/book.dart';

class OpenLibraryService {
  static const String _baseUrl = 'https://openlibrary.org';

  Future<List<Book>> searchBooks(String query) async {
    if (query.trim().isEmpty) return [];

    final directResults = await _searchBooksByQuery(query);
    final authorResults = await _searchBooksByAuthorName(query);

    return _mergeBooks(directResults, authorResults);
  }

  Future<List<Book>> _searchBooksByQuery(String query) async {
    final uri = Uri.parse(
      '$_baseUrl/search.json?q=${Uri.encodeQueryComponent(query)}&limit=50',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) return [];

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final docs = data['docs'] as List<dynamic>? ?? [];

    return docs.map((item) {
      final json = item as Map<String, dynamic>;
      return _bookFromSearchJson(json);
    }).toList();
  }

  Future<List<Book>> _searchBooksByAuthorName(String authorName) async {
    final authorUri = Uri.parse(
      '$_baseUrl/search/authors.json?q=${Uri.encodeQueryComponent(authorName)}',
    );

    final authorResponse = await http.get(authorUri);

    if (authorResponse.statusCode != 200) return [];

    final authorData = jsonDecode(authorResponse.body) as Map<String, dynamic>;
    final authors = authorData['docs'] as List<dynamic>? ?? [];

    if (authors.isEmpty) return [];

    final normalizedQuery = _normalize(authorName);

    final exactAuthor = authors.cast<Map<String, dynamic>?>().firstWhere(
          (author) => _normalize(author?['name']?.toString() ?? '') == normalizedQuery,
          orElse: () => null,
        );

    final selectedAuthor = exactAuthor ?? authors.first as Map<String, dynamic>;
    final authorKey = selectedAuthor['key']?.toString();

    if (authorKey == null || authorKey.isEmpty) return [];

    final worksUri = Uri.parse(
      '$_baseUrl/authors/$authorKey/works.json?limit=100',
    );

    final worksResponse = await http.get(worksUri);

    if (worksResponse.statusCode != 200) return [];

    final worksData = jsonDecode(worksResponse.body) as Map<String, dynamic>;
    final entries = worksData['entries'] as List<dynamic>? ?? [];

    return entries.map((item) {
      final json = item as Map<String, dynamic>;
      return _bookFromAuthorWorkJson(json, selectedAuthor['name']?.toString());
    }).toList();
  }

  Book _bookFromSearchJson(Map<String, dynamic> json) {
    final coverId = json['cover_i'];
    final coverUrl = coverId != null
        ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
        : null;

    final authors = (json['author_name'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final languages = (json['language'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final isbns = (json['isbn'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return Book(
      id: json['key']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown Title',
      authors: authors,
      publishedDate: json['first_publish_year'] != null
          ? DateTime.tryParse('${json['first_publish_year']}-01-01')
          : null,
      coverUrl: coverUrl,
      language: languages.isNotEmpty ? languages.first : null,
      isbn10: isbns.isNotEmpty ? isbns.first : null,
    );
  }

  Book _bookFromAuthorWorkJson(
    Map<String, dynamic> json,
    String? authorName,
  ) {
    final coverIds = json['covers'] as List<dynamic>?;
    final coverId = coverIds != null && coverIds.isNotEmpty ? coverIds.first : null;

    final coverUrl = coverId != null
        ? 'https://covers.openlibrary.org/b/id/$coverId-L.jpg'
        : null;

    return Book(
      id: json['key']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown Title',
      authors: authorName == null ? [] : [authorName],
      description: _descriptionToString(json['description']),
      coverUrl: coverUrl,
      createdAt: json['created']?['value'] != null
          ? DateTime.tryParse(json['created']['value'].toString())
          : null,
    );
  }

  String? _descriptionToString(dynamic description) {
    if (description == null) return null;
    if (description is String) return description;
    if (description is Map<String, dynamic>) {
      return description['value']?.toString();
    }
    return null;
  }

  List<Book> _mergeBooks(List<Book> first, List<Book> second) {
    final Map<String, Book> uniqueBooks = {};

    for (final book in [...first, ...second]) {
      final key = '${book.title.toLowerCase()}-${book.authors.join(",").toLowerCase()}';
      uniqueBooks[key] = book;
    }

    return uniqueBooks.values.toList();
  }

  String _normalize(String value) {
    return value.trim().toLowerCase();
  }
}
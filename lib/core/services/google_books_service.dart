import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../shared/models/book.dart';

class GoogleBooksService {
  Future<List<Book>> searchBooks(String query) async {
    final uri = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeQueryComponent(query)}&maxResults=20',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      return [];
    }

    final data = jsonDecode(response.body);

    final items = data['items'] as List? ?? [];

    return items.map((item) {
      final volume = item['volumeInfo'] ?? {};

      return Book(
        id: item['id'] ?? '',
        title: volume['title'] ?? 'Unknown',
        subtitle: volume['subtitle'],
        authors:
            (volume['authors'] as List?)?.map((e) => e.toString()).toList() ??
                [],
        description: volume['description'],
        pageCount: volume['pageCount'],
        publisher: volume['publisher'],
        language: volume['language'],
        coverUrl: volume['imageLinks']?['thumbnail'],
        averageRating:
            (volume['averageRating'] as num?)?.toDouble() ?? 0,
        categories:
            (volume['categories'] as List?)?.map((e) => e.toString()).toList() ??
                [],
        googleBooksId: item['id'],
      );
    }).toList();
  }
}
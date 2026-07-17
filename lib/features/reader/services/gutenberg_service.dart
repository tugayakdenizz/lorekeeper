import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GutenbergBook {
  final int id;
  final String title;
  final String author;
  final List<String> languages;
  final int downloadCount;
  final String? coverUrl;
  final String? epubUrl;

  const GutenbergBook({
    required this.id,
    required this.title,
    required this.author,
    required this.languages,
    required this.downloadCount,
    required this.coverUrl,
    required this.epubUrl,
  });

  factory GutenbergBook.fromJson(Map<String, dynamic> json) {
    final authors = (json['authors'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map(
          (item) =>
              Map<String, dynamic>.from(item)['name'] as String? ?? '',
        )
        .where((name) => name.trim().isNotEmpty)
        .toList();

    final formats = Map<String, dynamic>.from(
      json['formats'] as Map? ?? const <String, dynamic>{},
    );

    String? findFormat(bool Function(String key) test) {
      for (final entry in formats.entries) {
        final url = entry.value;

        if (url is String && url.isNotEmpty && test(entry.key)) {
          return url.replaceFirst('http://', 'https://');
        }
      }

      return null;
    }

    return GutenbergBook(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? 'İsimsiz Kitap',
      author:
          authors.isEmpty ? 'Bilinmeyen yazar' : authors.join(', '),
      languages: List<String>.from(
        json['languages'] as List<dynamic>? ?? const [],
      ),
      downloadCount:
          (json['download_count'] as num?)?.toInt() ?? 0,
      coverUrl: findFormat(
        (key) => key.startsWith('image/jpeg'),
      ),
      epubUrl: findFormat(
            (key) =>
                key.startsWith('application/epub+zip') &&
                !key.contains('.images'),
          ) ??
          findFormat(
            (key) => key.startsWith('application/epub+zip'),
          ),
    );
  }
}

class GutenbergService {
  static const String _baseUrl = 'https://gutendex.com/books';

  Future<List<GutenbergBook>> search({
    required String query,
    String? language,
  }) async {
    final parameters = <String, String>{
      'copyright': 'false',
      'mime_type': 'application/epub+zip',
      'sort': 'popular',
    };

    if (query.trim().isNotEmpty) {
      parameters['search'] = query.trim();
    }

    if (language != null && language.isNotEmpty) {
      parameters['languages'] = language;
    }

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: parameters,
    );

    final response = await http.get(uri).timeout(
          const Duration(seconds: 25),
        );

    if (response.statusCode != 200) {
      throw Exception(
        'Gutenberg kataloğuna bağlanılamadı '
        '(${response.statusCode}).',
      );
    }

    final json = jsonDecode(
      utf8.decode(response.bodyBytes),
    );

    final results =
        json['results'] as List<dynamic>? ?? const [];

    return results
        .whereType<Map>()
        .map(
          (item) => GutenbergBook.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .where((book) => book.epubUrl != null)
        .toList();
  }

  Future<GutenbergBook?> findBestMatch({
    required String title,
    required List<String> authors,
  }) async {
    final books = await search(query: title);

    if (books.isEmpty) {
      return null;
    }

    final normalizedTitle = _normalize(title);
    final normalizedAuthors = authors
        .map(_normalize)
        .where((value) => value.isNotEmpty)
        .toList();

    GutenbergBook? bestBook;
    var bestScore = -1;

    for (final book in books) {
      final candidateTitle = _normalize(book.title);
      final candidateAuthor = _normalize(book.author);

      var score = 0;

      if (candidateTitle == normalizedTitle) {
        score += 100;
      } else if (candidateTitle.contains(normalizedTitle) ||
          normalizedTitle.contains(candidateTitle)) {
        score += 70;
      } else {
        final requestedWords =
            normalizedTitle.split(' ').where((word) => word.length > 2);
        final matchedWords = requestedWords
            .where(candidateTitle.contains)
            .length;
        score += matchedWords * 8;
      }

      for (final author in normalizedAuthors) {
        if (candidateAuthor.contains(author) ||
            author.contains(candidateAuthor)) {
          score += 45;
        } else {
          final authorParts =
              author.split(' ').where((part) => part.length > 2);
          score += authorParts
                  .where(candidateAuthor.contains)
                  .length *
              10;
        }
      }

      if (score > bestScore) {
        bestScore = score;
        bestBook = book;
      }
    }

    if (bestScore < 35) {
      return null;
    }

    return bestBook;
  }

  Future<Uint8List> downloadEpub(String url) async {
    final targetUri = Uri.parse(url);

    // Project Gutenberg dosya sunucusu tarayıcıdan doğrudan
    // isteklerde CORS başlığı vermediği için yalnızca web
    // geliştirme ortamında CORS proxy kullanılır.
    final requestUri = kIsWeb
        ? Uri.parse(
            'https://corsproxy.io/?url='
            '${Uri.encodeComponent(targetUri.toString())}',
          )
        : targetUri;

    final response = await http.get(requestUri).timeout(
          const Duration(seconds: 60),
        );

    if (response.statusCode != 200) {
      throw Exception(
        'Kitap indirilemedi (${response.statusCode}).',
      );
    }

    if (response.bodyBytes.isEmpty) {
      throw Exception('İndirilen EPUB dosyası boş geldi.');
    }

    return response.bodyBytes;
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9çğıöşü\s]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

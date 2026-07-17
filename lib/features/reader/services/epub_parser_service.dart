import 'dart:typed_data';

import 'package:epub_plus/epub_plus.dart';

import '../models/reader_document.dart';

class EpubParserService {
  Future<ReaderDocument> parse({
    required Uint8List bytes,
    required String fallbackTitle,
    required String fallbackAuthor,
    required String documentId,
    required ReaderSourceType sourceType,
    String? sourceUrl,
  }) async {
    final epubBook = await EpubReader.readBook(bytes);
    final chapters = <ReaderChapter>[];

    _appendChapters(
      epubBook.chapters,
      chapters,
    );

    if (chapters.isEmpty) {
      throw const FormatException(
        'EPUB içinde okunabilir bölüm bulunamadı.',
      );
    }

    final title = (epubBook.title ?? '').trim();
    final author = (epubBook.author ?? '').trim();

    return ReaderDocument(
      id: documentId,
      title: title.isEmpty ? fallbackTitle : title,
      author: author.isEmpty ? fallbackAuthor : author,
      sourceType: sourceType,
      chapters: chapters,
      epubBytes: bytes,
      sourceUrl: sourceUrl,
    );
  }

  void _appendChapters(
    List<EpubChapter> source,
    List<ReaderChapter> target,
  ) {
    for (final chapter in source) {
      final plainText = _htmlToPlainText(
        chapter.htmlContent ?? '',
      );

      if (plainText.isNotEmpty) {
        target.add(
          ReaderChapter(
            title: _cleanTitle(chapter.title),
            content: plainText,
          ),
        );
      }

      if (chapter.subChapters.isNotEmpty) {
        _appendChapters(
          chapter.subChapters,
          target,
        );
      }
    }
  }

  String _cleanTitle(String? value) {
    final title = _htmlToPlainText(value ?? '').trim();
    return title.isEmpty ? 'Bölüm' : title;
  }

  String _htmlToPlainText(String html) {
    var value = html;

    value = value.replaceAll(
      RegExp(
        r'<(script|style)[^>]*>.*?</\1>',
        caseSensitive: false,
        dotAll: true,
      ),
      '',
    );

    value = value
        .replaceAll(
          RegExp(
            r'<br\s*/?>',
            caseSensitive: false,
          ),
          '\n',
        )
        .replaceAll(
          RegExp(
            r'</(p|div|h1|h2|h3|h4|h5|h6|li|blockquote)>',
            caseSensitive: false,
          ),
          '\n\n',
        )
        .replaceAll(
          RegExp(r'<[^>]+>'),
          '',
        );

    const entities = <String, String>{
      '&nbsp;': ' ',
      '&amp;': '&',
      '&quot;': '"',
      '&#39;': "'",
      '&apos;': "'",
      '&lt;': '<',
      '&gt;': '>',
      '&mdash;': '—',
      '&ndash;': '–',
      '&hellip;': '…',
    };

    for (final entry in entities.entries) {
      value = value.replaceAll(
        entry.key,
        entry.value,
      );
    }

    value = value.replaceAllMapped(
      RegExp(r'&#(\d+);'),
      (match) {
        final code = int.tryParse(
          match.group(1) ?? '',
        );

        if (code == null) {
          return '';
        }

        return String.fromCharCode(code);
      },
    );

    return value
        .replaceAll('\r', '')
        .replaceAll(
          RegExp(r'[ \t]+\n'),
          '\n',
        )
        .replaceAll(
          RegExp(r'\n[ \t]+'),
          '\n',
        )
        .replaceAll(
          RegExp(r'\n{3,}'),
          '\n\n',
        )
        .trim();
  }
}

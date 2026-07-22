import 'dart:convert';
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
    final images = _createImageMap(epubBook.content?.images);
    final chapters = <ReaderChapter>[];

    _appendChapters(epubBook.chapters, chapters, images);

    if (chapters.isEmpty) {
      throw const FormatException('EPUB içinde okunabilir bölüm bulunamadı.');
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

  Map<String, String> _createImageMap(Map<String, EpubByteContentFile>? source) {
    final result = <String, String>{};
    if (source == null) return result;

    for (final entry in source.entries) {
      final content = entry.value.content;
      if (content == null || content.isEmpty) continue;
      final mime = entry.value.contentMimeType ?? _mimeFromName(entry.key);
      final uri = 'data:$mime;base64,${base64Encode(content)}';
      final normalized = _normalizePath(entry.key);
      result[normalized] = uri;
      result[normalized.split('/').last] = uri;
    }
    return result;
  }

  void _appendChapters(
    List<EpubChapter> source,
    List<ReaderChapter> target,
    Map<String, String> images,
  ) {
    for (final chapter in source) {
      final rawHtml = chapter.htmlContent ?? '';
      final html = _prepareHtml(rawHtml, images);
      final plain = _htmlToPlainText(rawHtml);

      if (plain.isNotEmpty) {
        target.add(
          ReaderChapter(
            title: _cleanTitle(chapter.title),
            htmlContent: html,
            plainText: plain,
            wordCount: _wordCount(plain),
          ),
        );
      }

      if (chapter.subChapters.isNotEmpty) {
        _appendChapters(chapter.subChapters, target, images);
      }
    }
  }

  String _prepareHtml(String html, Map<String, String> images) {
    var value = html.replaceAll(
      RegExp(r'<(script|iframe|object)[^>]*>.*?</\1>', caseSensitive: false, dotAll: true),
      '',
    );

    value = value.replaceAllMapped(
      RegExp(r'''(<img\b[^>]*?\bsrc\s*=\s*["'])([^"']+)(["'][^>]*>)''', caseSensitive: false),
      (match) {
        final src = match.group(2) ?? '';
        if (src.startsWith('data:') || src.startsWith('http')) return match.group(0)!;
        final clean = _normalizePath(Uri.decodeComponent(src.split('#').first.split('?').first));
        final replacement = images[clean] ?? images[clean.split('/').last];
        if (replacement == null) return match.group(0)!;
        return '${match.group(1)}$replacement${match.group(3)}';
      },
    );

    return value.trim();
  }

  String _cleanTitle(String? value) {
    final title = _htmlToPlainText(value ?? '').trim();
    return title.isEmpty ? 'Bölüm' : title;
  }

  int _wordCount(String value) => value
      .split(RegExp(r'\s+'))
      .where((item) => item.trim().isNotEmpty)
      .length;

  String _normalizePath(String value) {
    final parts = <String>[];
    for (final part in value.replaceAll('\\', '/').split('/')) {
      if (part.isEmpty || part == '.') continue;
      if (part == '..') {
        if (parts.isNotEmpty) parts.removeLast();
      } else {
        parts.add(part);
      }
    }
    return parts.join('/').toLowerCase();
  }

  String _mimeFromName(String value) {
    final lower = value.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.svg')) return 'image/svg+xml';
    return 'image/jpeg';
  }

  String _htmlToPlainText(String html) {
    var value = html
        .replaceAll(RegExp(r'<(script|style)[^>]*>.*?</\1>', caseSensitive: false, dotAll: true), '')
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</(p|div|h1|h2|h3|h4|h5|h6|li|blockquote)>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'<[^>]+>'), '');

    const entities = <String, String>{
      '&nbsp;': ' ', '&amp;': '&', '&quot;': '"', '&#39;': "'", '&apos;': "'",
      '&lt;': '<', '&gt;': '>', '&mdash;': '—', '&ndash;': '–', '&hellip;': '…',
    };
    for (final entry in entities.entries) {
      value = value.replaceAll(entry.key, entry.value);
    }
    value = value.replaceAllMapped(RegExp(r'&#(\d+);'), (m) {
      final code = int.tryParse(m.group(1) ?? '');
      return code == null ? '' : String.fromCharCode(code);
    });
    return value
        .replaceAll('\r', '')
        .replaceAll(RegExp(r'[ \t]+\n'), '\n')
        .replaceAll(RegExp(r'\n[ \t]+'), '\n')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }
}

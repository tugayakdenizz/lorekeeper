import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/reader_document.dart';
import 'epub_file_store.dart';

class DownloadedBookInfo {
  final String bookId;
  final String documentId;
  final String fileName;
  final String title;
  final String author;
  final ReaderSourceType sourceType;
  final String? sourceUrl;
  final String? filePath;
  final int fileSize;
  final DateTime downloadedAt;

  const DownloadedBookInfo({
    required this.bookId,
    required this.documentId,
    required this.fileName,
    required this.title,
    required this.author,
    required this.sourceType,
    required this.fileSize,
    required this.downloadedAt,
    this.sourceUrl,
    this.filePath,
  });

  Map<String, dynamic> toJson() => {
        'bookId': bookId,
        'documentId': documentId,
        'fileName': fileName,
        'title': title,
        'author': author,
        'sourceType': sourceType.name,
        'sourceUrl': sourceUrl,
        'filePath': filePath,
        'fileSize': fileSize,
        'downloadedAt': downloadedAt.toIso8601String(),
      };

  factory DownloadedBookInfo.fromJson(Map<String, dynamic> json) {
    final sourceName = json['sourceType'] as String?;
    final sourceType = ReaderSourceType.values.firstWhere(
      (item) => item.name == sourceName,
      orElse: () => ReaderSourceType.localEpub,
    );

    return DownloadedBookInfo(
      bookId: json['bookId'] as String? ?? '',
      documentId: json['documentId'] as String? ?? '',
      fileName: json['fileName'] as String? ?? 'book.epub',
      title: json['title'] as String? ?? 'İsimsiz Kitap',
      author: json['author'] as String? ?? 'Bilinmeyen yazar',
      sourceType: sourceType,
      sourceUrl: json['sourceUrl'] as String?,
      filePath: json['filePath'] as String?,
      fileSize: (json['fileSize'] as num?)?.toInt() ?? 0,
      downloadedAt: DateTime.tryParse(json['downloadedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class StoredReaderBook {
  final DownloadedBookInfo info;
  final Uint8List bytes;

  const StoredReaderBook({required this.info, required this.bytes});
}

class ReaderStorageService {
  static const String _boxName = 'reader_library_v2';
  final EpubFileStore _fileStore = EpubFileStore();

  Future<Box<dynamic>> _openBox() async => Hive.isBoxOpen(_boxName)
      ? Hive.box<dynamic>(_boxName)
      : Hive.openBox<dynamic>(_boxName);


  Future<bool> hasAcknowledgedPublicDomainNotice() async {
    final box = await _openBox();
    return box.get('settings:public-domain-notice-v1') == true;
  }

  Future<void> acknowledgePublicDomainNotice() async {
    final box = await _openBox();
    await box.put('settings:public-domain-notice-v1', true);
  }

  Future<void> saveProgress(String documentId, ReaderProgress progress) async {
    final box = await _openBox();
    await box.put('progress:$documentId', progress.toJson());
  }

  Future<ReaderProgress> loadProgress(String documentId) async {
    final box = await _openBox();
    final raw = box.get('progress:$documentId');
    return raw is Map
        ? ReaderProgress.fromJson(Map<String, dynamic>.from(raw))
        : const ReaderProgress();
  }

  Future<DownloadedBookInfo> saveDownloadedEpub({
    required String bookId,
    required String documentId,
    required String fileName,
    required String title,
    required String author,
    required ReaderSourceType sourceType,
    required Uint8List bytes,
    String? sourceUrl,
  }) async {
    final box = await _openBox();
    final filePath = await _fileStore.write(bookId: bookId, bytes: bytes);

    final info = DownloadedBookInfo(
      bookId: bookId,
      documentId: documentId,
      fileName: fileName,
      title: title,
      author: author,
      sourceType: sourceType,
      sourceUrl: sourceUrl,
      filePath: filePath,
      fileSize: bytes.length,
      downloadedAt: DateTime.now(),
    );

    await box.put('download:$bookId', info.toJson());

    // Web ve dosya sistemi olmayan platformlar için güvenli yedek.
    if (filePath == null) {
      await box.put('download-bytes:$bookId', bytes);
    } else {
      await box.delete('download-bytes:$bookId');
    }

    return info;
  }

  Future<DownloadedBookInfo?> getDownloadedBookInfo(String bookId) async {
    final box = await _openBox();
    final raw = box.get('download:$bookId');
    if (raw is! Map) return null;
    return DownloadedBookInfo.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<bool> hasDownloadedBook(String bookId) async {
    return await loadDownloadedBook(bookId) != null;
  }

  Future<StoredReaderBook?> loadDownloadedBook(String bookId) async {
    final box = await _openBox();
    final info = await getDownloadedBookInfo(bookId);
    if (info == null) return null;

    Uint8List? bytes;
    if ((info.filePath ?? '').isNotEmpty) {
      bytes = await _fileStore.read(info.filePath!);
    }

    bytes ??= _bytesFromRaw(box.get('download-bytes:$bookId'));

    if (bytes == null || bytes.isEmpty) {
      await box.delete('download:$bookId');
      await box.delete('download-bytes:$bookId');
      return null;
    }

    return StoredReaderBook(info: info, bytes: bytes);
  }

  Future<void> deleteDownloadedBook(String bookId) async {
    final box = await _openBox();
    final info = await getDownloadedBookInfo(bookId);

    if ((info?.filePath ?? '').isNotEmpty) {
      await _fileStore.delete(info!.filePath!);
    }

    await box.delete('download:$bookId');
    await box.delete('download-bytes:$bookId');

    // progress:<documentId> özellikle silinmez.
    // Yer imleri, notlar ve okuma konumu korunur.
  }

  Uint8List? _bytesFromRaw(dynamic raw) {
    if (raw is Uint8List) return raw;
    if (raw is List<int>) return Uint8List.fromList(raw);
    if (raw is List) return Uint8List.fromList(raw.cast<int>());
    return null;
  }
}

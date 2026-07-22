import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/reader_document.dart';

class ReaderStorageService {
  static const String _boxName = 'reader_library_v1';

  Future<Box<dynamic>> _openBox() async => Hive.isBoxOpen(_boxName)
      ? Hive.box<dynamic>(_boxName)
      : Hive.openBox<dynamic>(_boxName);

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

  Future<void> saveLocalEpub({
    required String documentId,
    required String fileName,
    required Uint8List bytes,
  }) async {
    final box = await _openBox();
    await box.put('epub:$documentId', {'fileName': fileName, 'bytes': bytes});
  }

  Future<Uint8List?> loadLocalEpub(String documentId) async {
    final box = await _openBox();
    final raw = box.get('epub:$documentId');
    if (raw is! Map) return null;
    final bytes = raw['bytes'];
    if (bytes is Uint8List) return bytes;
    if (bytes is List<int>) return Uint8List.fromList(bytes);
    return null;
  }
}

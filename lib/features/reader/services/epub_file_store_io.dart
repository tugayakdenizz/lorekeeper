import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class EpubFileStore {
  Future<String?> write({
    required String bookId,
    required Uint8List bytes,
  }) async {
    final root = await getApplicationDocumentsDirectory();
    final directory = Directory('${root.path}/reader_books');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final safeName = bookId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final file = File('${directory.path}/$safeName.epub');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<Uint8List?> read(String path) async {
    final file = File(path);
    if (!await file.exists()) return null;
    return file.readAsBytes();
  }

  Future<void> delete(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

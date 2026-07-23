import 'dart:typed_data';

class EpubFileStore {
  Future<String?> write({
    required String bookId,
    required Uint8List bytes,
  }) async {
    return null;
  }

  Future<Uint8List?> read(String path) async {
    return null;
  }

  Future<void> delete(String path) async {}
}

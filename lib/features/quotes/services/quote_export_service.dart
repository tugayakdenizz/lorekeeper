import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class QuoteExportService {
  Future<File> exportPng({
    required RenderRepaintBoundary boundary,
    required String fileName,
  }) async {
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    if (bytes == null) {
      throw StateError('Alıntı görseli oluşturulamadı.');
    }

    final directory = await getTemporaryDirectory();
    final safeName = fileName
        .replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')
        .replaceAll(RegExp(r'_+'), '_');

    final file = File('${directory.path}/$safeName.png');
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);

    return file;
  }

  Future<void> shareFile({
    required File file,
    String? text,
    ui.Rect? sharePositionOrigin,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: text,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }
}

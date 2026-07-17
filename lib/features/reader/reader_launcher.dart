import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../shared/models/book.dart';
import 'models/reader_document.dart';
import 'reader_screen.dart';
import 'services/epub_parser_service.dart';
import 'services/gutenberg_service.dart';
import 'services/reader_storage_service.dart';

class ReaderLauncher {
  static final _parser = EpubParserService();
  static final _storage = ReaderStorageService();
  static final _gutenberg = GutenbergService();

  static Future<void> showSourcePicker({
    required BuildContext context,
    required Book book,
  }) async {
    final selection =
        await showModalBottomSheet<_ReaderSourceSelection>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ReaderSourceSheet(
        bookTitle: book.title,
      ),
    );

    if (selection == null || !context.mounted) {
      return;
    }

    switch (selection) {
      case _ReaderSourceSelection.localEpub:
        await _openLocalEpub(
          context: context,
          book: book,
        );
      case _ReaderSourceSelection.gutenberg:
        await _openMatchedGutenbergBook(
          context: context,
          book: book,
        );
    }
  }

  static Future<void> _openLocalEpub({
    required BuildContext context,
    required Book book,
  }) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['epub'],
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final file = result.files.single;
      final bytes = file.bytes;

      if (bytes == null) {
        throw Exception(
          'EPUB dosyası okunamadı. Lütfen tekrar seç.',
        );
      }

      if (!context.mounted) {
        return;
      }

      _showLoading(
        context,
        'EPUB hazırlanıyor…',
      );

      final documentId =
          'local:${book.id}:${file.name.hashCode}';

      final document = await _parser.parse(
        bytes: Uint8List.fromList(bytes),
        fallbackTitle: book.title,
        fallbackAuthor: book.authors.join(', '),
        documentId: documentId,
        sourceType: ReaderSourceType.localEpub,
      );

      await _storage.saveLocalEpub(
        documentId: document.id,
        fileName: file.name,
        bytes: Uint8List.fromList(bytes),
      );

      if (!context.mounted) {
        return;
      }

      Navigator.pop(context);
      await _openReader(context, document);
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      _closeLoadingIfOpen(context);
      _showError(context, error);
    }
  }

  static Future<void> _openMatchedGutenbergBook({
    required BuildContext context,
    required Book book,
  }) async {
    var loadingIsOpen = false;

    try {
      _showLoading(
        context,
        '"${book.title}" Gutenberg’de aranıyor…',
      );
      loadingIsOpen = true;

      final selected = await _gutenberg.findBestMatch(
        title: book.title,
        authors: book.authors,
      );

      if (!context.mounted) {
        return;
      }

      if (selected == null || selected.epubUrl == null) {
        Navigator.pop(context);
        loadingIsOpen = false;

        _showNotAvailableDialog(
          context: context,
          bookTitle: book.title,
        );
        return;
      }

      final bytes = await _gutenberg.downloadEpub(
        selected.epubUrl!,
      );

      final document = await _parser.parse(
        bytes: bytes,
        fallbackTitle: selected.title,
        fallbackAuthor: selected.author,
        documentId: 'gutenberg:${selected.id}',
        sourceType: ReaderSourceType.gutenberg,
        sourceUrl: selected.epubUrl,
      );

      if (!context.mounted) {
        return;
      }

      Navigator.pop(context);
      loadingIsOpen = false;

      await _openReader(context, document);
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      if (loadingIsOpen) {
        Navigator.pop(context);
      }

      _showError(context, error);
    }
  }

  static Future<void> _openReader(
    BuildContext context,
    ReaderDocument document,
  ) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReaderScreen(
          document: document,
        ),
      ),
    );
  }

  static void _showLoading(
    BuildContext context,
    String text,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          content: Row(
            children: [
              const CircularProgressIndicator(
                color: AppColors.gold,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void _showNotAvailableDialog({
    required BuildContext context,
    required String bookTitle,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            'Ücretsiz sürüm bulunamadı',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            '"$bookTitle" için Project Gutenberg’de '
            'eşleşen ücretsiz EPUB bulunamadı. Kendi yasal '
            'EPUB dosyanı seçerek okumaya devam edebilirsin.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  static void _closeLoadingIfOpen(
    BuildContext context,
  ) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  static void _showError(
    BuildContext context,
    Object error,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error
              .toString()
              .replaceFirst('Exception: ', ''),
        ),
      ),
    );
  }
}

enum _ReaderSourceSelection {
  localEpub,
  gutenberg,
}

class _ReaderSourceSheet extends StatelessWidget {
  final String bookTitle;

  const _ReaderSourceSheet({
    required this.bookTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        30,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Okuma Kaynağını Seç',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 21,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"$bookTitle" kitabını hangi kaynaktan '
              'açmak istediğini seç.',
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            _SourceTile(
              icon: Icons.public_rounded,
              title: 'Gutenberg’de Bu Kitabı Bul',
              subtitle:
                  'Yalnızca seçtiğin kitabın ücretsiz sürümü aranır.',
              onTap: () => Navigator.pop(
                context,
                _ReaderSourceSelection.gutenberg,
              ),
            ),
            const SizedBox(height: 12),
            _SourceTile(
              icon: Icons.upload_file_rounded,
              title: 'Kendi EPUB Dosyamı Seç',
              subtitle:
                  'Bu kitaba ait cihazındaki EPUB dosyasını aç.',
              onTap: () => Navigator.pop(
                context,
                _ReaderSourceSelection.localEpub,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SourceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.gold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

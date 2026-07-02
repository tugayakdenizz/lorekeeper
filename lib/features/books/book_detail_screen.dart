import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/book.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({
    super.key,
    required this.book,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final _storage = LibraryStorageService();

  bool get _isAdded => _storage.containsBook(widget.book.id);

  Future<void> _toggleBook() async {
    await _storage.toggleBook(widget.book);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final author =
        book.authors.isNotEmpty ? book.authors.join(', ') : 'Unknown author';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: book.coverUrl == null
                      ? Container(
                          width: 150,
                          height: 220,
                          color: AppColors.surfaceLight,
                          child: const Icon(
                            Icons.menu_book_rounded,
                            size: 56,
                            color: AppColors.gold,
                          ),
                        )
                      : Image.network(
                          book.coverUrl!,
                          width: 150,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                book.title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                author,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  if (book.publishedDate != null)
                    _InfoChip(text: '📅 ${book.publishedDate!.year}'),
                  if (book.pageCount != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    _InfoChip(text: '📖 ${book.pageCount}'),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _toggleBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isAdded ? AppColors.surfaceLight : AppColors.gold,
                    foregroundColor:
                        _isAdded ? AppColors.textPrimary : AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    _isAdded ? 'Kütüphaneden Çıkar' : 'Kütüphaneye Ekle',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (book.description != null) ...[
                const Text(
                  'Açıklama',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  book.description!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String text;

  const _InfoChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/book.dart';
import '../../shared/models/user_book.dart';

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

  UserBook? get _userBook {
    try {
      return _storage
          .getUserBooks()
          .firstWhere((item) => item.book.id == widget.book.id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _toggleBook() async {
    await _storage.toggleBook(widget.book);
    setState(() {});
  }

  Future<void> _updateStatus(UserBookStatus status) async {
    if (!_isAdded) {
      await _storage.addBook(widget.book);
    }

    final current = _userBook;
    if (current == null) return;

    await _storage.updateUserBook(
      current.copyWith(
        status: status,
        startedAt: status == UserBookStatus.reading
            ? current.startedAt ?? DateTime.now()
            : current.startedAt,
        finishedAt: status == UserBookStatus.finished
            ? DateTime.now()
            : current.finishedAt,
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final author =
        book.authors.isNotEmpty ? book.authors.join(', ') : 'Unknown author';

    final selectedStatus = _userBook?.status;

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
              const Text(
                'Okuma Durumu',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _StatusChip(
                    label: 'Okuyacağım',
                    isSelected: selectedStatus == UserBookStatus.wantToRead,
                    onTap: () => _updateStatus(UserBookStatus.wantToRead),
                  ),
                  _StatusChip(
                    label: 'Okuyorum',
                    isSelected: selectedStatus == UserBookStatus.reading,
                    onTap: () => _updateStatus(UserBookStatus.reading),
                  ),
                  _StatusChip(
                    label: 'Bitirdim',
                    isSelected: selectedStatus == UserBookStatus.finished,
                    onTap: () => _updateStatus(UserBookStatus.finished),
                  ),
                  _StatusChip(
                    label: 'Yarım Bıraktım',
                    isSelected: selectedStatus == UserBookStatus.dnf,
                    onTap: () => _updateStatus(UserBookStatus.dnf),
                  ),
                ],
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

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : AppColors.surface,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.background : AppColors.textSecondary,
            fontWeight: FontWeight.w800,
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
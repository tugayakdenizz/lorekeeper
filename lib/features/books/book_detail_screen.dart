import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/book.dart';
import '../../shared/models/user_book.dart';
import 'widgets/book_header.dart';
import 'widgets/description_section.dart';
import 'widgets/info_chips.dart';
import 'widgets/reading_progress_section.dart';

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

  int? get _totalPages {
    final userBook = _userBook;
    return userBook?.totalPagesOverride ?? widget.book.pageCount;
  }

  Future<void> _toggleBook() async {
    await _storage.toggleBook(widget.book);
    setState(() {});
  }

  Future<void> _toggleFavorite() async {
    if (!_isAdded) {
      await _storage.addBook(widget.book);
    }

    final current = _userBook;
    if (current == null) return;

    await _storage.updateUserBook(
      current.copyWith(isFavorite: !current.isFavorite),
    );

    setState(() {});
  }

  Future<void> _updateRating(double rating) async {
    if (!_isAdded) {
      await _storage.addBook(widget.book);
    }

    final current = _userBook;
    if (current == null) return;

    await _storage.updateUserBook(
      current.copyWith(userRating: rating),
    );

    setState(() {});
  }

  Future<void> _updateStatus(UserBookStatus status) async {
    if (!_isAdded) {
      await _storage.addBook(widget.book);
    }

    final current = _userBook;
    if (current == null) return;

    final totalPages = current.totalPagesOverride ?? current.book.pageCount;

    await _storage.updateUserBook(
      current.copyWith(
        status: status,
        currentPage: status == UserBookStatus.finished && totalPages != null
            ? totalPages
            : current.currentPage,
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

  Future<void> _showProgressSheet() async {
    if (!_isAdded) {
      await _storage.addBook(widget.book);
    }

    final current = _userBook;
    if (current == null) return;

    final currentPageController = TextEditingController(
      text: current.currentPage == 0 ? '' : current.currentPage.toString(),
    );

    final totalPageController = TextEditingController(
      text:
          (current.totalPagesOverride ?? current.book.pageCount)?.toString() ??
              '',
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'İlerlemeyi Güncelle',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _ProgressField(
                controller: currentPageController,
                hintText: 'Bulunduğun sayfa',
              ),
              const SizedBox(height: AppSpacing.md),
              _ProgressField(
                controller: totalPageController,
                hintText: 'Toplam sayfa',
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final currentPage =
                        int.tryParse(currentPageController.text.trim()) ?? 0;
                    final totalPages =
                        int.tryParse(totalPageController.text.trim());

                    final safePage = totalPages == null
                        ? currentPage
                        : currentPage.clamp(0, totalPages);

                    await _storage.updateUserBook(
                      current.copyWith(
                        currentPage: safePage,
                        totalPagesOverride: totalPages,
                        status: safePage > 0
                            ? UserBookStatus.reading
                            : current.status,
                        startedAt: current.startedAt ?? DateTime.now(),
                      ),
                    );

                    if (!mounted) return;

                    Navigator.pop(context);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Kaydet',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final userBook = _userBook;

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
              Center(child: _BookCover(book: book)),
              const SizedBox(height: AppSpacing.lg),
              BookHeader(
                title: book.title,
                author: author,
                isFavorite: userBook?.isFavorite == true,
                onFavoritePressed: _toggleFavorite,
              ),
              InfoChips(book: book, totalPages: _totalPages),
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
              _ReadingStatusSection(
                selectedStatus: userBook?.status,
                onStatusChanged: _updateStatus,
              ),
              const SizedBox(height: AppSpacing.xl),
              _RatingSection(
                rating: userBook?.userRating,
                onRatingChanged: _updateRating,
              ),
              const SizedBox(height: AppSpacing.xl),
              ReadingProgressSection(
                userBook: userBook,
                totalPages: _totalPages,
                onUpdatePressed: _showProgressSheet,
              ),
              const SizedBox(height: AppSpacing.xl),
              DescriptionSection(description: book.description),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  final Book book;

  const _BookCover({required this.book});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
    );
  }
}

class _ProgressField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const _ProgressField({
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _ReadingStatusSection extends StatelessWidget {
  final UserBookStatus? selectedStatus;
  final ValueChanged<UserBookStatus> onStatusChanged;

  const _ReadingStatusSection({
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              onTap: () => onStatusChanged(UserBookStatus.wantToRead),
            ),
            _StatusChip(
              label: 'Okuyorum',
              isSelected: selectedStatus == UserBookStatus.reading,
              onTap: () => onStatusChanged(UserBookStatus.reading),
            ),
            _StatusChip(
              label: 'Bitirdim',
              isSelected: selectedStatus == UserBookStatus.finished,
              onTap: () => onStatusChanged(UserBookStatus.finished),
            ),
            _StatusChip(
              label: 'Yarım Bıraktım',
              isSelected: selectedStatus == UserBookStatus.dnf,
              onTap: () => onStatusChanged(UserBookStatus.dnf),
            ),
          ],
        ),
      ],
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

class _RatingSection extends StatelessWidget {
  final double? rating;
  final ValueChanged<double> onRatingChanged;

  const _RatingSection({
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedRating = rating ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Puanım',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: List.generate(5, (index) {
            final starValue = index + 1;
            final isSelected = selectedRating >= starValue;

            return IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 42,
                minHeight: 42,
              ),
              onPressed: () => onRatingChanged(starValue.toDouble()),
              icon: Icon(
                isSelected
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: AppColors.gold,
                size: 34,
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          selectedRating == 0
              ? 'Henüz puan vermedin.'
              : '${selectedRating.toStringAsFixed(0)} / 5',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

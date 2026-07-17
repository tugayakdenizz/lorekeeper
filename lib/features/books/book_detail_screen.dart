import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/book.dart';
import '../../shared/models/user_book.dart';
import 'widgets/book_cover.dart';
import 'widgets/description_section.dart';
import 'widgets/info_chips.dart';
import 'widgets/progress_bottom_sheet.dart';
import 'widgets/rating_section.dart';
import 'widgets/reading_progress_section.dart';
import 'widgets/reading_sessions_section.dart';
import 'widgets/book_series_section.dart';
import '../reader/reader_launcher.dart';

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


  Future<void> _toggleSeriesTracking() async {
    if (!_isAdded) {
      await _storage.addBook(widget.book);
    }

    final current = _userBook;
    if (current == null) return;

    final fallbackSeriesTitle =
        (current.book.seriesId ?? '').trim().isNotEmpty
            ? current.book.seriesId!.trim()
            : current.book.title.trim();

    await _storage.updateUserBook(
      current.copyWith(
        isSeriesTracked: !current.isSeriesTracked,
        trackedSeriesTitle: current.isSeriesTracked
            ? null
            : fallbackSeriesTitle,
        updatedAt: DateTime.now(),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }


  Future<void> _openReader() async {
    await ReaderLauncher.showSourcePicker(
      context: context,
      book: widget.book,
    );

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _showProgressSheet() async {
    if (!_isAdded) {
      await _storage.addBook(widget.book);
    }

    final current = _userBook;
    if (current == null) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        return ProgressBottomSheet(
          userBook: current,
          onSave: (updatedUserBook) async {
            await _storage.updateUserBook(updatedUserBook);
            if (mounted) {
              setState(() {});
            }
          },
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
              _TopBar(
                isFavorite: userBook?.isFavorite == true,
                onBackPressed: () => Navigator.pop(context),
                onFavoritePressed: _toggleFavorite,
              ),
              const SizedBox(height: AppSpacing.md),

              _HeroBookSection(
                book: book,
                author: author,
                totalPages: _totalPages,
                rating: userBook?.userRating,
              ),

              const SizedBox(height: AppSpacing.xl),

              _PrimaryActionButton(
                isAdded: _isAdded,
                onPressed: _toggleBook,
              ),

              const SizedBox(height: AppSpacing.md),

              _ReadBookButton(
                hasProgress: (userBook?.currentPage ?? 0) > 0,
                onPressed: _openReader,
              ),

              const SizedBox(height: AppSpacing.xl),

              _PremiumSection(
                child: _ReadingStatusSection(
                  selectedStatus: userBook?.status,
                  onStatusChanged: _updateStatus,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              _PremiumSection(
                child: RatingSection(
                  rating: userBook?.userRating,
                  onRatingChanged: _updateRating,
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              _PremiumSection(
                child: ReadingProgressSection(
                  userBook: userBook,
                  totalPages: _totalPages,
                  onUpdatePressed: _showProgressSheet,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              _PremiumSection(
                child: BookSeriesSection(
                  seriesTitle: (userBook?.trackedSeriesTitle ??
                          book.seriesId ??
                          book.title)
                      .trim(),
                  volumeNumber: book.volumeNumber,
                  isTracked: userBook?.isSeriesTracked == true,
                  onToggleTracking: _toggleSeriesTracking,
                ),
              ),

              if (userBook != null) ...[
                const SizedBox(height: AppSpacing.lg),
                _PremiumSection(
                  child: ReadingSessionsSection(
                    sessions: userBook.readingSessions,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _PremiumSection(
                  child: _BookStatsSection(
                    userBook: userBook,
                    totalPages: _totalPages,
                  ),
                ),
              ],

              if ((book.description ?? '').trim().isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                _PremiumSection(
                  child: DescriptionSection(description: book.description),
                ),
              ],

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}


class _BookStatsSection extends StatelessWidget {
  final UserBook userBook;
  final int? totalPages;

  const _BookStatsSection({
    required this.userBook,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final rating = userBook.userRating;
    final addedAt = userBook.addedAt;
    final progressText = totalPages == null || totalPages == 0
        ? '${userBook.currentPage} sayfa'
        : '${userBook.currentPage} / $totalPages sayfa';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📚 Kitap İstatistikleri',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _BookStatRow(
          icon: Icons.auto_stories_rounded,
          label: 'Durum',
          value: _statusText(userBook.status),
        ),
        _BookStatRow(
          icon: Icons.trending_up_rounded,
          label: 'İlerleme',
          value: progressText,
        ),
        _BookStatRow(
          icon: Icons.star_rounded,
          label: 'Puanın',
          value: rating == null ? 'Henüz yok' : '${rating.toStringAsFixed(0)} / 5',
        ),
        _BookStatRow(
          icon: Icons.favorite_rounded,
          label: 'Favori',
          value: userBook.isFavorite ? 'Evet' : 'Hayır',
        ),
        _BookStatRow(
          icon: Icons.calendar_month_rounded,
          label: 'Eklenme',
          value: addedAt == null ? 'Bilinmiyor' : _dateText(addedAt),
          isLast: true,
        ),
      ],
    );
  }

  String _statusText(UserBookStatus status) {
    switch (status) {
      case UserBookStatus.wantToRead:
        return 'Okuyacağım';
      case UserBookStatus.reading:
        return 'Okuyorum';
      case UserBookStatus.finished:
        return 'Bitirdim';
      case UserBookStatus.dnf:
        return 'Yarım Bıraktım';
    }
  }

  String _dateText(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }
}

class _BookStatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _BookStatRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 12,
        bottom: isLast ? 0 : 12,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColors.border.withOpacity(0.7),
                ),
              ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.gold,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}


class _TopBar extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onBackPressed;
  final VoidCallback onFavoritePressed;

  const _TopBar({
    required this.isFavorite,
    required this.onBackPressed,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onPressed: onBackPressed,
        ),
        const Spacer(),
        _CircleIconButton(
          icon: isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          onPressed: onFavoritePressed,
          isActive: isFavorite,
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isActive;

  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isActive ? AppColors.gold : AppColors.surface,
      borderRadius: BorderRadius.circular(99),
      child: InkWell(
        borderRadius: BorderRadius.circular(99),
        onTap: onPressed,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: isActive ? AppColors.gold : AppColors.border,
            ),
          ),
          child: Icon(
            icon,
            color: isActive ? AppColors.background : AppColors.gold,
            size: 21,
          ),
        ),
      ),
    );
  }
}

class _HeroBookSection extends StatelessWidget {
  final Book book;
  final String author;
  final int? totalPages;
  final double? rating;

  const _HeroBookSection({
    required this.book,
    required this.author,
    required this.totalPages,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surfaceLight.withOpacity(0.55),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.08),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background.withOpacity(0.55),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.gold.withOpacity(0.18)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.16),
                  blurRadius: 36,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: BookCover(
              coverUrl: book.coverUrl,
              width: 156,
              height: 230,
              borderRadius: 22,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            book.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              height: 1.12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            author,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          InfoChips(book: book, totalPages: totalPages),
          if (rating != null) ...[
            const SizedBox(height: AppSpacing.md),
            _RatingBadge(rating: rating!),
          ],
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;

  const _RatingBadge({
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.12),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: AppColors.gold.withOpacity(0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            color: AppColors.gold,
            size: 18,
          ),
          const SizedBox(width: 5),
          Text(
            '${rating.toStringAsFixed(0)} / 5',
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  final bool isAdded;
  final VoidCallback onPressed;

  const _PrimaryActionButton({
    required this.isAdded,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          isAdded
              ? Icons.remove_circle_outline_rounded
              : Icons.add_circle_outline_rounded,
        ),
        label: Text(
          isAdded ? 'Kütüphaneden Çıkar' : 'Kütüphaneye Ekle',
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isAdded ? AppColors.surfaceLight : AppColors.gold,
          foregroundColor: isAdded ? AppColors.textPrimary : AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isAdded ? AppColors.border : AppColors.gold,
            ),
          ),
        ),
      ),
    );
  }
}


class _ReadBookButton extends StatelessWidget {
  final bool hasProgress;
  final VoidCallback onPressed;

  const _ReadBookButton({
    required this.hasProgress,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.auto_stories_rounded),
        label: Text(
          hasProgress ? 'Okumaya Devam Et' : 'Kitabı Oku',
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class _PremiumSection extends StatelessWidget {
  final Widget child;

  const _PremiumSection({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : AppColors.background,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.border,
          ),
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

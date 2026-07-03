import 'package:flutter/material.dart';

import '../../../core/services/library_storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/user_book.dart';
import '../../books/book_detail_screen.dart';
import 'reading_progress_bar.dart';

class LibraryBookCard extends StatelessWidget {
  final UserBook userBook;

  const LibraryBookCard({
    super.key,
    required this.userBook,
  });

  @override
  Widget build(BuildContext context) {
    final storage = LibraryStorageService();
    final book = userBook.book;

    final totalPages = userBook.totalPagesOverride ?? book.pageCount;

    double progress = 0;

    if (userBook.status == UserBookStatus.finished) {
      progress = 1;
    } else if (totalPages != null && totalPages > 0) {
      progress = (userBook.currentPage / totalPages).clamp(0.0, 1.0);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookDetailScreen(book: book),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: book.coverUrl == null
                  ? Container(
                      width: 74,
                      height: 110,
                      color: AppColors.surfaceLight,
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: AppColors.gold,
                      ),
                    )
                  : Image.network(
                      book.coverUrl!,
                      width: 74,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      if (userBook.isFavorite)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(
                            Icons.favorite_rounded,
                            color: AppColors.gold,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    book.authors.isNotEmpty
                        ? book.authors.join(', ')
                        : 'Unknown author',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (userBook.userRating != null) ...[
                    const SizedBox(height: 8),
                    _RatingPreview(rating: userBook.userRating!),
                  ],
                  const SizedBox(height: 12),
                  ReadingProgressBar(progress: progress),
                  const SizedBox(height: 8),
                  Text(
                    _progressText(userBook),
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                storage.removeBook(book.id);
              },
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.gold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _progressText(UserBook userBook) {
    final book = userBook.book;
    final totalPages = userBook.totalPagesOverride ?? book.pageCount;

    switch (userBook.status) {
      case UserBookStatus.wantToRead:
        return '⭐ Okuyacağım';

      case UserBookStatus.reading:
        if (totalPages != null && totalPages > 0) {
          final percent = ((userBook.currentPage / totalPages) * 100).round();
          return '${userBook.currentPage} / $totalPages sayfa • $percent%';
        }
        return '📖 Okuyorum';

      case UserBookStatus.finished:
        return '✅ Tamamlandı • 100%';

      case UserBookStatus.dnf:
        return '❌ Yarım bırakıldı';
    }
  }
}

class _RatingPreview extends StatelessWidget {
  final double rating;

  const _RatingPreview({
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final roundedRating = rating.round();

    return Row(
      children: [
        ...List.generate(5, (index) {
          final isSelected = index < roundedRating;

          return Icon(
            isSelected ? Icons.star_rounded : Icons.star_border_rounded,
            color: AppColors.gold,
            size: 17,
          );
        }),
        const SizedBox(width: 6),
        Text(
          '${rating.toStringAsFixed(0)} / 5',
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

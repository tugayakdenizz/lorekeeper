import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/user_book.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ValueListenableBuilder<List<UserBook>>(
            valueListenable: LibraryStorageService.userBooksNotifier,
            builder: (context, userBooks, _) {
              final readingBooks = userBooks
                  .where((e) => e.status == UserBookStatus.reading)
                  .toList();

              final finishedBooks = userBooks
                  .where((e) => e.status == UserBookStatus.finished)
                  .toList();

              final wantToReadBooks = userBooks
                  .where((e) => e.status == UserBookStatus.wantToRead)
                  .toList();

              final favoriteBooks =
                  userBooks.where((e) => e.isFavorite).toList();

              final continueBook =
                  readingBooks.isNotEmpty ? readingBooks.first : null;

              final totalPagesRead = userBooks.fold<int>(
                0,
                (total, item) => total + item.currentPage,
              );

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Diyar',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Okuma yolculuğuna devam et.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    if (continueBook != null)
                      _ContinueReadingCard(userBook: continueBook)
                    else
                      const _EmptyContinueCard(),

                    const SizedBox(height: AppSpacing.xl),

                    _ReadingGoalCard(
                      finishedCount: finishedBooks.length,
                      goalCount: 30,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Okuyorum',
                            value: readingBooks.length.toString(),
                            icon: Icons.auto_stories_rounded,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            title: 'Bitirdim',
                            value: finishedBooks.length.toString(),
                            icon: Icons.check_circle_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),

                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Sayfa',
                            value: totalPagesRead.toString(),
                            icon: Icons.menu_book_rounded,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            title: 'Toplam',
                            value: userBooks.length.toString(),
                            icon: Icons.library_books_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    _FavoriteBooksSection(favoriteBooks: favoriteBooks),

                    const SizedBox(height: AppSpacing.xl),

                    const Text(
                      'Son Eklenenler',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    if (userBooks.isEmpty)
                      const Text(
                        'Henüz kitap eklemedin.',
                        style: TextStyle(color: AppColors.textSecondary),
                      )
                    else
                      ...userBooks.reversed.take(3).map(
                            (userBook) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.md,
                              ),
                              child: _MiniBookCard(userBook: userBook),
                            ),
                          ),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ContinueReadingCard extends StatelessWidget {
  final UserBook userBook;

  const _ContinueReadingCard({required this.userBook});

  @override
  Widget build(BuildContext context) {
    final book = userBook.book;
    final totalPages = userBook.totalPagesOverride ?? book.pageCount;

    final progress = totalPages != null && totalPages > 0
        ? (userBook.currentPage / totalPages).clamp(0.0, 1.0)
        : 0.0;

    final percent = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: book.coverUrl == null
                ? Container(
                    width: 88,
                    height: 132,
                    color: AppColors.surfaceLight,
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.gold,
                    ),
                  )
                : Image.network(
                    book.coverUrl!,
                    width: 88,
                    height: 132,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Devam Et',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  book.authors.isNotEmpty
                      ? book.authors.join(', ')
                      : 'Unknown author',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: AppColors.background.withOpacity(0.55),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.gold),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  totalPages == null
                      ? '${userBook.currentPage} sayfa'
                      : '${userBook.currentPage} / $totalPages sayfa • $percent%',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyContinueCard extends StatelessWidget {
  const _EmptyContinueCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_stories_rounded, color: AppColors.gold),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Okumaya başladığın bir kitap burada görünecek.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingGoalCard extends StatelessWidget {
  final int finishedCount;
  final int goalCount;

  const _ReadingGoalCard({
    required this.finishedCount,
    required this.goalCount,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goalCount > 0
        ? (finishedCount / goalCount).clamp(0.0, 1.0)
        : 0.0;

    final percent = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎯 Okuma Hedefi',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$finishedCount / $goalCount kitap • $percent%',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.background.withOpacity(0.55),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteBooksSection extends StatelessWidget {
  final List<UserBook> favoriteBooks;

  const _FavoriteBooksSection({
    required this.favoriteBooks,
  });

  @override
  Widget build(BuildContext context) {
    if (favoriteBooks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          children: [
            Icon(Icons.favorite_border_rounded, color: AppColors.gold),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Favori kitapların burada görünecek.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '❤️ Favoriler (${favoriteBooks.length})',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...favoriteBooks.take(3).map(
              (userBook) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _MiniBookCard(userBook: userBook),
              ),
            ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.gold),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            title,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _MiniBookCard extends StatelessWidget {
  final UserBook userBook;

  const _MiniBookCard({required this.userBook});

  @override
  Widget build(BuildContext context) {
    final book = userBook.book;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: book.coverUrl == null
                ? Container(
                    width: 48,
                    height: 70,
                    color: AppColors.surfaceLight,
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.gold,
                    ),
                  )
                : Image.network(
                    book.coverUrl!,
                    width: 48,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _statusText(userBook.status),
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (userBook.isFavorite)
            const Icon(
              Icons.favorite_rounded,
              color: AppColors.gold,
              size: 20,
            ),
        ],
      ),
    );
  }

  String _statusText(UserBookStatus status) {
    switch (status) {
      case UserBookStatus.wantToRead:
        return '⭐ Okuyacağım';
      case UserBookStatus.reading:
        return '📖 Okuyorum';
      case UserBookStatus.finished:
        return '✅ Bitirdim';
      case UserBookStatus.dnf:
        return '❌ Yarım Bıraktım';
    }
  }
}

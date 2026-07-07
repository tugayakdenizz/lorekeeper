import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/services/reading_goal_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/user_book.dart';
import '../books/book_detail_screen.dart';
import '../books/widgets/book_cover.dart';
import '../../shared/widgets/empty_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<String> _mysticMessages = [
    'Sisler çöktü, okumaya devam et.',
    'Her kitap yeni bir sır saklar.',
    'Kredik Shaw seni bekliyor.',
    'Bugün hangi sırrı keşfedeceksin?',
    'Her sayfa yeni bir efsanenin başlangıcıdır.',
    'Bir sonraki bölüm sislerin ardında.',
    'Bilgelik bazen eski bir sayfada saklıdır.',
    'Okuduğun her kitap kendi efsaneni büyütür.',
  ];

  late String _currentMysticMessage;

  @override
  void initState() {
    super.initState();
    _currentMysticMessage = _pickMessage();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentMysticMessage = _pickMessage(except: _currentMysticMessage);
  }

  String _pickMessage({String? except}) {
    final random = Random(DateTime.now().microsecondsSinceEpoch);

    if (_mysticMessages.length == 1) {
      return _mysticMessages.first;
    }

    String selected = _mysticMessages[random.nextInt(_mysticMessages.length)];

    while (selected == except) {
      selected = _mysticMessages[random.nextInt(_mysticMessages.length)];
    }

    return selected;
  }

  void _openBookDetail(BuildContext context, UserBook userBook) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookDetailScreen(book: userBook.book),
      ),
    );
  }

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
                      'Kredik Shaw',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 320),
                      transitionBuilder: (child, animation) {
                        final slideAnimation = Tween<Offset>(
                          begin: const Offset(0, 0.25),
                          end: Offset.zero,
                        ).animate(animation);

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: slideAnimation,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        _currentMysticMessage,
                        key: ValueKey(_currentMysticMessage),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    if (continueBook != null)
                      _ContinueReadingCard(
                        userBook: continueBook,
                        onTap: () => _openBookDetail(context, continueBook),
                      )
                    else
                      const _EmptyContinueCard(),
                    const SizedBox(height: AppSpacing.xl),
                    ValueListenableBuilder<int>(
                      valueListenable: ReadingGoalService.goalNotifier,
                      builder: (context, goal, _) {
                        return _ReadingGoalCard(
                          finishedCount: finishedBooks.length,
                          goalCount: goal,
                        );
                      },
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
                    _FavoriteBooksSection(
                      favoriteBooks: favoriteBooks,
                      onBookTap: (userBook) =>
                          _openBookDetail(context, userBook),
                    ),
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
                      const SizedBox(
                        height: 260,
                        child: EmptyState(
                          icon: Icons.library_books_rounded,
                          title: 'Henüz kitap eklemedin',
                          subtitle:
                              'İlk kitabını Keşfet bölümünden ekleyerek kütüphaneni oluşturmaya başla.',
                        ),
                      )
                    else
                      ...userBooks.reversed.take(3).map(
                            (userBook) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.md,
                              ),
                              child: _MiniBookCard(
                                userBook: userBook,
                                onTap: () =>
                                    _openBookDetail(context, userBook),
                              ),
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
  final VoidCallback onTap;

  const _ContinueReadingCard({
    required this.userBook,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final book = userBook.book;
    final totalPages = userBook.totalPagesOverride ?? book.pageCount;

    final progress = totalPages != null && totalPages > 0
        ? (userBook.currentPage / totalPages).clamp(0.0, 1.0)
        : 0.0;

    final percent = (progress * 100).round();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            BookCover(
              coverUrl: book.coverUrl,
              width: 88,
              height: 132,
              borderRadius: 18,
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
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.gold,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyContinueCard extends StatelessWidget {
  const _EmptyContinueCard();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 320,
      child: EmptyState(
        icon: Icons.auto_stories_rounded,
        title: 'Sisler sessiz...',
        subtitle:
            'Şu anda okumakta olduğun bir kitap bulunmuyor.\nKeşfet bölümünden bir kitap ekleyerek macerana başlayabilirsin.',
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
    final remaining = (goalCount - finishedCount).clamp(0, goalCount);

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
          const SizedBox(height: 14),
          Text(
            remaining == 0
                ? '🎉 Tebrikler! Yıllık hedefini tamamladın.'
                : '$remaining kitap kaldı.',
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w800,
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
  final ValueChanged<UserBook> onBookTap;

  const _FavoriteBooksSection({
    required this.favoriteBooks,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    if (favoriteBooks.isEmpty) {
      return const SizedBox(
        height: 260,
        child: EmptyState(
          icon: Icons.favorite_rounded,
          title: 'Henüz favori kitabın yok',
          subtitle:
              'Beğendiğin kitaplara kalp bırakarak burada görünmelerini sağlayabilirsin.',
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
                child: _MiniBookCard(
                  userBook: userBook,
                  onTap: () => onBookTap(userBook),
                ),
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
  final VoidCallback onTap;

  const _MiniBookCard({
    required this.userBook,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final book = userBook.book;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            BookCover(
              coverUrl: book.coverUrl,
              width: 48,
              height: 70,
              borderRadius: 12,
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
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.favorite_rounded,
                  color: AppColors.gold,
                  size: 20,
                ),
              ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
            ),
          ],
        ),
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

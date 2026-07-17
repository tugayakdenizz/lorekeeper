import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/user_book.dart';
import '../books/book_detail_screen.dart';
import 'widgets_v2/achievement_strip.dart';
import 'widgets_v2/current_quest_card.dart';
import 'widgets_v2/hero_header.dart';
import 'widgets_v2/reading_streak_card.dart';
import 'widgets_v2/upcoming_release_section.dart';
import 'widgets_v2/worlds_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<String> _dailyLoreQuotes = [
    'Bir sayfa daha, yeni bir kader.',
    'Bazı kapılar yalnızca okuyanlara açılır.',
    'Her hikâye, keşfedilmeyi bekleyen bir diyardır.',
    'Sessizlikte kalan sözcükler en güçlü büyüyü taşır.',
    'Bir kitabın sonu, başka bir evrenin başlangıcıdır.',
    'Okuduğun her bölüm efsanene yeni bir iz bırakır.',
    'Kayıp dünyalar, onları hatırlayacak bir okur bekler.',
    'Bilgelik bazen unutulmuş bir sayfanın arasında saklanır.',
  ];

  void _openBook(
    BuildContext context,
    UserBook userBook,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookDetailScreen(
          book: userBook.book,
        ),
      ),
    );
  }

  String _quoteOfTheDay() {
    final now = DateTime.now();
    final dayNumber = now.difference(DateTime(now.year, 1, 1)).inDays;

    return _dailyLoreQuotes[
        dayNumber % _dailyLoreQuotes.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ValueListenableBuilder<List<UserBook>>(
          valueListenable:
              LibraryStorageService.userBooksNotifier,
          builder: (context, userBooks, _) {
            final readingBooks = userBooks
                .where(
                  (item) =>
                      item.status == UserBookStatus.reading,
                )
                .toList();

            final finishedBooks = userBooks
                .where(
                  (item) =>
                      item.status == UserBookStatus.finished,
                )
                .toList();

            final currentQuest = readingBooks.isEmpty
                ? null
                : readingBooks.first;

            final totalPagesRead = userBooks.fold<int>(
              0,
              (sum, item) => sum + item.currentPage,
            );

            final level = 1 + (finishedBooks.length ~/ 3);

            final xp =
                (finishedBooks.length * 250) +
                totalPagesRead;

            final streakDays =
                _calculateStreakDays(userBooks);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  HeroHeader(
                    title: 'Kredik Shaw',
                    subtitle: _quoteOfTheDay(),
                    level: level,
                    xp: xp,
                    streakDays: streakDays,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  CurrentQuestCard(
                    userBook: currentQuest,
                    onTap: currentQuest == null
                        ? null
                        : () => _openBook(
                              context,
                              currentQuest,
                            ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  UpcomingReleaseSection(
                    books: userBooks,
                    onBookTap: (userBook) {
                      _openBook(context, userBook);
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  WorldsSection(
                    books: userBooks,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ReadingStreakCard(
                    books: userBooks,
                    dailyPageGoal: 30,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AchievementStrip(
                    books: userBooks,
                    streakDays: streakDays,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  int _calculateStreakDays(
    List<UserBook> books,
  ) {
    final readDates = <DateTime>{};

    for (final book in books) {
      for (final session in book.readingSessions) {
        final date = session.createdAt;

        readDates.add(
          DateTime(
            date.year,
            date.month,
            date.day,
          ),
        );
      }
    }

    final now = DateTime.now();
    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    var cursor = today;

    if (!readDates.contains(today)) {
      cursor = today.subtract(
        const Duration(days: 1),
      );
    }

    var streak = 0;

    while (readDates.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(
        const Duration(days: 1),
      );
    }

    return streak;
  }
}
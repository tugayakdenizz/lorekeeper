import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/user_book.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              final finished = userBooks
                  .where((e) => e.status == UserBookStatus.finished)
                  .length;

              final reading = userBooks
                  .where((e) => e.status == UserBookStatus.reading)
                  .length;

              final favoriteBooks =
                  userBooks.where((e) => e.isFavorite).toList();

              final ratedBooks =
                  userBooks.where((e) => e.userRating != null).toList();

              final averageRating = ratedBooks.isEmpty
                  ? 0.0
                  : ratedBooks
                          .map((e) => e.userRating!)
                          .reduce((a, b) => a + b) /
                      ratedBooks.length;

              final pages = userBooks.fold<int>(
                0,
                (total, item) => total + item.currentPage,
              );

              final achievements = _buildAchievements(
                totalBooks: userBooks.length,
                finishedBooks: finished,
                favoriteBooks: favoriteBooks.length,
                ratedBooks: ratedBooks.length,
                pagesRead: pages,
              );

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profil',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _ProfileHeader(),
                    const SizedBox(height: AppSpacing.xl),
                    Row(
                      children: [
                        Expanded(
                          child: _StatBox(
                            value: '${userBooks.length}',
                            label: 'Kitap',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatBox(
                            value: '$finished',
                            label: 'Bitirdi',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _StatBox(
                            value: '$reading',
                            label: 'Okuyor',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatBox(
                            value: '$pages',
                            label: 'Sayfa',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _StatBox(
                            value: averageRating.toStringAsFixed(1),
                            label: 'Ortalama Puan',
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatBox(
                            value: '${favoriteBooks.length}',
                            label: 'Favori',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _AchievementsSection(achievements: achievements),
                    const SizedBox(height: AppSpacing.xl),
                    _FavoritesSection(favoriteBooks: favoriteBooks),
                    const SizedBox(height: AppSpacing.xl),
                    const _MenuTile(
                      icon: Icons.language,
                      title: 'Dil',
                      subtitle: 'Türkçe / English yakında',
                    ),
                    const _MenuTile(
                      icon: Icons.dark_mode_rounded,
                      title: 'Tema',
                      subtitle: 'Dark mode aktif',
                    ),
                    const _MenuTile(
                      icon: Icons.emoji_events_rounded,
                      title: 'Başarılar',
                      subtitle: 'Rozetler aktif',
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<_Achievement> _buildAchievements({
    required int totalBooks,
    required int finishedBooks,
    required int favoriteBooks,
    required int ratedBooks,
    required int pagesRead,
  }) {
    return [
      _Achievement(
        emoji: '📚',
        title: 'İlk Kitap',
        description: 'Kütüphanene ilk kitabını ekledin.',
        isUnlocked: totalBooks >= 1,
      ),
      _Achievement(
        emoji: '📖',
        title: 'Kitap Kurdu',
        description: 'Toplam 1000 sayfa ilerleme kaydettin.',
        isUnlocked: pagesRead >= 1000,
      ),
      _Achievement(
        emoji: '✅',
        title: 'Bitirici',
        description: 'İlk kitabını bitirdin.',
        isUnlocked: finishedBooks >= 1,
      ),
      _Achievement(
        emoji: '👑',
        title: 'Usta Okur',
        description: '10 kitabı tamamladın.',
        isUnlocked: finishedBooks >= 10,
      ),
      _Achievement(
        emoji: '❤️',
        title: 'Favori Rafı',
        description: '5 kitabı favorilerine ekledin.',
        isUnlocked: favoriteBooks >= 5,
      ),
      _Achievement(
        emoji: '⭐',
        title: 'Eleştirmen',
        description: '5 kitaba puan verdin.',
        isUnlocked: ratedBooks >= 5,
      ),
    ];
  }
}

class _Achievement {
  final String emoji;
  final String title;
  final String description;
  final bool isUnlocked;

  const _Achievement({
    required this.emoji,
    required this.title,
    required this.description,
    required this.isUnlocked,
  });
}

class _AchievementsSection extends StatelessWidget {
  final List<_Achievement> achievements;

  const _AchievementsSection({
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    final unlockedCount =
        achievements.where((achievement) => achievement.isUnlocked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🏆 Başarılar ($unlockedCount/${achievements.length})',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...achievements.map(
          (achievement) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _AchievementCard(achievement: achievement),
          ),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final _Achievement achievement;

  const _AchievementCard({
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: achievement.isUnlocked ? 1 : 0.45,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: achievement.isUnlocked ? AppColors.gold : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Text(
              achievement.emoji,
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              achievement.isUnlocked
                  ? Icons.check_circle_rounded
                  : Icons.lock_rounded,
              color: AppColors.gold,
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesSection extends StatelessWidget {
  final List<UserBook> favoriteBooks;

  const _FavoritesSection({
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
                'Henüz favori kitabın yok.',
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
        ...favoriteBooks.map(
          (userBook) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _FavoriteBookCard(userBook: userBook),
          ),
        ),
      ],
    );
  }
}

class _FavoriteBookCard extends StatelessWidget {
  final UserBook userBook;

  const _FavoriteBookCard({
    required this.userBook,
  });

  @override
  Widget build(BuildContext context) {
    final book = userBook.book;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
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
                  book.authors.isNotEmpty
                      ? book.authors.join(', ')
                      : 'Unknown author',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                if (userBook.userRating != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index < userBook.userRating!.round()
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: AppColors.gold,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${userBook.userRating!.toStringAsFixed(0)} / 5',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.favorite_rounded, color: AppColors.gold),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

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
          CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.gold,
            child: Icon(Icons.person, color: AppColors.background, size: 34),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LoreKeeper',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kişisel okuma asistanın',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;

  const _StatBox({
    required this.value,
    required this.label,
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
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

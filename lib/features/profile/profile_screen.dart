import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/services/reading_goal_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/user_book.dart';
import 'widgets/achievements_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _showGoalSheet(BuildContext context, int currentGoal) async {
    final controller = TextEditingController(text: currentGoal.toString());

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
                'Yıllık Okuma Hedefi',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Örn: 30',
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final goal = int.tryParse(controller.text.trim()) ?? 30;
                    final safeGoal = goal <= 0 ? 1 : goal;

                    await ReadingGoalService().updateGoal(safeGoal);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
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

    controller.dispose();
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
                    ValueListenableBuilder<int>(
                      valueListenable: ReadingGoalService.goalNotifier,
                      builder: (context, goal, _) {
                        return _ReadingGoalSettingsCard(
                          goal: goal,
                          finishedCount: finished,
                          onEditPressed: () => _showGoalSheet(context, goal),
                        );
                      },
                    ),
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
                    AchievementsSection(userBooks: userBooks),
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

}

class _ReadingGoalSettingsCard extends StatelessWidget {
  final int goal;
  final int finishedCount;
  final VoidCallback onEditPressed;

  const _ReadingGoalSettingsCard({
    required this.goal,
    required this.finishedCount,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal > 0 ? (finishedCount / goal).clamp(0.0, 1.0) : 0.0;
    final percent = (progress * 100).round();
    final remaining = (goal - finishedCount).clamp(0, goal);

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
            '🎯 Yıllık Hedef',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$finishedCount / $goal kitap • $percent%',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.background.withOpacity(0.55),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            remaining == 0
                ? '🎉 Hedef tamamlandı.'
                : '$remaining kitap kaldı.',
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onEditPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.gold,
                side: const BorderSide(color: AppColors.gold),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'Hedefi Değiştir',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
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

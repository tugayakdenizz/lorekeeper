import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/user_book.dart';

class AchievementsSection extends StatelessWidget {
  final List<UserBook> userBooks;

  const AchievementsSection({
    super.key,
    required this.userBooks,
  });

  @override
  Widget build(BuildContext context) {
    final finishedCount = userBooks
        .where((book) => book.status == UserBookStatus.finished)
        .length;

    final totalBooks = userBooks.length;

    final favoriteCount = userBooks.where((book) => book.isFavorite).length;

    final totalPages = userBooks.fold<int>(
      0,
      (total, item) => total + item.currentPage,
    );

    final achievements = [
      _AchievementData(
        icon: Icons.menu_book_rounded,
        title: 'İlk Kitap',
        subtitle: 'İlk kitabını kütüphanene ekle.',
        current: totalBooks,
        target: 1,
      ),
      _AchievementData(
        icon: Icons.auto_stories_rounded,
        title: 'Sislerin Yolcusu',
        subtitle: '10 kitap bitir.',
        current: finishedCount,
        target: 10,
      ),
      _AchievementData(
        icon: Icons.workspace_premium_rounded,
        title: 'Kredik Shaw Muhafızı',
        subtitle: '25 kitap bitir.',
        current: finishedCount,
        target: 25,
      ),
      _AchievementData(
        icon: Icons.favorite_rounded,
        title: 'Sadık Okur',
        subtitle: '5 favori kitap seç.',
        current: favoriteCount,
        target: 5,
      ),
      _AchievementData(
        icon: Icons.local_fire_department_rounded,
        title: 'Sayfa Avcısı',
        subtitle: '1000 sayfa oku.',
        current: totalPages,
        target: 1000,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🏆 Başarımlar',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...achievements.map(
          (achievement) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _AchievementCard(data: achievement),
          ),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final _AchievementData data;

  const _AchievementCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final progress = data.target == 0
        ? 0.0
        : (data.current / data.target).clamp(0.0, 1.0);

    final isCompleted = data.current >= data.target;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isCompleted
              ? AppColors.gold.withOpacity(0.55)
              : AppColors.border,
        ),
        boxShadow: isCompleted
            ? [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.08),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.gold
                  : AppColors.background.withOpacity(0.65),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCompleted ? AppColors.gold : AppColors.border,
              ),
            ),
            child: Icon(
              data.icon,
              color: isCompleted ? AppColors.background : AppColors.gold,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: AppColors.background.withOpacity(0.65),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.gold,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  isCompleted
                      ? 'Tamamlandı'
                      : '${data.current.clamp(0, data.target)} / ${data.target}',
                  style: TextStyle(
                    color: isCompleted
                        ? AppColors.gold
                        : AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
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

class _AchievementData {
  final IconData icon;
  final String title;
  final String subtitle;
  final int current;
  final int target;

  const _AchievementData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.current,
    required this.target,
  });
}
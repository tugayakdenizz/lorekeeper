import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/user_book.dart';

class AchievementStrip extends StatelessWidget {
  final List<UserBook> books;
  final int streakDays;

  const AchievementStrip({
    super.key,
    required this.books,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    final achievements = _buildAchievements();

    final unlockedCount = achievements
        .where((achievement) => achievement.isUnlocked)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          unlockedCount: unlockedCount,
          totalCount: achievements.length,
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 184,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: achievements.length,
            separatorBuilder: (_, __) {
              return const SizedBox(width: AppSpacing.md);
            },
            itemBuilder: (context, index) {
              return _AchievementCard(
                achievement: achievements[index],
              );
            },
          ),
        ),
      ],
    );
  }

  List<_AchievementData> _buildAchievements() {
    final finishedBooks = books
        .where(
          (item) => item.status == UserBookStatus.finished,
        )
        .length;

    final favoriteBooks = books
        .where((item) => item.isFavorite)
        .length;

    final totalPages = books.fold<int>(
      0,
      (sum, item) => sum + item.currentPage,
    );

    final totalSessions = books.fold<int>(
      0,
      (sum, item) => sum + item.readingSessions.length,
    );

    return [
      _AchievementData(
        title: 'İlk Efsane',
        description: 'İlk kitabını tamamla.',
        icon: Icons.auto_stories_rounded,
        currentValue: finishedBooks,
        targetValue: 1,
      ),
      _AchievementData(
        title: 'Seçkin Raf',
        description: '3 kitabı favorilerine ekle.',
        icon: Icons.favorite_rounded,
        currentValue: favoriteBooks,
        targetValue: 3,
      ),
      _AchievementData(
        title: 'Bilge Okur',
        description: 'Toplam 1.000 sayfaya ulaş.',
        icon: Icons.menu_book_rounded,
        currentValue: totalPages,
        targetValue: 1000,
      ),
      _AchievementData(
        title: 'Ritüel Ustası',
        description: '5 okuma oturumu tamamla.',
        icon: Icons.local_fire_department_rounded,
        currentValue: totalSessions,
        targetValue: 5,
      ),
      _AchievementData(
        title: 'Alev Muhafızı',
        description: '3 günlük okuma serisi oluştur.',
        icon: Icons.whatshot_rounded,
        currentValue: streakDays,
        targetValue: 3,
      ),
      _AchievementData(
        title: 'Kadim Arşiv',
        description: 'Kütüphanene 10 kitap ekle.',
        icon: Icons.account_balance_rounded,
        currentValue: books.length,
        targetValue: 10,
      ),
    ];
  }
}

class _SectionHeader extends StatelessWidget {
  final int unlockedCount;
  final int totalCount;

  const _SectionHeader({
    required this.unlockedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Başarımlar',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Okuma yolculuğunda kazandığın unvanlar.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.10),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: AppColors.gold.withOpacity(0.20),
            ),
          ),
          child: Text(
            '$unlockedCount / $totalCount',
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final _AchievementData achievement;

  const _AchievementCard({
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final progress = achievement.progress;

    return Container(
      width: 190,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: achievement.isUnlocked
              ? [
                  AppColors.surface,
                  AppColors.gold.withOpacity(0.13),
                ]
              : [
                  AppColors.surface,
                  AppColors.background.withOpacity(0.82),
                ],
        ),
        border: Border.all(
          color: achievement.isUnlocked
              ? AppColors.gold.withOpacity(0.35)
              : AppColors.border,
        ),
        boxShadow: achievement.isUnlocked
            ? [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: achievement.isUnlocked
                      ? AppColors.gold.withOpacity(0.14)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  achievement.icon,
                  color: achievement.isUnlocked
                      ? AppColors.gold
                      : AppColors.textMuted,
                  size: 22,
                ),
              ),
              const Spacer(),
              Icon(
                achievement.isUnlocked
                    ? Icons.verified_rounded
                    : Icons.lock_outline_rounded,
                color: achievement.isUnlocked
                    ? AppColors.gold
                    : AppColors.textMuted,
                size: 19,
              ),
            ],
          ),
          const Spacer(),
          Text(
            achievement.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: achievement.isUnlocked
                  ? AppColors.textPrimary
                  : AppColors.textMuted,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            achievement.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(
                achievement.isUnlocked
                    ? AppColors.gold
                    : AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Text(
                achievement.isUnlocked
                    ? 'KİLİT AÇILDI'
                    : '${achievement.currentValue} / ${achievement.targetValue}',
                style: TextStyle(
                  color: achievement.isUnlocked
                      ? AppColors.gold
                      : AppColors.textSecondary,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing:
                      achievement.isUnlocked ? 0.7 : 0,
                ),
              ),
              const Spacer(),
              Text(
                '%${(progress * 100).round()}',
                style: TextStyle(
                  color: achievement.isUnlocked
                      ? AppColors.gold
                      : AppColors.textMuted,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AchievementData {
  final String title;
  final String description;
  final IconData icon;
  final int currentValue;
  final int targetValue;

  const _AchievementData({
    required this.title,
    required this.description,
    required this.icon,
    required this.currentValue,
    required this.targetValue,
  });

  bool get isUnlocked => currentValue >= targetValue;

  double get progress {
    if (targetValue <= 0) {
      return 0;
    }

    return (currentValue / targetValue).clamp(0.0, 1.0);
  }
}
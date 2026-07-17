import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/user_book.dart';

class ReadingStreakCard extends StatelessWidget {
  final List<UserBook> books;
  final int dailyPageGoal;

  const ReadingStreakCard({
    super.key,
    required this.books,
    this.dailyPageGoal = 30,
  });

  @override
  Widget build(BuildContext context) {
    final ritual = _ReadingRitualData.fromBooks(
      books,
      dailyPageGoal: dailyPageGoal,
    );

    final progress = dailyPageGoal <= 0
        ? 0.0
        : (ritual.todayPages / dailyPageGoal).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.gold.withOpacity(0.09),
              ],
            ),
            border: Border.all(
              color: AppColors.gold.withOpacity(0.22),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                Positioned(
                  right: -34,
                  top: -42,
                  child: Container(
                    width: 138,
                    height: 138,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold.withOpacity(0.06),
                    ),
                  ),
                ),
                Positioned(
                  right: 18,
                  bottom: 18,
                  child: Icon(
                    Icons.local_fire_department_rounded,
                    size: 92,
                    color: AppColors.gold.withOpacity(0.04),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _StreakHero(
                        streakDays: ritual.streakDays,
                        todayPages: ritual.todayPages,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _TodayGoalPanel(
                        todayPages: ritual.todayPages,
                        dailyPageGoal: dailyPageGoal,
                        progress: progress,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _WeekStrip(days: ritual.lastSevenDays),
                      const SizedBox(height: AppSpacing.lg),
                      _StatsRow(
                        weeklyPages: ritual.weeklyPages,
                        totalSessions: ritual.totalSessions,
                        activeDays: ritual.activeDays,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Okuma Ritüeli',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Her gün attığın küçük adımlar efsaneni büyütür.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.local_fire_department_rounded,
          color: AppColors.gold,
        ),
      ],
    );
  }
}

class _StreakHero extends StatelessWidget {
  final int streakDays;
  final int todayPages;

  const _StreakHero({
    required this.streakDays,
    required this.todayPages,
  });

  @override
  Widget build(BuildContext context) {
    final String message;

    if (todayPages > 0) {
      message = 'Bugünün ritüeli başladı';
    } else if (streakDays > 0) {
      message = 'Serini korumak için bugün oku';
    } else {
      message = 'İlk ritüelini bugün başlat';
    }

    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.12),
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: AppColors.gold.withOpacity(0.20),
            ),
          ),
          child: const Icon(
            Icons.local_fire_department_rounded,
            color: AppColors.gold,
            size: 32,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$streakDays günlük seri',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                message,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TodayGoalPanel extends StatelessWidget {
  final int todayPages;
  final int dailyPageGoal;
  final double progress;

  const _TodayGoalPanel({
    required this.todayPages,
    required this.dailyPageGoal,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (dailyPageGoal - todayPages).clamp(0, dailyPageGoal);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.70),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.flag_rounded,
                color: AppColors.gold,
                size: 19,
              ),
              const SizedBox(width: 8),
              const Text(
                'Bugünkü hedef',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Text(
                '$todayPages / $dailyPageGoal sayfa',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(color: AppColors.surface),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.gold,
                            Color(0xFFFFE3A0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            remaining == 0
                ? 'Bugünün ritüeli tamamlandı.'
                : '$remaining sayfa daha okuyarak ritüeli tamamla.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  final List<_ReadingDay> days;

  const _WeekStrip({
    required this.days,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: days
          .map(
            (day) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: _DayItem(day: day),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DayItem extends StatelessWidget {
  final _ReadingDay day;

  const _DayItem({
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    final active = day.pages > 0;

    return Column(
      children: [
        Text(
          day.label,
          style: TextStyle(
            color: day.isToday
                ? AppColors.gold
                : AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 34,
          height: 42,
          decoration: BoxDecoration(
            color: active
                ? AppColors.gold.withOpacity(0.15)
                : AppColors.background.withOpacity(0.72),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: day.isToday
                  ? AppColors.gold
                  : active
                      ? AppColors.gold.withOpacity(0.25)
                      : AppColors.border,
            ),
          ),
          child: Icon(
            active
                ? Icons.local_fire_department_rounded
                : Icons.circle_outlined,
            color: active
                ? AppColors.gold
                : AppColors.textMuted,
            size: active ? 19 : 13,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          '${day.pages}',
          style: TextStyle(
            color: active
                ? AppColors.textPrimary
                : AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int weeklyPages;
  final int totalSessions;
  final int activeDays;

  const _StatsRow({
    required this.weeklyPages,
    required this.totalSessions,
    required this.activeDays,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            value: '$weeklyPages',
            label: '7 günlük sayfa',
          ),
        ),
        Container(
          width: 1,
          height: 34,
          color: AppColors.border,
        ),
        Expanded(
          child: _StatItem(
            value: '$activeDays',
            label: 'Aktif gün',
          ),
        ),
        Container(
          width: 1,
          height: 34,
          color: AppColors.border,
        ),
        Expanded(
          child: _StatItem(
            value: '$totalSessions',
            label: 'Oturum',
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ReadingRitualData {
  final int todayPages;
  final int weeklyPages;
  final int streakDays;
  final int activeDays;
  final int totalSessions;
  final List<_ReadingDay> lastSevenDays;

  const _ReadingRitualData({
    required this.todayPages,
    required this.weeklyPages,
    required this.streakDays,
    required this.activeDays,
    required this.totalSessions,
    required this.lastSevenDays,
  });

  factory _ReadingRitualData.fromBooks(
    List<UserBook> books, {
    required int dailyPageGoal,
  }) {
    final now = DateTime.now();
    final today = _dateOnly(now);

    final pagesByDay = <DateTime, int>{};
    var totalSessions = 0;

    for (final book in books) {
      for (final session in book.readingSessions) {
        final day = _dateOnly(session.createdAt);

        pagesByDay[day] =
            (pagesByDay[day] ?? 0) + session.pagesRead;

        totalSessions++;
      }
    }

    final mondayOfCurrentWeek = today.subtract(
  Duration(days: today.weekday - DateTime.monday),
);

final lastSevenDays = List.generate(7, (index) {
  final date = mondayOfCurrentWeek.add(
    Duration(days: index),
  );

  return _ReadingDay(
    date: date,
    label: _dayLabel(date.weekday),
    pages: pagesByDay[date] ?? 0,
    isToday: date == today,
  );
});

    final weeklyPages = lastSevenDays.fold<int>(
      0,
      (sum, day) => sum + day.pages,
    );

    final activeDays =
        lastSevenDays.where((day) => day.pages > 0).length;

    var streakDays = 0;
    var cursor = today;

    if ((pagesByDay[today] ?? 0) == 0) {
      cursor = today.subtract(const Duration(days: 1));
    }

    while ((pagesByDay[cursor] ?? 0) > 0) {
      streakDays++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return _ReadingRitualData(
      todayPages: pagesByDay[today] ?? 0,
      weeklyPages: weeklyPages,
      streakDays: streakDays,
      activeDays: activeDays,
      totalSessions: totalSessions,
      lastSevenDays: lastSevenDays,
    );
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static String _dayLabel(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Pzt';
      case DateTime.tuesday:
        return 'Sal';
      case DateTime.wednesday:
        return 'Çar';
      case DateTime.thursday:
        return 'Per';
      case DateTime.friday:
        return 'Cum';
      case DateTime.saturday:
        return 'Cmt';
      case DateTime.sunday:
        return 'Paz';
      default:
        return '';
    }
  }
}

class _ReadingDay {
  final DateTime date;
  final String label;
  final int pages;
  final bool isToday;

  const _ReadingDay({
    required this.date,
    required this.label,
    required this.pages,
    required this.isToday,
  });
}
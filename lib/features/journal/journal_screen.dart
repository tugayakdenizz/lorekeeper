import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/user_book.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

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

              final pagesRead = userBooks.fold<int>(
                0,
                (total, item) => total + item.currentPage,
              );

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chronicles',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Okuma yolculuğunun günlüğü.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    _SummaryCard(
                      pagesRead: pagesRead,
                      readingCount: readingBooks.length,
                      finishedCount: finishedBooks.length,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    const Text(
                      'Yakında',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    const _FeatureCard(
                      icon: Icons.edit_note_rounded,
                      title: 'Okuma Notları',
                      description: 'Kitaplarla ilgili düşüncelerini kaydet.',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _FeatureCard(
                      icon: Icons.format_quote_rounded,
                      title: 'Alıntılar',
                      description: 'Etkilendiğin cümleleri arşivle.',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _FeatureCard(
                      icon: Icons.timeline_rounded,
                      title: 'Okuma Geçmişi',
                      description: 'Sayfa ilerlemeni günlük olarak takip et.',
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

class _SummaryCard extends StatelessWidget {
  final int pagesRead;
  final int readingCount;
  final int finishedCount;

  const _SummaryCard({
    required this.pagesRead,
    required this.readingCount,
    required this.finishedCount,
  });

  @override
  Widget build(BuildContext context) {
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
            'Bugünkü Özet',
            style: TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  value: pagesRead.toString(),
                  label: 'Sayfa',
                ),
              ),
              Expanded(
                child: _MiniStat(
                  value: readingCount.toString(),
                  label: 'Okunan',
                ),
              ),
              Expanded(
                child: _MiniStat(
                  value: finishedCount.toString(),
                  label: 'Biten',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;

  const _MiniStat({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
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
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 30),
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
                const SizedBox(height: 4),
                Text(
                  description,
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
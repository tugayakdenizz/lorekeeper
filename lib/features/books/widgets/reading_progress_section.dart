import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/user_book.dart';

class ReadingProgressSection extends StatelessWidget {
  final UserBook? userBook;
  final int? totalPages;
  final VoidCallback onUpdatePressed;

  const ReadingProgressSection({
    super.key,
    required this.userBook,
    required this.totalPages,
    required this.onUpdatePressed,
  });

  @override
  Widget build(BuildContext context) {
    final currentPage = userBook?.currentPage ?? 0;
    final status = userBook?.status;

    final progress = totalPages != null && totalPages! > 0
        ? (currentPage / totalPages!).clamp(0.0, 1.0)
        : 0.0;

    final shownProgress = status == UserBookStatus.finished ? 1.0 : progress;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Okuma İlerlemesi',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: shownProgress,
            minHeight: 8,
            backgroundColor: AppColors.surface,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          status == UserBookStatus.finished
              ? 'Tamamlandı • 100%'
              : totalPages == null
                  ? '$currentPage sayfa'
                  : '$currentPage / $totalPages sayfa • ${(progress * 100).round()}%',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onUpdatePressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.gold,
              side: const BorderSide(color: AppColors.gold),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text(
              'İlerlemeyi Güncelle',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }
}
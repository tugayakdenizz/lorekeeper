import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/user_book.dart';

class ContinueSeriesSection extends StatelessWidget {
  final List<UserBook> books;
  final ValueChanged<UserBook> onBookTap;

  const ContinueSeriesSection({
    super.key,
    required this.books,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    final trackedBooks = books
        .where((item) => item.isSeriesTracked)
        .take(6)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(),
        const SizedBox(height: AppSpacing.md),
        if (trackedBooks.isEmpty)
          const _EmptySeriesCard()
        else
          SizedBox(
            height: 230,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: trackedBooks.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                final userBook = trackedBooks[index];
                return _SeriesCard(
                  userBook: userBook,
                  index: index,
                  onTap: () => onBookTap(userBook),
                );
              },
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
                'Seriye Devam Et',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Yalnızca takip etmeyi seçtiğin seriler.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Icon(Icons.notifications_active_rounded, color: AppColors.gold),
      ],
    );
  }
}

class _SeriesCard extends StatelessWidget {
  final UserBook userBook;
  final int index;
  final VoidCallback onTap;

  const _SeriesCard({
    required this.userBook,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final book = userBook.book;
    final seriesName = (userBook.trackedSeriesTitle ?? book.seriesId ?? book.title)
        .trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          width: 248,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.gold.withOpacity(index.isEven ? 0.10 : 0.065),
              ],
            ),
            border: Border.all(color: AppColors.gold.withOpacity(0.22)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.background.withOpacity(0.76),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.collections_bookmark_rounded,
                        color: AppColors.gold,
                        size: 21,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.11),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Text(
                        'TAKİPTE',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  seriesName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    height: 1.16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Text(
                      book.volumeNumber == null
                          ? 'Seri kitabı'
                          : '${book.volumeNumber}. kitap',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'EVRENE DÖN',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.gold,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptySeriesCard extends StatelessWidget {
  const _EmptySeriesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          Icon(Icons.add_alert_rounded, color: AppColors.gold, size: 30),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'Bir kitabın detayından “Seriyi Takip Et” seçeneğini açtığında burada görünecek.',
              style: TextStyle(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

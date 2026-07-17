import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/user_book.dart';

class UpcomingReleaseSection extends StatelessWidget {
  final List<UserBook> books;
  final ValueChanged<UserBook> onBookTap;

  const UpcomingReleaseSection({
    super.key,
    required this.books,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    final trackedBooks = books
        .where((item) => item.isSeriesTracked)
        .toList()
      ..sort(_sortTrackedBooks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(trackedCount: trackedBooks.length),
        const SizedBox(height: AppSpacing.md),
        if (trackedBooks.isEmpty)
          const _EmptyTrackingCard()
        else
          SizedBox(
            height: 246,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: trackedBooks.length,
              separatorBuilder: (_, __) {
                return const SizedBox(width: AppSpacing.md);
              },
              itemBuilder: (context, index) {
                final userBook = trackedBooks[index];

                return _TrackingCard(
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

  static int _sortTrackedBooks(
    UserBook first,
    UserBook second,
  ) {
    final firstDate = first.updatedAt ??
        first.addedAt ??
        DateTime.fromMillisecondsSinceEpoch(0);

    final secondDate = second.updatedAt ??
        second.addedAt ??
        DateTime.fromMillisecondsSinceEpoch(0);

    return secondDate.compareTo(firstDate);
  }
}

class _SectionHeader extends StatelessWidget {
  final int trackedCount;

  const _SectionHeader({
    required this.trackedCount,
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
                'Seri Takip Merkezi',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Yeni hikâyelerini beklediğin seriler.',
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.notifications_active_rounded,
                color: AppColors.gold,
                size: 15,
              ),
              const SizedBox(width: 6),
              Text(
                '$trackedCount seri',
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrackingCard extends StatelessWidget {
  final UserBook userBook;
  final int index;
  final VoidCallback onTap;

  const _TrackingCard({
    required this.userBook,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final book = userBook.book;
    final seriesTitle = _seriesTitle(userBook);
    final authorText = book.authors.isEmpty
        ? 'Yazar bilgisi bulunamadı'
        : book.authors.join(', ');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(27),
        child: Ink(
          width: 268,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(27),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.gold.withOpacity(
                  index.isEven ? 0.10 : 0.065,
                ),
              ],
            ),
            border: Border.all(
              color: AppColors.gold.withOpacity(0.23),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(27),
            child: Stack(
              children: [
                Positioned(
                  right: -34,
                  top: -42,
                  child: Container(
                    width: 134,
                    height: 134,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold.withOpacity(0.055),
                    ),
                  ),
                ),
                Positioned(
                  right: 14,
                  bottom: 12,
                  child: Icon(
                    Icons.radar_rounded,
                    size: 82,
                    color: AppColors.gold.withOpacity(0.04),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _TrackingStatusBadge(),
                      const Spacer(),
                      Text(
                        seriesTitle.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.9,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 19,
                          height: 1.12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        authorText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _VolumeBadge(
                        volumeNumber: book.volumeNumber,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _TrackingFooter(
                        volumeNumber: book.volumeNumber,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _seriesTitle(UserBook userBook) {
    final trackedTitle =
        userBook.trackedSeriesTitle?.trim();

    if (trackedTitle != null && trackedTitle.isNotEmpty) {
      return trackedTitle;
    }

    final modelSeries = userBook.book.seriesId?.trim();

    if (modelSeries != null && modelSeries.isNotEmpty) {
      return modelSeries;
    }

    return userBook.book.title;
  }
}

class _VolumeBadge extends StatelessWidget {
  final int? volumeNumber;

  const _VolumeBadge({
    required this.volumeNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.menu_book_rounded,
          color: AppColors.gold,
          size: 15,
        ),
        const SizedBox(width: 7),
        Text(
          volumeNumber == null
              ? 'Cilt bilgisi bekleniyor'
              : '$volumeNumber. Kitap',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _TrackingStatusBadge extends StatelessWidget {
  const _TrackingStatusBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.74),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.gold.withOpacity(0.19),
            ),
          ),
          child: const Icon(
            Icons.notifications_active_rounded,
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
            border: Border.all(
              color: AppColors.gold.withOpacity(0.18),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _LiveIndicator(),
              SizedBox(width: 7),
              Text(
                'TAKİP AKTİF',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LiveIndicator extends StatelessWidget {
  const _LiveIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        color: AppColors.gold,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _TrackingFooter extends StatelessWidget {
  final int? volumeNumber;

  const _TrackingFooter({
    required this.volumeNumber,
  });

  @override
  Widget build(BuildContext context) {
    final volumeText = volumeNumber == null
        ? 'Seri bilgisi izleniyor'
        : '$volumeNumber. kitap takip ediliyor';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.65),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.radar_rounded,
            color: AppColors.gold,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              volumeText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.gold,
            size: 17,
          ),
        ],
      ),
    );
  }
}

class _EmptyTrackingCard extends StatelessWidget {
  const _EmptyTrackingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.10),
              borderRadius: BorderRadius.circular(19),
            ),
            child: const Icon(
              Icons.radar_rounded,
              color: AppColors.gold,
              size: 29,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Takip merkezinde henüz bir seri yok',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Bir kitabın detayından “Seriyi Takip Et” seçeneğini açtığında yayın yolculuğu burada görünecek.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.42,
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
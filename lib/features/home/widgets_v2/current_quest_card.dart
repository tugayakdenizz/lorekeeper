import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/user_book.dart';

class CurrentQuestCard extends StatelessWidget {
  final UserBook? userBook;
  final VoidCallback? onTap;

  const CurrentQuestCard({
    super.key,
    required this.userBook,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentBook = userBook;

    if (currentBook == null) {
      return const _EmptyQuestCard();
    }

    final totalPages =
        currentBook.totalPagesOverride ?? currentBook.book.pageCount;

    final currentPage = currentBook.currentPage;

    final progress = totalPages == null || totalPages <= 0
        ? 0.0
        : (currentPage / totalPages).clamp(0.0, 1.0);

    final progressPercent = (progress * 100).round();

    final remainingPages = totalPages == null
        ? null
        : (totalPages - currentPage).clamp(0, totalPages);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(),
        const SizedBox(height: AppSpacing.md),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(28),
            child: Ink(
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
                  color: AppColors.gold.withOpacity(0.28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  const Positioned(
                    right: -28,
                    top: -34,
                    child: _DecorativeOrb(
                      size: 128,
                      opacity: 0.08,
                    ),
                  ),
                  const Positioned(
                    left: -40,
                    bottom: -55,
                    child: _DecorativeOrb(
                      size: 142,
                      opacity: 0.04,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _QuestBadge(),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _QuestIcon(),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _BookInformation(
                                title: currentBook.book.title,
                                seriesId: currentBook.book.seriesId,
                                volumeNumber:
                                    currentBook.book.volumeNumber,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            const _OpenButton(),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _QuestObjective(
                          currentPage: currentPage,
                          totalPages: totalPages,
                          remainingPages: remainingPages,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _ProgressHeader(
                          currentPage: currentPage,
                          totalPages: totalPages,
                          progressPercent: progressPercent,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _QuestProgressBar(progress: progress),
                        const SizedBox(height: AppSpacing.md),
                        _QuestFooter(
                          progressPercent: progressPercent,
                          remainingPages: remainingPages,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aktif Görev',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Yolculuğuna kaldığın sayfadan devam et.',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _QuestBadge extends StatelessWidget {
  const _QuestBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.12),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: AppColors.gold.withOpacity(0.24),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 15,
            color: AppColors.gold,
          ),
          SizedBox(width: 7),
          Text(
            'ANA GÖREV',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestIcon extends StatelessWidget {
  const _QuestIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.gold.withOpacity(0.20),
        ),
      ),
      child: const Icon(
        Icons.auto_stories_rounded,
        color: AppColors.gold,
        size: 29,
      ),
    );
  }
}

class _BookInformation extends StatelessWidget {
  final String title;
  final String? seriesId;
  final int? volumeNumber;

  const _BookInformation({
    required this.title,
    required this.seriesId,
    required this.volumeNumber,
  });

  @override
  Widget build(BuildContext context) {
    final hasSeries =
        seriesId != null && seriesId!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasSeries) ...[
          Text(
            volumeNumber == null
                ? seriesId!
                : '$seriesId • $volumeNumber. Kitap',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 21,
            height: 1.12,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Okuma yolculuğu devam ediyor',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _OpenButton extends StatelessWidget {
  const _OpenButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.12),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.arrow_forward_rounded,
        size: 20,
        color: AppColors.gold,
      ),
    );
  }
}

class _QuestObjective extends StatelessWidget {
  final int currentPage;
  final int? totalPages;
  final int? remainingPages;

  const _QuestObjective({
    required this.currentPage,
    required this.totalPages,
    required this.remainingPages,
  });

  @override
  Widget build(BuildContext context) {
    final String objective;

    if (currentPage <= 0) {
      objective = 'İlk bölümü aç ve yolculuğu başlat.';
    } else if (remainingPages == null) {
      objective = '$currentPage. sayfadan okumaya devam et.';
    } else if (remainingPages == 0) {
      objective = 'Son sayfaya ulaştın. Görevi tamamla.';
    } else if (remainingPages! <= 25) {
      objective = 'Finale yalnızca $remainingPages sayfa kaldı.';
    } else {
      final nextTarget = _nextTargetPage(
        currentPage: currentPage,
        totalPages: totalPages!,
      );

      objective = '$nextTarget. sayfaya ulaş.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.flag_rounded,
              color: AppColors.gold,
              size: 21,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Görev hedefi',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  objective,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
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

  int _nextTargetPage({
    required int currentPage,
    required int totalPages,
  }) {
    final nextTarget = ((currentPage ~/ 25) + 1) * 25;

    if (nextTarget > totalPages) {
      return totalPages;
    }

    return nextTarget;
  }
}

class _ProgressHeader extends StatelessWidget {
  final int currentPage;
  final int? totalPages;
  final int progressPercent;

  const _ProgressHeader({
    required this.currentPage,
    required this.totalPages,
    required this.progressPercent,
  });

  @override
  Widget build(BuildContext context) {
    final pageText = totalPages == null
        ? '$currentPage sayfa'
        : '$currentPage / $totalPages sayfa';

    return Row(
      children: [
        const Text(
          'Görev ilerlemesi',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Text(
          pageText,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '%$progressPercent',
          style: const TextStyle(
            color: AppColors.gold,
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _QuestProgressBar extends StatelessWidget {
  final double progress;

  const _QuestProgressBar({
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        height: 10,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: AppColors.background,
            ),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gold,
                      Color(0xFFFFE29A),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestFooter extends StatelessWidget {
  final int progressPercent;
  final int? remainingPages;

  const _QuestFooter({
    required this.progressPercent,
    required this.remainingPages,
  });

  @override
  Widget build(BuildContext context) {
    final String statusText;
    final IconData icon;

    if (progressPercent >= 100) {
      statusText = 'Görev tamamlanmaya hazır';
      icon = Icons.verified_rounded;
    } else if (progressPercent >= 75) {
      statusText = 'Final bölümü yaklaşıyor';
      icon = Icons.bolt_rounded;
    } else if (progressPercent >= 40) {
      statusText = 'Yolculuğun yarısını aştın';
      icon = Icons.explore_rounded;
    } else if (progressPercent > 0) {
      statusText = 'Efsane şekillenmeye başladı';
      icon = Icons.auto_awesome_rounded;
    } else {
      statusText = 'İlk adım seni bekliyor';
      icon = Icons.door_front_door_rounded;
    }

    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: AppColors.gold,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            statusText,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (remainingPages != null && remainingPages! > 0)
          Text(
            '$remainingPages sayfa kaldı',
            style: const TextStyle(
              color: AppColors.gold,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
      ],
    );
  }
}

class _EmptyQuestCard extends StatelessWidget {
  const _EmptyQuestCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.explore_rounded,
                  size: 32,
                  color: AppColors.gold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Henüz aktif görevin yok',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'Bir kitabı “Okuyorum” olarak işaretlediğinde yeni görevin burada başlayacak.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Text(
                  'Yeni bir dünya seni bekliyor',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DecorativeOrb extends StatelessWidget {
  final double size;
  final double opacity;

  const _DecorativeOrb({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.gold.withOpacity(opacity),
      ),
    );
  }
}
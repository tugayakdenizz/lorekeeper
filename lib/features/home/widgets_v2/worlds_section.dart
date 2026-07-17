import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/user_book.dart';

class WorldsSection extends StatelessWidget {
  final List<UserBook> books;

  const WorldsSection({
    super.key,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    final worlds = _buildWorlds(books);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(),
        const SizedBox(height: AppSpacing.md),
        if (worlds.isEmpty)
          const _EmptyWorldsCard()
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: worlds.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.08,
            ),
            itemBuilder: (context, index) {
              return _WorldCard(
                world: worlds[index],
                index: index,
              );
            },
          ),
      ],
    );
  }

  List<_WorldData> _buildWorlds(List<UserBook> userBooks) {
    final categoryCounts = <String, int>{};

    for (final userBook in userBooks) {
      final uniqueCategories = userBook.book.categories
          .map(_normalizeCategory)
          .where((category) => category.isNotEmpty)
          .toSet();

      for (final category in uniqueCategories) {
        categoryCounts[category] =
            (categoryCounts[category] ?? 0) + 1;
      }
    }

    final entries = categoryCounts.entries.toList()
      ..sort((a, b) {
        final countComparison = b.value.compareTo(a.value);
        if (countComparison != 0) return countComparison;
        return a.key.compareTo(b.key);
      });

    return entries
        .take(4)
        .map(
          (entry) => _WorldData(
            title: entry.key,
            bookCount: entry.value,
            icon: _iconForCategory(entry.key),
          ),
        )
        .toList();
  }

  String _normalizeCategory(String rawCategory) {
    final cleaned = rawCategory
        .replaceAll('&', ' ve ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (cleaned.isEmpty) return '';

    final lower = cleaned.toLowerCase();

    const categoryTranslations = <String, String>{
      'fiction': 'Kurgu',
      'fantasy': 'Fantastik',
      'science fiction': 'Bilim Kurgu',
      'young adult fiction': 'Genç Yetişkin',
      'juvenile fiction': 'Çocuk ve Gençlik',
      'romance': 'Romantik',
      'mystery': 'Gizem',
      'thrillers': 'Gerilim',
      'horror': 'Korku',
      'history': 'Tarih',
      'biography': 'Biyografi',
      'comics': 'Çizgi Roman',
      'graphic novels': 'Grafik Roman',
      'adventure stories': 'Macera',
      'literary collections': 'Edebiyat',
      'self-help': 'Kişisel Gelişim',
      'philosophy': 'Felsefe',
      'psychology': 'Psikoloji',
    };

    if (categoryTranslations.containsKey(lower)) {
      return categoryTranslations[lower]!;
    }

    for (final entry in categoryTranslations.entries) {
      if (lower.contains(entry.key)) {
        return entry.value;
      }
    }

    return _toTitleCase(cleaned);
  }

  String _toTitleCase(String value) {
    return value
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  IconData _iconForCategory(String category) {
    final value = category.toLowerCase();

    if (value.contains('fantastik')) {
      return Icons.auto_awesome_rounded;
    }
    if (value.contains('bilim kurgu')) {
      return Icons.rocket_launch_rounded;
    }
    if (value.contains('korku')) {
      return Icons.nights_stay_rounded;
    }
    if (value.contains('gizem') || value.contains('gerilim')) {
      return Icons.visibility_rounded;
    }
    if (value.contains('tarih') || value.contains('biyografi')) {
      return Icons.account_balance_rounded;
    }
    if (value.contains('romantik')) {
      return Icons.favorite_rounded;
    }
    if (value.contains('çizgi') || value.contains('grafik')) {
      return Icons.collections_bookmark_rounded;
    }
    if (value.contains('macera')) {
      return Icons.explore_rounded;
    }
    if (value.contains('felsefe') || value.contains('psikoloji')) {
      return Icons.psychology_rounded;
    }

    return Icons.public_rounded;
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

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
                'Evrenlerin',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Kütüphanenin şekillendirdiği dünyalar.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.10),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.gold.withOpacity(0.18),
            ),
          ),
          child: const Icon(
            Icons.public_rounded,
            color: AppColors.gold,
            size: 20,
          ),
        ),
      ],
    );
  }
}

class _WorldCard extends StatelessWidget {
  final _WorldData world;
  final int index;

  const _WorldCard({
    required this.world,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.gold.withOpacity(index.isEven ? 0.085 : 0.05),
          ],
        ),
        border: Border.all(
          color: AppColors.gold.withOpacity(0.19),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(world.icon, color: AppColors.gold),
            const Spacer(),
            Text(
              world.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${world.bookCount} kitap',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyWorldsCard extends StatelessWidget {
  const _EmptyWorldsCard();

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.travel_explore_rounded,
                color: AppColors.gold,
                size: 28,
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Evrenlerin henüz şekillenmedi',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Kütüphanene kitap ekledikçe en çok ziyaret ettiğin dünyalar burada oluşacak.',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.42,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ExampleCategory(
                icon: Icons.auto_awesome_rounded,
                label: 'Fantastik',
              ),
              _ExampleCategory(
                icon: Icons.rocket_launch_rounded,
                label: 'Bilim Kurgu',
              ),
              _ExampleCategory(
                icon: Icons.nights_stay_rounded,
                label: 'Korku',
              ),
              _ExampleCategory(
                icon: Icons.favorite_rounded,
                label: 'Romantik',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExampleCategory extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ExampleCategory({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.72),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.gold, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorldData {
  final String title;
  final int bookCount;
  final IconData icon;

  const _WorldData({
    required this.title,
    required this.bookCount,
    required this.icon,
  });
}
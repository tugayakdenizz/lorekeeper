import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              SizedBox(height: AppSpacing.xl),
              _WelcomeCard(),
              SizedBox(height: AppSpacing.xl),
              Text('Your Realm', style: AppTextStyles.title),
              SizedBox(height: AppSpacing.md),
              Expanded(child: _RealmGrid()),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('LoreKeeper', style: AppTextStyles.display),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Every story deserves a keeper.',
          style: AppTextStyles.body,
        ),
      ],
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            AppColors.surface,
            AppColors.surfaceLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_stories_rounded, size: 52, color: AppColors.gold),
          SizedBox(height: AppSpacing.md),
          Text(
            'Welcome, Keeper.',
            style: AppTextStyles.title,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Track your books, follow authors, and keep your reading legends alive.',
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}

class _RealmGrid extends StatelessWidget {
  const _RealmGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.05,
      children: const [
        _RealmCard(
          icon: Icons.search_rounded,
          title: 'Discover',
          subtitle: 'Find books',
        ),
        _RealmCard(
          icon: Icons.menu_book_rounded,
          title: 'Library',
          subtitle: 'Your books',
        ),
        _RealmCard(
          icon: Icons.favorite_rounded,
          title: 'Authors',
          subtitle: 'Follow writers',
        ),
        _RealmCard(
          icon: Icons.edit_note_rounded,
          title: 'Journal',
          subtitle: 'Book notes',
        ),
      ],
    );
  }
}

class _RealmCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _RealmCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.gold, size: 34),
          const Spacer(),
          Text(title, style: AppTextStyles.title.copyWith(fontSize: 19)),
          const SizedBox(height: AppSpacing.xs),
          Text(subtitle, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
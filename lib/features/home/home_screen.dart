import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(22, 20, 22, 0),
              sliver: SliverToBoxAdapter(
                child: _Header(),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(22, 28, 22, 0),
              sliver: SliverToBoxAdapter(
                child: _HeroCard(),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(22, 28, 22, 12),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Your Realm',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.05,
                children: const [
                  _MenuCard(Icons.search_rounded, 'Discover', 'Find books'),
                  _MenuCard(Icons.auto_stories_rounded, 'Library', 'Your books'),
                  _MenuCard(Icons.person_heart_rounded, 'Authors', 'Follow writers'),
                  _MenuCard(Icons.edit_note_rounded, 'Journal', 'Book notes'),
                ],
              ),
            ),
          ],
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
        Text(
          'LoreKeeper',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 6),
        Text(
          'Every story deserves a keeper.',
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [AppTheme.card, AppTheme.cardLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.menu_book_rounded, size: 52, color: AppTheme.gold),
          SizedBox(height: 18),
          Text(
            'Welcome, Keeper.',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Track your books, follow authors, and keep your reading legends alive.',
            style: TextStyle(fontSize: 15, height: 1.4, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MenuCard(this.icon, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.gold, size: 34),
          const Spacer(),
          Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.white60)),
        ],
      ),
    );
  }
}
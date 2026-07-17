import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class HeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final int level;
  final int xp;
  final int streakDays;

  const HeroHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.level,
    required this.xp,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    final currentLevelXp = xp % 1000;
    final progress = (currentLevelXp / 1000).clamp(0.0, 1.0);
    final nextLevelXp = 1000 - currentLevelXp;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.gold.withOpacity(0.11),
            AppColors.surface,
          ],
        ),
        border: Border.all(
          color: AppColors.gold.withOpacity(0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            const Positioned(
              right: -42,
              top: -58,
              child: _DecorativeGlow(
                size: 180,
                opacity: 0.075,
              ),
            ),
            const Positioned(
              left: -70,
              bottom: -90,
              child: _DecorativeGlow(
                size: 210,
                opacity: 0.035,
              ),
            ),
            Positioned(
              right: 18,
              bottom: 20,
              child: Icon(
                Icons.castle_rounded,
                size: 112,
                color: AppColors.gold.withOpacity(0.045),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopBar(
                    level: level,
                    streakDays: streakDays,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 34,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.7,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _XpPanel(
                    currentLevelXp: currentLevelXp,
                    nextLevelXp: nextLevelXp,
                    progress: progress,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int level;
  final int streakDays;

  const _TopBar({
    required this.level,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.11),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: AppColors.gold.withOpacity(0.20),
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
                'LOREKEEPER',
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        _CompactBadge(
          icon: Icons.local_fire_department_rounded,
          text: '$streakDays Gün',
        ),
        const SizedBox(width: AppSpacing.sm),
        _CompactBadge(
          icon: Icons.shield_rounded,
          text: 'Seviye $level',
        ),
      ],
    );
  }
}

class _CompactBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CompactBadge({
    required this.icon,
    required this.text,
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
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: AppColors.gold,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _XpPanel extends StatelessWidget {
  final int currentLevelXp;
  final int nextLevelXp;
  final double progress;

  const _XpPanel({
    required this.currentLevelXp,
    required this.nextLevelXp,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.70),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.bolt_rounded,
                color: AppColors.gold,
                size: 19,
              ),
              const SizedBox(width: 8),
              const Text(
                'Bilgelik Deneyimi',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              Text(
                '$currentLevelXp / 1000 XP',
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
                  Container(
                    color: AppColors.surface,
                  ),
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
          Row(
            children: [
              const Text(
                'Sonraki Rütbe',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              Text(
                '$nextLevelXp XP kaldı',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DecorativeGlow extends StatelessWidget {
  final double size;
  final double opacity;

  const _DecorativeGlow({
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
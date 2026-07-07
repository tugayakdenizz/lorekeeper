import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/reading_session.dart';
import '../../../shared/widgets/empty_state.dart';

class ReadingSessionsSection extends StatelessWidget {
  final List<ReadingSession> sessions;

  const ReadingSessionsSection({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    final sortedSessions = [...sessions]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📅 Okuma Geçmişi',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (sortedSessions.isEmpty)
          const SizedBox(
            height: 250,
            child: EmptyState(
              icon: Icons.history_rounded,
              title: 'Henüz okuma geçmişi yok',
              subtitle:
                  'İlk okuma oturumunu tamamladığında geçmişin burada oluşacak.',
            ),
          )
        else
          ...sortedSessions.take(5).map(
                (session) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _ReadingSessionTile(session: session),
                ),
              ),
      ],
    );
  }
}

class _ReadingSessionTile extends StatelessWidget {
  final ReadingSession session;

  const _ReadingSessionTile({
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.history_rounded,
              color: AppColors.gold,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _dateText(session.createdAt),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${session.pagesRead} sayfa okundu',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.12),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              '+${session.pagesRead}',
              style: const TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _dateText(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) {
      return 'Bugün';
    }

    if (entryDate == yesterday) {
      return 'Dün';
    }

    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }
}

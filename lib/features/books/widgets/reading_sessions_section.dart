import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/reading_session.dart';

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
          const Text(
            'Henüz okuma geçmişi yok.',
            style: TextStyle(color: AppColors.textSecondary),
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
          const Icon(
            Icons.history_rounded,
            color: AppColors.gold,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              _dateText(session.createdAt),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '+${session.pagesRead} sayfa',
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  String _dateText(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final entryDate = DateTime(date.year, date.month, date.day);

    if (entryDate == today) {
      return 'Bugün';
    }

    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }
}
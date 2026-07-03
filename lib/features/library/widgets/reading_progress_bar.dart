import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ReadingProgressBar extends StatelessWidget {
  final double progress;

  const ReadingProgressBar({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: LinearProgressIndicator(
        value: safeProgress,
        minHeight: 7,
        backgroundColor: AppColors.background.withOpacity(0.55),
        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
      ),
    );
  }
}
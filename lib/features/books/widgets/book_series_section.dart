import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class BookSeriesSection extends StatelessWidget {
  final String seriesTitle;
  final int? volumeNumber;
  final bool isTracked;
  final VoidCallback onToggleTracking;

  const BookSeriesSection({
    super.key,
    required this.seriesTitle,
    required this.volumeNumber,
    required this.isTracked,
    required this.onToggleTracking,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.account_tree_rounded, color: AppColors.gold),
            SizedBox(width: AppSpacing.sm),
            Text(
              'Seri Takibi',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.65),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isTracked
                  ? AppColors.gold.withOpacity(0.38)
                  : AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                seriesTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (volumeNumber != null) ...[
                const SizedBox(height: 6),
                Text(
                  '$volumeNumber. kitap',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Text(
                isTracked
                    ? 'Bu seri Home ekranındaki “Seriye Devam Et” bölümünde gösteriliyor.'
                    : 'Bu seriyi takip ederek Home ekranından yolculuğuna devam edebilirsin.',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: onToggleTracking,
            icon: Icon(
              isTracked
                  ? Icons.notifications_active_rounded
                  : Icons.add_alert_rounded,
            ),
            label: Text(
              isTracked ? 'Seri Takip Ediliyor' : 'Seriyi Takip Et',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor:
                  isTracked ? AppColors.surfaceLight : AppColors.gold,
              foregroundColor:
                  isTracked ? AppColors.gold : AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: isTracked ? AppColors.gold : AppColors.gold,
                ),
              ),
            ),
          ),
        ),
        if (isTracked) ...[
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: onToggleTracking,
              child: const Text(
                'Takibi bırak',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class RatingSection extends StatelessWidget {
  final double? rating;
  final ValueChanged<double> onRatingChanged;

  const RatingSection({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selectedRating = rating ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Puanım',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        Row(
          children: List.generate(5, (index) {
            final starValue = index + 1;
            final isSelected = selectedRating >= starValue;

            return IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 42,
                minHeight: 42,
              ),
              onPressed: () => onRatingChanged(starValue.toDouble()),
              icon: Icon(
                isSelected
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: AppColors.gold,
                size: 34,
              ),
            );
          }),
        ),

        const SizedBox(height: 4),

        Text(
          selectedRating == 0
              ? 'Henüz puan vermedin.'
              : '${selectedRating.toStringAsFixed(0)} / 5',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class DescriptionSection extends StatelessWidget {
  final String? description;

  const DescriptionSection({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    if (description == null || description!.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Açıklama',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          description!,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
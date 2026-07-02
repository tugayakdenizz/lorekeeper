import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const greeting = 'Good Morning';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                greeting,
                style: TextStyle(
                  color: AppColors.gold,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Tugay 👋',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                'Ready for another adventure?',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.surfaceLight,
          child: Icon(Icons.person, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
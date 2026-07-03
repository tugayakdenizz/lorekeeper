import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'favorite_button.dart';

class BookHeader extends StatelessWidget {
  final String title;
  final String author;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  const BookHeader({
    super.key,
    required this.title,
    required this.author,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            FavoriteButton(
              isFavorite: isFavorite,
              onTap: onFavoritePressed,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          author,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}
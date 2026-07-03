import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: Icon(
          isFavorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          key: ValueKey<bool>(isFavorite),
          color: AppColors.gold,
          size: 30,
        ),
      ),
    );
  }
}
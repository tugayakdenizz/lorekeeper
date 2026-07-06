import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class BookCover extends StatelessWidget {
  final String? coverUrl;
  final double width;
  final double height;
  final double borderRadius;

  const BookCover({
    super.key,
    required this.coverUrl,
    this.width = 150,
    this.height = 220,
    this.borderRadius = 22,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: coverUrl == null || coverUrl!.trim().isEmpty
          ? _PlaceholderCover(width: width, height: height)
          : Image.network(
              coverUrl!,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _PlaceholderCover(width: width, height: height);
              },
            ),
    );
  }
}

class _PlaceholderCover extends StatelessWidget {
  final double width;
  final double height;

  const _PlaceholderCover({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1B2335),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.gold.withOpacity(0.35),
          width: 1.2,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_stories_rounded,
                color: AppColors.gold,
                size: width * 0.28,
              ),
              const SizedBox(height: 8),
              Text(
                'LoreKeeper',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.gold,
                  fontWeight: FontWeight.w900,
                  fontSize: width * 0.10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'No Cover',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: width * 0.075,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
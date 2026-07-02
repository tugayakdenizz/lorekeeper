import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const display = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: -0.6,
  );

  static const title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontSize: 16,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static const caption = TextStyle(
    fontSize: 13,
    color: AppColors.textMuted,
  );
}
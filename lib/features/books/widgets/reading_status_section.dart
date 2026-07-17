import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/user_book.dart';

class BookReadingStatusSection extends StatelessWidget {
  final UserBookStatus? selectedStatus;
  final ValueChanged<UserBookStatus> onStatusChanged;

  const BookReadingStatusSection({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Okuma Durumu',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _StatusChip(
              label: 'Okuyacağım',
              isSelected: selectedStatus == UserBookStatus.wantToRead,
              onTap: () => onStatusChanged(UserBookStatus.wantToRead),
            ),
            _StatusChip(
              label: 'Okuyorum',
              isSelected: selectedStatus == UserBookStatus.reading,
              onTap: () => onStatusChanged(UserBookStatus.reading),
            ),
            _StatusChip(
              label: 'Bitirdim',
              isSelected: selectedStatus == UserBookStatus.finished,
              onTap: () => onStatusChanged(UserBookStatus.finished),
            ),
            _StatusChip(
              label: 'Yarım Bıraktım',
              isSelected: selectedStatus == UserBookStatus.dnf,
              onTap: () => onStatusChanged(UserBookStatus.dnf),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : AppColors.surface,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.background : AppColors.textSecondary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
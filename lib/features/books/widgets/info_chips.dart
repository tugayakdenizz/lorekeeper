import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/book.dart';
import 'info_chip.dart';

class InfoChips extends StatelessWidget {
  final Book book;
  final int? totalPages;

  const InfoChips({
    super.key,
    required this.book,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (book.publishedDate != null)
          InfoChip(text: '📅 ${book.publishedDate!.year}'),
        if (totalPages != null) ...[
          const SizedBox(width: AppSpacing.sm),
          InfoChip(text: '📖 $totalPages'),
        ],
      ],
    );
  }
}
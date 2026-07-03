import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/user_book.dart';
import 'library_book_card.dart';

class LibrarySection extends StatelessWidget {
  final String title;
  final List<UserBook> books;

  const LibrarySection({
    super.key,
    required this.title,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title (${books.length})',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...books.map(
            (userBook) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: LibraryBookCard(userBook: userBook),
            ),
          ),
        ],
      ),
    );
  }
}
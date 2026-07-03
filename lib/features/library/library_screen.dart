import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/user_book.dart';
import 'widgets/library_section.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Library',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: ValueListenableBuilder<List<UserBook>>(
                  valueListenable: LibraryStorageService.userBooksNotifier,
                  builder: (context, userBooks, _) {
                    if (userBooks.isEmpty) {
                      return const Center(
                        child: Text(
                          'Henüz kütüphanene kitap eklemedin.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      );
                    }

                    return ListView(
                      children: [
                        LibrarySection(
                          title: '📖 Okuyorum',
                          books: _filterByStatus(
                            userBooks,
                            UserBookStatus.reading,
                          ),
                        ),
                        LibrarySection(
                          title: '⭐ Okuyacağım',
                          books: _filterByStatus(
                            userBooks,
                            UserBookStatus.wantToRead,
                          ),
                        ),
                        LibrarySection(
                          title: '✅ Bitirdim',
                          books: _filterByStatus(
                            userBooks,
                            UserBookStatus.finished,
                          ),
                        ),
                        LibrarySection(
                          title: '❌ Yarım Bıraktım',
                          books: _filterByStatus(
                            userBooks,
                            UserBookStatus.dnf,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static List<UserBook> _filterByStatus(
    List<UserBook> userBooks,
    UserBookStatus status,
  ) {
    return userBooks.where((item) => item.status == status).toList();
  }
}
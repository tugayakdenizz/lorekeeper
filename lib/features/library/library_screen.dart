import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/user_book.dart';
import 'widgets/library_book_card.dart';

enum _LibraryFilter {
  all,
  reading,
  wantToRead,
  finished,
  dnf,
  favorites,
}

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  _LibraryFilter _selectedFilter = _LibraryFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserBook> _filteredBooks(List<UserBook> userBooks) {
    final query = _query.trim().toLowerCase();

    return userBooks.where((userBook) {
      final book = userBook.book;

      final matchesSearch = query.isEmpty ||
          book.title.toLowerCase().contains(query) ||
          book.authors.any((author) => author.toLowerCase().contains(query));

      final matchesFilter = switch (_selectedFilter) {
        _LibraryFilter.all => true,
        _LibraryFilter.reading => userBook.status == UserBookStatus.reading,
        _LibraryFilter.wantToRead =>
          userBook.status == UserBookStatus.wantToRead,
        _LibraryFilter.finished => userBook.status == UserBookStatus.finished,
        _LibraryFilter.dnf => userBook.status == UserBookStatus.dnf,
        _LibraryFilter.favorites => userBook.isFavorite,
      };

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ValueListenableBuilder<List<UserBook>>(
            valueListenable: LibraryStorageService.userBooksNotifier,
            builder: (context, userBooks, _) {
              final filteredBooks = _filteredBooks(userBooks);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kütüphane',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${userBooks.length} kitap • ${filteredBooks.length} sonuç',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SearchBox(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _query = value;
                      });
                    },
                    onClear: () {
                      _searchController.clear();
                      setState(() {
                        _query = '';
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FilterChips(
                    selectedFilter: _selectedFilter,
                    onChanged: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: _LibraryContent(
                      userBooks: filteredBooks,
                      isLibraryEmpty: userBooks.isEmpty,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBox({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: 'Kitap veya yazar ara',
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.gold,
        ),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: onClear,
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textMuted,
                ),
              ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.gold),
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final _LibraryFilter selectedFilter;
  final ValueChanged<_LibraryFilter> onChanged;

  const _FilterChips({
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      _FilterItem(
        filter: _LibraryFilter.all,
        label: 'Tümü',
        icon: Icons.library_books_rounded,
      ),
      _FilterItem(
        filter: _LibraryFilter.reading,
        label: 'Okuyorum',
        icon: Icons.auto_stories_rounded,
      ),
      _FilterItem(
        filter: _LibraryFilter.wantToRead,
        label: 'Okuyacağım',
        icon: Icons.bookmark_rounded,
      ),
      _FilterItem(
        filter: _LibraryFilter.finished,
        label: 'Bitirdim',
        icon: Icons.check_circle_rounded,
      ),
      _FilterItem(
        filter: _LibraryFilter.favorites,
        label: 'Favoriler',
        icon: Icons.favorite_rounded,
      ),
      _FilterItem(
        filter: _LibraryFilter.dnf,
        label: 'Yarım',
        icon: Icons.close_rounded,
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: _FilterChipButton(
                  item: item,
                  isSelected: selectedFilter == item.filter,
                  onTap: () => onChanged(item.filter),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final _FilterItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : AppColors.surface,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 17,
              color: isSelected ? AppColors.background : AppColors.gold,
            ),
            const SizedBox(width: 6),
            Text(
              item.label,
              style: TextStyle(
                color:
                    isSelected ? AppColors.background : AppColors.textSecondary,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterItem {
  final _LibraryFilter filter;
  final String label;
  final IconData icon;

  const _FilterItem({
    required this.filter,
    required this.label,
    required this.icon,
  });
}

class _LibraryContent extends StatelessWidget {
  final List<UserBook> userBooks;
  final bool isLibraryEmpty;

  const _LibraryContent({
    required this.userBooks,
    required this.isLibraryEmpty,
  });

  @override
  Widget build(BuildContext context) {
    if (isLibraryEmpty) {
      return const Center(
        child: Text(
          'Henüz kütüphanene kitap eklemedin.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    if (userBooks.isEmpty) {
      return const Center(
        child: Text(
          'Bu arama veya filtreyle eşleşen kitap yok.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      itemCount: userBooks.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return LibraryBookCard(userBook: userBooks[index]);
      },
    );
  }
}

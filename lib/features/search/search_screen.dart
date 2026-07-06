import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../repositories/book_repository.dart';
import '../../shared/models/book.dart';
import '../../shared/models/user_book.dart';
import '../books/book_detail_screen.dart';
import 'widgets/book_result_card.dart';

enum _SearchState { idle, loading, success, empty, error }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _repository = BookRepository();
  final _libraryStorage = LibraryStorageService();
  final _controller = TextEditingController();

  _SearchState _state = _SearchState.idle;
  List<Book> _books = [];
  String _lastQuery = '';
  String _errorMessage = '';

  Future<void> _search() async {
    final query = _controller.text.trim();

    if (query.isEmpty) {
      setState(() {
        _state = _SearchState.idle;
        _books = [];
        _errorMessage = '';
        _lastQuery = '';
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _state = _SearchState.loading;
      _books = [];
      _errorMessage = '';
      _lastQuery = query;
    });

    try {
      final results = await _repository.searchBooks(query);

      if (!mounted) return;

      setState(() {
        _books = results;
        _state = results.isEmpty ? _SearchState.empty : _SearchState.success;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _state = _SearchState.error;
        _errorMessage = _friendlyErrorMessage(error);
      });
    }
  }

  String _friendlyErrorMessage(Object error) {
    final text = error.toString().toLowerCase();

    if (text.contains('429') || text.contains('too many requests')) {
      return 'Google Books şu an çok fazla istek aldı. Birkaç dakika sonra tekrar dene.';
    }

    if (text.contains('socket') ||
        text.contains('network') ||
        text.contains('failed host lookup') ||
        text.contains('xmlhttprequest')) {
      return 'İnternet bağlantını kontrol edip tekrar dene.';
    }

    return 'Arama sırasında bir sorun oluştu. Lütfen tekrar dene.';
  }

  Future<void> _toggleBook(Book book) async {
    await _libraryStorage.toggleBook(book);

    final isNowAdded = _libraryStorage.containsBook(book.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isNowAdded
              ? '${book.title} kütüphaneye eklendi'
              : '${book.title} kütüphaneden çıkarıldı',
        ),
      ),
    );
  }

  void _openBookDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookDetailScreen(book: book),
      ),
    );
  }

  Set<String> _addedIdsFromUserBooks(List<UserBook> userBooks) {
    return userBooks.map((userBook) => userBook.book.id).toSet();
  }

  void _clearSearch() {
    _controller.clear();

    setState(() {
      _state = _SearchState.idle;
      _books = [];
      _errorMessage = '';
      _lastQuery = '';
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<UserBook>>(
      valueListenable: LibraryStorageService.userBooksNotifier,
      builder: (context, userBooks, _) {
        final addedBookIds = _addedIdsFromUserBooks(userBooks);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Discover',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Yeni kitaplar ve yazarlar keşfet.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SearchField(
                    controller: _controller,
                    isLoading: _state == _SearchState.loading,
                    onSubmitted: (_) => _search(),
                    onSearchPressed: _search,
                    onClearPressed: _clearSearch,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: _SearchContent(
                      state: _state,
                      books: _books,
                      errorMessage: _errorMessage,
                      lastQuery: _lastQuery,
                      addedBookIds: addedBookIds,
                      onRetry: _search,
                      onBookTap: _openBookDetail,
                      onBookAdd: _toggleBook,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSearchPressed;
  final VoidCallback onClearPressed;

  const _SearchField({
    required this.controller,
    required this.isLoading,
    required this.onSubmitted,
    required this.onSearchPressed,
    required this.onClearPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: 'Kitap veya yazar ara...',
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.gold),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textMuted,
                ),
                onPressed: onClearPressed,
              ),
            IconButton(
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.gold,
                    ),
              onPressed: isLoading ? null : onSearchPressed,
            ),
          ],
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.gold),
        ),
      ),
    );
  }
}

class _SearchContent extends StatelessWidget {
  final _SearchState state;
  final List<Book> books;
  final String errorMessage;
  final String lastQuery;
  final Set<String> addedBookIds;
  final VoidCallback onRetry;
  final ValueChanged<Book> onBookTap;
  final ValueChanged<Book> onBookAdd;

  const _SearchContent({
    required this.state,
    required this.books,
    required this.errorMessage,
    required this.lastQuery,
    required this.addedBookIds,
    required this.onRetry,
    required this.onBookTap,
    required this.onBookAdd,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case _SearchState.idle:
        return const _StateMessage(
          icon: Icons.travel_explore_rounded,
          title: 'Keşfetmeye başla',
          subtitle: 'Kitap adı, yazar adı veya seri adı arayabilirsin.',
        );

      case _SearchState.loading:
        return const _LoadingState();

      case _SearchState.empty:
        return _StateMessage(
          icon: Icons.search_off_rounded,
          title: 'Sonuç bulunamadı',
          subtitle: '"$lastQuery" için eşleşen kitap bulunamadı.',
        );

      case _SearchState.error:
        return _ErrorState(
          message: errorMessage,
          onRetry: onRetry,
        );

      case _SearchState.success:
        return ListView.separated(
          itemCount: books.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final book = books[index];

            return BookResultCard(
              book: book,
              isAdded: addedBookIds.contains(book.id),
              onAdd: () => onBookAdd(book),
              onTap: () => onBookTap(book),
            );
          },
        );
    }
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        return Container(
          height: 118,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 86,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SkeletonLine(width: double.infinity),
                    const SizedBox(height: 10),
                    const _SkeletonLine(width: 150),
                    const Spacer(),
                    const _SkeletonLine(width: 90),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double width;

  const _SkeletonLine({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 12,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StateMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.gold, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: AppColors.gold,
              size: 42,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Arama tamamlanamadı',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Tekrar Dene'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.gold,
                  foregroundColor: AppColors.background,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

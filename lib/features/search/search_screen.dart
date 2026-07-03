import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../repositories/book_repository.dart';
import '../../shared/models/book.dart';
import '../../shared/models/user_book.dart';
import '../books/book_detail_screen.dart';
import 'widgets/book_result_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _repository = BookRepository();
  final _libraryStorage = LibraryStorageService();
  final _controller = TextEditingController();

  bool _isLoading = false;
  List<Book> _books = [];

  Future<void> _search() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final results = await _repository.searchBooks(query);

      if (!mounted) return;

      setState(() {
        _books = results;
      });
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Arama sırasında bir hata oluştu')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _controller,
                    onSubmitted: (_) => _search(),
                    decoration: InputDecoration(
                      hintText: 'Search books or authors...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: _search,
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (_isLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_books.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Kitap veya yazar aramaya başla',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: _books.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final book = _books[index];

                          return BookResultCard(
                            book: book,
                            isAdded: addedBookIds.contains(book.id),
                            onAdd: () => _toggleBook(book),
                            onTap: () => _openBookDetail(book),
                          );
                        },
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
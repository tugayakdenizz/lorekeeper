import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'services/gutenberg_service.dart';

class GutenbergPickerScreen extends StatefulWidget {
  final String initialQuery;

  const GutenbergPickerScreen({
    super.key,
    this.initialQuery = '',
  });

  @override
  State<GutenbergPickerScreen> createState() =>
      _GutenbergPickerScreenState();
}

class _GutenbergPickerScreenState
    extends State<GutenbergPickerScreen> {
  final _service = GutenbergService();
  late final TextEditingController _searchController;

  List<GutenbergBook> _books = const [];
  String _language = '';
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.initialQuery,
    );
    _search();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final books = await _service.search(
        query: _searchController.text,
        language: _language.isEmpty ? null : _language,
      );

      if (!mounted) return;

      setState(() {
        _books = books;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.toString();
        _books = const [];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text(
          'Gutenberg Kütüphanesi',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onSubmitted: (_) => _search(),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Kitap veya yazar ara',
                      hintStyle: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.gold,
                      ),
                      suffixIcon: IconButton(
                        onPressed: _search,
                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.gold,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: AppColors.border,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: _LanguageChip(
                          label: 'Tümü',
                          selected: _language.isEmpty,
                          onTap: () {
                            setState(() => _language = '');
                            _search();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _LanguageChip(
                          label: 'Türkçe',
                          selected: _language == 'tr',
                          onTap: () {
                            setState(() => _language = 'tr');
                            _search();
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _LanguageChip(
                          label: 'İngilizce',
                          selected: _language == 'en',
                          onTap: () {
                            setState(() => _language = 'en');
                            _search();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.gold,
        ),
      );
    }

    if (_error != null) {
      return _MessageState(
        icon: Icons.cloud_off_rounded,
        title: 'Kataloğa ulaşılamadı',
        subtitle: _error!,
        onPressed: _search,
      );
    }

    if (_books.isEmpty) {
      return _MessageState(
        icon: Icons.menu_book_rounded,
        title: 'Sonuç bulunamadı',
        subtitle:
            'Arama kelimesini veya dil filtresini değiştirip tekrar dene.',
        onPressed: _search,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      itemCount: _books.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final book = _books[index];

        return _GutenbergBookCard(
          book: book,
          onTap: () => Navigator.pop(context, book),
        );
      },
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.gold : AppColors.surface,
      borderRadius: BorderRadius.circular(99),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected
                  ? AppColors.background
                  : AppColors.textSecondary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _GutenbergBookCard extends StatelessWidget {
  final GutenbergBook book;
  final VoidCallback onTap;

  const _GutenbergBookCard({
    required this.book,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _Cover(url: book.coverUrl),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        height: 1.2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      book.author,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${book.languages.join(', ').toUpperCase()} • ${book.downloadCount} indirme',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.download_rounded,
                color: AppColors.gold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  final String? url;

  const _Cover({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        width: 66,
        height: 96,
        color: AppColors.background,
        child: url == null
            ? const Icon(
                Icons.auto_stories_rounded,
                color: AppColors.gold,
              )
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.auto_stories_rounded,
                    color: AppColors.gold,
                  );
                },
              ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const _MessageState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.gold, size: 54),
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
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.background,
              ),
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }
}

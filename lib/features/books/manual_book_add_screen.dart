import 'package:flutter/material.dart';

import '../../core/services/library_storage_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../shared/models/book.dart';
import '../../shared/models/user_book.dart';

class ManualBookAddScreen extends StatefulWidget {
  const ManualBookAddScreen({super.key});

  @override
  State<ManualBookAddScreen> createState() => _ManualBookAddScreenState();
}

class _ManualBookAddScreenState extends State<ManualBookAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = LibraryStorageService();

  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _pageCountController = TextEditingController();
  final _descriptionController = TextEditingController();

  UserBookStatus _selectedStatus = UserBookStatus.wantToRead;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _pageCountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final now = DateTime.now();
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();
    final pageCount = int.tryParse(_pageCountController.text.trim());
    final description = _descriptionController.text.trim();

    final book = Book(
      id: 'manual-${now.microsecondsSinceEpoch}',
      title: title,
      authors: author.isEmpty ? const ['Bilinmeyen yazar'] : [author],
      description: description.isEmpty ? null : description,
      pageCount: pageCount,
      language: 'tr',
      createdAt: now,
      categories: const ['Manual'],
    );

    await _storage.addBook(book);

    final matches = _storage
        .getUserBooks()
        .where((item) => item.book.id == book.id)
        .toList();

    if (matches.isNotEmpty) {
      final current = matches.first;

      await _storage.updateUserBook(
        current.copyWith(
          status: _selectedStatus,
          startedAt: _selectedStatus == UserBookStatus.reading ? now : null,
          finishedAt: _selectedStatus == UserBookStatus.finished ? now : null,
          currentPage:
              _selectedStatus == UserBookStatus.finished && pageCount != null
                  ? pageCount
                  : 0,
        ),
      );
    }

    if (!mounted) return;

    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title kütüphaneye eklendi')),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TopBar(onBackPressed: () => Navigator.pop(context)),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Kitabı Manuel Ekle',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Aradığın kitap raflarda yoksa kendi kaydını oluştur.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _PremiumTextField(
                  controller: _titleController,
                  label: 'Kitap adı',
                  hintText: 'Örn: Metal Bükücü',
                  icon: Icons.menu_book_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Kitap adı zorunlu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                _PremiumTextField(
                  controller: _authorController,
                  label: 'Yazar',
                  hintText: 'Örn: Brandon Sanderson',
                  icon: Icons.person_rounded,
                ),
                const SizedBox(height: AppSpacing.md),
                _PremiumTextField(
                  controller: _pageCountController,
                  label: 'Toplam sayfa',
                  hintText: 'Örn: 672',
                  icon: Icons.numbers_rounded,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return null;

                    final pageCount = int.tryParse(text);
                    if (pageCount == null || pageCount <= 0) {
                      return 'Geçerli bir sayfa sayısı gir';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                _PremiumTextField(
                  controller: _descriptionController,
                  label: 'Açıklama',
                  hintText: 'Kısa not veya açıklama ekleyebilirsin.',
                  icon: Icons.notes_rounded,
                  maxLines: 4,
                ),
                const SizedBox(height: AppSpacing.xl),
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
                      isSelected: _selectedStatus == UserBookStatus.wantToRead,
                      onTap: () => setState(() {
                        _selectedStatus = UserBookStatus.wantToRead;
                      }),
                    ),
                    _StatusChip(
                      label: 'Okuyorum',
                      isSelected: _selectedStatus == UserBookStatus.reading,
                      onTap: () => setState(() {
                        _selectedStatus = UserBookStatus.reading;
                      }),
                    ),
                    _StatusChip(
                      label: 'Bitirdim',
                      isSelected: _selectedStatus == UserBookStatus.finished,
                      onTap: () => setState(() {
                        _selectedStatus = UserBookStatus.finished;
                      }),
                    ),
                    _StatusChip(
                      label: 'Yarım Bıraktım',
                      isSelected: _selectedStatus == UserBookStatus.dnf,
                      onTap: () => setState(() {
                        _selectedStatus = UserBookStatus.dnf;
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveBook,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.add_rounded),
                    label: Text(
                      _isSaving ? 'Ekleniyor...' : 'Kütüphaneye Ekle',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.background,
                      disabledBackgroundColor:
                          AppColors.gold.withOpacity(0.45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onBackPressed;

  const _TopBar({required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(99),
          child: InkWell(
            borderRadius: BorderRadius.circular(99),
            onTap: onBackPressed,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.gold,
                size: 21,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PremiumTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _PremiumTextField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        labelStyle: const TextStyle(color: AppColors.gold),
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: Icon(icon, color: AppColors.gold),
        filled: true,
        fillColor: AppColors.surface,
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : AppColors.surface,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.border,
          ),
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

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/models/reading_session.dart';
import '../../../shared/models/user_book.dart';

class ProgressBottomSheet extends StatefulWidget {
  final UserBook userBook;
  final Future<void> Function(UserBook updatedUserBook) onSave;

  const ProgressBottomSheet({
    super.key,
    required this.userBook,
    required this.onSave,
  });

  @override
  State<ProgressBottomSheet> createState() => _ProgressBottomSheetState();
}

class _ProgressBottomSheetState extends State<ProgressBottomSheet> {
  late final TextEditingController _currentPageController;
  late final TextEditingController _totalPageController;

  @override
  void initState() {
    super.initState();

    _currentPageController = TextEditingController(
      text: widget.userBook.currentPage == 0
          ? ''
          : widget.userBook.currentPage.toString(),
    );

    _totalPageController = TextEditingController(
      text: (widget.userBook.totalPagesOverride ?? widget.userBook.book.pageCount)
              ?.toString() ??
          '',
    );
  }

  @override
  void dispose() {
    _currentPageController.dispose();
    _totalPageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final oldPage = widget.userBook.currentPage;

    final currentPage =
        int.tryParse(_currentPageController.text.trim()) ?? 0;

    final totalPages = int.tryParse(_totalPageController.text.trim());

    final safePage = totalPages == null
        ? currentPage
        : currentPage.clamp(0, totalPages);

    final pagesRead = safePage - oldPage;

    final sessions = [...widget.userBook.readingSessions];

    if (pagesRead > 0) {
      sessions.add(
        ReadingSession(
          id: '${widget.userBook.id}_${DateTime.now().millisecondsSinceEpoch}',
          pagesRead: pagesRead,
          createdAt: DateTime.now(),
        ),
      );
    }

    final updatedUserBook = widget.userBook.copyWith(
      currentPage: safePage,
      totalPagesOverride: totalPages,
      readingSessions: sessions,
      status: safePage > 0 ? UserBookStatus.reading : widget.userBook.status,
      startedAt: widget.userBook.startedAt ?? DateTime.now(),
    );

    await widget.onSave(updatedUserBook);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'İlerlemeyi Güncelle',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProgressField(
            controller: _currentPageController,
            hintText: 'Bulunduğun sayfa',
          ),
          const SizedBox(height: AppSpacing.md),
          _ProgressField(
            controller: _totalPageController,
            hintText: 'Toplam sayfa',
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'Kaydet',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const _ProgressField({
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
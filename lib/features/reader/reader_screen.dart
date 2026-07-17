import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'models/reader_document.dart';
import 'services/reader_storage_service.dart';

class ReaderScreen extends StatefulWidget {
  final ReaderDocument document;

  const ReaderScreen({
    super.key,
    required this.document,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final _storage = ReaderStorageService();
  final _scrollController = ScrollController();

  ReaderProgress _progress = const ReaderProgress();
  bool _isLoading = true;
  bool _controlsVisible = true;
  Timer? _saveTimer;

  int get _chapterIndex => _progress.chapterIndex.clamp(
        0,
        widget.document.chapters.length - 1,
      );

  ReaderChapter get _chapter =>
      widget.document.chapters[_chapterIndex];

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _saveNow();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    final loaded = await _storage.loadProgress(
      widget.document.id,
    );

    if (!mounted) return;

    final safeChapter = loaded.chapterIndex.clamp(
      0,
      widget.document.chapters.length - 1,
    );

    setState(() {
      _progress = loaded.copyWith(chapterIndex: safeChapter);
      _isLoading = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      final safeOffset = loaded.scrollOffset
          .clamp(
            0.0,
            _scrollController.position.maxScrollExtent,
          )
          .toDouble();

      _scrollController.jumpTo(safeOffset);
    });
  }

  void _onScroll() {
    _progress = _progress.copyWith(
      scrollOffset: _scrollController.offset,
    );
    _scheduleSave();
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(
      const Duration(milliseconds: 600),
      _saveNow,
    );
  }

  Future<void> _saveNow() {
    return _storage.saveProgress(
      widget.document.id,
      _progress,
    );
  }

  Future<void> _changeChapter(int index) async {
    final safeIndex = index.clamp(
      0,
      widget.document.chapters.length - 1,
    );

    setState(() {
      _progress = _progress.copyWith(
        chapterIndex: safeIndex,
        scrollOffset: 0,
      );
    });

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }

    await _saveNow();
  }

  void _showReadingSettings() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void update(ReaderProgress progress) {
              setState(() => _progress = progress);
              setSheetState(() {});
              _scheduleSave();
            }

            return _SettingsSheet(
              progress: _progress,
              onChanged: update,
            );
          },
        );
      },
    );
  }

  void _showChapters() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _ChapterSheet(
          chapters: widget.document.chapters,
          selectedIndex: _chapterIndex,
          onSelected: (index) {
            Navigator.pop(context);
            _changeChapter(index);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = _ReaderPalette.fromMode(
      _progress.themeMode,
    );

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: palette.accent,
                ),
              )
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _controlsVisible = !_controlsVisible;
                  });
                },
                child: Stack(
                  children: [
                    ListView(
                      controller: _scrollController,
                      padding: EdgeInsets.fromLTRB(
                        26,
                        _controlsVisible ? 98 : 38,
                        26,
                        _controlsVisible ? 116 : 44,
                      ),
                      children: [
                        Text(
                          _chapter.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: palette.heading,
                            fontSize: 24,
                            height: 1.2,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          _chapter.content,
                          style: TextStyle(
                            color: palette.text,
                            fontSize: _progress.fontSize,
                            height: _progress.lineHeight,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 180),
                      top: _controlsVisible ? 0 : -84,
                      left: 0,
                      right: 0,
                      child: _TopControls(
                        palette: palette,
                        title: widget.document.title,
                        chapterIndex: _chapterIndex,
                        chapterCount:
                            widget.document.chapters.length,
                        onBack: () => Navigator.pop(context),
                        onChapters: _showChapters,
                      ),
                    ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 180),
                      bottom: _controlsVisible ? 0 : -100,
                      left: 0,
                      right: 0,
                      child: _BottomControls(
                        palette: palette,
                        canGoPrevious: _chapterIndex > 0,
                        canGoNext: _chapterIndex <
                            widget.document.chapters.length - 1,
                        onPrevious: () =>
                            _changeChapter(_chapterIndex - 1),
                        onNext: () =>
                            _changeChapter(_chapterIndex + 1),
                        onSettings: _showReadingSettings,
                        onChapters: _showChapters,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _TopControls extends StatelessWidget {
  final _ReaderPalette palette;
  final String title;
  final int chapterIndex;
  final int chapterCount;
  final VoidCallback onBack;
  final VoidCallback onChapters;

  const _TopControls({
    required this.palette,
    required this.title,
    required this.chapterIndex,
    required this.chapterCount,
    required this.onBack,
    required this.onChapters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: palette.panel.withOpacity(0.97),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: palette.heading,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: palette.heading,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${chapterIndex + 1} / $chapterCount',
                  style: TextStyle(
                    color: palette.muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onChapters,
            icon: Icon(
              Icons.toc_rounded,
              color: palette.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  final _ReaderPalette palette;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSettings;
  final VoidCallback onChapters;

  const _BottomControls({
    required this.palette,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    required this.onSettings,
    required this.onChapters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      color: palette.panel.withOpacity(0.97),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ControlButton(
            icon: Icons.chevron_left_rounded,
            label: 'Önceki',
            palette: palette,
            onPressed: canGoPrevious ? onPrevious : null,
          ),
          _ControlButton(
            icon: Icons.toc_rounded,
            label: 'Bölümler',
            palette: palette,
            onPressed: onChapters,
          ),
          _ControlButton(
            icon: Icons.text_fields_rounded,
            label: 'Görünüm',
            palette: palette,
            onPressed: onSettings,
          ),
          _ControlButton(
            icon: Icons.chevron_right_rounded,
            label: 'Sonraki',
            palette: palette,
            onPressed: canGoNext ? onNext : null,
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final _ReaderPalette palette;
  final VoidCallback? onPressed;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.palette,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: enabled
                  ? palette.accent
                  : palette.muted.withOpacity(0.4),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: enabled
                    ? palette.muted
                    : palette.muted.withOpacity(0.4),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSheet extends StatelessWidget {
  final ReaderProgress progress;
  final ValueChanged<ReaderProgress> onChanged;

  const _SettingsSheet({
    required this.progress,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        32,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Okuma Görünümü',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Tema',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: ReaderThemeMode.values.map((mode) {
                final selected = progress.themeMode == mode;
                final palette = _ReaderPalette.fromMode(mode);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => onChanged(
                        progress.copyWith(themeMode: mode),
                      ),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 58,
                        decoration: BoxDecoration(
                          color: palette.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected
                                ? AppColors.gold
                                : AppColors.border,
                            width: selected ? 2 : 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _themeLabel(mode),
                          style: TextStyle(
                            color: palette.heading,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SliderSetting(
              label: 'Yazı Boyutu',
              value: progress.fontSize,
              min: 15,
              max: 30,
              divisions: 15,
              onChanged: (value) => onChanged(
                progress.copyWith(fontSize: value),
              ),
            ),
            _SliderSetting(
              label: 'Satır Aralığı',
              value: progress.lineHeight,
              min: 1.25,
              max: 2.15,
              divisions: 9,
              onChanged: (value) => onChanged(
                progress.copyWith(lineHeight: value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _themeLabel(ReaderThemeMode mode) {
    switch (mode) {
      case ReaderThemeMode.dark:
        return 'Koyu';
      case ReaderThemeMode.sepia:
        return 'Sepya';
      case ReaderThemeMode.light:
        return 'Açık';
    }
  }
}

class _SliderSetting extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  const _SliderSetting({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Text(
              value.toStringAsFixed(1),
              style: const TextStyle(
                color: AppColors.gold,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: AppColors.gold,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ChapterSheet extends StatelessWidget {
  final List<ReaderChapter> chapters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _ChapterSheet({
    required this.chapters,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.78,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'Bölümler',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: chapters.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: AppColors.border,
                ),
                itemBuilder: (context, index) {
                  final selected = index == selectedIndex;

                  return ListTile(
                    onTap: () => onSelected(index),
                    leading: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: selected
                            ? AppColors.gold
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    title: Text(
                      chapters[index].title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected
                            ? AppColors.gold
                            : AppColors.textPrimary,
                        fontWeight: selected
                            ? FontWeight.w900
                            : FontWeight.w700,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReaderPalette {
  final Color background;
  final Color panel;
  final Color heading;
  final Color text;
  final Color muted;
  final Color accent;

  const _ReaderPalette({
    required this.background,
    required this.panel,
    required this.heading,
    required this.text,
    required this.muted,
    required this.accent,
  });

  factory _ReaderPalette.fromMode(ReaderThemeMode mode) {
    switch (mode) {
      case ReaderThemeMode.dark:
        return const _ReaderPalette(
          background: Color(0xFF0C1017),
          panel: Color(0xFF151B25),
          heading: Color(0xFFF4E7C6),
          text: Color(0xFFD5D8DE),
          muted: Color(0xFF979EAA),
          accent: Color(0xFFD7B56D),
        );
      case ReaderThemeMode.sepia:
        return const _ReaderPalette(
          background: Color(0xFFF2E7D2),
          panel: Color(0xFFE8D8BC),
          heading: Color(0xFF382B21),
          text: Color(0xFF49392D),
          muted: Color(0xFF796857),
          accent: Color(0xFF8B5E2A),
        );
      case ReaderThemeMode.light:
        return const _ReaderPalette(
          background: Color(0xFFF8F8F6),
          panel: Color(0xFFFFFFFF),
          heading: Color(0xFF171717),
          text: Color(0xFF292929),
          muted: Color(0xFF6B6B6B),
          accent: Color(0xFF8B651C),
        );
    }
  }
}

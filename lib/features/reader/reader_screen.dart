import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../quotes/quote_studio_screen.dart';
import 'models/reader_document.dart';
import 'services/reader_storage_service.dart';

class ReaderScreen extends StatefulWidget {
  final ReaderDocument document;

  const ReaderScreen({super.key, required this.document});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen>
    with WidgetsBindingObserver {
  final _storage = ReaderStorageService();
  final _scrollController = ScrollController();
  ReaderProgress _progress = const ReaderProgress();
  bool _isLoading = true;
  bool _controlsVisible = true;
  Timer? _saveTimer;
  Timer? _readingTimer;
  String _selectedQuoteText = '';

  int get _chapterIndex => _progress.chapterIndex.clamp(
        0,
        widget.document.chapters.length - 1,
      );
  ReaderChapter get _chapter => widget.document.chapters[_chapterIndex];

  double get _overallProgress {
    final count = widget.document.chapters.length;
    if (count == 0) return 0;
    return ((_chapterIndex + _progress.chapterProgress) / count).clamp(0, 1);
  }

  bool get _hasCurrentBookmark => _progress.bookmarks.any(
        (item) =>
            item.chapterIndex == _chapterIndex &&
            (item.scrollOffset - _progress.scrollOffset).abs() < 80,
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
    _loadProgress();
    _readingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted || _isLoading) return;
      _progress = _progress.copyWith(
        totalReadSeconds: _progress.totalReadSeconds + 30,
        lastReadAt: DateTime.now(),
      );
      _scheduleSave();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _saveNow();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveTimer?.cancel();
    _readingTimer?.cancel();
    _saveNow();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    final loaded = await _storage.loadProgress(widget.document.id);
    if (!mounted) return;
    final safeChapter = loaded.chapterIndex.clamp(
      0,
      widget.document.chapters.length - 1,
    );
    setState(() {
      _progress = loaded.copyWith(chapterIndex: safeChapter);
      _isLoading = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreOffset());
  }

  void _restoreOffset() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final target = _progress.scrollOffset.clamp(0.0, max).toDouble();
    _scrollController.jumpTo(target);
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isLoading) return;
    final max = _scrollController.position.maxScrollExtent;
    final chapterProgress = max <= 0
        ? 0.0
        : (_scrollController.offset / max).clamp(0.0, 1.0);
    _progress = _progress.copyWith(
      scrollOffset: _scrollController.offset,
      chapterProgress: chapterProgress,
      lastReadAt: DateTime.now(),
    );
    _scheduleSave();
    if (mounted) setState(() {});
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 700), _saveNow);
  }

  Future<void> _saveNow() =>
      _storage.saveProgress(widget.document.id, _progress);

  Future<void> _changeChapter(int index, {double offset = 0}) async {
    final safeIndex = index.clamp(0, widget.document.chapters.length - 1);
    setState(() {
      _progress = _progress.copyWith(
        chapterIndex: safeIndex,
        scrollOffset: offset,
        chapterProgress: 0,
      );
    });
    await _saveNow();
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreOffset());
  }

  Future<void> _toggleBookmark() async {
    final matches = _progress.bookmarks.where(
      (item) =>
          item.chapterIndex == _chapterIndex &&
          (item.scrollOffset - _progress.scrollOffset).abs() < 80,
    );
    final updated = [..._progress.bookmarks];
    if (matches.isNotEmpty) {
      updated.removeWhere((item) => item.id == matches.first.id);
    } else {
      updated.add(
        ReaderBookmark(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          chapterIndex: _chapterIndex,
          scrollOffset: _progress.scrollOffset,
          chapterTitle: _chapter.title,
          createdAt: DateTime.now(),
        ),
      );
    }
    setState(() => _progress = _progress.copyWith(bookmarks: updated));
    await _saveNow();
  }

  Future<void> _addNote() async {
    final controller = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Bölüm Notu',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 6,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Bu bölümle ilgili notunu yaz…',
            hintStyle: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (text == null || text.isEmpty) return;
    final updated = [
      ..._progress.notes,
      ReaderNote(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        chapterIndex: _chapterIndex,
        chapterTitle: _chapter.title,
        text: text,
        createdAt: DateTime.now(),
      ),
    ];
    setState(() => _progress = _progress.copyWith(notes: updated));
    await _saveNow();
  }


  void _openQuoteStudio() {
    final selected = _selectedQuoteText.trim();
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Önce kitaptan paylaşmak istediğin sözü seç.'),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => QuoteStudioScreen(
          quote: selected,
          bookTitle: widget.document.title,
          author: widget.document.author,
        ),
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          void update(ReaderProgress value) {
            setState(() => _progress = value);
            setSheetState(() {});
            _scheduleSave();
          }

          return _SettingsSheet(progress: _progress, onChanged: update);
        },
      ),
    );
  }

  void _showLibraryPanel() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _LibrarySheet(
        document: widget.document,
        progress: _progress,
        onChapter: (index) {
          Navigator.pop(context);
          _changeChapter(index);
        },
        onBookmark: (bookmark) {
          Navigator.pop(context);
          _changeChapter(bookmark.chapterIndex, offset: bookmark.scrollOffset);
        },
        onDeleteBookmark: (id) {
          setState(() {
            _progress = _progress.copyWith(
              bookmarks: _progress.bookmarks.where((e) => e.id != id).toList(),
            );
          });
          _saveNow();
        },
        onDeleteNote: (id) {
          setState(() {
            _progress = _progress.copyWith(
              notes: _progress.notes.where((e) => e.id != id).toList(),
            );
          });
          _saveNow();
        },
      ),
    );
  }

  void _showSearch() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _SearchSheet(
        document: widget.document,
        onSelected: (index) {
          Navigator.pop(context);
          _changeChapter(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = _ReaderPalette.fromMode(_progress.themeMode);
    final html = '''
<div style="color:${palette.cssText};font-size:${_progress.fontSize}px;line-height:${_progress.lineHeight};font-family:${_fontCss(_progress.fontFamily)};">
<style>p{margin:0 0 ${_progress.paragraphSpacing}px 0;} img{max-width:100%;height:auto;} blockquote{opacity:.86;border-left:3px solid ${palette.cssAccent};padding-left:14px;}</style>
${_chapter.htmlContent}
</div>
''';

    return PopScope(
      onPopInvokedWithResult: (_, __) => _saveNow(),
      child: Scaffold(
        backgroundColor: palette.background,
        body: SafeArea(
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: palette.accent))
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _controlsVisible = !_controlsVisible),
                  child: Stack(
                    children: [
                      ListView(
                        controller: _scrollController,
                        padding: EdgeInsets.fromLTRB(
                          _progress.horizontalPadding,
                          _controlsVisible ? 96 : 30,
                          _progress.horizontalPadding,
                          _controlsVisible ? 118 : 38,
                        ),
                        children: [
                          Text(
                            _chapter.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: palette.heading,
                              fontSize: 25,
                              height: 1.2,
                              fontFamily: _fontFamily(_progress.fontFamily),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 22),
                          SelectionArea(
                            onSelectionChanged: (selection) {
                              _selectedQuoteText = selection?.plainText ?? '';
                            },
                            child: Html(data: html, shrinkWrap: true),
                          ),
                          const SizedBox(height: 40),
                          _ChapterNavigationCard(
                            palette: palette,
                            canPrevious: _chapterIndex > 0,
                            canNext: _chapterIndex < widget.document.chapters.length - 1,
                            onPrevious: () => _changeChapter(_chapterIndex - 1),
                            onNext: () => _changeChapter(_chapterIndex + 1),
                          ),
                        ],
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 180),
                        top: _controlsVisible ? 0 : -90,
                        left: 0,
                        right: 0,
                        child: _TopBar(
                          palette: palette,
                          title: widget.document.title,
                          progress: _overallProgress,
                          chapterIndex: _chapterIndex,
                          chapterCount: widget.document.chapters.length,
                          bookmarked: _hasCurrentBookmark,
                          onBack: () async {
                            await _saveNow();
                            if (context.mounted) Navigator.pop(context);
                          },
                          onSearch: _showSearch,
                          onBookmark: _toggleBookmark,
                        ),
                      ),
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 180),
                        bottom: _controlsVisible ? 0 : -105,
                        left: 0,
                        right: 0,
                        child: _BottomBar(
                          palette: palette,
                          onLibrary: _showLibraryPanel,
                          onNote: _addNote,
                          onQuote: _openQuoteStudio,
                          onSettings: _showSettings,
                          readSeconds: _progress.totalReadSeconds,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  static String _fontCss(ReaderFontFamily value) {
    switch (value) {
      case ReaderFontFamily.serif:
        return 'Georgia, serif';
      case ReaderFontFamily.sans:
        return 'Arial, sans-serif';
      case ReaderFontFamily.book:
        return 'Palatino, serif';
    }
  }

  static String _fontFamily(ReaderFontFamily value) {
    switch (value) {
      case ReaderFontFamily.serif:
        return 'Georgia';
      case ReaderFontFamily.sans:
        return 'Arial';
      case ReaderFontFamily.book:
        return 'Palatino';
    }
  }
}

class _TopBar extends StatelessWidget {
  final _ReaderPalette palette;
  final String title;
  final double progress;
  final int chapterIndex;
  final int chapterCount;
  final bool bookmarked;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final VoidCallback onBookmark;

  const _TopBar({
    required this.palette,
    required this.title,
    required this.progress,
    required this.chapterIndex,
    required this.chapterCount,
    required this.bookmarked,
    required this.onBack,
    required this.onSearch,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: palette.panel.withOpacity(.97),
      child: Column(
        children: [
          SizedBox(
            height: 72,
            child: Row(
              children: [
                IconButton(onPressed: onBack, icon: Icon(Icons.arrow_back_ios_new_rounded, color: palette.heading)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: palette.heading, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 3),
                      Text('${chapterIndex + 1} / $chapterCount • %${(progress * 100).round()}', style: TextStyle(color: palette.muted, fontSize: 11)),
                    ],
                  ),
                ),
                IconButton(onPressed: onSearch, icon: Icon(Icons.search_rounded, color: palette.accent)),
                IconButton(onPressed: onBookmark, icon: Icon(bookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, color: palette.accent)),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: progress,
            minHeight: 3,
            backgroundColor: palette.muted.withOpacity(.18),
            valueColor: AlwaysStoppedAnimation(palette.accent),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final _ReaderPalette palette;
  final VoidCallback onLibrary;
  final VoidCallback onNote;
  final VoidCallback onQuote;
  final VoidCallback onSettings;
  final int readSeconds;

  const _BottomBar({required this.palette, required this.onLibrary, required this.onNote, required this.onQuote, required this.onSettings, required this.readSeconds});

  @override
  Widget build(BuildContext context) {
    final minutes = readSeconds ~/ 60;
    return Container(
      height: 88,
      color: palette.panel.withOpacity(.97),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Action(icon: Icons.toc_rounded, label: 'Kitap', palette: palette, onTap: onLibrary),
          _Action(icon: Icons.note_add_outlined, label: 'Not', palette: palette, onTap: onNote),
          _Action(icon: Icons.format_quote_rounded, label: 'Alıntı', palette: palette, onTap: onQuote),
          _Action(icon: Icons.text_fields_rounded, label: 'Görünüm', palette: palette, onTap: onSettings),
          _Action(icon: Icons.timer_outlined, label: '$minutes dk', palette: palette, onTap: onLibrary),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String label;
  final _ReaderPalette palette;
  final VoidCallback onTap;
  const _Action({required this.icon, required this.label, required this.palette, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, color: palette.accent),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: palette.muted, fontSize: 10, fontWeight: FontWeight.w700)),
          ]),
        ),
      );
}

class _ChapterNavigationCard extends StatelessWidget {
  final _ReaderPalette palette;
  final bool canPrevious;
  final bool canNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  const _ChapterNavigationCard({required this.palette, required this.canPrevious, required this.canNext, required this.onPrevious, required this.onNext});

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(child: OutlinedButton.icon(onPressed: canPrevious ? onPrevious : null, icon: const Icon(Icons.chevron_left_rounded), label: const Text('Önceki Bölüm'))),
        const SizedBox(width: 12),
        Expanded(child: OutlinedButton.icon(onPressed: canNext ? onNext : null, icon: const Icon(Icons.chevron_right_rounded), label: const Text('Sonraki Bölüm'))),
      ]);
}

class _SettingsSheet extends StatelessWidget {
  final ReaderProgress progress;
  final ValueChanged<ReaderProgress> onChanged;
  const _SettingsSheet({required this.progress, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 30),
      decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            const Text('Okuma Görünümü', style: TextStyle(color: AppColors.textPrimary, fontSize: 21, fontWeight: FontWeight.w900)),
            const SizedBox(height: 18),
            const _Label('Tema'),
            const SizedBox(height: 9),
            Row(children: ReaderThemeMode.values.map((mode) {
              final selected = progress.themeMode == mode;
              final palette = _ReaderPalette.fromMode(mode);
              return Expanded(child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: () => onChanged(progress.copyWith(themeMode: mode)),
                  child: Container(
                    height: 58,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: palette.background, borderRadius: BorderRadius.circular(15), border: Border.all(color: selected ? AppColors.gold : AppColors.border, width: selected ? 2 : 1)),
                    child: Text(_themeLabel(mode), style: TextStyle(color: palette.heading, fontWeight: FontWeight.w900)),
                  ),
                ),
              ));
            }).toList()),
            const SizedBox(height: 18),
            const _Label('Yazı Tipi'),
            const SizedBox(height: 9),
            Wrap(spacing: 8, children: ReaderFontFamily.values.map((font) => ChoiceChip(
              label: Text(_fontLabel(font)),
              selected: progress.fontFamily == font,
              onSelected: (_) => onChanged(progress.copyWith(fontFamily: font)),
            )).toList()),
            const SizedBox(height: 12),
            _Slider(label: 'Yazı Boyutu', value: progress.fontSize, min: 15, max: 30, divisions: 15, onChanged: (v) => onChanged(progress.copyWith(fontSize: v))),
            _Slider(label: 'Satır Aralığı', value: progress.lineHeight, min: 1.2, max: 2.2, divisions: 10, onChanged: (v) => onChanged(progress.copyWith(lineHeight: v))),
            _Slider(label: 'Paragraf Boşluğu', value: progress.paragraphSpacing, min: 4, max: 28, divisions: 12, onChanged: (v) => onChanged(progress.copyWith(paragraphSpacing: v))),
            _Slider(label: 'Kenar Boşluğu', value: progress.horizontalPadding, min: 12, max: 42, divisions: 15, onChanged: (v) => onChanged(progress.copyWith(horizontalPadding: v))),
          ]),
        ),
      ),
    );
  }

  static String _themeLabel(ReaderThemeMode mode) => switch (mode) {
        ReaderThemeMode.dark => 'Koyu',
        ReaderThemeMode.sepia => 'Sepya',
        ReaderThemeMode.light => 'Açık',
      };
  static String _fontLabel(ReaderFontFamily font) => switch (font) {
        ReaderFontFamily.serif => 'Serif',
        ReaderFontFamily.sans => 'Modern',
        ReaderFontFamily.book => 'Kitap',
      };
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w800));
}

class _Slider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  const _Slider({required this.label, required this.value, required this.min, required this.max, required this.divisions, required this.onChanged});

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w800)),
          Text(value.toStringAsFixed(value < 3 ? 2 : 0), style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w900)),
        ]),
        Slider(value: value.clamp(min, max), min: min, max: max, divisions: divisions, activeColor: AppColors.gold, onChanged: onChanged),
      ]);
}

class _LibrarySheet extends StatefulWidget {
  final ReaderDocument document;
  final ReaderProgress progress;
  final ValueChanged<int> onChapter;
  final ValueChanged<ReaderBookmark> onBookmark;
  final ValueChanged<String> onDeleteBookmark;
  final ValueChanged<String> onDeleteNote;
  const _LibrarySheet({required this.document, required this.progress, required this.onChapter, required this.onBookmark, required this.onDeleteBookmark, required this.onDeleteNote});

  @override
  State<_LibrarySheet> createState() => _LibrarySheetState();
}

class _LibrarySheetState extends State<_LibrarySheet> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * .82,
      decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: SafeArea(top: false, child: Column(children: [
        const SizedBox(height: 12),
        Container(width: 44, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(99))),
        const SizedBox(height: 16),
        const Text('Kitap Menüsü', style: TextStyle(color: AppColors.textPrimary, fontSize: 21, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        SegmentedButton<int>(segments: const [
          ButtonSegment(value: 0, label: Text('Bölümler'), icon: Icon(Icons.toc_rounded)),
          ButtonSegment(value: 1, label: Text('Yer İmleri'), icon: Icon(Icons.bookmark_outline)),
          ButtonSegment(value: 2, label: Text('Notlar'), icon: Icon(Icons.notes_rounded)),
        ], selected: {tab}, onSelectionChanged: (v) => setState(() => tab = v.first)),
        const SizedBox(height: 12),
        Expanded(child: switch (tab) {
          0 => ListView.builder(itemCount: widget.document.chapters.length, itemBuilder: (_, i) => ListTile(
            selected: i == widget.progress.chapterIndex,
            leading: CircleAvatar(child: Text('${i + 1}')),
            title: Text(widget.document.chapters[i].title, maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text('${widget.document.chapters[i].wordCount} kelime'),
            onTap: () => widget.onChapter(i),
          )),
          1 => widget.progress.bookmarks.isEmpty ? const _Empty(text: 'Henüz yer imi eklenmedi.') : ListView(children: widget.progress.bookmarks.map((b) => ListTile(
            leading: const Icon(Icons.bookmark_rounded, color: AppColors.gold),
            title: Text(b.chapterTitle),
            subtitle: Text('${b.createdAt.day}.${b.createdAt.month}.${b.createdAt.year}'),
            onTap: () => widget.onBookmark(b),
            trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () { widget.onDeleteBookmark(b.id); setState(() {}); }),
          )).toList()),
          _ => widget.progress.notes.isEmpty ? const _Empty(text: 'Henüz bölüm notu eklenmedi.') : ListView(children: widget.progress.notes.map((n) => ListTile(
            leading: const Icon(Icons.note_rounded, color: AppColors.gold),
            title: Text(n.chapterTitle),
            subtitle: Text(n.text, maxLines: 3, overflow: TextOverflow.ellipsis),
            trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () { widget.onDeleteNote(n.id); setState(() {}); }),
          )).toList()),
        }),
      ])),
    );
  }
}

class _SearchSheet extends StatefulWidget {
  final ReaderDocument document;
  final ValueChanged<int> onSelected;
  const _SearchSheet({required this.document, required this.onSelected});
  @override
  State<_SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<_SearchSheet> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final normalized = query.trim().toLowerCase();
    final results = normalized.isEmpty
        ? <int>[]
        : List<int>.generate(widget.document.chapters.length, (i) => i)
            .where((i) => widget.document.chapters[i].plainText.toLowerCase().contains(normalized) || widget.document.chapters[i].title.toLowerCase().contains(normalized))
            .toList();
    return Container(
      height: MediaQuery.sizeOf(context).height * .78,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      decoration: const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: SafeArea(top: false, child: Column(children: [
        TextField(autofocus: true, onChanged: (v) => setState(() => query = v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'Kitap içinde ara…')),
        const SizedBox(height: 12),
        Expanded(child: normalized.isEmpty
            ? const _Empty(text: 'Aramak istediğin kelimeyi yaz.')
            : results.isEmpty
                ? const _Empty(text: 'Eşleşme bulunamadı.')
                : ListView.builder(itemCount: results.length, itemBuilder: (_, index) {
                    final i = results[index];
                    final chapter = widget.document.chapters[i];
                    final lower = chapter.plainText.toLowerCase();
                    final at = lower.indexOf(normalized);
                    final start = (at - 70).clamp(0, chapter.plainText.length);
                    final end = (at + normalized.length + 120).clamp(0, chapter.plainText.length);
                    return ListTile(title: Text(chapter.title), subtitle: Text(chapter.plainText.substring(start, end).replaceAll('\n', ' '), maxLines: 3, overflow: TextOverflow.ellipsis), onTap: () => widget.onSelected(i));
                  })),
      ])),
    );
  }
}

class _Empty extends StatelessWidget {
  final String text;
  const _Empty({required this.text});
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(30), child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary))));
}

class _ReaderPalette {
  final Color background;
  final Color panel;
  final Color heading;
  final Color text;
  final Color muted;
  final Color accent;
  const _ReaderPalette({required this.background, required this.panel, required this.heading, required this.text, required this.muted, required this.accent});

  String get cssText => '#${text.value.toRadixString(16).padLeft(8, '0').substring(2)}';
  String get cssAccent => '#${accent.value.toRadixString(16).padLeft(8, '0').substring(2)}';

  factory _ReaderPalette.fromMode(ReaderThemeMode mode) => switch (mode) {
        ReaderThemeMode.dark => const _ReaderPalette(background: Color(0xFF0B1020), panel: Color(0xFF131B2E), heading: Color(0xFFF5D58A), text: Color(0xFFE7E2D8), muted: Color(0xFFA9B0BE), accent: Color(0xFFD9B667)),
        ReaderThemeMode.sepia => const _ReaderPalette(background: Color(0xFFF3E7CF), panel: Color(0xFFE8D8B8), heading: Color(0xFF4A3522), text: Color(0xFF3D3025), muted: Color(0xFF786854), accent: Color(0xFF9A6A2F)),
        ReaderThemeMode.light => const _ReaderPalette(background: Color(0xFFF7F7F5), panel: Color(0xFFFFFFFF), heading: Color(0xFF1C2430), text: Color(0xFF2C333A), muted: Color(0xFF6C747C), accent: Color(0xFF8A622B)),
      };
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'models/quote_entry.dart';
import 'models/quote_visual_theme.dart';
import 'services/quote_export_service.dart';
import 'services/quote_storage_service.dart';
import 'widgets/quote_story_canvas.dart';
import 'widgets/quote_theme_picker.dart';

class QuoteStudioScreen extends StatefulWidget {
  final String quote;
  final String bookTitle;
  final String author;
  const QuoteStudioScreen({super.key, required this.quote, required this.bookTitle, required this.author});
  @override
  State<QuoteStudioScreen> createState() => _QuoteStudioScreenState();
}

class _QuoteStudioScreenState extends State<QuoteStudioScreen> {
  final GlobalKey _captureKey = GlobalKey();
  final QuoteExportService _exportService = QuoteExportService();
  final QuoteStorageService _storageService = QuoteStorageService();
  QuoteVisualTheme _theme = QuoteVisualThemes.gothic;
  bool _showBrand = true;
  bool _busy = false;

  Future<void> _saveQuote() async {
    final entry = QuoteEntry(id: DateTime.now().microsecondsSinceEpoch.toString(), text: widget.quote.trim(), bookTitle: widget.bookTitle.trim(), author: widget.author.trim(), themeId: _theme.id, createdAt: DateTime.now());
    await _storageService.saveQuote(entry);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alıntı profiline kaydedildi.')));
  }

  Future<void> _shareQuote() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final renderObject = _captureKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) throw StateError('Paylaşım önizlemesi hazır değil.');
      final file = await _exportService.exportPng(boundary: renderObject, fileName: 'lorekeeper_quote_${DateTime.now().millisecondsSinceEpoch}');
      await _exportService.shareFile(file: file, text: '${widget.bookTitle} — ${widget.author}');
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Paylaşım hazırlanamadı: $error')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D1B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF090D1B), foregroundColor: Colors.white, elevation: 0,
        title: const Text('Alıntı Stüdyosu', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [IconButton(tooltip: 'Profile kaydet', onPressed: _saveQuote, icon: const Icon(Icons.bookmark_add_outlined)), Padding(padding: const EdgeInsets.only(right: 10), child: FilledButton.icon(onPressed: _busy ? null : _shareQuote, style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD6B56C), foregroundColor: const Color(0xFF12101A)), icon: _busy ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.ios_share_rounded, size: 19), label: const Text('Paylaş')))],
      ),
      body: SafeArea(
        top: false,
        child: Column(children: [
          Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(38, 22, 38, 20), child: RepaintBoundary(key: _captureKey, child: QuoteStoryCanvas(quote: widget.quote, bookTitle: widget.bookTitle, author: widget.author, visualTheme: _theme, showBrand: _showBrand)))),
          Container(
            padding: const EdgeInsets.only(top: 14, bottom: 12),
            decoration: BoxDecoration(color: const Color(0xFF10162A), border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08)))),
            child: Column(children: [QuoteThemePicker(selectedId: _theme.id, onSelected: (theme) => setState(() => _theme = theme)), const SizedBox(height: 8), SwitchListTile.adaptive(value: _showBrand, onChanged: (value) => setState(() => _showBrand = value), title: const Text('LoreKeeper imzasını göster', style: TextStyle(color: Colors.white)), activeTrackColor: const Color(0xFFD6B56C), contentPadding: const EdgeInsets.symmetric(horizontal: 22))]),
          ),
        ]),
      ),
    );
  }
}

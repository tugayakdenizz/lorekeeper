import 'package:flutter/material.dart';
import '../models/quote_visual_theme.dart';

class QuoteStoryCanvas extends StatelessWidget {
  final String quote;
  final String bookTitle;
  final String author;
  final QuoteVisualTheme visualTheme;
  final bool showBrand;

  const QuoteStoryCanvas({super.key, required this.quote, required this.bookTitle, required this.author, required this.visualTheme, required this.showBrand});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: visualTheme.backgroundColors),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: visualTheme.accentColor.withValues(alpha: 0.42)),
          boxShadow: const [BoxShadow(blurRadius: 28, offset: Offset(0, 16), color: Color(0x66000000))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              if (visualTheme.showStars) const _StarField(),
              const Positioned.fill(child: _Vignette()),
              if (visualTheme.showOrnaments) Positioned(top: 28, left: 28, right: 28, child: _Ornament(color: visualTheme.accentColor)),
              Padding(
                padding: const EdgeInsets.fromLTRB(36, 58, 36, 42),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    Text('“', style: TextStyle(height: 0.8, fontFamily: 'Georgia', fontSize: 72, color: visualTheme.accentColor)),
                    const SizedBox(height: 18),
                    Text(quote.trim(), textAlign: TextAlign.center, maxLines: 12, overflow: TextOverflow.ellipsis, style: TextStyle(height: 1.45, fontFamily: 'Georgia', fontSize: _fontSizeFor(quote), fontWeight: FontWeight.w600, color: visualTheme.foregroundColor)),
                    const Spacer(flex: 2),
                    Container(width: 56, height: 1, color: visualTheme.accentColor.withValues(alpha: 0.75)),
                    const SizedBox(height: 24),
                    Text(bookTitle.trim().isEmpty ? 'Kitap' : bookTitle.trim(), textAlign: TextAlign.center, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: visualTheme.accentColor)),
                    if (author.trim().isNotEmpty) ...[
                      const SizedBox(height: 7),
                      Text(author.trim(), textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: visualTheme.foregroundColor.withValues(alpha: 0.72))),
                    ],
                    const Spacer(),
                    AnimatedOpacity(opacity: showBrand ? 1 : 0, duration: const Duration(milliseconds: 180), child: Text('LOREKEEPER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 3.2, color: visualTheme.foregroundColor.withValues(alpha: 0.58)))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _fontSizeFor(String text) {
    final length = text.trim().length;
    if (length <= 90) return 27;
    if (length <= 170) return 23;
    if (length <= 280) return 20;
    return 17;
  }
}

class _Ornament extends StatelessWidget {
  final Color color;
  const _Ornament({required this.color});
  @override
  Widget build(BuildContext context) => Row(children: [Expanded(child: Divider(color: color.withValues(alpha: 0.55))), Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Icon(Icons.auto_awesome, size: 17, color: color)), Expanded(child: Divider(color: color.withValues(alpha: 0.55)))]);
}

class _Vignette extends StatelessWidget {
  const _Vignette();
  @override
  Widget build(BuildContext context) => DecoratedBox(decoration: BoxDecoration(gradient: RadialGradient(radius: 0.95, colors: [Colors.transparent, Colors.black.withValues(alpha: 0.25)], stops: const [0.46, 1])));
}

class _StarField extends StatelessWidget {
  const _StarField();
  @override
  Widget build(BuildContext context) => const Stack(children: [
    _Star(top: 68, left: 62, size: 3), _Star(top: 116, right: 52, size: 2), _Star(top: 190, left: 38, size: 2), _Star(top: 270, right: 28, size: 4), _Star(bottom: 210, left: 44, size: 2), _Star(bottom: 118, right: 62, size: 3),
  ]);
}

class _Star extends StatelessWidget {
  final double? top, bottom, left, right;
  final double size;
  const _Star({this.top, this.bottom, this.left, this.right, required this.size});
  @override
  Widget build(BuildContext context) => Positioned(top: top, bottom: bottom, left: left, right: right, child: DecoratedBox(decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x99FFFFFF)), child: SizedBox.square(dimension: size)));
}

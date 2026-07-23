import 'package:flutter/material.dart';
import '../models/quote_visual_theme.dart';

class QuoteThemePicker extends StatelessWidget {
  final String selectedId;
  final ValueChanged<QuoteVisualTheme> onSelected;
  const QuoteThemePicker({super.key, required this.selectedId, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: QuoteVisualThemes.all.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final theme = QuoteVisualThemes.all[index];
          final selected = theme.id == selectedId;
          return GestureDetector(
            onTap: () => onSelected(theme),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 92,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFF171D30), borderRadius: BorderRadius.circular(18), border: Border.all(width: selected ? 2 : 1, color: selected ? const Color(0xFFD6B56C) : Colors.white.withValues(alpha: 0.10))),
              child: Column(children: [Expanded(child: DecoratedBox(decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), gradient: LinearGradient(colors: theme.backgroundColors)), child: Center(child: Icon(Icons.format_quote_rounded, color: theme.accentColor, size: 24)))), const SizedBox(height: 6), Text(theme.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, fontWeight: selected ? FontWeight.w700 : FontWeight.w500, color: selected ? const Color(0xFFF2D58D) : Colors.white70))]),
            ),
          );
        },
      ),
    );
  }
}

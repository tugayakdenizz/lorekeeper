import 'package:flutter/material.dart';

class QuoteVisualTheme {
  final String id;
  final String label;
  final List<Color> backgroundColors;
  final Color foregroundColor;
  final Color accentColor;
  final bool showStars;
  final bool showOrnaments;

  const QuoteVisualTheme({required this.id, required this.label, required this.backgroundColors, required this.foregroundColor, required this.accentColor, this.showStars = false, this.showOrnaments = true});
}

class QuoteVisualThemes {
  static const gothic = QuoteVisualTheme(id: 'gothic', label: 'Gotik', backgroundColors: [Color(0xFF070A16), Color(0xFF11172B), Color(0xFF05060D)], foregroundColor: Color(0xFFF4EBDD), accentColor: Color(0xFFD6B56C));
  static const moonlight = QuoteVisualTheme(id: 'moonlight', label: 'Ay Işığı', backgroundColors: [Color(0xFF0B1733), Color(0xFF162B52), Color(0xFF080D1B)], foregroundColor: Color(0xFFF4F6FF), accentColor: Color(0xFFB9C9FF), showStars: true);
  static const parchment = QuoteVisualTheme(id: 'parchment', label: 'Parşömen', backgroundColors: [Color(0xFFF1DFC0), Color(0xFFD2AF78), Color(0xFFF4E8CD)], foregroundColor: Color(0xFF2F2418), accentColor: Color(0xFF7B4A24));
  static const royal = QuoteVisualTheme(id: 'royal', label: 'Kraliyet', backgroundColors: [Color(0xFF21102D), Color(0xFF4B234F), Color(0xFF100815)], foregroundColor: Color(0xFFFFF5E6), accentColor: Color(0xFFE7C46A), showStars: true);
  static const minimal = QuoteVisualTheme(id: 'minimal', label: 'Minimal', backgroundColors: [Color(0xFFF5F2EB), Color(0xFFE8E3D8)], foregroundColor: Color(0xFF161616), accentColor: Color(0xFF68604F), showOrnaments: false);
  static const all = [gothic, moonlight, parchment, royal, minimal];
  static QuoteVisualTheme byId(String id) => all.firstWhere((theme) => theme.id == id, orElse: () => gothic);
}

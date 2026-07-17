import 'dart:typed_data';

enum ReaderSourceType {
  localEpub,
  gutenberg,
}

enum ReaderThemeMode {
  dark,
  sepia,
  light,
}

class ReaderChapter {
  final String title;
  final String content;

  const ReaderChapter({
    required this.title,
    required this.content,
  });
}

class ReaderDocument {
  final String id;
  final String title;
  final String author;
  final ReaderSourceType sourceType;
  final List<ReaderChapter> chapters;
  final Uint8List? epubBytes;
  final String? sourceUrl;

  const ReaderDocument({
    required this.id,
    required this.title,
    required this.author,
    required this.sourceType,
    required this.chapters,
    this.epubBytes,
    this.sourceUrl,
  });
}

class ReaderProgress {
  final int chapterIndex;
  final double scrollOffset;
  final double fontSize;
  final double lineHeight;
  final ReaderThemeMode themeMode;

  const ReaderProgress({
    this.chapterIndex = 0,
    this.scrollOffset = 0,
    this.fontSize = 19,
    this.lineHeight = 1.65,
    this.themeMode = ReaderThemeMode.sepia,
  });

  ReaderProgress copyWith({
    int? chapterIndex,
    double? scrollOffset,
    double? fontSize,
    double? lineHeight,
    ReaderThemeMode? themeMode,
  }) {
    return ReaderProgress(
      chapterIndex: chapterIndex ?? this.chapterIndex,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapterIndex': chapterIndex,
      'scrollOffset': scrollOffset,
      'fontSize': fontSize,
      'lineHeight': lineHeight,
      'themeMode': themeMode.name,
    };
  }

  factory ReaderProgress.fromJson(Map<String, dynamic> json) {
    final themeName = json['themeMode'] as String?;
    final theme = ReaderThemeMode.values.firstWhere(
      (item) => item.name == themeName,
      orElse: () => ReaderThemeMode.sepia,
    );

    return ReaderProgress(
      chapterIndex: (json['chapterIndex'] as num?)?.toInt() ?? 0,
      scrollOffset: (json['scrollOffset'] as num?)?.toDouble() ?? 0,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 19,
      lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.65,
      themeMode: theme,
    );
  }
}

import 'dart:typed_data';

enum ReaderSourceType { localEpub, gutenberg }
enum ReaderThemeMode { dark, sepia, light }
enum ReaderFontFamily { serif, sans, book }

class ReaderChapter {
  final String title;
  final String htmlContent;
  final String plainText;
  final int wordCount;

  const ReaderChapter({
    required this.title,
    required this.htmlContent,
    required this.plainText,
    required this.wordCount,
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

  int get totalWords => chapters.fold(0, (sum, item) => sum + item.wordCount);
}

class ReaderBookmark {
  final String id;
  final int chapterIndex;
  final double scrollOffset;
  final String chapterTitle;
  final DateTime createdAt;

  const ReaderBookmark({
    required this.id,
    required this.chapterIndex,
    required this.scrollOffset,
    required this.chapterTitle,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'chapterIndex': chapterIndex,
        'scrollOffset': scrollOffset,
        'chapterTitle': chapterTitle,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ReaderBookmark.fromJson(Map<String, dynamic> json) => ReaderBookmark(
        id: json['id'] as String? ?? '',
        chapterIndex: (json['chapterIndex'] as num?)?.toInt() ?? 0,
        scrollOffset: (json['scrollOffset'] as num?)?.toDouble() ?? 0,
        chapterTitle: json['chapterTitle'] as String? ?? 'Bölüm',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}

class ReaderNote {
  final String id;
  final int chapterIndex;
  final String chapterTitle;
  final String text;
  final DateTime createdAt;

  const ReaderNote({
    required this.id,
    required this.chapterIndex,
    required this.chapterTitle,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'chapterIndex': chapterIndex,
        'chapterTitle': chapterTitle,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ReaderNote.fromJson(Map<String, dynamic> json) => ReaderNote(
        id: json['id'] as String? ?? '',
        chapterIndex: (json['chapterIndex'] as num?)?.toInt() ?? 0,
        chapterTitle: json['chapterTitle'] as String? ?? 'Bölüm',
        text: json['text'] as String? ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}

class ReaderProgress {
  final int chapterIndex;
  final double scrollOffset;
  final double chapterProgress;
  final double fontSize;
  final double lineHeight;
  final double paragraphSpacing;
  final double horizontalPadding;
  final ReaderThemeMode themeMode;
  final ReaderFontFamily fontFamily;
  final int totalReadSeconds;
  final DateTime? lastReadAt;
  final List<ReaderBookmark> bookmarks;
  final List<ReaderNote> notes;

  const ReaderProgress({
    this.chapterIndex = 0,
    this.scrollOffset = 0,
    this.chapterProgress = 0,
    this.fontSize = 19,
    this.lineHeight = 1.65,
    this.paragraphSpacing = 12,
    this.horizontalPadding = 24,
    this.themeMode = ReaderThemeMode.sepia,
    this.fontFamily = ReaderFontFamily.serif,
    this.totalReadSeconds = 0,
    this.lastReadAt,
    this.bookmarks = const [],
    this.notes = const [],
  });

  ReaderProgress copyWith({
    int? chapterIndex,
    double? scrollOffset,
    double? chapterProgress,
    double? fontSize,
    double? lineHeight,
    double? paragraphSpacing,
    double? horizontalPadding,
    ReaderThemeMode? themeMode,
    ReaderFontFamily? fontFamily,
    int? totalReadSeconds,
    DateTime? lastReadAt,
    List<ReaderBookmark>? bookmarks,
    List<ReaderNote>? notes,
  }) => ReaderProgress(
        chapterIndex: chapterIndex ?? this.chapterIndex,
        scrollOffset: scrollOffset ?? this.scrollOffset,
        chapterProgress: chapterProgress ?? this.chapterProgress,
        fontSize: fontSize ?? this.fontSize,
        lineHeight: lineHeight ?? this.lineHeight,
        paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
        horizontalPadding: horizontalPadding ?? this.horizontalPadding,
        themeMode: themeMode ?? this.themeMode,
        fontFamily: fontFamily ?? this.fontFamily,
        totalReadSeconds: totalReadSeconds ?? this.totalReadSeconds,
        lastReadAt: lastReadAt ?? this.lastReadAt,
        bookmarks: bookmarks ?? this.bookmarks,
        notes: notes ?? this.notes,
      );

  Map<String, dynamic> toJson() => {
        'chapterIndex': chapterIndex,
        'scrollOffset': scrollOffset,
        'chapterProgress': chapterProgress,
        'fontSize': fontSize,
        'lineHeight': lineHeight,
        'paragraphSpacing': paragraphSpacing,
        'horizontalPadding': horizontalPadding,
        'themeMode': themeMode.name,
        'fontFamily': fontFamily.name,
        'totalReadSeconds': totalReadSeconds,
        'lastReadAt': lastReadAt?.toIso8601String(),
        'bookmarks': bookmarks.map((e) => e.toJson()).toList(),
        'notes': notes.map((e) => e.toJson()).toList(),
      };

  factory ReaderProgress.fromJson(Map<String, dynamic> json) {
    T enumValue<T extends Enum>(List<T> values, Object? raw, T fallback) {
      return values.cast<T?>().firstWhere(
            (item) => item?.name == raw,
            orElse: () => fallback,
          ) ??
          fallback;
    }

    final bookmarkRaw = json['bookmarks'] as List<dynamic>? ?? const [];
    final noteRaw = json['notes'] as List<dynamic>? ?? const [];

    return ReaderProgress(
      chapterIndex: (json['chapterIndex'] as num?)?.toInt() ?? 0,
      scrollOffset: (json['scrollOffset'] as num?)?.toDouble() ?? 0,
      chapterProgress: (json['chapterProgress'] as num?)?.toDouble() ?? 0,
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 19,
      lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 1.65,
      paragraphSpacing: (json['paragraphSpacing'] as num?)?.toDouble() ?? 12,
      horizontalPadding: (json['horizontalPadding'] as num?)?.toDouble() ?? 24,
      themeMode: enumValue(ReaderThemeMode.values, json['themeMode'], ReaderThemeMode.sepia),
      fontFamily: enumValue(ReaderFontFamily.values, json['fontFamily'], ReaderFontFamily.serif),
      totalReadSeconds: (json['totalReadSeconds'] as num?)?.toInt() ?? 0,
      lastReadAt: DateTime.tryParse(json['lastReadAt'] as String? ?? ''),
      bookmarks: bookmarkRaw
          .whereType<Map>()
          .map((e) => ReaderBookmark.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      notes: noteRaw
          .whereType<Map>()
          .map((e) => ReaderNote.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../shared/models/book_series.dart';

class BookSeriesStorageService {
  static const String _boxName = 'book_series';

  static final ValueNotifier<List<BookSeries>> seriesNotifier =
      ValueNotifier<List<BookSeries>>([]);

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Map>(_boxName);
    }

    _refresh();
  }

  Box<Map> get _box => Hive.box<Map>(_boxName);

  List<BookSeries> getSeries() {
    final result = <BookSeries>[];

    for (final value in _box.values) {
      try {
        result.add(
          BookSeries.fromJson(
            Map<String, dynamic>.from(value),
          ),
        );
      } catch (_) {
        // Bozuk kayıt varsa uygulamayı çökertme.
      }
    }

    result.sort(
      (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
    );

    return result;
  }

  BookSeries? getSeriesById(String id) {
    final value = _box.get(id);

    if (value == null) return null;

    try {
      return BookSeries.fromJson(
        Map<String, dynamic>.from(value),
      );
    } catch (_) {
      return null;
    }
  }

  BookSeries? findSeriesForBook(String bookId) {
    for (final series in getSeries()) {
      if (series.bookIds.contains(bookId)) {
        return series;
      }
    }

    return null;
  }

  Future<void> saveSeries(BookSeries series) async {
    await _box.put(series.id, series.toJson());
    _refresh();
  }

  Future<void> createSeries({
    required String title,
    String? description,
    String? universeName,
    String? coverUrl,
  }) async {
    final now = DateTime.now();

    final series = BookSeries(
      id: 'series-${now.microsecondsSinceEpoch}',
      title: title.trim(),
      description: _nullableText(description),
      universeName: _nullableText(universeName),
      coverUrl: _nullableText(coverUrl),
      createdAt: now,
    );

    await saveSeries(series);
  }

  Future<void> deleteSeries(String seriesId) async {
    await _box.delete(seriesId);
    _refresh();
  }

  Future<void> addBookToSeries({
    required String seriesId,
    required String bookId,
  }) async {
    final series = getSeriesById(seriesId);
    if (series == null) return;

    final updatedBookIds = [...series.bookIds];

    if (!updatedBookIds.contains(bookId)) {
      updatedBookIds.add(bookId);
    }

    await saveSeries(
      series.copyWith(bookIds: updatedBookIds),
    );
  }

  Future<void> removeBookFromSeries({
    required String seriesId,
    required String bookId,
  }) async {
    final series = getSeriesById(seriesId);
    if (series == null) return;

    final updatedBookIds = [...series.bookIds]..remove(bookId);

    await saveSeries(
      series.copyWith(bookIds: updatedBookIds),
    );
  }

  Future<void> reorderBooks({
    required String seriesId,
    required List<String> orderedBookIds,
  }) async {
    final series = getSeriesById(seriesId);
    if (series == null) return;

    await saveSeries(
      series.copyWith(bookIds: orderedBookIds),
    );
  }

  Future<void> updateSeries({
    required BookSeries series,
    String? title,
    String? description,
    String? universeName,
    String? coverUrl,
    bool? isCompleted,
  }) async {
    final updated = series.copyWith(
      title: title?.trim() ?? series.title,
      description: description == null
          ? series.description
          : _nullableText(description),
      universeName: universeName == null
          ? series.universeName
          : _nullableText(universeName),
      coverUrl:
          coverUrl == null ? series.coverUrl : _nullableText(coverUrl),
      isCompleted: isCompleted ?? series.isCompleted,
    );

    await saveSeries(updated);
  }

  String? _nullableText(String? value) {
    final text = value?.trim() ?? '';
    return text.isEmpty ? null : text;
  }

  void _refresh() {
    seriesNotifier.value = getSeries();
  }
}
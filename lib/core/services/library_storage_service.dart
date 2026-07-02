import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../shared/models/book.dart';

class LibraryStorageService {
  static const String _boxName = 'user_library_books';

  static final ValueNotifier<List<Book>> booksNotifier =
      ValueNotifier<List<Book>>([]);

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_boxName);
    _refresh();
  }

  Box<Map> get _box => Hive.box<Map>(_boxName);

  Future<void> addBook(Book book) async {
    await _box.put(book.id, book.toJson());
    _refresh();
  }

  Future<void> removeBook(String bookId) async {
    await _box.delete(bookId);
    _refresh();
  }

  bool containsBook(String bookId) {
    return _box.containsKey(bookId);
  }

  List<Book> getBooks() {
    return _box.values
        .map((json) => Book.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<void> toggleBook(Book book) async {
    if (containsBook(book.id)) {
      await removeBook(book.id);
    } else {
      await addBook(book);
    }
  }

  void _refresh() {
    booksNotifier.value = getBooks();
  }
}
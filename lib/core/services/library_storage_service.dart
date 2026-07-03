import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../shared/models/book.dart';
import '../../shared/models/user_book.dart';

class LibraryStorageService {
  static const String _boxName = 'user_library_books';

  static final ValueNotifier<List<UserBook>> userBooksNotifier =
      ValueNotifier<List<UserBook>>([]);

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<Map>(_boxName);
    await _migrateOldBooksIfNeeded();
    _refresh();
  }

  Box<Map> get _box => Hive.box<Map>(_boxName);

  Future<void> addBook(Book book) async {
    final userBook = UserBook(
      id: book.id,
      book: book,
      status: UserBookStatus.wantToRead,
      addedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _box.put(book.id, _userBookToHiveJson(userBook));
    _refresh();
  }

  Future<void> removeBook(String bookId) async {
    await _box.delete(bookId);
    _refresh();
  }

  Future<void> toggleBook(Book book) async {
    if (containsBook(book.id)) {
      await removeBook(book.id);
    } else {
      await addBook(book);
    }
  }

  bool containsBook(String bookId) {
    return _box.containsKey(bookId);
  }

  List<UserBook> getUserBooks() {
    final result = <UserBook>[];

    for (final value in _box.values) {
      try {
        final json = Map<String, dynamic>.from(value);
        result.add(UserBook.fromJson(json));
      } catch (_) {
        // Bozuk kayıt varsa uygulamayı çökertme.
      }
    }

    return result;
  }

  List<Book> getBooks() {
    return getUserBooks().map((userBook) => userBook.book).toList();
  }

  Future<void> updateUserBook(UserBook userBook) async {
    final updated = userBook.copyWith(updatedAt: DateTime.now());

    await _box.put(updated.id, _userBookToHiveJson(updated));
    _refresh();
  }

  Future<void> _migrateOldBooksIfNeeded() async {
    final entries = _box.toMap();

    for (final entry in entries.entries) {
      try {
        final json = Map<String, dynamic>.from(entry.value);

        if (!json.containsKey('book')) {
          final book = Book.fromJson(json);
          final userBook = UserBook(
            id: book.id,
            book: book,
            status: UserBookStatus.wantToRead,
            addedAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await _box.put(entry.key, _userBookToHiveJson(userBook));
        }
      } catch (_) {
        await _box.delete(entry.key);
      }
    }
  }

  Map<String, dynamic> _userBookToHiveJson(UserBook userBook) {
    final json = userBook.toJson();
    json['book'] = userBook.book.toJson();
    return json;
  }

  void _refresh() {
    userBooksNotifier.value = getUserBooks();
  }
}
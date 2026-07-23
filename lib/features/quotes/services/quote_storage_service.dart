import 'package:hive/hive.dart';
import '../models/quote_entry.dart';

class QuoteStorageService {
  static const boxName = 'lorekeeper_quotes';
  static const _quotesKey = 'saved_quotes';

  Future<Box<dynamic>> _box() async => Hive.isBoxOpen(boxName) ? Hive.box<dynamic>(boxName) : Hive.openBox<dynamic>(boxName);

  Future<List<QuoteEntry>> getQuotes() async {
    final box = await _box();
    final raw = box.get(_quotesKey, defaultValue: const <dynamic>[]) as List;
    final quotes = raw.whereType<Map>().map(QuoteEntry.fromMap).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return quotes;
  }

  Future<void> saveQuote(QuoteEntry quote) async {
    final box = await _box();
    final quotes = await getQuotes();
    final updated = [quote, ...quotes.where((item) => item.id != quote.id)];
    await box.put(_quotesKey, updated.map((item) => item.toMap()).toList());
  }

  Future<void> deleteQuote(String id) async {
    final box = await _box();
    final quotes = await getQuotes();
    await box.put(_quotesKey, quotes.where((item) => item.id != id).map((item) => item.toMap()).toList());
  }
}

import 'package:flutter/material.dart';
import 'models/quote_entry.dart';
import 'quote_studio_screen.dart';
import 'services/quote_storage_service.dart';

class SavedQuotesScreen extends StatefulWidget {
  const SavedQuotesScreen({super.key});
  @override
  State<SavedQuotesScreen> createState() => _SavedQuotesScreenState();
}

class _SavedQuotesScreenState extends State<SavedQuotesScreen> {
  final QuoteStorageService _storage = QuoteStorageService();
  late Future<List<QuoteEntry>> _quotes;
  @override
  void initState() { super.initState(); _reload(); }
  void _reload() { _quotes = _storage.getQuotes(); }
  Future<void> _delete(String id) async { await _storage.deleteQuote(id); setState(_reload); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D1B),
      appBar: AppBar(backgroundColor: const Color(0xFF090D1B), foregroundColor: Colors.white, title: const Text('Alıntılarım')),
      body: FutureBuilder<List<QuoteEntry>>(
        future: _quotes,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          final quotes = snapshot.data ?? const [];
          if (quotes.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(32), child: Text('Henüz kaydedilmiş bir alıntın yok.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 16))));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: quotes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final quote = quotes[index];
              return Card(
                color: const Color(0xFF151C31),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text('“${quote.text}”', maxLines: 4, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, height: 1.4, fontFamily: 'Georgia')),
                  subtitle: Padding(padding: const EdgeInsets.only(top: 12), child: Text('${quote.bookTitle} · ${quote.author}', style: const TextStyle(color: Color(0xFFD6B56C)))),
                  trailing: IconButton(onPressed: () => _delete(quote.id), icon: const Icon(Icons.delete_outline, color: Colors.white54)),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => QuoteStudioScreen(quote: quote.text, bookTitle: quote.bookTitle, author: quote.author)));
                    if (mounted) setState(_reload);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lorekeeper/l10n/app_localizations.dart';

import 'core/services/library_storage_service.dart';
import 'core/services/reading_goal_service.dart';
import 'core/theme/app_theme.dart';
import 'features/main/main_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final libraryStorage = LibraryStorageService();
  await libraryStorage.init();

  final readingGoalService = ReadingGoalService();
  await readingGoalService.init();

  runApp(const LoreKeeperApp());
}

class LoreKeeperApp extends StatelessWidget {
  const LoreKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoreKeeper',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: const Locale('tr'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const MainShell(),
    );
  }
}
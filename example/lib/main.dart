import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/services/connection_settings_service.dart';
import 'l10n/app_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'presentation/screens/composed_screen.dart';

/// Notifier to reactively change the application locale from settings.
final appLocaleNotifier = ValueNotifier<Locale?>(null);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  final prefs = await SharedPreferences.getInstance();
  final settingsService = ConnectionSettingsService(prefs);
  final storedLocale = settingsService.localeCode;
  if (storedLocale != null && storedLocale.isNotEmpty) {
    appLocaleNotifier.value = Locale(storedLocale);
  }

  runApp(const MainApp());
}

/// The main entry point widget for the GenUI Playground application.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: appLocaleNotifier,
      builder: (context, locale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GenUI Playground',
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', ''), Locale('es', '')],
          theme: ThemeData.dark(useMaterial3: true).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1),
              brightness: Brightness.dark,
              primary: const Color(0xFF6366F1),
              secondary: const Color(0xFF06B6D4),
            ),
            scaffoldBackgroundColor: const Color(0xFF0B0F19),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0F172A),
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            cardTheme: const CardThemeData(
              color: Color(0xFF1E293B),
              elevation: 4,
              margin: EdgeInsets.zero,
            ),
          ),
          home: const ComposedScreen(),
        );
      },
    );
  }
}

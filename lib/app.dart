import 'dart:ui';

import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/pages/home/home.dart';
import 'package:basso_hoogerheide/pages/login.dart';
import 'package:basso_hoogerheide/pages/profile.dart';
import 'package:basso_hoogerheide/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class App extends StatelessWidget {
  const App({super.key});

  final AppTheme _appTheme = const AppTheme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: _appTheme.dark.colorScheme.primary,
      darkTheme: _appTheme.dark,
      debugShowCheckedModeBanner: false,
      home: SplashPage(
        // TODO: lógica de inicialização
        initialWork: () async {
          await _initializeLocale();
          return '/home';
        },
      ),
      restorationScopeId: 'basso_hoogerheide',
      routes: {
        '/login': (_) => LoginPage(),
        '/home': (_) => const HomePage(),
        '/profile': (_) => const ProfilePage(),
      },
      themeMode: ThemeMode.dark,
      title: 'Basso Hoogerheide',
    );
  }

  Future<void> _initializeLocale() {
    final String localeTag = PlatformDispatcher.instance.locale.toLanguageTag();
    Intl.defaultLocale = localeTag;
    return initializeDateFormatting(localeTag);
  }
}

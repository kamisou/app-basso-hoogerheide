import 'dart:convert';
import 'dart:ui';

import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/data_objects/app_config.dart';
import 'package:basso_hoogerheide/pages/home/folders/annotations.dart';
import 'package:basso_hoogerheide/pages/home/folders/new_folder.dart';
import 'package:basso_hoogerheide/pages/home/home.dart';
import 'package:basso_hoogerheide/pages/login.dart';
import 'package:basso_hoogerheide/pages/profile/profile.dart';
import 'package:basso_hoogerheide/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

late Provider<AppConfig> appConfigProvider;

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
          await _loadAppConfiguration();
          return '/login';
        },
      ),
      restorationScopeId: 'basso_hoogerheide',
      routes: {
        '/login': (_) => LoginPage(),
        '/home': (_) => const HomePage(),
        '/newFolder': (_) => const NewFolderPage(),
        '/annotations': (_) => const AnnotationsPage(),
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

  Future<void> _loadAppConfiguration() async {
    final folderFormData = await rootBundle
        .loadString('./assets/new_folder_form_data.json')
        .then((value) => json.decode(value));

    appConfigProvider = Provider(
      (ref) => AppConfig(
        newFormFieldData: folderFormData,
        newEventColors: [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow,
          Colors.pink,
          Colors.cyan,
          Colors.white,
          Colors.black,
        ],
      ),
    );
  }
}

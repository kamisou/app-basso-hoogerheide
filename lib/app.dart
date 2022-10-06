import 'dart:ui';

import 'package:basso_hoogerheide/constants/secure_storage_keys.dart';
import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/interface/local_notifications.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/interface/secure_storage.dart';
import 'package:basso_hoogerheide/models/repository/profile.dart';
import 'package:basso_hoogerheide/pages/home/calendar/new_event.dart';
import 'package:basso_hoogerheide/pages/home/contacts/new_contact.dart';
import 'package:basso_hoogerheide/pages/home/folders/annotations.dart';
import 'package:basso_hoogerheide/pages/home/folders/new_folder.dart';
import 'package:basso_hoogerheide/pages/home/home.dart';
import 'package:basso_hoogerheide/pages/login.dart';
import 'package:basso_hoogerheide/pages/profile/profile.dart';
import 'package:basso_hoogerheide/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class App extends ConsumerWidget {
  const App({super.key});

  final AppTheme _appTheme = const AppTheme();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      color: _appTheme.dark.colorScheme.primary,
      darkTheme: _appTheme.dark,
      debugShowCheckedModeBanner: false,
      home: SplashPage(
        initialWork: () async {
          Intl.defaultLocale =
              PlatformDispatcher.instance.locale.toLanguageTag();
          final bool isTokenValid = await _validateToken(ref);
          await ref.read(localNotificationsProvider).initialize();
          return isTokenValid ? '/home' : '/login';
        },
      ),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
      ],
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      restorationScopeId: 'basso_hoogerheide',
      routes: {
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomePage(),
        '/newEvent': (_) => const NewEventPage(),
        '/newContact': (_) => const NewContactPage(),
        '/newFolder': (_) => const NewFolderPage(),
        '/annotations': (_) => const AnnotationsPage(),
        '/profile': (_) => const ProfilePage(),
      },
      themeMode: ThemeMode.dark,
      title: 'Basso Hoogerheide',
    );
  }

  Future<bool> _validateToken(WidgetRef ref) async {
    final String? authToken = await ref
        .read(secureStorageProvider)
        .read(SecureStorageKey.authToken.key);
    ref.read(authTokenProvider.notifier).state = authToken;
    try {
      await ref.read(appUserProvider.future);
      return authToken != null;
    } on RestException {
      return false;
    }
  }
}

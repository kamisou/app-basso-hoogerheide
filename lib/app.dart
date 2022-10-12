import 'dart:ui';

import 'package:basso_hoogerheide/constants/configuration.dart';
import 'package:basso_hoogerheide/constants/secure_storage_keys.dart';
import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/interface/messaging.dart';
import 'package:basso_hoogerheide/interface/notifications.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/interface/secure_storage.dart';
import 'package:basso_hoogerheide/models/repository/profile.dart';
import 'package:basso_hoogerheide/pages/home/calendar/new_event.dart';
import 'package:basso_hoogerheide/pages/home/contacts/new_contact.dart';
import 'package:basso_hoogerheide/pages/home/folders/annotations.dart';
import 'package:basso_hoogerheide/pages/home/folders/folder_search.dart';
import 'package:basso_hoogerheide/pages/home/folders/new_folder.dart';
import 'package:basso_hoogerheide/pages/home/home.dart';
import 'package:basso_hoogerheide/pages/login.dart';
import 'package:basso_hoogerheide/pages/profile/profile.dart';
import 'package:basso_hoogerheide/pages/splash.dart';
import 'package:firebase_core/firebase_core.dart';
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
          await Firebase.initializeApp();
          await ref.read(notificationsProvider).initialize();
          final bool isTokenValid = await _validateToken(ref);
          return isTokenValid ? '/home' : '/login';
        },
        afterWork: (route) async {
          switch (route) {
            case '/home':
              await _initializeMessaging(ref);
              break;
            case '/login':
              await ref.read(messagingProvider).unsubscribeFromTopic(
                  ref.read(configurationProvider).calendarEventsMessagingTopic);
              break;
          }
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
        '/folderSearch': (_) => const FolderSearchPage(),
        '/annotations': (_) => const AnnotationsPage(),
        '/profile': (_) => const ProfilePage(),
      },
      themeMode: ThemeMode.dark,
      title: 'Basso Hoogerheide',
    );
  }

  Future<bool> _validateToken(WidgetRef ref) async {
    final String? authToken =
        await ref.read(secureStorageProvider).read(SecureStorageKey.authToken);
    if (authToken == null) return false;
    ref.read(authTokenProvider.notifier).state = authToken;
    try {
      await ref.read(appUserProvider.future);
      return true;
    } on RestException {
      return false;
    }
  }

  Future<void> _initializeMessaging(WidgetRef ref) async {
    final Messaging messaging = ref.read(messagingProvider);
    final bool isAuthorized = await messaging.initialize();
    if (isAuthorized) {
      messaging.subscribeToTopic(
        ref.read(configurationProvider).calendarEventsMessagingTopic,
      );
    }
  }
}

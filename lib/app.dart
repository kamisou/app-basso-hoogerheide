import 'dart:ui';

import 'package:basso_hoogerheide/constants/configuration.dart';
import 'package:basso_hoogerheide/constants/secure_storage_keys.dart';
import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/interface/messaging.dart';
import 'package:basso_hoogerheide/interface/notifications.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/interface/secure_storage.dart';
import 'package:basso_hoogerheide/pages/home/calendar/new_event.dart';
import 'package:basso_hoogerheide/pages/home/contacts/new_contact.dart';
import 'package:basso_hoogerheide/pages/home/folders/annotations.dart';
import 'package:basso_hoogerheide/pages/home/folders/folder_search.dart';
import 'package:basso_hoogerheide/pages/home/folders/new_folder.dart';
import 'package:basso_hoogerheide/pages/home/home.dart';
import 'package:basso_hoogerheide/pages/login.dart';
import 'package:basso_hoogerheide/pages/profile/profile.dart';
import 'package:basso_hoogerheide/pages/splash.dart';
import 'package:basso_hoogerheide/repositories/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final AppTheme _appTheme = const AppTheme();

  @override
  Widget build(BuildContext context) {
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
          final bool isTokenValid = await _validateToken();
          return isTokenValid ? '/home' : '/login';
        },
        afterWork: (route) async {
          switch (route) {
            case '/home':
              await _initializeMessaging();
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

  Future<bool> _validateToken() async {
    final String? authToken =
        await ref.read(secureStorageProvider).read(SecureStorageKey.authToken);
    if (authToken == null) return false;
    ref.read(authTokenProvider.notifier).state = authToken;
    try {
      await ref.read(appUserProvider.future);
      return true;
    } on RestException {
      ref.read(messagingProvider).unsubscribeFromTopic(
            ref.read(configurationProvider).calendarEventsMessagingTopic,
          );
      return false;
    }
  }

  Future<void> _initializeMessaging() async {
    final Messaging messaging = ref.read(messagingProvider);
    final bool isAuthorized = await messaging.initialize();
    if (isAuthorized) {
      messaging.subscribeToTopic(
        ref.read(configurationProvider).calendarEventsMessagingTopic,
      );
    }
  }
}

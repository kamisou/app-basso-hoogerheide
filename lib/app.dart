import 'dart:ui';

import 'package:basso_hoogerheide/constants/routes.dart';
import 'package:basso_hoogerheide/constants/secure_storage_keys.dart';
import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/interface/message_handlers/event_message_handler.dart';
import 'package:basso_hoogerheide/interface/messaging.dart';
import 'package:basso_hoogerheide/interface/notifications.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/interface/secure_storage.dart';
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
        initialWork: _initialWork,
        afterWork: _afterWork,
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
      routes: appRoutes,
      themeMode: ThemeMode.dark,
      title: 'Basso Hoogerheide',
    );
  }

  Future<String> _initialWork() async {
    Intl.defaultLocale = PlatformDispatcher.instance.locale.toLanguageTag();

    await Firebase.initializeApp();
    await ref.read(notificationsProvider).initialize();

    final bool isTokenValid = await _validateToken();
    return isTokenValid ? '/home' : '/login';
  }

  Future<void> _afterWork(String route) async {
    switch (route) {
      case '/home':
        await _initializeMessaging();
        break;
    }
  }

  Future<bool> _validateToken() async {
    final SecureStorage secureStorage = ref.read(secureStorageProvider);

    final String? authToken =
        await secureStorage.read(SecureStorageKey.authToken);
    if (authToken == null) return false;
    ref.read(authTokenProvider.notifier).state = authToken;

    try {
      await ref.read(appUserProvider.future);
      return true;
    } on RestException {
      ref.read(messagingProvider).unsubscribeFromTopic('events');
      return false;
    }
  }

  Future<void> _initializeMessaging() async {
    final Messaging messaging = ref.read(messagingProvider);
    final bool isAuthorized = await messaging.initialize();
    if (isAuthorized) {
      messaging.subscribeToTopic(
        'events',
        ref.read(eventMessageHandlerProvider),
      );
    }
  }
}

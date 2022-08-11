import 'package:basso_hoogerheide/constants/app_configuration.dart';
import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/controllers/profile.dart';
import 'package:basso_hoogerheide/interfaces/encrypted_storage.dart';
import 'package:basso_hoogerheide/pages/home.dart';
import 'package:basso_hoogerheide/pages/login.dart';
import 'package:basso_hoogerheide/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          final encryptedStorage = ref.read(storageProvider);
          final config = ref.read(appConfigProvider);
          await encryptedStorage.initialize();

          final token = encryptedStorage.read(config.sessionTokenStorageKey);
          if (token != null) {
            final profile = ref.read(profileProvider);
            profile.getUser();
            return '/home';
          }

          return '/login';
        },
      ),
      restorationScopeId: 'basso_hoogerheide',
      routes: {
        '/login': (_) => LoginPage(),
        '/home': (_) => const HomePage(),
      },
      themeMode: ThemeMode.dark,
      title: 'Basso Hoogerheide',
    );
  }
}

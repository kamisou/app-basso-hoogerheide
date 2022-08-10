import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/interface/encrypted_storage.dart';
import 'package:basso_hoogerheide/pages/home.dart';
import 'package:basso_hoogerheide/pages/login.dart';
import 'package:basso_hoogerheide/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      color: appDarkThemeData.colorScheme.primary,
      darkTheme: appDarkThemeData,
      debugShowCheckedModeBanner: false,
      home: SplashPage(
        initialWork: () async {
          final encryptedStorage = ref.read(encryptedStorageProvider);
          final token = await encryptedStorage.read('session_token');
          return token != null ? '/home' : '/login';
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

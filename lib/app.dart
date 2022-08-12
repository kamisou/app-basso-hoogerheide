import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:basso_hoogerheide/pages/home.dart';
import 'package:basso_hoogerheide/pages/login.dart';
import 'package:basso_hoogerheide/pages/splash.dart';
import 'package:flutter/material.dart';

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
        initialWork: () async => '/home',
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

import 'package:basso_hoogerheide/constants/theme_data.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: appDarkThemeData.colorScheme.primary,
      darkTheme: appDarkThemeData,
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'basso_hoogerheide',
      themeMode: ThemeMode.dark,
      title: 'Basso Hoogerheide',
    );
  }
}

import 'package:flutter/material.dart';

class App extends StatelessWidget {
  static const Color _appColor = Color(0xFFA81818);

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      color: _appColor,
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'basso_hoogerheide',
      themeMode: ThemeMode.dark,
      title: 'Basso Hoogerheide',
    );
  }
}
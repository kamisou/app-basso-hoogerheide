import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.initialWork,
  });

  /// Work to be executed while the splash screen is shown.
  /// Should return the route to be redirected to after finished.
  final Future<String> Function() initialWork;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.initialWork().then(
          (route) => Navigator.pushReplacementNamed(context, route),
        );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

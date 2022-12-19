import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
    required this.initialWork,
    this.afterWork,
  });

  /// Work to be executed while the splash screen is shown.
  /// Should return the route to be redirected to after finished.
  final Future<String> Function() initialWork;

  /// Work to be executed after the user was redirected to the page
  /// returned from initialWork. This can be used to perform work
  /// after the user goes to the home screen for example.
  final Future<void> Function(String)? afterWork;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.initialWork().then((route) {
      Navigator.pushReplacementNamed(context, route);
      widget.afterWork?.call(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/icons/logo.svg'),
              const SizedBox(height: 32),
              const LinearProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class QuickSnackbar {
  const QuickSnackbar({
    required this.content,
    this.duration = const Duration(seconds: 4),
  });

  final Widget content;

  final Duration duration;

  ScaffoldFeatureController show(BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: content,
          duration: duration,
        ),
      );
}

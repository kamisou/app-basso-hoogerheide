import 'package:flutter/material.dart';

class ErrorSnackbar<E extends Object?> {
  const ErrorSnackbar({
    required this.content,
  });

  final Widget Function(BuildContext, E) content;

  void show(BuildContext context, Object? error) {
    if (error is! E) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: content(context, error)),
    );
  }
}

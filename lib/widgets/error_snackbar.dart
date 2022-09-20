import 'package:flutter/material.dart';

class ErrorSnackbar {
  const ErrorSnackbar({
    required this.contents,
  });

  final Map<Type, Widget Function(BuildContext, Object)> contents;

  void show(BuildContext context, Object error) {
    if (!contents.containsKey(error.runtimeType)) throw error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: contents[error.runtimeType]!(context, error)),
    );
  }
}

import 'package:flutter/material.dart';

class ErrorSnackbar {
  const ErrorSnackbar({
    required this.context,
    required this.error,
  });

  final BuildContext context;

  final Object error;

  void on<E>({required ErrorContent Function(E) content}) {
    if (error is! E) return;
    final ErrorContent errorContent = content(error as E);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(
                errorContent.message ?? 'Ocorreu um erro inesperado.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Icon(
              errorContent.icon,
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorContent<E> {
  const ErrorContent({
    this.message,
    this.icon = Icons.error_outlined,
  });

  final String? message;

  final IconData icon;
}

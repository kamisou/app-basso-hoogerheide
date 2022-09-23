import 'package:flutter/material.dart';

class LoadingSnackbar {
  const LoadingSnackbar({
    required this.contentBuilder,
    this.errorBuilder,
    this.finishedBuilder,
  });

  final WidgetBuilder contentBuilder;

  final Function(BuildContext, Object)? errorBuilder;

  final WidgetBuilder? finishedBuilder;

  void show(BuildContext context, Future future) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(minutes: 5),
        dismissDirection: DismissDirection.none,
        padding: EdgeInsets.zero,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: contentBuilder(context),
            ),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(4),
                ),
              ),
              child: const LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
    future.then(
      (_) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        if (finishedBuilder != null) {
          return ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: finishedBuilder!(context)),
          );
        }
      },
      onError: errorBuilder != null
          ? (error) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: errorBuilder!(context, error)),
              )
          : null,
    );
  }
}

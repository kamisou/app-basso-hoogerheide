import 'package:flutter/material.dart';

class LoadingSnackbar {
  LoadingSnackbar({
    required this.content,
    this.onError,
    this.onFinished,
  });

  final WidgetBuilder content;

  final WidgetBuilder? onError;

  final WidgetBuilder? onFinished;

  ScaffoldFeatureController? _scaffoldFeatureController;

  void show(BuildContext context, Stream<double> progress) {
    _scaffoldFeatureController = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(minutes: 5),
        dismissDirection: DismissDirection.none,
        padding: EdgeInsets.zero,
        content: StreamBuilder<double>(
          stream: progress,
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: content(context),
                ),
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(4),
                    ),
                  ),
                  child: LinearProgressIndicator(value: snapshot.data),
                ),
              ],
            );
          },
        ),
      ),
    );
    progress.last.then(
      (_) {
        _scaffoldFeatureController?.close();

        if (onFinished != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: onFinished!(context)),
          );
        }
      },
      onError: (_) {
        _scaffoldFeatureController?.close();
        if (onError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: onError!(context)),
          );
        }
      },
    );
  }
}

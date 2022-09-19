import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoadingSnackbar {
  LoadingSnackbar({
    required this.contentBuilder,
    this.errorBuilder,
    this.finishedBuilder,
  });

  final WidgetBuilder contentBuilder;

  final WidgetBuilder? errorBuilder;

  final WidgetBuilder? finishedBuilder;

  ScaffoldFeatureController? _scaffoldFeatureController;

  void show(BuildContext context, Future future) {
    _scaffoldFeatureController = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(minutes: 5),
        dismissDirection: DismissDirection.none,
        padding: EdgeInsets.zero,
        content: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _scaffoldFeatureController?.close();
              if (snapshot.hasError) {
                if (errorBuilder != null) {
                  SchedulerBinding.instance.addPostFrameCallback(
                    (_) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: errorBuilder!(context)),
                    ),
                  );
                }
              } else {
                if (finishedBuilder != null) {
                  SchedulerBinding.instance.addPostFrameCallback(
                    (_) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: finishedBuilder!(context)),
                    ),
                  );
                }
              }
            }
            return Column(
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
            );
          },
        ),
      ),
    );
  }
}

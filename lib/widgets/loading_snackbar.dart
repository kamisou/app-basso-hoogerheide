import 'package:flutter/material.dart';

class LoadingSnackbar<T extends ProgressStream> {
  LoadingSnackbar({
    required this.contentBuilder,
    this.errorBuilder,
    this.finishedBuilder,
  });

  final WidgetBuilder contentBuilder;

  final WidgetBuilder? errorBuilder;

  final WidgetBuilder? finishedBuilder;

  ScaffoldFeatureController? _scaffoldFeatureController;

  void show(BuildContext context, T upload) {
    _scaffoldFeatureController = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(minutes: 5),
        dismissDirection: DismissDirection.none,
        padding: EdgeInsets.zero,
        content: StreamBuilder<double>(
          stream: upload.progress,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              _scaffoldFeatureController?.close();
              if (snapshot.hasError) {
                if (errorBuilder != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: errorBuilder!(context)),
                  );
                }
              } else {
                if (finishedBuilder != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: finishedBuilder!(context)),
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
                  child: LinearProgressIndicator(value: snapshot.data),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

abstract class ProgressStream {
  const ProgressStream(this.progress);

  final Stream<double> progress;
}

class FileUploadProgressStream extends ProgressStream {
  const FileUploadProgressStream(
    super.progress, {
    required this.fileName,
  });

  final String fileName;
}

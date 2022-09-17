import 'package:basso_hoogerheide/models/input/downloadable_file.dart';

class ModelCategory {
  const ModelCategory({
    required this.title,
    this.models = const [],
  });

  ModelCategory.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        models = (json['models'] as List? ?? [])
            .cast<Map<String, dynamic>>()
            .map(DownloadableFile.fromJson)
            .toList();

  final String title;

  final List<DownloadableFile> models;
}

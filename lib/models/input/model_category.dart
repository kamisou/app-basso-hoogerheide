import 'package:basso_hoogerheide/models/input/downloadable_file.dart';

class ModelCategory {
  ModelCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        models = (json['models'] as List? ?? [])
            .cast<Map<String, dynamic>>()
            .map(DownloadableFile.fromJson)
            .toList();

  final int id;

  final String title;

  final List<DownloadableFile> models;
}

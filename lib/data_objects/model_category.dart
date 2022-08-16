import 'package:basso_hoogerheide/data_objects/downloadable_file.dart';

class ModelCategory {
  const ModelCategory({
    required this.title,
    required this.models,
  });

  final String title;

  final List<DownloadableFile> models;
}

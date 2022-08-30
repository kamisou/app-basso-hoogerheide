import 'package:basso_hoogerheide/data_objects/input/downloadable_file.dart';

class ModelCategory {
  const ModelCategory({
    required this.title,
    this.models = const [],
  });

  final String title;

  final List<DownloadableFile> models;
}

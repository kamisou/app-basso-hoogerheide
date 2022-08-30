import 'package:basso_hoogerheide/data_objects/input/downloadable_file.dart';

class FoldersController {
  const FoldersController();

  // TODO: salvar nova pasta
  Future<void> addFolder(Map<String, dynamic> folder) async {}

  // TODO: adicionar anotação
  Future<void> addAnnotation(String? annotation) async {}

  // TODO: deletar arquivo da pasta
  Future<void> deleteFolderFile(DownloadableFile file) async {}

  String? validateAnnotation(String? annotation) {
    if (annotation?.isEmpty ?? true) {
      return 'Selecione uma opção';
    }
    return null;
  }
}

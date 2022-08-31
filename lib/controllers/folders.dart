import 'package:basso_hoogerheide/data_objects/input/downloadable_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final foldersControllerProvider =
    Provider.autoDispose((ref) => const FoldersController());

class FoldersController {
  const FoldersController();

  // TODO: salvar nova pasta
  Future<void> addFolder(Map<String, dynamic> folder) async {}

  // TODO: adicionar anotação
  Future<void> addAnnotation(String? annotation) async {}

  // TODO: deletar arquivo da pasta
  Future<void> deleteFolderFile(DownloadableFile file) async {}

  String? validateAnnotation(String? value) =>
      (value?.isEmpty ?? true) ? 'Informe um valor para a anotação' : null;
}

import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final foldersRepositoryProvider =
    Provider.autoDispose((ref) => const FoldersRepository());

class FoldersRepository {
  const FoldersRepository();

  // TODO: buscar id de nova pasta real
  Future<int> getNewFolderId() =>
      Future.delayed(const Duration(seconds: 2), () => 1501);

  // TODO: salvar nova pasta
  Future<void> addFolder(Map<String, dynamic> folder) async {}

  // TODO: adicionar anotação
  Future<void> addAnnotation(String? annotation) async {}

  // TODO: deletar arquivo da pasta
  Future<void> deleteFolderFile(DownloadableFile file) async {}
}

import 'dart:developer';

import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final foldersRepositoryProvider =
    Provider.autoDispose((ref) => const FoldersRepository());

final annotationOptionsProvider = Provider.autoDispose(
  (ref) => ref.read(foldersRepositoryProvider).getNewAnnotationOptions(),
);

class FoldersRepository {
  const FoldersRepository();

  // TODO: buscar id de nova pasta real
  Future<int> getNewFolderId() {
    log('getNewFolderId');
    return Future.delayed(const Duration(seconds: 2), () => 1501);
  }

  // TODO: buscar opções de anotação
  Future<List<String>> getNewAnnotationOptions() {
    log('getNewAnnotationOptions');
    return Future.delayed(
      const Duration(seconds: 1),
      () => [
        'Atendimento inicial',
        'Petição Inicial',
        'Audiência',
      ],
    );
  }

  // TODO: salvar nova pasta
  Future<void> addFolder(Map<String, dynamic> folder) async => log('addFolder');

  // TODO: adicionar anotação
  Future<void> addAnnotation(String? annotation) async => log('addAnnotation');

  // TODO: deletar arquivo da pasta
  Future<void> deleteFolderFile(DownloadableFile file) async =>
      log('deleteFolderFile');
}

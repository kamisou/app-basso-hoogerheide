import 'dart:convert';
import 'dart:developer';

import 'package:basso_hoogerheide/extensions.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:basso_hoogerheide/models/input/folder/folder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final foldersRepositoryProvider = Provider.autoDispose(FoldersRepository.new);

final foldersProvider = FutureProvider(
  (ref) => ref.read(foldersRepositoryProvider).getFolders(),
);

final annotationOptionsProvider = Provider.autoDispose(
  (ref) => ref.read(foldersRepositoryProvider).getNewAnnotationOptions(),
);

class FoldersRepository {
  const FoldersRepository(this.ref);

  final Ref ref;

  Future<List<Folder>> getFolders() =>
      ref.read(restClientProvider).get('/folders').then((value) => json
          .decodeList<Map<String, dynamic>>(value)
          .map(Folder.fromJson)
          .toList());

  Future<int> getNewFolderId() => ref
      .read(restClientProvider)
      .get('/folders/new_id')
      .then((value) => json.decode(value)['new_id']);

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

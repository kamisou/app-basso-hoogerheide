import 'dart:convert';

import 'package:basso_hoogerheide/extensions.dart';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:basso_hoogerheide/models/input/folder/folder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final foldersRepositoryProvider = Provider.autoDispose(FoldersRepository.new);

final foldersFilterProvider = StateProvider.autoDispose<String?>((ref) => null);

final foldersProvider = FutureProvider(
  (ref) => ref.read(foldersRepositoryProvider).getFolders(),
);

final filteredFoldersProvider = FutureProvider.autoDispose((ref) {
  final String? filter = ref.watch(foldersFilterProvider);
  final Future<List<Folder>> folders = ref.watch(foldersProvider.future);
  return folders.then((value) {
    if (filter?.isNotEmpty ?? false) {
      final regex = RegExp(filter!, caseSensitive: false);
      return value
          .where(
            (e) => e.name.contains(regex) || e.id.toString().contains(regex),
          )
          .toList();
    }
    return value;
  });
});

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

  Future<List<String>> getNewAnnotationOptions() => ref
      .read(restClientProvider)
      .get('/folders/annotations')
      .then((value) => json.decodeList<String>(value).toList());

  Future<void> addFolder(Map<String, dynamic> folder) => ref
      .read(restClientProvider)
      .post('/folders/add', body: folder)
      .then((_) => ref.refresh(foldersProvider));

  Future<void> addAnnotation(Map<String, dynamic>? annotation) async {
    if (annotation == null) return;
    await ref
        .read(restClientProvider)
        .post('/folders/annotations/add', body: annotation);
  }

  Future<void> deleteFolderFile(DownloadableFile file) =>
      ref.read(restClientProvider).delete('/folders/files/delete');
}

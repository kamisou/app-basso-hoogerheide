import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/folder/folder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final foldersRepositoryProvider = Provider.autoDispose(FoldersRepository.new);

final foldersProvider = FutureProvider.autoDispose(
  (ref) => ref.read(foldersRepositoryProvider).getFolders(),
);

final searchTermProvider = StateProvider.autoDispose((ref) => '');

final searchFoldersProvider = FutureProvider.autoDispose(
  (ref) => ref
      .read(foldersRepositoryProvider)
      .getFolders(searchTerm: ref.watch(searchTermProvider)),
);

final annotationOptionsProvider = FutureProvider.autoDispose(
  (ref) => ref.read(foldersRepositoryProvider).getNewAnnotationOptions(),
);

final folderFormData = FutureProvider.autoDispose(
  (ref) => ref.read(foldersRepositoryProvider).getNewFolderFormData(),
);

class FoldersRepository {
  static const int _foldersPageSize = 20;

  const FoldersRepository(this.ref);

  final Ref ref;

  Future<List<Folder>> getFolders({int? afterPage, String? searchTerm}) => ref
      .read(restClientProvider)
      .get(
        '/folders?page_size=$_foldersPageSize'
        '${afterPage != null ? '&page_after=$afterPage' : ''}'
        '${searchTerm != null ? '&q=$searchTerm' : ''}',
      )
      .then((value) => (value['folders'] as List? ?? [])
          .cast<Map<String, dynamic>>()
          .map(Folder.fromJson)
          .toList());

  Future<List<String>> getNewAnnotationOptions() => ref
      .read(restClientProvider)
      .get('/folders/annotations')
      .then((value) => (value['annotations'] as List? ?? []).cast<String>());

  Future<void> addFolder(Map<String, dynamic> folder) => ref
      .read(restClientProvider)
      .post('/folders/add', body: folder)
      .then((_) => ref.refresh(foldersProvider));

  Future<void> addAnnotation(
    int folderId,
    Map<String, dynamic>? annotation,
  ) async {
    if (annotation == null) return;
    await ref
        .read(restClientProvider)
        .post('/folders/$folderId/annotations/add', body: annotation)
        .then((_) => ref.refresh(foldersProvider));
  }

  Future<void> deleteFolderFile(int folderId, String fileName) =>
      ref.read(restClientProvider).delete('/folders/files/delete', body: {
        'folder_id': folderId,
        'file_name': fileName,
      }).then((_) => ref.refresh(foldersProvider));

  Future<Map<String, dynamic>> getNewFolderFormData() => ref
      .read(restClientProvider)
      .get('/folders/form_data')
      .then((value) => value as Map<String, dynamic>);
}

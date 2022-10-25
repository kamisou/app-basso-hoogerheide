import 'dart:io';

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

final folderFormData = FutureProvider.autoDispose.family(
  (Ref ref, int? folderId) =>
      ref.read(foldersRepositoryProvider).getNewFolderFormData(folderId),
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

  Future<void> addFolder(Map<String, dynamic> folder) => ref
      .read(restClientProvider)
      .post('/folders/add', body: folder)
      .then((_) => ref.refresh(foldersProvider));

  Future<void> addFolderFile(int folderId, File file) =>
      ref.read(restClientProvider).uploadImage(
        'POST',
        '/folders/add_file',
        field: 'new_file',
        file: file,
        fields: {'folder_id': folderId.toString()},
      ).then((_) => ref.refresh(foldersProvider));

  Future<void> addAnnotation(int folderId, String? annotation) async {
    if (annotation == null) return;
    await ref.read(restClientProvider).post('/folders/add_annotation', body: {
      'annotation': annotation,
      'folder_id': folderId
    }).then((_) => ref.refresh(foldersProvider));
  }

  Future<void> deleteFolderFile(int folderId, String fileName) =>
      ref.read(restClientProvider).delete('/folders/files/delete', body: {
        'folder_id': folderId,
        'file_name': fileName,
      }).then((_) => ref.refresh(foldersProvider));

  Future<void> deleteAnnotation(int annotationId) =>
      ref.read(restClientProvider).delete(
        '/folders/annotations/delete',
        body: {'annotation_id': annotationId},
      ).then((_) => ref.refresh(foldersProvider));

  Future<void> deleteFolder(Folder folder) =>
      ref.read(restClientProvider).delete(
        '/folders/delete',
        body: {'id': folder.id},
      ).then((_) => ref.refresh(foldersProvider));

  Future<Map<String, dynamic>> getNewFolderFormData([int? folderId]) => ref
      .read(restClientProvider)
      .get('/folders/form_data/${folderId ?? ''}')
      .then((value) => value as Map<String, dynamic>);
}

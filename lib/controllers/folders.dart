import 'dart:io';

import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/folder/folder.dart';
import 'package:basso_hoogerheide/repositories/folders.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final foldersControllerProvider = Provider.autoDispose(FoldersController.new);

class FoldersController {
  const FoldersController(this.ref);

  final Ref ref;

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
}

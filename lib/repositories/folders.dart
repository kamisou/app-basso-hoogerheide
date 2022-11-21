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

  Future<Map<String, dynamic>> getNewFolderFormData([int? folderId]) => ref
      .read(restClientProvider)
      .get('/folders/form_data/${folderId ?? ''}')
      .then((value) => value as Map<String, dynamic>);
}

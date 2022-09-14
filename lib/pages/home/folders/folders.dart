import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/folder/folder.dart';
import 'package:basso_hoogerheide/models/repository/folders.dart';
import 'package:basso_hoogerheide/pages/home/folders/folder_card.dart';
import 'package:basso_hoogerheide/widgets/collection.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:basso_hoogerheide/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoldersPage extends ConsumerStatefulWidget {
  const FoldersPage({super.key});

  @override
  ConsumerState<FoldersPage> createState() => _FoldersPageState();
}

class _FoldersPageState extends ConsumerState<FoldersPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'folder_fab',
        child: const Icon(Icons.person_add),
        onPressed: () => ref
            .read(foldersRepositoryProvider)
            .getNewFolderId()
            .then((id) => Navigator.pushNamed(
                  context,
                  '/newFolder',
                  // TODO: pessoa física e jurídica
                  arguments: {'new_id': id, 'folder_type': 'person'},
                )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SearchBar(
              hintText: 'N° da pasta, cliente, procurador, CPF...',
              // TODO: atualizar filtro da lista de pastas
              onChanged: (value) {},
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ref.watch(foldersProvider).when(
                  data: (data) => Collection<Folder>(
                    collection: data,
                    itemBuilder: (_, item) => FolderCard(
                      folder: item,
                      onDeleteFolderFile:
                          ref.read(foldersRepositoryProvider).deleteFolderFile,
                    ),
                    emptyWidget: const EmptyCard(
                      icon: Icons.folder_off_outlined,
                      message: 'Nenhuma pasta encontrada',
                    ),
                  ),
                  error: (_, __) => const EmptyCard(
                    icon: Icons.error,
                    message: 'Houve um erro ao buscar as pastas',
                  ),
                  loading: () => Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(20),
                    child: const CircularProgressIndicator(),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

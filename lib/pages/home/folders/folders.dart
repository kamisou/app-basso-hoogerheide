import 'package:basso_hoogerheide/models/input/folder/folder.dart';
import 'package:basso_hoogerheide/models/repository/contacts.dart';
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
            .getNewFolderFormData()
            .then((data) => Navigator.pushNamed(
                  context,
                  '/newFolder',
                  arguments: {'form_data': data},
                )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SearchBar(
              hintText: 'N° da pasta, cliente, procurador, CPF...',
              onChanged: (value) =>
                  ref.read(contactsFilterProvider.notifier).state = value,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: AsyncCollection<Folder>(
              asyncCollection: ref.watch(filteredFoldersProvider),
              itemBuilder: (_, folder) => FolderCard(
                folder: folder,
                onDeleteFolderFile: (file) => ref
                    .read(foldersRepositoryProvider)
                    .deleteFolderFile(folder.id, file.id),
              ),
              errorWidget: (_) => const EmptyCard(
                icon: Icons.error,
                message: 'Houve um erro ao buscar as pastas',
              ),
              emptyWidget: const EmptyCard(
                icon: Icons.folder_off_outlined,
                message: 'Nenhuma pasta encontrada',
              ),
              loadingWidget: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(20),
                child: const CircularProgressIndicator(),
              ),
              onRefresh: () {
                ref.refresh(foldersProvider);
                return ref.read(foldersProvider.future);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:basso_hoogerheide/models/input/folder/folder.dart';
import 'package:basso_hoogerheide/pages/home/folders/folder_card.dart';
import 'package:basso_hoogerheide/repositories/folders.dart';
import 'package:basso_hoogerheide/widgets/async_collection.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:basso_hoogerheide/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FolderSearchPage extends ConsumerStatefulWidget {
  const FolderSearchPage({super.key});

  @override
  ConsumerState<FolderSearchPage> createState() => _FolderSearchPageState();
}

class _FolderSearchPageState extends ConsumerState<FolderSearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool hasSearchTerm = ref.watch(searchTermProvider).isNotEmpty;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SearchBar(
                      autofocus: true,
                      controller: _controller,
                      hintText: 'N° da pasta, cliente, procurador, CPF...',
                      onEditingComplete: () {
                        ref.read(searchTermProvider.notifier).state =
                            _controller.text;
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AsyncCollection<Folder>(
                asyncCollection: hasSearchTerm
                    ? ref.watch(searchFoldersProvider)
                    : const AsyncData([]),
                itemBuilder: (context, folder) => FolderCard(folder: folder),
                errorWidget: (_) => const EmptyCard(
                  icon: Icons.error,
                  message: 'Houve um erro ao buscar as pastas',
                ),
                emptyWidget: hasSearchTerm
                    ? const EmptyCard(
                        icon: Icons.folder_off_outlined,
                        message: 'Nenhuma pasta encontrada',
                      )
                    : const SizedBox.shrink(),
                loadingWidget: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(20),
                  child: const CircularProgressIndicator(),
                ),
                onReachingEnd: (finishFetching, reachEnd) async {
                  final folders = ref.read(searchFoldersProvider).value!;
                  final newFolders =
                      await ref.read(foldersRepositoryProvider).getFolders(
                            afterPage: folders.last.id,
                            searchTerm: ref.read(searchTermProvider),
                          );
                  folders.addAll(newFolders);
                  finishFetching();
                  if (newFolders.isEmpty) reachEnd();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

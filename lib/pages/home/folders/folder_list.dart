import 'package:basso_hoogerheide/data_objects/folder/folder.dart';
import 'package:basso_hoogerheide/pages/home/folders/folder_card.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:flutter/material.dart';

class FolderList extends StatelessWidget {
  const FolderList({
    super.key,
    required this.folders,
  });

  final List<Folder> folders;

  @override
  Widget build(BuildContext context) {
    return folders.isNotEmpty
        ? ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: folders.length,
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FolderCard(folder: folders[index]),
            ),
          )
        : const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: EmptyCard(
              icon: Icons.folder_off_outlined,
              message: 'Nenhuma pasta encontrada',
            ),
          );
  }
}

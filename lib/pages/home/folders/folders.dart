import 'dart:convert';

import 'package:basso_hoogerheide/data_objects/folder/folder.dart';
import 'package:basso_hoogerheide/pages/home/folders/folder_card.dart';
import 'package:basso_hoogerheide/widgets/base_page_body.dart';
import 'package:basso_hoogerheide/widgets/collection.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:basso_hoogerheide/widgets/search_bar.dart';
import 'package:flutter/material.dart';

class FoldersPage extends HomePageBody {
  const FoldersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar(
            hintText: 'N° da pasta, cliente, procurador, CPF...',
            // TODO: atualizar lista de pastas
            onChanged: (value) {},
          ),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: Collection<Folder>(
            // TODO: utilizar dados de pasta
            collection: const [],
            itemBuilder: (_, item) => FolderCard(folder: item),
            emptyWidget: const EmptyCard(
              icon: Icons.folder_off_outlined,
              message: 'Nenhuma pasta encontrada',
            ),
          ),
        ),
      ],
    );
  }

  @override
  void Function(BuildContext)? get fabAction =>
      (context) => DefaultAssetBundle.of(context)
          .loadString('assets/new_folder_form_data.json')
          .then((value) => Navigator.pushNamed(
                context,
                '/newFolder',
                arguments: {
                  // TODO: utilizar id de nova pasta
                  'new_id': 1501,
                  'folder_type': 'person',
                  'new_folder_form_data': json.decode(value),
                },
              ));

  @override
  String get title => 'Clientes';
}

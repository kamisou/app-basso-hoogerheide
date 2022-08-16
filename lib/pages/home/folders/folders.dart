import 'package:basso_hoogerheide/pages/home/folders/folder_list.dart';
import 'package:basso_hoogerheide/widgets/base_page_body.dart';
import 'package:basso_hoogerheide/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';

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
        const Expanded(child: FolderList(folders: [])),
      ],
    );
  }

  @override
  // TODO: adicionar pasta
  VoidCallback? get fabAction => () {};

  @override
  String get title => 'Clientes';
}

import 'package:basso_hoogerheide/data_objects/downloadable_file.dart';
import 'package:basso_hoogerheide/data_objects/model_category.dart';
import 'package:basso_hoogerheide/widgets/base_page_body.dart';
import 'package:basso_hoogerheide/widgets/collection.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:flutter/material.dart';

class ModelsPage extends HomePageBody {
  const ModelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Collection<ModelCategory>(
      collection: const [
        ModelCategory(
          title: 'Previdenciário',
          models: [
            DownloadableFile(
              title: 'Título do documento',
              url: 'https://google.com',
            ),
            DownloadableFile(
              title: 'Título do documento 2',
              url: 'https://google.com.br',
            ),
          ],
        ),
      ],
      itemBuilder: (_, item) => const SizedBox(height: 30),
      emptyWidget: const EmptyCard(
        icon: Icons.file_download_off_outlined,
        message: 'Nenhum modelo encontrado',
      ),
    );
  }

  @override
  VoidCallback? get fabAction => null;

  @override
  String get title => 'Modelos';
}

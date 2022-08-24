import 'package:basso_hoogerheide/data_objects/model_category.dart';
import 'package:basso_hoogerheide/pages/home/models/model_card.dart';
import 'package:basso_hoogerheide/widgets/base_page_body.dart';
import 'package:basso_hoogerheide/widgets/collection.dart';
import 'package:basso_hoogerheide/widgets/empty_card.dart';
import 'package:flutter/material.dart';

class ModelsPage extends HomePageBody {
  const ModelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Collection<ModelCategory>(
      // TODO: utilizar dados de modelos
      collection: const [],
      itemBuilder: (_, item) => ModelCard(modelCategory: item),
      emptyWidget: const EmptyCard(
        icon: Icons.file_download_off_outlined,
        message: 'Nenhum modelo encontrado',
      ),
    );
  }

  @override
  void Function(BuildContext)? get fabAction => null;

  @override
  String get title => 'Modelos';
}

import 'dart:io';

import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/model_category.dart';
import 'package:basso_hoogerheide/repositories/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final modelsControllerProvider = Provider.autoDispose(ModelsController.new);

class ModelsController {
  const ModelsController(this.ref);

  final Ref ref;

  Future<void> deleteModel(ModelCategory category, String fileName) =>
      ref.read(restClientProvider).delete(
        '/models/categories/files/delete',
        body: {'category': category.title, 'file_name': fileName},
      ).then((_) => ref.refresh(modelCategoriesProvider));

  Future<void> uploadModelFile(ModelCategory category, File file) => ref
      .read(restClientProvider)
      .uploadImage('POST', '/models/${category.title}/add_file',
          field: 'model_file', file: file)
      .then((_) => ref.refresh(modelCategoriesProvider));
}

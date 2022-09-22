import 'dart:io';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/model_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final modelsRepositoryProvider =
    Provider.autoDispose(ModelsRepositoryProvider.new);

final modelCategoriesProvider = FutureProvider.autoDispose(
  (ref) => ref.read(modelsRepositoryProvider).getModelCategories(),
);

class ModelsRepositoryProvider {
  const ModelsRepositoryProvider(this.ref);

  final Ref ref;

  Future<List<ModelCategory>> getModelCategories() => ref
      .read(restClientProvider)
      .get('/models/categories')
      .then((value) => (value['categories'] as List? ?? [])
          .cast<Map<String, dynamic>>()
          .map(ModelCategory.fromJson)
          .toList());

  Future<void> deleteModel(int categoryId, int fileId) => ref
      .read(restClientProvider)
      .delete('/models/categories/$categoryId/files/$fileId/delete')
      .then((_) => ref.refresh(modelsRepositoryProvider));

  Future<void> uploadModelFile(int categoryId, File file) => ref
      .read(restClientProvider)
      .uploadImage('PUT', '/models/categories/$categoryId/files/new',
          field: 'model_file', file: file)
      .then((_) => ref.refresh(modelCategoriesProvider));
}

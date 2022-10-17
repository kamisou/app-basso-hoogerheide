import 'dart:io';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/model_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final modelsRepositoryProvider = Provider.autoDispose(ModelsRepository.new);

final modelCategoriesProvider = FutureProvider.autoDispose(
  (ref) => ref.read(modelsRepositoryProvider).getModelCategories(),
);

class ModelsRepository {
  const ModelsRepository(this.ref);

  final Ref ref;

  Future<List<ModelCategory>> getModelCategories() => ref
      .read(restClientProvider)
      .get('/models/categories')
      .then((value) => (value['categories'] as List? ?? [])
          .cast<Map<String, dynamic>>()
          .map(ModelCategory.fromJson)
          .toList());

  Future<void> deleteModel(int categoryId, String fileName) =>
      ref.read(restClientProvider).delete(
        '/models/categories/files/delete',
        body: {'category_id': categoryId, 'file_name': fileName},
      ).then((_) => ref.refresh(modelsRepositoryProvider));

  Future<void> uploadModelFile(int categoryId, File file) => ref
      .read(restClientProvider)
      .upload('POST', '/models/categories/$categoryId/files/new',
          field: 'model_file', file: file)
      .then((_) => ref.refresh(modelCategoriesProvider));
}

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
}

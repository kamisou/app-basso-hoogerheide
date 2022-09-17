import 'dart:developer';
import 'dart:io';
import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:basso_hoogerheide/models/input/model_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final modelsRepositoryProvider =
    Provider.autoDispose(ModelsRepositoryProvider.new);

final modelsProvider = FutureProvider.autoDispose(
  (ref) => ref.read(modelsRepositoryProvider).getModels(),
);

class ModelsRepositoryProvider {
  const ModelsRepositoryProvider(this.ref);

  final Ref ref;

  Future<List<ModelCategory>> getModels() => ref
      .read(restClientProvider)
      .get('/models')
      .then((value) => (value['categories'] as List? ?? [])
          .cast<Map<String, dynamic>>()
          .map(ModelCategory.fromJson)
          .toList());

  Future<void> deleteModel(DownloadableFile file) => ref
      .read(restClientProvider)
      .delete('/models/delete', body: {'file_id': file.id});

  // TODO: fazer upload real do arquivo
  Future<void> uploadModelFile(File file) async => log('uploadModelFile');
}

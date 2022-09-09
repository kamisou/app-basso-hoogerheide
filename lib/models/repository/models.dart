import 'dart:developer';
import 'dart:io';
import 'package:basso_hoogerheide/interface/uploader.dart';
import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:basso_hoogerheide/models/input/model_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final modelsRepositoryProvider = Provider.autoDispose(
  (ref) => ModelsRepositoryProvider(
    fileUploader: ref.read(fileUploaderProvider),
  ),
);

final modelsProvider = FutureProvider.autoDispose(
  (ref) => ref.read(modelsRepositoryProvider).getModels(),
);

class ModelsRepositoryProvider {
  const ModelsRepositoryProvider({
    required this.fileUploader,
  });

  final FileUploader fileUploader;

  // TODO: buscar modelos reais
  Future<List<ModelCategory>> getModels() async {
    log('getModels');
    return Future.delayed(
      const Duration(seconds: 2),
      () => [
        ModelCategory(
          title: 'Categoria 1',
          models: [
            DownloadableFile(
              title: 'Modelo 1',
              url: 'https://google.com',
              previewUrl: 'https://picsum.photos/200',
              uploadTimestamp: DateTime.now(),
            ),
            DownloadableFile(
              title: 'Modelo 2',
              url: 'https://google.com',
              previewUrl: 'https://picsum.photos/201',
              uploadTimestamp: DateTime.now(),
            ),
          ],
        ),
      ],
    );
  }

  // TODO: deletar modelo
  Future<void> deleteModel(DownloadableFile file) async => log('deleteModel');

  // TODO: fazer upload real do arquivo
  Future<void> uploadModelFile(File file) async => log('uploadModelFile');
}

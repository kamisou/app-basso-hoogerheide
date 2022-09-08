import 'dart:developer';
import 'dart:io';

import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:basso_hoogerheide/interface/uploader.dart';
import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:basso_hoogerheide/models/input/model_category.dart';
import 'package:basso_hoogerheide/widgets/loading_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final modelsRepositoryProvider = Provider.autoDispose(
  (ref) => ModelsRepositoryProvider(
    filePicker: ref.read(filePickerProvider),
    fileUploader: ref.read(fileUploaderProvider),
  ),
);

final modelsProvider = FutureProvider.autoDispose(
  (ref) => ref.read(modelsRepositoryProvider).getModels(),
);

class ModelsRepositoryProvider {
  const ModelsRepositoryProvider({
    required this.filePicker,
    required this.fileUploader,
  });

  final FilePicker filePicker;

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
  Future<FileUploadProgressStream?> uploadModelFile() async {
    log('uploadModelFile');
    final List<File>? result = await filePicker.pickFiles(
      dialogTitle: 'Selecione um arquivo para o modelo:',
      withReadStream: true,
    );
    if (result == null) return null;

    return FileUploadProgressStream(
      fileUploader.upload(result.first),
      fileName: result.first.path.split('/').last,
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:basso_hoogerheide/interface/file_picker.dart';
import 'package:basso_hoogerheide/interface/uploader.dart';
import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:basso_hoogerheide/widgets/loading_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final modelsRepositoryProvider = Provider.autoDispose(
  (ref) => ModelsRepositoryProvider(
    filePicker: ref.read(filePickerProvider),
    fileUploader: ref.read(fileUploaderProvider),
  ),
);

class ModelsRepositoryProvider {
  const ModelsRepositoryProvider({
    required this.filePicker,
    required this.fileUploader,
  });

  final FilePicker filePicker;

  final FileUploader fileUploader;

  // TODO: deletar modelo
  Future<void> deleteModel(DownloadableFile file) async => log('deleteModel');

  // TODO: fazer upload real do arquivo
  Future<FileUploadProgressStream?> uploadModelFile() async {
    log('pickAndUploadModelFile');
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

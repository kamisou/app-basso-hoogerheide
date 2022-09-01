import 'dart:io';

import 'package:basso_hoogerheide/interface/uploader.dart';
import 'package:basso_hoogerheide/models/input/downloadable_file.dart';
import 'package:basso_hoogerheide/models/output/picked_model_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final modelsRepositoryProvider =
    Provider((ref) => const ModelsRepositoryProvider());

class ModelsRepositoryProvider {
  const ModelsRepositoryProvider();

  // TODO: deletar modelo
  Future<void> deleteModel(DownloadableFile file) async {}

  // TODO: fazer upload real do arquivo
  Future<PickedModelData?> pickAndUploadModelFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Selecione um arquivo:',
      withReadStream: true,
    );
    if (result == null) return null;

    final File file = File(result.files.first.path!);

    return PickedModelData(
      title: file.path.split('/').last,
      stream: const MockUploader().upload(file).asBroadcastStream(),
    );
  }
}

import 'dart:io';

import 'package:basso_hoogerheide/data_objects/input/downloadable_file.dart';
import 'package:basso_hoogerheide/interface/uploader.dart';
import 'package:basso_hoogerheide/pages/home/models/models.dart';
import 'package:file_picker/file_picker.dart';

class ModelsController {
  const ModelsController();

  // TODO: deletar documento dos modelos
  Future<void> deleteModel(DownloadableFile file) async {}

  Future<File?> pickModelFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Selecione um arquivo:',
      withReadStream: true,
    );
    if (result == null) return null;
    return File(result.files.first.path!);
  }

  Future<PickedModelData?> uploadModelFile(File? file) async {
    if (file == null) return null;

    return PickedModelData(
      title: file.path.split('/').last,
      // TODO: substituir com uploader real
      stream: MockUploader().upload(file).asBroadcastStream(),
    );
  }
}

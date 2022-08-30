import 'dart:io';

import 'package:basso_hoogerheide/data_objects/input/downloadable_file.dart';
import 'package:basso_hoogerheide/interface/uploader.dart';
import 'package:basso_hoogerheide/pages/home/models/models.dart';
import 'package:file_picker/file_picker.dart';

class ModelsController {
  const ModelsController();

  // TODO: substituir com uploader real
  final Uploader _uploader = const MockUploader();

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
      stream: _uploader.upload(file).asBroadcastStream(),
    );
  }
}

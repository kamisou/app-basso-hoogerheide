import 'dart:io';

import 'package:basso_hoogerheide/data_objects/input/downloadable_file.dart';
import 'package:basso_hoogerheide/data_objects/output/picked_model_data.dart';
import 'package:basso_hoogerheide/interface/uploader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final modelsControllerProvider =
    Provider.autoDispose((ref) => const ModelsController());

class ModelsController {
  const ModelsController();

  // TODO: substituir com uploader real
  final Uploader _uploader = const MockUploader();

  // TODO: deletar documento dos modelos
  Future<void> deleteModel(DownloadableFile file) async {}

  Future<PickedModelData?> pickAndUploadModelFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Selecione um arquivo:',
      withReadStream: true,
    );
    if (result == null) return null;

    final file = File(result.files.first.path!);

    return PickedModelData(
      title: file.path.split('/').last,
      stream: _uploader.upload(file).asBroadcastStream(),
    );
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart' as fp;

class FilePicker {
  Future<List<File>?> pickFiles({
    String? dialogTitle,
    bool? allowMultiple,
  }) async {
    final fp.FilePickerResult? result = await fp.FilePicker.platform.pickFiles(
      dialogTitle: dialogTitle,
      allowMultiple: allowMultiple ?? false,
    );
    if (result == null) return null;
    return result.files.map((e) => File(e.path!)).toList();
  }
}

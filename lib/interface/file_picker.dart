import 'dart:io';

import 'package:file_picker/file_picker.dart' as fp;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filePickerProvider =
    Provider.autoDispose<FilePicker>((ref) => const FilePicker());

class FilePicker {
  const FilePicker();

  Future<List<File>?> pickFiles({
    String? dialogTitle,
    bool allowMultiple = false,
  }) async {
    final fp.FilePickerResult? result = await fp.FilePicker.platform.pickFiles(
      dialogTitle: dialogTitle,
      allowMultiple: allowMultiple,
    );
    if (result == null) return null;
    return result.files.map((e) => File(e.path!)).toList();
  }
}

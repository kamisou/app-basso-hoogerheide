import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: usar uploader de arquivos real
final fileUploaderProvider =
    Provider.autoDispose<FileUploader>((ref) => const MockUploader());

abstract class FileUploader {
  const FileUploader();

  Stream<double> upload(File file);
}

class MockUploader extends FileUploader {
  const MockUploader();

  @override
  Stream<double> upload(File file) async* {
    final Stream<List<int>> fileStream = file.openRead();

    final int totalSize = file.statSync().size;
    int totalProcessed = 0;
    await for (final bytes in fileStream) {
      await Future.delayed(const Duration(milliseconds: 2000));
      totalProcessed += bytes.length;
      yield totalProcessed / totalSize;
    }
  }
}

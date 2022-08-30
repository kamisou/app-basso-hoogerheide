import 'dart:io';

abstract class Uploader {
  const Uploader();

  Stream<double> upload(File file);
}

class MockUploader extends Uploader {
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

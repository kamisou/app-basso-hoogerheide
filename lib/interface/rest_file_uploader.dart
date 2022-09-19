import 'dart:io';

import 'package:basso_hoogerheide/interface/rest_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: usar uploader de arquivos real
final restFileUploaderProvider = Provider.autoDispose<RestFileUploader>(
  (ref) => RestFileUploader(ref.watch(restClientProvider)),
);

class RestFileUploader {
  const RestFileUploader(this.restClient);

  final RestClient restClient;

  Future<dynamic> upload(
    String method,
    String endpoint,
    File file,
  ) async {
    final String fileExtension =
        file.path.substring(file.path.lastIndexOf('.'));

    final Stream<List<int>> fileStream = file.openRead();

    return restClient.post(
      endpoint,
      headers: {
        'Content-Type': 'image/$fileExtension',
        'Content-Length': file.statSync().size,
        'Content-Encoding': 'gzip',
      },
      body: await fileStream.transform(gzip.encoder).single,
    );
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:basso_hoogerheide/constants/configuration.dart';
import 'package:basso_hoogerheide/constants/secure_storage_keys.dart';
import 'package:basso_hoogerheide/interface/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restClientProvider = Provider.autoDispose(
  (ref) {
    final String? authToken = ref.watch(authTokenProvider).value;
    final Map<String, String>? headers =
        authToken != null ? {'Authorization': 'Bearer $authToken'} : null;
    return RestClient(
      host: ref.watch(configurationProvider).restServerUrl,
      defaultHeaders: headers,
    );
  },
);

final authTokenProvider = FutureProvider((ref) =>
    ref.watch(secureStorageProvider).read(SecureStorageKey.authToken.key));

class RestClient {
  const RestClient({
    required this.host,
    this.defaultHeaders,
  });

  final String host;

  final Map<String, Object>? defaultHeaders;

  Future<dynamic> get(
    String endpoint, {
    Object? body,
    Map<String, Object?>? headers,
  }) =>
      _request(
        'GET',
        Uri.parse('$host$endpoint'),
        body: body,
        headers: headers,
      );

  Future<dynamic> post(
    String endpoint, {
    Object? body,
    Map<String, Object?>? headers,
  }) =>
      _request(
        'POST',
        Uri.parse('$host$endpoint'),
        body: body,
        headers: headers,
      );

  Future<dynamic> put(
    String endpoint, {
    Object? body,
    Map<String, Object?>? headers,
  }) =>
      _request(
        'PUT',
        Uri.parse('$host$endpoint'),
        body: body,
        headers: headers,
      );

  Future<dynamic> delete(
    String endpoint, {
    Object? body,
    Map<String, Object?>? headers,
  }) =>
      _request(
        'DELETE',
        Uri.parse('$host$endpoint'),
        body: body,
        headers: headers,
      );

  Future<dynamic> uploadImage(
    String method,
    String endpoint,
    File file,
  ) async {
    final String fileExtension =
        file.path.substring(file.path.lastIndexOf('.') + 1);

    final Stream<List<int>> fileStream = file.openRead();

    return _request(
      method,
      Uri.parse('$host$endpoint'),
      body: await fileStream.transform(gzip.encoder).single,
      headers: {
        'Content-Type': 'image/$fileExtension',
        'Content-Length': file.statSync().size,
        'Content-Encoding': 'gzip',
      },
    );
  }

  Future<dynamic> _request(
    String method,
    Uri url, {
    Object? body,
    Map<String, Object?>? headers,
  }) async {
    final HttpClient client = HttpClient();
    final HttpClientRequest request = await client.openUrl(method, url);

    defaultHeaders?.forEach((key, value) {
      request.headers.add(key, value);
    });
    headers?.forEach((key, value) {
      if (value != null) {
        request.headers.add(key, value);
      }
    });

    if (body != null) request.write(body);

    log('$method ${url.path}');
    final HttpClientResponse response = await request.close();

    if (response.statusCode > 399) {
      String? serverMessage;
      try {
        serverMessage = await response
            .transform(utf8.decoder)
            .join()
            .then(json.decode)
            .then((value) => value['message']);
      } on Object {
        serverMessage = null;
      }

      throw RestException(
        statusCode: response.statusCode,
        reasonPhrase: response.reasonPhrase,
        serverMessage: serverMessage,
      );
    }
    final String data = await response.transform(utf8.decoder).join();
    return data.isEmpty ? null : json.decode(data);
  }
}

class RestException {
  const RestException({
    required this.statusCode,
    required this.reasonPhrase,
    this.serverMessage,
  });

  final int statusCode;

  final String reasonPhrase;

  final String? serverMessage;
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:basso_hoogerheide/constants/secure_storage_keys.dart';
import 'package:basso_hoogerheide/interface/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restClientProvider = Provider.autoDispose<RestClient>(
  (ref) {
    final String? authToken = ref.watch(authTokenProvider).value;
    // TODO: apontar para servidor rest real
    return RestClient(
      host: '',
      defaultHeaders: authToken != null
          ? {
              'Authorization': 'Bearer $authToken',
            }
          : null,
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

  Future<Object> _request(
    String method,
    Uri url, {
    Object? body,
    Map<String, Object?>? headers,
  }) async {
    final HttpClient client = HttpClient();
    final HttpClientRequest request = await client.openUrl(method, url);

    if (body != null) request.write(body);

    defaultHeaders?.forEach((key, value) {
      request.headers.add(key, value);
    });
    headers?.forEach((key, value) {
      if (value != null) {
        request.headers.add(key, value);
      }
    });

    log('$method ${url.path}');
    final HttpClientResponse response = await request.close();

    if (response.statusCode > 399) {
      final String statusMessage =
          await response.transform(utf8.decoder).join();
      throw HttpException(statusMessage);
    }
    return response.single;
  }
}

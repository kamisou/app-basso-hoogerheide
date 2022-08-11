import 'dart:convert';
import 'dart:io';

import 'package:basso_hoogerheide/constants/app_configuration.dart';
import 'package:basso_hoogerheide/interfaces/encrypted_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restProvider = Provider((ref) {
  final config = ref.read(appConfigProvider);
  final storage = ref.watch(storageProvider);

  return RestApi(
    config.restApiServer,
    storage.read(config.sessionTokenStorageKey),
  );
});

class RestApi {
  RestApi(String server, String? token)
      : _server = server,
        _token = token;

  final String _server;

  final String? _token;

  final HttpClient _client = HttpClient();

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
  }) async {
    final response = await _makeRequest(endpoint, query: query, body: body);
    switch (response.statusCode) {
      case HttpStatus.ok:
        {
          final responseBody = await response.transform(utf8.decoder).join();
          final jsonBody = json.decode(responseBody);
          return jsonBody;
        }
      default:
        final statusMessage = await response.transform(utf8.decoder).join();
        throw statusMessage;
    }
  }

  Future<List<Map<String, dynamic>>> getList(
    String endpoint, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
  }) async {
    final response = await _makeRequest(endpoint, query: query, body: body);

    switch (response.statusCode) {
      case HttpStatus.ok:
        {
          final responseBody = await response.transform(utf8.decoder).join();
          final jsonBody = json.decode(responseBody);
          final listBody =
              (jsonBody as List? ?? []).cast<Map<String, dynamic>>();
          return listBody;
        }
      case HttpStatus.noContent:
        return [];
      default:
        final statusMessage = await response.transform(utf8.decoder).join();
        throw statusMessage;
    }
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final response = await _makeRequest(endpoint, body: body);

    if (response.statusCode != HttpStatus.ok) {
      final statusMessage = await response.transform(utf8.decoder).join();
      throw statusMessage;
    }

    return await response.transform(utf8.decoder).join();
  }

  Future<HttpClientResponse> _makeRequest(
    String endpoint, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('$_server$endpoint${_parsedQueryParams(query)}');
    final request = await _client.openUrl('GET', url);
    request.headers.set('Accept', 'application/json');

    if (_token != null) {
      request.headers.set('Authorization', 'Bearer $_token');
    }
    if (body != null) {
      request.headers.contentType = ContentType.json;
      request.write(endpoint);
    }
    return request.close();
  }

  String _parsedQueryParams(Map<String, dynamic>? query) {
    if (query?.isEmpty ?? true) return '';

    bool isNotFirst = false;
    String queryString = '?';
    query!.entries.map((e) {
      if (isNotFirst) queryString += '&';
      queryString += '${e.key}=${e.value}';
      isNotFirst = true;
    });

    return queryString;
  }
}

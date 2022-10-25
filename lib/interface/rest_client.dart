import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:basso_hoogerheide/constants/configuration.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final authTokenProvider = StateProvider<String?>((ref) => null);

final restClientProvider = Provider.autoDispose(
  (ref) {
    final String? authToken = ref.watch(authTokenProvider);
    return RestClient(
      host: ref.watch(configurationProvider).restServerUrl,
      defaultHeaders: {
        'Accept': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken'
      },
    );
  },
);

class RestClient {
  const RestClient({
    required this.host,
    this.defaultHeaders,
  });

  final String host;

  final Map<String, String>? defaultHeaders;

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) =>
      _request(
        'GET',
        Uri.parse('$host$endpoint'),
        body: body,
        headers: headers,
      );

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) =>
      _request(
        'POST',
        Uri.parse('$host$endpoint'),
        body: body,
        headers: headers,
      );

  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) =>
      _request(
        'PUT',
        Uri.parse('$host$endpoint'),
        body: body,
        headers: headers,
      );

  Future<dynamic> delete(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) =>
      _request(
        'DELETE',
        Uri.parse('$host$endpoint'),
        body: body,
        headers: headers,
      );

  Future<dynamic> uploadImage(
    String method,
    String endpoint, {
    required String field,
    required File file,
    Map<String, String>? fields,
  }) async {
    final request = http.MultipartRequest(method, Uri.parse('$host$endpoint'));
    request.files.add(
      http.MultipartFile.fromBytes(
        field,
        file.readAsBytesSync(),
        filename: file.path.substring(file.path.lastIndexOf('/') + 1),
      ),
    );
    if (fields != null) {
      request.fields.addAll(fields);
    }
    if (defaultHeaders != null) {
      request.headers.addAll(defaultHeaders!);
    }
    return request.send().then(_handleResponse);
  }

  Future<dynamic> _request(
    String method,
    Uri url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final request = http.Request(method, url);

    if (defaultHeaders != null) {
      request.headers.addAll(defaultHeaders!);
    }
    if (headers != null) {
      request.headers.addAll(headers);
    }

    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = json.encode(body);
    }

    log('$method ${url.path} ${request.headers['Authorization']}');

    final http.StreamedResponse response;
    try {
      response = await request.send();
    } on SocketException {
      rethrow;
    }

    return _handleResponse(response);
  }

  Future<dynamic> _handleResponse(http.StreamedResponse response) async {
    if (response.statusCode > 399) {
      String? serverMessage;
      try {
        serverMessage = await response.stream
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
    final String data = await response.stream.transform(utf8.decoder).join();
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

  final String? reasonPhrase;

  final String? serverMessage;
}

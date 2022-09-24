import 'dart:developer';
import 'dart:io';

import 'package:basso_hoogerheide/constants/configuration.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authTokenProvider = StateProvider<String?>((ref) => null);

final restClientProvider = Provider.autoDispose(
  (ref) {
    final String? authToken = ref.watch(authTokenProvider);
    return RestClient(
      baseUrl: ref.watch(configurationProvider).restServerUrl,
      defaultHeaders: {
        'Accept': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken'
      },
    );
  },
);

class RestClient {
  RestClient({
    required String baseUrl,
    Map<String, dynamic>? defaultHeaders,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: defaultHeaders,
          ),
        )..interceptors.add(
            InterceptorsWrapper(
              onRequest: (requestOptions, handler) {
                log(
                  '${requestOptions.method} ${requestOptions.path}\n'
                  'Query ${requestOptions.queryParameters}\n',
                );
                return handler.next(requestOptions);
              },
              onResponse: (response, handler) {
                log('${response.realUri} ${response.statusCode} ${response.statusMessage}\n');
                return handler.next(response);
              },
              onError: (dioError, handler) {
                log('${dioError.requestOptions.path} ${dioError.type}: ${dioError.message}');
                return handler.next(dioError);
              },
            ),
          );

  final Dio _dio;

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) =>
      _request(
        'GET',
        endpoint,
        body: body,
        query: query,
        headers: headers,
      );

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) =>
      _request(
        'POST',
        endpoint,
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
        endpoint,
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
        endpoint,
        body: body,
        headers: headers,
      );

  Future<dynamic> uploadImage(
    String method,
    String endpoint, {
    required String field,
    required File file,
  }) async {
    final FormData formData = FormData.fromMap({
      field: MultipartFile.fromBytes(
        file.readAsBytesSync(),
        filename: file.path.substring(file.path.lastIndexOf('/') + 1),
      )
    });
    try {
      final Response response = await _dio.request(
        endpoint,
        data: formData,
        options: Options(method: method),
      );
      return _handleResponse(response);
    } on Exception {
      throw const SocketException('Falha ao realizar pedido HTTP');
    }
  }

  Future<dynamic> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final Response response = await _dio.request(
        endpoint,
        queryParameters: query,
        data: body,
        options: Options(
          method: method,
          headers: headers,
          contentType: 'application/json',
        ),
      );
      return _handleResponse(response);
    } on Exception {
      throw const SocketException('Falha ao realizar pedido HTTP');
    }
  }

  Future<dynamic> _handleResponse(Response response) async {
    if (response.statusCode! > 399) {
      String? serverMessage;
      try {
        serverMessage = await response.data['message'];
      } on Object {
        serverMessage = null;
      }
      throw RestException(
        statusCode: response.statusCode!,
        reasonPhrase: response.statusMessage,
        serverMessage: serverMessage,
      );
    }
    return response.data;
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

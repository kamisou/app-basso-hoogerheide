import 'dart:convert';
import 'dart:io';

class RestClient {
  const RestClient({
    required this.host,
  });

  final String host;

  Future<dynamic> get(String endpoint, {Object? body}) =>
      _request('GET', Uri.parse('$host$endpoint'), body: body);

  Future<dynamic> post(String endpoint, {Object? body}) =>
      _request('POST', Uri.parse('$host$endpoint'), body: body);

  Future<dynamic> _request(String method, Uri url, {Object? body}) async {
    final HttpClient client = HttpClient();
    final HttpClientRequest request = await client.openUrl(method, url);

    if (body != null) request.write(body);
    final HttpClientResponse response = await request.close();

    if (response.statusCode > 399) {
      final String statusMessage =
          await response.transform(utf8.decoder).join();
      throw HttpException(statusMessage);
    }
    return response.single;
  }
}

import 'dart:_http';
import 'dart:convert';

import 'package:http/http.dart' as http;

typedef R JsonConverter<R>(Map<String, dynamic> json);

class ApiClient<R> {
  final String apiBase = "https://sheltered-scrubland-23764.herokuapp.com";
  final JsonConverter<R> converter;

  ApiClient(this.converter);

  Future<R> post(String path, Map<String, dynamic> body) async {
    final uri = Uri.http(apiBase, path, body);
    final response = await http.post(uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json'
      },
      body: body
    );
    return converter(jsonDecode(response.body));
  }
}

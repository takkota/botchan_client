import 'dart:convert';

import 'package:http/http.dart' as http;

typedef R JsonConverter<R>(Map<String, dynamic> json);
typedef R OnError<R>(int statusCode);

class ApiClient<R> {
  final String apiBase = "sheltered-scrubland-23764.herokuapp.com";
  final JsonConverter<R> converter;

  ApiClient(this.converter);

  Future<R> post(String path, Map<String, dynamic> body, {OnError onError}) async {
    final uri = Uri.https(apiBase, path);
    final response = await http.post(uri,
        headers: {
          'Content-type' : 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body)
    );
    // ErrorHandling
    if (response.statusCode != 200) {
      if (onError != null) {
        onError(response.statusCode);
      }
      print("statusCode: $path " + response.statusCode.toString());
      return null;
    }
    return converter(jsonDecode(response.body));
  }
}

import 'dart:io';

import 'package:botchan_client/routes.dart';
import 'package:botchan_client/utility/shared_preferences_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:dio/dio.dart';

void main() async {
  final injector = Injector.getInjector("default");
  final dio = new Dio(
    Options()
        ..baseUrl = "https://sheltered-scrubland-23764.herokuapp.com"
        ..connectTimeout = 5000
        ..receiveTimeout = 4000
  );
  dio.interceptor.request.onSend = (request) {
    print("[HTTP Resuest] data is:" + request.data.toString());
    return request;
  };
  dio.interceptor.response.onSuccess = (Response response) {
    print("[SUCCESS HTTP] response is:" + response.toString());
    return response;
  };
  dio.interceptor.response.onError = (DioError error) {
    print("[ERROR HTTP] response is:" + error.message);
    return error;
  };
  injector.map<Dio>((i) => dio, isSingleton: true);

  Routes();
}

Future<String> get userId async {
   final userId = await SharedPreferencesHelper.getUserId();
   if (userId != null) {
     return userId;
   } else {
     final userId = Uuid().v4();
     SharedPreferencesHelper.setUserId(userId);
     return userId;
   }
}

Dio get dio => Injector.getInjector("default").get<Dio>();

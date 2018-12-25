import 'package:botchan_client/routes.dart';
import 'package:botchan_client/utility/shared_preferences_helper.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:dio/dio.dart';

void main() {
  final injector = Injector.getInjector("default");
  final dio = new Dio(
    Options()
        ..baseUrl = "https://sheltered-scrubland-23764.herokuapp.com"
        ..connectTimeout = 5000
        ..receiveTimeout = 4000
  );
  dio.interceptor.response.onSuccess = (Response response) {
    print("[SUCCESS HTTP] response is:" + response.toString());
  };
  dio.interceptor.response.onError = (DioError error) {
    print("[ERROR HTTP] response is:" + error.response.toString());
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

import 'package:botchan_client/routes.dart';
import 'package:botchan_client/utility/shared_preferences_helper.dart';
import 'package:uuid/uuid.dart';

void main() {
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

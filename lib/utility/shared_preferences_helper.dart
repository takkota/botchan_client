import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }

  static Future setUserId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userId", value);
  }

  static Future<bool> isAccountLinked() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isAccountLinked") ?? false;
  }

  static Future setAccountLinked(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isAccountLinked", value);
  }
}

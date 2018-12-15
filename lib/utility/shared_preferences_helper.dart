import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  static Future<bool> isAccountLinked() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isAccountLinked") ?? true;
  }

  static Future setAccountLinked(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isAccountLinked", value);
  }
}

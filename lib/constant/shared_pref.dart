import 'package:shared_preferences/shared_preferences.dart';

const String tokenDevice = "";

class SharedPrefs {
  static SharedPreferences? preferences;
  static SharedPrefs instance = SharedPrefs.ctor();

  factory SharedPrefs() {
    return instance;
  }
  SharedPrefs.ctor();

  static Future<SharedPreferences> init() async {
    return preferences = await SharedPreferences.getInstance();
  }

  static Future<Future<bool>> write(String? key, dynamic value) async =>
      preferences!.setString(key!, "$value");

  static String read(String? key) => preferences!.getString(key ?? "") ?? "";

  static Future<bool> remove(String? key) async =>
      await preferences!.remove(key!);
}

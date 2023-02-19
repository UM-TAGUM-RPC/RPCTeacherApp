import 'package:shared_preferences/shared_preferences.dart';

const String tokenDevice = "";

class SharedPrefs {
  static SharedPreferences? preferences;
  static SharedPrefs instance = SharedPrefs.ctor();

  factory SharedPrefs() {
    return instance;
  }
  SharedPrefs.ctor();

  static init() async {
    return preferences = await SharedPreferences.getInstance();
  }

  static write(String? key, dynamic value) async =>
      preferences!.setString(key!, "$value");

  static read(String? key) => preferences!.getString(key ?? "") ?? "";

  static remove(String? key) async => await preferences!.remove(key!);
}

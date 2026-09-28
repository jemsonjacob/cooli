import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SpHelper {
  static SharedPreferences? _sp;
  static FlutterSecureStorage? _ss;

  static Future<SharedPreferences> getSP() async {
    _sp ??= await SharedPreferences.getInstance();
    await _sp!.reload();
    return _sp!;
  }

  static FlutterSecureStorage _secureInstance() {
    _ss ??= const FlutterSecureStorage();
    return _ss!;
  }

  ///
  ///## Save string in shared pref
  ///[key] name to save.
  ///can retreave saved string using [key]
  ///[secure] set true if you want to save string in secure storage.
  static Future<bool> saveString(String key, String value,
      {bool secure = false}) async {
    if (secure) {
      await _secureInstance().write(key: key, value: value);
      return true;
    }
    final sp = await getSP();
    return await sp.setString(key, value);
  }

  static Future<bool?> clearAll() async {
    return await _sp?.clear();
  }

  ///
  ///## Read saved String
  ///[key] name given to save.
  ///[secure] true if String saved as secure.
  static Future<String?> getString(String key, {bool secure = false}) async {
    if (secure) {
      return await _secureInstance().read(key: key);
    }
    final sp = await getSP();
    return sp.getString(key);
  }

  ///
  ///## Read saved boolean
  ///[key] name given to save.
  static Future<bool?> getBoolean(String key) async {
    final sp = await getSP();
    return sp.getBool(key);
  }

  ///
  ///
  static Future<bool> saveBoolean(
    String key,
    bool value,
  ) async {
    final sp = await getSP();
    return await sp.setBool(key, value);
  }
}

extension RememberBool on bool {
  Future rememberMe(String name) async {
    await SpHelper.saveBoolean(name, this);
  }

  Future<bool> getMeBack(String name) async {
    return await SpHelper.getBoolean(name) ?? this;
  }
}

extension RememberString on String {
  rememberMe(String name) async {
    await SpHelper.saveString(name, this);
  }

  Future<String> getMeBack(String name) async {
    return await SpHelper.getString(name) ?? this;
  }
}

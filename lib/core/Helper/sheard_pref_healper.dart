import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Two stores:
/// - [FlutterSecureStorage] (encrypted) for tokens.
/// - [SharedPreferences] (plain) for non-sensitive flags.
class SharedPrefHelper {
  SharedPrefHelper._();

  static const FlutterSecureStorage _secure = FlutterSecureStorage();

  // ---------- secure: tokens ----------
  static Future<void> setSecuredString(String key, String value) =>
      _secure.write(key: key, value: value);

  static Future<String> getSecuredString(String key) async =>
      await _secure.read(key: key) ?? '';
 
  static Future<void> removeSecuredData(String key) => _secure.delete(key: key);

  static Future<void> clearAllSecuredData() => _secure.deleteAll();

  // ---------- plain: flags ----------
  static Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  /// Wipe everything — call on logout / expired session.
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _secure.deleteAll();
}
}

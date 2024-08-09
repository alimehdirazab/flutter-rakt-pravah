import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  // Keys for SharedPreferences
  static const String _keyToken = 'token';
  static const String _keyId = 'id';
  static const String _keyName = 'name';
  static const String _keyPhoneNumber = 'phoneNumber';

  // Save methods
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
  }

  static Future<void> saveId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyId, id);
  }

  static Future<void> saveName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
  }

  static Future<void> savePhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPhoneNumber, phoneNumber);
  }

  // Retrieve methods
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<int?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyId);
  }

  static Future<String?> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  static Future<String?> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPhoneNumber);
  }

  // Delete methods
  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
  }

  static Future<void> removeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyId);
  }

  static Future<void> removeName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
  }

  static Future<void> removePhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPhoneNumber);
  }

  // Clear all stored data
  static Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

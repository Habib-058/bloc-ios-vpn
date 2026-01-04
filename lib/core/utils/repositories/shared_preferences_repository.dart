import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesRepository {
  // Private constructor to prevent instantiation
  SharedPreferencesRepository._();

  // SharedPreferences instance
  static SharedPreferences? _prefs;

  /// Get SharedPreferences instance, initializing if needed
  static Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }


  /// Save a String value
  static Future<bool> saveString(String key, String value) async {
    final prefs = await _preferences;
    final result = await prefs.setString(key, value);
    if (kDebugMode) {
      debugPrint("Saved String: $key = $value");
    }
    return result;
  }

  /// Get a String value
  static Future<String?> getString(String key) async {
    final prefs = await _preferences;
    return prefs.getString(key);
  }

  /// Save an int value
  static Future<bool> saveInt(String key, int value) async {
    final prefs = await _preferences;
    final result = await prefs.setInt(key, value);
    if (kDebugMode) {
      debugPrint("Saved Int: $key = $value");
    }
    return result;
  }

  /// Get an int value
  static Future<int?> getInt(String key) async {
    final prefs = await _preferences;
    return prefs.getInt(key);
  }

  /// Save a bool value
  static Future<bool> saveBool(String key, bool value) async {
    final prefs = await _preferences;
    final result = await prefs.setBool(key, value);
    if (kDebugMode) {
      debugPrint("Saved Bool: $key = $value");
    }
    return result;
  }

  /// Get a bool value
  static Future<bool?> getBool(String key) async {
    final prefs = await _preferences;
    return prefs.getBool(key);
  }

  /// Save a double value
  static Future<bool> saveDouble(String key, double value) async {
    final prefs = await _preferences;
    final result = await prefs.setDouble(key, value);
    if (kDebugMode) {
      debugPrint("Saved Double: $key = $value");
    }
    return result;
  }

  /// Get a double value
  static Future<double?> getDouble(String key) async {
    final prefs = await _preferences;
    return prefs.getDouble(key);
  }

  /// Save a List of Strings
  static Future<bool> saveStringList(String key, List<String> value) async {
    final prefs = await _preferences;
    final result = await prefs.setStringList(key, value);
    if (kDebugMode) {
      debugPrint("Saved StringList: $key = $value");
    }
    return result;
  }

  /// Get a List of Strings
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await _preferences;
    return prefs.getStringList(key);
  }

  /// Remove a value by key
  static Future<bool> remove(String key) async {
    final prefs = await _preferences;
    final result = await prefs.remove(key);
    if (kDebugMode) {
      debugPrint("Removed: $key");
    }
    return result;
  }

  /// Check if a key exists
  static Future<bool> containsKey(String key) async {
    final prefs = await _preferences;
    return prefs.containsKey(key);
  }

  /// Get all keys
  static Future<Set<String>> getAllKeys() async {
    final prefs = await _preferences;
    return prefs.getKeys();
  }

  /// Clear all stored data
  static Future<bool> clear() async {
    final prefs = await _preferences;
    final result = await prefs.clear();
    if (kDebugMode) {
      debugPrint("Cleared all data");
    }
    return result;
  }
}


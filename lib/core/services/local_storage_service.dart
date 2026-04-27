import 'package:shared_preferences/shared_preferences.dart';

/// A service to handle local data persistence using SharedPreferences.
///
/// Ideal for simple flags (onboarding seen) and basic session data.
class LocalStorageService {
  static SharedPreferences? _prefs;

  /// Initialize the SharedPreferences instance.
  /// Should be called in main.dart before runApp.
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── Generic Setters ────────────────────────────────────────────────────────

  Future<bool> setString(String key, String value) async =>
      await _prefs?.setString(key, value) ?? false;

  Future<bool> setBool(String key, bool value) async =>
      await _prefs?.setBool(key, value) ?? false;

  Future<bool> setInt(String key, int value) async =>
      await _prefs?.setInt(key, value) ?? false;

  // ── Generic Getters ────────────────────────────────────────────────────────

  String? getString(String key) => _prefs?.getString(key);

  bool getBool(String key, {bool defaultValue = false}) =>
      _prefs?.getBool(key) ?? defaultValue;

  int getInt(String key, {int defaultValue = 0}) =>
      _prefs?.getInt(key) ?? defaultValue;

  // ── Utility ────────────────────────────────────────────────────────────────

  Future<bool> remove(String key) async => await _prefs?.remove(key) ?? false;

  Future<bool> clear() async => await _prefs?.clear() ?? false;

  bool hasKey(String key) => _prefs?.containsKey(key) ?? false;
}

/// Provider for the storage service to be used with Riverpod.
/// Note: Make sure to call LocalStorageService.init() in main.dart
final localStorageProvider = LocalStorageService();

import '../strings.dart';
import 'shared_preferences_repository.dart';

class AuthPreferencesRepository {
  // Private constructor to prevent instantiation
  AuthPreferencesRepository._();

  /// Get authentication token
  static Future<String> getAuthToken() async {
    final token = await SharedPreferencesRepository.getString(Strings.accessToken);
    return token ?? '';
  }

  /// Set authentication token
  static Future<bool> setAuthToken(String token) async {
    return await SharedPreferencesRepository.saveString(Strings.accessToken, token);
  }

  /// Clear authentication token
  static Future<bool> clearAuthToken() async {
    return await SharedPreferencesRepository.remove(Strings.accessToken);
  }


  /// Get FCM token
  static Future<String?> getFcmToken() async {
    return await SharedPreferencesRepository.getString(Strings.fcmToken);
  }

  /// Set FCM token
  static Future<bool> setFcmToken(String token) async {
    return await SharedPreferencesRepository.saveString(Strings.fcmToken, token);
  }

  /// Clear FCM token
  static Future<bool> clearFcmToken() async {
    return await SharedPreferencesRepository.remove(Strings.fcmToken);
  }
}


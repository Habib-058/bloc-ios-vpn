

import 'package:bloc_vpn_ios/core/cache_repositories/shared_preferences_repository.dart';

/// Repository for managing app-level settings and configurations
/// 
/// This repository handles application-wide settings that are not user-specific.
/// Examples: app version, installation date, feature flags, etc.
class AppPreferencesRepository {
  // Private constructor to prevent instantiation
  AppPreferencesRepository._();

  // ==================== App Configuration Methods ====================
  
  /// Get app version
  static Future<String?> getAppVersion() async {
    return await SharedPreferencesRepository.getString('app_version');
  }

  /// Set app version
  static Future<bool> setAppVersion(String version) async {
    return await SharedPreferencesRepository.saveString('app_version', version);
  }

  /// Get installation date
  static Future<String?> getInstallationDate() async {
    return await SharedPreferencesRepository.getString('installation_date');
  }

  /// Set installation date
  static Future<bool> setInstallationDate(String date) async {
    return await SharedPreferencesRepository.saveString('installation_date', date);
  }

  /// Check if it's the first launch
  static Future<bool?> isFirstLaunch() async {
    return await SharedPreferencesRepository.getBool('is_first_launch');
  }

  /// Set first launch flag
  static Future<bool> setFirstLaunch(bool isFirst) async {
    return await SharedPreferencesRepository.saveBool('is_first_launch', isFirst);
  }

  // ==================== Add more app-level preferences as needed ====================
}


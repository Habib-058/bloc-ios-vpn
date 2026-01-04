import 'package:bloc_vpn_ios/core/cache_repositories/shared_preferences_repository.dart';

import '../utils/strings.dart';


class UserPreferencesRepository {
  // Private constructor to prevent instantiation
  UserPreferencesRepository._();

  static const Duration _cacheRefreshInterval = Duration(hours: 6);

  static Future<bool?> getAcceptedPolicy() async {
    return await SharedPreferencesRepository.getBool(Strings.acceptedPolicy);
  }

  static Future<void> setAcceptedPolicy(bool acceptedPolicy) async {
     await SharedPreferencesRepository.saveBool(Strings.acceptedPolicy, acceptedPolicy);
  }

  static Future<void> setUserSubscriptionStatus(bool subscriptionStatus) async {
    await SharedPreferencesRepository.saveBool(Strings.subscriptionStatus, subscriptionStatus);
  }

  static Future<bool?> getUserSubscriptionStatus() async {
    return await SharedPreferencesRepository.getBool(Strings.subscriptionStatus);
  }

  static Future<void> setCurrentTimeStampToCheckSubscription() async {
    final now = DateTime.now();
    await SharedPreferencesRepository.saveInt(Strings.subscriptionStatusLastChecked, now.millisecondsSinceEpoch);
  }

  static Future<bool> shouldCheckSubscriptionStatus() async {
    final lastRefreshTimestamp = await SharedPreferencesRepository.getInt(Strings.subscriptionStatusLastChecked) ?? 0;

    if (lastRefreshTimestamp == 0) {
      print("Never checked subscription status before.");
      return false;
    }

    final lastRefreshTime = DateTime.fromMillisecondsSinceEpoch(lastRefreshTimestamp);
    final now = DateTime.now();
    final timeSinceLastRefresh = now.difference(lastRefreshTime);

    return timeSinceLastRefresh >= _cacheRefreshInterval;
  }

}


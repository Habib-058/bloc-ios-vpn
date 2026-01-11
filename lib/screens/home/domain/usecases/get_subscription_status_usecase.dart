import 'package:bloc_vpn_ios/core/cache_repositories/user_preferences_repository.dart';

/// Use case to get subscription status from local cache
class GetSubscriptionStatusUseCase {
  Future<bool> call() async {
    final isSubscribed =
        await UserPreferencesRepository.getUserSubscriptionStatus() ?? false;
    return isSubscribed;
  }
}

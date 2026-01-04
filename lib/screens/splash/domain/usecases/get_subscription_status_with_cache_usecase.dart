import 'package:bloc_vpn_ios/core/cache_repositories/user_preferences_repository.dart';
import '../entities/subscription_status_result.dart';
import '../repositories/splash_screen_repository.dart';

/// Use case that handles the business logic for getting subscription status
/// with caching (decides whether to fetch from server or use local cache)
class GetSubscriptionStatusWithCacheUseCase {
  final SplashScreenRepository repository;

  GetSubscriptionStatusWithCacheUseCase(this.repository);

  Future<SubscriptionStatusResult> call() async {
    // Business Logic: Decide if we should check subscription status from server
    final shouldCheckSubscriptionStatus =
        await UserPreferencesRepository.shouldCheckSubscriptionStatus();

    if (shouldCheckSubscriptionStatus) {
      // Business Logic: Fetch from server
      final subscriptionStatusResponse = await repository.getSubscriptionStatus();

      // Business Logic: Process response and save if successful
      if (subscriptionStatusResponse.isSuccess &&
          subscriptionStatusResponse.user != null) {
        final isSubscribed =
            subscriptionStatusResponse.user?.isSubscriptionStatus ?? false;

        // Business Logic: Save subscription status and timestamp
        await UserPreferencesRepository.setUserSubscriptionStatus(isSubscribed);
        await UserPreferencesRepository.setCurrentTimeStampToCheckSubscription();

        return SubscriptionStatusResult(
          isSubscribed: isSubscribed,
          subscriptionStatus: subscriptionStatusResponse,
          source: 'server',
        );
      }
    }

    // Business Logic: Get from local cache
    final isSubscribed =
        await UserPreferencesRepository.getUserSubscriptionStatus() ?? false;

    return SubscriptionStatusResult(
      isSubscribed: isSubscribed,
      source: 'local',
    );
  }
}


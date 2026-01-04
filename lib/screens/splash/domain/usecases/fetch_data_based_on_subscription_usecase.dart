import 'package:bloc_vpn_ios/screens/server/domain/entities/server_response_entity.dart';

import '../repositories/splash_screen_repository.dart';

/// Use case that handles the business logic for fetching data
/// based on subscription status (premium vs free)
class FetchDataBasedOnSubscriptionUseCase {
  final SplashScreenRepository repository;

  FetchDataBasedOnSubscriptionUseCase(this.repository);

  Future<ServerResponse> call(bool isSubscribed) async {
    // Business Logic: Decide which API to call based on subscription status
    if (isSubscribed) {
      // Business Logic: User is subscribed - fetch premium data
      return await repository.fetchPremiumData();
    } else {
      // Business Logic: User is not subscribed - fetch free data
      return await repository.fetchFreeData();
    }
  }
}


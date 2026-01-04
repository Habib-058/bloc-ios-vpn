import 'package:bloc_vpn_ios/screens/splash/domain/entities/subscription_status_entity.dart';

import '../../../server/domain/entities/server_response_entity.dart';

abstract class SplashScreenRepository {
  Future<bool> getAcceptedTC();
  void setAcceptedTC(bool accepted);

  Future<SubscriptionStatus> getSubscriptionStatus();
  Future<ServerResponse> fetchPremiumData();
  Future<ServerResponse> fetchFreeData();
}

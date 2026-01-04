import 'package:bloc_vpn_ios/screens/splash/domain/entities/subscription_status_entity.dart';

abstract class SplashScreenRepository {
  Future<bool> getAcceptedTC();
  void setAcceptedTC(bool accepted);

  Future<SubscriptionStatus> getSubscriptionStatus();
}

import 'package:bloc_vpn_ios/core/utils/dependency_injection/dependencies.dart';
import 'package:bloc_vpn_ios/screens/splash/domain/entities/subscription_status_entity.dart';

class SubscriptionStatusUseCase {
  final SplashScreenRepository repository;

  SubscriptionStatusUseCase(this.repository);

  Future<SubscriptionStatus> call() {
    return repository.getSubscriptionStatus();
  }
}
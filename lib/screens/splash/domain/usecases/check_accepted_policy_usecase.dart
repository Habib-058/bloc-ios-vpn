import '../repositories/splash_screen_repository.dart';

class CheckAcceptedPolicyUseCase {
  final SplashScreenRepository repository;

  CheckAcceptedPolicyUseCase(this.repository);

  Future<bool> call() async {
    return await repository.getAcceptedTC();
  }
  void setAcceptedPolicy(bool accepted) {
    repository.setAcceptedTC(accepted);
  }
}


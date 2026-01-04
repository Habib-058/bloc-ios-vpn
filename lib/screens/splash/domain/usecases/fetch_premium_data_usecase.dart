import '../../../server/domain/entities/server_response_entity.dart';
import '../repositories/splash_screen_repository.dart';

class FetchPremiumDataUseCase {
  final SplashScreenRepository repository;

  FetchPremiumDataUseCase(this.repository);

  Future<ServerResponse> call() async {
    return await repository.fetchPremiumData();
  }
}


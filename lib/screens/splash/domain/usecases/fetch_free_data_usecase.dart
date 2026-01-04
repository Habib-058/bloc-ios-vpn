import '../../../server/domain/entities/server_response_entity.dart';
import '../repositories/splash_screen_repository.dart';

class FetchFreeDataUseCase {
  final SplashScreenRepository repository;

  FetchFreeDataUseCase(this.repository);

  Future<ServerResponse> call() async {
    return await repository.fetchFreeData();
  }
}


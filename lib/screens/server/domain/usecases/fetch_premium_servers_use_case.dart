import '../entities/server_list_entity.dart';
import '../repositories/server_screen_repository.dart';

class FetchPremiumServersUseCase {
  ServerScreenRepository repository;
  FetchPremiumServersUseCase({required this.repository});

  Future<ServerList> call() async {
    return await repository.fetchPremiumServers();
  }
}
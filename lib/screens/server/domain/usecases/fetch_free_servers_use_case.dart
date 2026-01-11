import 'package:bloc_vpn_ios/screens/server/domain/entities/server_list_entity.dart';
import 'package:bloc_vpn_ios/screens/server/domain/repositories/server_screen_repository.dart';

class FetchFreeServersUseCase {
  ServerScreenRepository repository;
  FetchFreeServersUseCase({required this.repository});

  Future<ServerList> call() async {
    return await repository.fetchFreeServers();
  }
}
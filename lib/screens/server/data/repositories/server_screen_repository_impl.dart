import 'package:bloc_vpn_ios/screens/server/data/datasources/server_remote_data_source.dart';
import 'package:bloc_vpn_ios/screens/server/domain/entities/server_list_entity.dart';
import 'package:bloc_vpn_ios/screens/server/domain/repositories/server_screen_repository.dart';

class ServerScreenRepositoryImpl extends ServerScreenRepository {
   ServerRemoteDataSource remoteDataSource;
    ServerScreenRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ServerList> fetchFreeServers() {
    // TODO: implement fetchFreeServers
    throw UnimplementedError();
  }

  @override
  Future<ServerList> fetchPremiumServers() {
    // TODO: implement fetchPremiumServers
    throw UnimplementedError();
  }


}
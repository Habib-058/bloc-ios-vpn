import 'package:bloc_vpn_ios/screens/server/domain/entities/server_list_entity.dart';

import '../../../../core/network/api_service.dart';

abstract class ServerRemoteDataSource {

  Future<ServerList> fetchFreeServers();

  Future<ServerList> fetchPremiumServers();
}

class ServerRemoteDataSourceImpl extends ServerRemoteDataSource {
  final ApiService apiService;
  ServerRemoteDataSourceImpl({required this.apiService});

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

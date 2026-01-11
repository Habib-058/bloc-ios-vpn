import 'package:bloc_vpn_ios/core/cache_repositories/server_cache_repositories/server_cache_repository.dart';
import 'package:bloc_vpn_ios/screens/server/data/datasources/server_local_data_source.dart';
import 'package:bloc_vpn_ios/screens/server/data/datasources/server_remote_data_source.dart';
import 'package:bloc_vpn_ios/screens/server/domain/entities/server_list_entity.dart';
import 'package:bloc_vpn_ios/screens/server/domain/repositories/server_screen_repository.dart';

class ServerScreenRepositoryImpl extends ServerScreenRepository {
   ServerRemoteDataSource remoteDataSource;
   ServerLocalDataSource localDataSource;
   ServerCacheRepository serverCacheRepository;
    ServerScreenRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.serverCacheRepository});

  @override
  Future<ServerList> fetchFreeServers() async {

    final cachedResponse = await serverCacheRepository.getCachedFreeServers();
    if(cachedResponse != null){
      return cachedResponse;
    } else {
      final remoteResponse = await remoteDataSource.fetchFreeServers();
      return remoteResponse;
    }

  }

  @override
  Future<ServerList> fetchPremiumServers() {
    // TODO: implement fetchPremiumServers
    throw UnimplementedError();
  }


}
import 'package:bloc_vpn_ios/screens/server/domain/entities/server_list_entity.dart';

abstract class ServerScreenRepository {
  Future<ServerList> fetchFreeServers();
  Future<ServerList> fetchPremiumServers();
}
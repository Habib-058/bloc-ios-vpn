import 'dart:convert';

import 'package:bloc_vpn_ios/core/cache_repositories/server_cache_repositories/server_cache_repository.dart';
import 'package:bloc_vpn_ios/screens/server/data/models/server_model.dart';

abstract class HomeLocalDataSources {
  Future<ServerModel> getCurrentVpnLocation();
}

class HomeLocalDataSourcesImpl extends HomeLocalDataSources {

  @override
  Future<ServerModel> getCurrentVpnLocation() async{
    final jsonString = await ServerCacheRepository.getFirstServer();

    if (jsonString != null) {
      final jsonMap = json.decode(jsonString);
      return ServerModel.fromJson(jsonMap);
    }

    return ServerModel(
      id: '136',
      name: 'De-1',
      ping: '1',
      count: '1',
      ip: '1',
      isSelected: '0',
      address:
      'gc2MPeF3akoiHWMOBb36Gr0ydhjxC4sHCX6ZhiOj4vBFQYHg+otNourb8y7GPSi1tYnd37c/RPk1oXIz4BUV6HmbPZRWau0Y3cQWMp/qghxNl38YAX6Da+dLWIrCqhQdgC49fwk73AOvvwXaZIlHAF8Sb8KnCCLcASVotbgQYT0PadTMohCzvjxJ2U0oczErVq1gzkCGlcXRWDN5mkUNTglKTUY1lda4rsqBftSvrgQfNNdaAwc1UWfU8/rX5c70qpXkKxq94gtDT6vE5NrYs8NQTyS6YuJukWhQc8IjC0HPDlCMKExH8HCienf7st4sHvFfGWaJiXMe3VIgQAkwiw==',
      locationId: '26',
      type: 'free',
    );
  }
}
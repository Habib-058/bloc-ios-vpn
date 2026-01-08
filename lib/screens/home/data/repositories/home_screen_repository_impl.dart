import 'package:bloc_vpn_ios/screens/home/domain/repositories/home_screen_repository.dart';
import 'package:bloc_vpn_ios/screens/server/data/models/server_model.dart';

import '../../../../core/vpn/enums/supported_protocol_list.dart';
import '../../../../core/vpn/vpn_service.dart';
import '../datasources/home_local_data_source.dart';

class HomeScreenRepositoryImpl extends HomeScreenRepository {
  HomeLocalDataSources homeLocalDataSources;
  HomeScreenRepositoryImpl({required this.homeLocalDataSources});


  @override
  Future<ServerModel> getCurrentVpnLocation()  async{
  return homeLocalDataSources.getCurrentVpnLocation();
  }

  @override
  Future<void> switchProtocol(protocol) async {
    await VpnService().switchProtocol(protocol);
  }

}
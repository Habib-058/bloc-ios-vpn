import 'package:bloc_vpn_ios/screens/home/domain/repositories/home_screen_repository.dart';
import 'package:bloc_vpn_ios/screens/server/data/models/server_model.dart';

import '../datasources/home_local_data_source.dart';

class HomeScreenRepositoryImpl extends HomeScreenRepository {
  HomeLocalDataSources homeLocalDataSources;
  HomeScreenRepositoryImpl({required this.homeLocalDataSources});


  @override
  Future<ServerModel> getCurrentVpnLocation()  async{
  return homeLocalDataSources.getCurrentVpnLocation();
  }

}
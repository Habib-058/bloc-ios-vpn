import 'package:bloc_vpn_ios/screens/server/data/models/server_model.dart';

import '../repositories/home_screen_repository.dart';

class InitializeHomeVpnLocationUseCase {
  final HomeScreenRepository repository;
  InitializeHomeVpnLocationUseCase(this.repository);

  Future<ServerModel> call()  async{
    return  repository.getCurrentVpnLocation();
  }
}
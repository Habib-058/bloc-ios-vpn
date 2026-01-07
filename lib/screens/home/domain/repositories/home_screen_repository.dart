import 'package:bloc_vpn_ios/screens/server/data/models/server_model.dart';

abstract class HomeScreenRepository {
  Future<ServerModel> getCurrentVpnLocation();
}
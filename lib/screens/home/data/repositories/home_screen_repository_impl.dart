import 'package:bloc_vpn_ios/screens/home/domain/entities/stage_status_entity.dart';
import 'package:bloc_vpn_ios/screens/home/domain/repositories/home_screen_repository.dart';
import 'package:bloc_vpn_ios/screens/server/data/models/server_model.dart';

import '../../../../core/vpn/vpn_connection_stage.dart';
import '../../../../core/vpn/vpn_connection_status.dart';
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

  @override
  Future<StageStatusEntity> initializeVPN() async {
    print("inside init vpn");

    await VpnService().initialize(
      groupIdentifier: "group.com.capvpn.capp",
      providerBundleIdentifier:
      "com.enovavpn.mobile.OpenVPNNgMobileVPNExtension",
      localizedDescription: "EnovaVPN",
    );

    // Return initial values (streams will update state asynchronously via BLoC)
    return StageStatusEntity(
      stage: CapVPNConnectionStage.disconnected,
      status: CapVPNConnectionStatus(),
    );
  }

}
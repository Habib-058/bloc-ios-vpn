import 'package:bloc_vpn_ios/screens/home/domain/entities/stage_status_entity.dart';
import 'package:bloc_vpn_ios/screens/server/data/models/server_model.dart';

import '../../../../core/vpn/enums/supported_protocol_list.dart';

abstract class HomeScreenRepository {
  Future<ServerModel> getCurrentVpnLocation();
  Future<void> switchProtocol(SupportedVpnProtocol protocol);
  Future<StageStatusEntity> initializeVPN();
}
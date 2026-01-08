import 'package:bloc_vpn_ios/screens/home/domain/repositories/home_screen_repository.dart';

import '../../../../core/vpn/enums/supported_protocol_list.dart';

class HomeSwitchProtocolUseCase {
  final HomeScreenRepository _homeScreenRepository;
  HomeSwitchProtocolUseCase(this._homeScreenRepository);

  Future<void> call(SupportedVpnProtocol protocol) async {
    return await _homeScreenRepository.switchProtocol(protocol);
  }

}
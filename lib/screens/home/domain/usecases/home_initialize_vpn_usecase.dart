import 'package:bloc_vpn_ios/screens/home/domain/entities/stage_status_entity.dart';
import 'package:bloc_vpn_ios/screens/home/domain/repositories/home_screen_repository.dart';

class HomeInitializeVpnUseCase {
  final HomeScreenRepository _homeScreenRepository;
  HomeInitializeVpnUseCase(this._homeScreenRepository);
  
  Future<StageStatusEntity> call() async {
    return await _homeScreenRepository.initializeVPN();
  }

}
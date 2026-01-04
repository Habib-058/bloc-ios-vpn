import 'package:bloc_vpn_ios/core/utils/repositories/shared_preferences_repository.dart';
import 'package:bloc_vpn_ios/core/utils/strings.dart';

abstract class SplashScreenLocalDataSource {
  Future<bool> getAcceptedPolicy();
}

class SplashScreenLocalDataSourceImpl implements SplashScreenLocalDataSource {
  @override
  Future<bool> getAcceptedPolicy() async {
    final result = await SharedPreferencesRepository.getBool(Strings.acceptedPolicy);
    return result ?? false;
  }
}


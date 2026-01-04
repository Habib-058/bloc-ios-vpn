import 'package:bloc_vpn_ios/core/utils/strings.dart';

import '../../../../../core/cache_repositories/shared_preferences_repository.dart';

abstract class SplashScreenLocalDataSource {
  Future<bool> getAcceptedPolicy();
  void setAcceptedPolicy(bool accepted);
}

class SplashScreenLocalDataSourceImpl implements SplashScreenLocalDataSource {
  @override
  Future<bool> getAcceptedPolicy() async {
    final result = await SharedPreferencesRepository.getBool(Strings.acceptedPolicy);
    return result ?? false;
  }

  @override
  void setAcceptedPolicy(bool accepted) {
    SharedPreferencesRepository.saveBool(Strings.acceptedPolicy, accepted);
  }
}


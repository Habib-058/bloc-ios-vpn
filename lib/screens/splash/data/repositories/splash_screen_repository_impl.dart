import 'package:bloc_vpn_ios/screens/splash/data/datasources/remote/remote_data_sources.dart';
import 'package:bloc_vpn_ios/screens/splash/domain/entities/subscription_status_entity.dart';

import '../../domain/repositories/splash_screen_repository.dart';
import '../datasources/local/local_data_sources.dart';

class SplashScreenRepositoryImpl extends SplashScreenRepository {
  final SplashScreenLocalDataSource localDataSource;
  final SplashScreenRemoteDataSource remoteDataSource;

  SplashScreenRepositoryImpl({required this.localDataSource, required this.remoteDataSource});

  @override
  Future<bool> getAcceptedTC() async {
    return await localDataSource.getAcceptedPolicy();
  }

  @override
  void setAcceptedTC(bool accepted) async {
      localDataSource.setAcceptedPolicy(accepted);
  }

  @override
  Future<SubscriptionStatus> getSubscriptionStatus() {
    return remoteDataSource.getSubscriptionStatus();
  }
}

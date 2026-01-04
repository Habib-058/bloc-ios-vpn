import '../../domain/repositories/splash_screen_repository.dart';
import '../datasources/local/local_data_sources.dart';

class SplashScreenRepositoryImpl extends SplashScreenRepository {
  final SplashScreenLocalDataSource localDataSource;

  SplashScreenRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> getAcceptedTC() async {
    return await localDataSource.getAcceptedPolicy();
  }
}

import 'package:get_it/get_it.dart';
import '../../../screens/splash/data/datasources/remote/remote_data_sources.dart';
import '../../../screens/splash/domain/usecases/subscription_status_usecase.dart';
import '../../network/api_service.dart';
import './dependencies.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> setupDependencies() async {
  // Data Sources

  getIt.registerLazySingleton<SplashScreenLocalDataSource>(
    () => SplashScreenLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<SplashScreenRemoteDataSource>(
    () => SplashScreenRemoteDataSourceImpl(apiService: getIt<ApiService>(),)
  );

  // Repositories
  getIt.registerLazySingleton<SplashScreenRepository>(
    () => SplashScreenRepositoryImpl(
      localDataSource: getIt<SplashScreenLocalDataSource>(),
      remoteDataSource: getIt<SplashScreenRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<CheckAcceptedPolicyUseCase>(
    () => CheckAcceptedPolicyUseCase(getIt<SplashScreenRepository>()),
  );

  getIt.registerLazySingleton<SubscriptionStatusUseCase>(
    () => SubscriptionStatusUseCase(getIt<SplashScreenRepository>()),
  );

  // BLoCs - Factory because we might need multiple instances or recreate on navigation
  getIt.registerFactory<SplashScreenBloc>(
    () => SplashScreenBloc(
      checkAcceptedPolicyUseCase: getIt<CheckAcceptedPolicyUseCase>(),
      subscriptionStatusUseCase: getIt<SubscriptionStatusUseCase>(),
    ),
  );
}

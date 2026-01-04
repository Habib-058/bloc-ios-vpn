import 'package:get_it/get_it.dart';
import '../../../screens/splash/data/datasources/remote/remote_data_sources.dart';
import '../../../screens/splash/domain/usecases/get_subscription_status_with_cache_usecase.dart';
import '../../../screens/splash/domain/usecases/fetch_data_based_on_subscription_usecase.dart';
import '../../network/api_service.dart';
import './dependencies.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> setupDependencies() async {
  // Data Sources

  getIt.registerLazySingleton<SplashScreenLocalDataSource>(
    () => SplashScreenLocalDataSourceImpl(),
  );

  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(() => ApiService());
  }

  getIt.registerLazySingleton<SplashScreenRemoteDataSource>(
    () => SplashScreenRemoteDataSourceImpl(apiService: getIt<ApiService>())
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

  getIt.registerLazySingleton<GetSubscriptionStatusWithCacheUseCase>(
    () => GetSubscriptionStatusWithCacheUseCase(getIt<SplashScreenRepository>()),
  );

  getIt.registerLazySingleton<FetchDataBasedOnSubscriptionUseCase>(
    () => FetchDataBasedOnSubscriptionUseCase(getIt<SplashScreenRepository>()),
  );

  // BLoCs - Factory because we might need multiple instances or recreate on navigation
  getIt.registerFactory<SplashScreenBloc>(
    () => SplashScreenBloc(
      checkAcceptedPolicyUseCase: getIt<CheckAcceptedPolicyUseCase>(),
      getSubscriptionStatusWithCacheUseCase: getIt<GetSubscriptionStatusWithCacheUseCase>(),
      fetchDataBasedOnSubscriptionUseCase: getIt<FetchDataBasedOnSubscriptionUseCase>(),
    ),
  );
}

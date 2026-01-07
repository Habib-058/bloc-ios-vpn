import '../../../core/utils/dependency_injection/core_dependencies.dart';
import '../../../core/network/api_service.dart';
import '../data/datasources/local/local_data_sources.dart';
import '../data/datasources/remote/remote_data_sources.dart';
import '../data/repositories/splash_screen_repository_impl.dart';
import '../domain/repositories/splash_screen_repository.dart';
import '../domain/usecases/check_accepted_policy_usecase.dart';
import '../domain/usecases/fetch_data_based_on_subscription_usecase.dart';
import '../domain/usecases/get_subscription_status_with_cache_usecase.dart';
import '../presentation/bloc/splash_screen_bloc.dart';

/// Register all Splash Screen feature dependencies
Future<void> setupSplashDependencies() async {
  // Data Sources
  getIt.registerLazySingleton<SplashScreenLocalDataSource>(
    () => SplashScreenLocalDataSourceImpl(),
  );

  getIt.registerLazySingleton<SplashScreenRemoteDataSource>(
    () => SplashScreenRemoteDataSourceImpl(
      apiService: getIt<ApiService>(),
    ),
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

  // BLoCs
  getIt.registerFactory<SplashScreenBloc>(
    () => SplashScreenBloc(
      checkAcceptedPolicyUseCase: getIt<CheckAcceptedPolicyUseCase>(),
      getSubscriptionStatusWithCacheUseCase:
          getIt<GetSubscriptionStatusWithCacheUseCase>(),
      fetchDataBasedOnSubscriptionUseCase:
          getIt<FetchDataBasedOnSubscriptionUseCase>(),
    ),
  );
}


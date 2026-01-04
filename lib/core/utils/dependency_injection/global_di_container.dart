import 'package:get_it/get_it.dart';
import './dependencies.dart';

final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> setupDependencies() async {
  
  // Data Sources
  getIt.registerLazySingleton<SplashScreenLocalDataSource>(
    () => SplashScreenLocalDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<SplashScreenRepository>(
    () => SplashScreenRepositoryImpl(
      localDataSource: getIt<SplashScreenLocalDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<CheckAcceptedPolicyUseCase>(
    () => CheckAcceptedPolicyUseCase(
      getIt<SplashScreenRepository>(),
    ),
  );

  // BLoCs - Factory because we might need multiple instances or recreate on navigation
  getIt.registerFactory<SplashScreenBloc>(
    () => SplashScreenBloc(
      checkAcceptedPolicyUseCase: getIt<CheckAcceptedPolicyUseCase>(),
    ),
  );
}


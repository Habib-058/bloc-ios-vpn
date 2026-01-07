import '../../../core/utils/dependency_injection/core_dependencies.dart';
import '../data/datasources/home_local_data_source.dart';
import '../data/repositories/home_screen_repository_impl.dart';
import '../domain/repositories/home_screen_repository.dart';
import '../domain/usecases/initialize_home_vpn_location_usecase.dart';
import '../presentation/bloc/home_screen_bloc.dart';

/// Register all Home Screen feature dependencies
Future<void> setupHomeDependencies() async {
  // Data Sources
  getIt.registerLazySingleton<HomeLocalDataSources>(
    () => HomeLocalDataSourcesImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<HomeScreenRepository>(
    () => HomeScreenRepositoryImpl(
      homeLocalDataSources: getIt<HomeLocalDataSources>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<InitializeHomeVpnLocationUseCase>(
    () => InitializeHomeVpnLocationUseCase(getIt<HomeScreenRepository>()),
  );

  // BLoCs
  getIt.registerFactory<HomeScreenBloc>(
    () => HomeScreenBloc(
      initializeHomeVpnLocationUseCase:
          getIt<InitializeHomeVpnLocationUseCase>(),
          // getIt<InitializeHomeVpnLocationUseCase>(),
    ),
  );
}


import 'package:bloc_vpn_ios/core/cache_repositories/server_cache_repositories/server_cache_repository.dart';
import 'package:bloc_vpn_ios/screens/server/data/datasources/server_local_data_source.dart';

import '../../../core/network/api_service.dart';
import '../../../core/utils/dependency_injection/core_dependencies.dart';
import '../data/datasources/server_remote_data_source.dart';
import '../data/repositories/server_screen_repository_impl.dart';
import '../domain/repositories/server_screen_repository.dart';
import '../../home/domain/usecases/get_subscription_status_usecase.dart';
import '../domain/usecases/fetch_free_servers_use_case.dart';
import '../domain/usecases/fetch_premium_servers_use_case.dart';
import '../presentation/bloc/server_screen_bloc.dart';

/// Register all Server Screen feature dependencies
Future<void> setupServerDependencies() async {
  // Data Sources
  getIt.registerLazySingleton<ServerRemoteDataSource>(
    () => ServerRemoteDataSourceImpl(
      apiService: getIt<ApiService>(),
    ),
  );


  // Repositories
  getIt.registerLazySingleton<ServerScreenRepository>(
    () => ServerScreenRepositoryImpl(
      remoteDataSource: getIt<ServerRemoteDataSource>(),
      localDataSource: getIt<ServerLocalDataSource>(),
      serverCacheRepository: getIt<ServerCacheRepository>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton<FetchFreeServersUseCase>(
    () => FetchFreeServersUseCase(
      repository: getIt<ServerScreenRepository>(),
    ),
  );

  getIt.registerLazySingleton<FetchPremiumServersUseCase>(
    () => FetchPremiumServersUseCase(
      repository: getIt<ServerScreenRepository>(),
    ),
  );

  // Reuse subscription status use case from home (or register if not already registered)
  if (!getIt.isRegistered<GetSubscriptionStatusUseCase>()) {
    getIt.registerLazySingleton<GetSubscriptionStatusUseCase>(
      () => GetSubscriptionStatusUseCase(),
    );
  }

  // BLoCs
  getIt.registerFactory<ServerScreenBloc>(
    () => ServerScreenBloc(
      getSubscriptionStatusUseCase: getIt<GetSubscriptionStatusUseCase>(),
      fetchFreeServersUseCase: getIt<FetchFreeServersUseCase>(),
      fetchPremiumServersUseCase: getIt<FetchPremiumServersUseCase>(),
    ),
  );
}

import 'package:get_it/get_it.dart';
import '../../network/api_service.dart';

final getIt = GetIt.instance;

Future<void> setupCoreDependencies() async {

  if (!getIt.isRegistered<ApiService>()) {
    getIt.registerLazySingleton<ApiService>(() => ApiService());
  }

}


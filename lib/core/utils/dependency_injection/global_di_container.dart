import './core_dependencies.dart';
import '../../../screens/splash/di/splash_di.dart';
import '../../../screens/home/di/home_di.dart';
import '../../../screens/server/di/server_di.dart';


Future<void> setupDependencies() async {
  await setupCoreDependencies();
  await setupSplashDependencies();
  await setupHomeDependencies();
  await setupServerDependencies();
}

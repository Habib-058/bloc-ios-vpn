import './core_dependencies.dart';
import '../../../screens/splash/di/splash_di.dart';
import '../../../screens/home/di/home_di.dart';


Future<void> setupDependencies() async {
  await setupCoreDependencies();
  await setupSplashDependencies();
  await setupHomeDependencies();
}

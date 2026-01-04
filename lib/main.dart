import 'package:bloc_vpn_ios/core/routes/app_navigation.dart';
import 'package:bloc_vpn_ios/core/utils/dependency_injection/global_di_container.dart';
import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();

  await Hive.initFlutter();
  // await HiveUtil.registerAdapters();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAP VPN',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoutes.splash,
      routes: AppNavigation.getRoutes(),
    );
  }
}

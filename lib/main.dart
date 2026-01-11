import 'dart:developer';
import 'dart:io';

import 'package:bloc_vpn_ios/core/routes/app_navigation.dart';
import 'package:bloc_vpn_ios/core/utils/dependency_injection/global_di_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'core/network/api_service.dart';
import 'core/network/url_service.dart';
import 'core/routes/app_routes.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/utils/logger/app_logger.dart';
import 'core/utils/logger/local_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();

  await Hive.initFlutter();
  // await HiveUtil.registerAdapters();

  await LocalLogger.initialize(
    clearInterval: const Duration(days: 7), // Clear logs every 7 days
    uploader:
        (File jsonFile, {required DateTime from, required DateTime to}) async {
          // Implement your log upload logic here
          // For now, return true to indicate success (logs will be cleared)
          // You can implement actual upload to your server later
          return true;
        },
  );

  await ApiService.initialize(
    client: http.Client(),
    baseUrl: UrlHelper.baseurl,
    timeoutSeconds: 120,
    onConnectionError: (error) async {
      // Get.isDialogOpen == false
      //     ? Get.dialog(
      //   NoInternetError(),
      //   barrierDismissible: false,
      // )
      //     : SizedBox();
    },
    onUnknownError: (error) async {
      log("onUnknownError: ", error: error.toJson(), level: 1000);
      // if (Get.currentRoute != Routes.UNKNOWN_ERROR) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     Get.offAllNamed(Routes.UNKNOWN_ERROR);
      //   });
      // }
    },
    logger: (AppLogger appLogger) async {
      log(appLogger.toString());
      if (appLogger.toJson()["data"]["reasonType"] == "TIMEOUT_ERROR") {
        // if (Get.currentRoute != Routes.UNKNOWN_ERROR) {
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     Get.offAllNamed(Routes.UNKNOWN_ERROR);
        //   });
        // }
      }
      await LocalLogger.instance.saveLog(appLogger.toJson());
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'CAP VPN',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: AppRoutes.splash,
        routes: AppNavigation.getRoutes(),
      ),
    );
  }
}

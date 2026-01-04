import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'app_screens.dart';


class AppNavigation {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.splash: (context) => const SplashScreen(),
      AppRoutes.privacyPolicy: (context) => const PrivacyPolicyScreen(),
      AppRoutes.termsConditions: (context) => const TermsConditions(),
      AppRoutes.home: (context) => const HomeScreen(),
    };
  }
}


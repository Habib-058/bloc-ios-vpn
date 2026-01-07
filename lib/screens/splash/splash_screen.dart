import 'package:bloc_vpn_ios/core/routes/app_routes.dart';
import 'package:bloc_vpn_ios/screens/splash/presentation/bloc/splash_screen_bloc.dart';
import 'package:bloc_vpn_ios/screens/splash/presentation/bloc/splash_screen_event.dart';
import 'package:bloc_vpn_ios/screens/splash/presentation/bloc/splash_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/dependency_injection/core_dependencies.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SplashScreenBloc>()..add(const InitializeSplashScreenEvent()),
      child: BlocListener<SplashScreenBloc, SplashScreenState>(
        listener: (context, state) {
          if (state.isInitialized) {
            if (state.isTCAccepted) {
              // Navigate to home screen
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            } else {
              // Navigate to terms and conditions screen
              Navigator.pushReplacementNamed(context, AppRoutes.termsConditions);
            }
          }
        },
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

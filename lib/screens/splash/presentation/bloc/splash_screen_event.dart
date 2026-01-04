
import 'package:equatable/equatable.dart';

abstract class SplashScreenEvent extends Equatable {
  const SplashScreenEvent();

  @override
  List<Object?> get props => [];
}

/// Single initialization event that handles all splash screen setup
class InitializeSplashScreen extends SplashScreenEvent {
  const InitializeSplashScreen();
}

/// Legacy event - kept for backward compatibility if needed
class CheckAcceptedTCStatus extends SplashScreenEvent {
  const CheckAcceptedTCStatus();
}

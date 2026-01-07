
import 'package:equatable/equatable.dart';

abstract class SplashScreenEvent extends Equatable {
  const SplashScreenEvent();

  @override
  List<Object?> get props => [];
}

/// Single initialization event that handles all splash screen setup
class InitializeSplashScreenEvent extends SplashScreenEvent {
  const InitializeSplashScreenEvent();
}

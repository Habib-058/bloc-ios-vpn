

import 'package:equatable/equatable.dart';

class SplashScreenState extends Equatable {
  final bool isLoading;
  final bool isInitialized;
  final String? errorMessage;
  final bool isTCAccepted;

  const SplashScreenState({
    this.isLoading = false,
    this.isInitialized = false,
    this.errorMessage,
    this.isTCAccepted = false,
  });

  SplashScreenState copyWith({
    bool? isLoading,
    bool? isInitialized,
    String? errorMessage,
    bool? isTCAccepted,
  }) {
    return SplashScreenState(
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: errorMessage,
      isTCAccepted: isTCAccepted ?? this.isTCAccepted,
    );
  }

  @override
  List<Object?> get props => [isLoading, isInitialized, errorMessage, isTCAccepted];
}

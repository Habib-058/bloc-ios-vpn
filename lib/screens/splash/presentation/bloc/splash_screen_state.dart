

import 'package:bloc_vpn_ios/screens/splash/domain/entities/subscription_status_entity.dart';
import 'package:equatable/equatable.dart';

class SplashScreenState extends Equatable {
  final bool isLoading;
  final bool isInitialized;
  final String? errorMessage;
  final bool isTCAccepted;
  final SubscriptionStatus? subscriptionStatus;
  final isSubscribed;

  const SplashScreenState({
    this.isLoading = false,
    this.isInitialized = false,
    this.errorMessage,
    this.isTCAccepted = false,
    this.subscriptionStatus,
    this.isSubscribed = false,
  });

  SplashScreenState copyWith({
    bool? isLoading,
    bool? isInitialized,
    String? errorMessage,
    bool? isTCAccepted,
    SubscriptionStatus? subscriptionStatus,
    bool? isSubscribed,
  }) {
    return SplashScreenState(
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: errorMessage,
      isTCAccepted: isTCAccepted ?? this.isTCAccepted,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isInitialized,
        errorMessage,
        isTCAccepted,
        subscriptionStatus,
        isSubscribed,
      ];
}

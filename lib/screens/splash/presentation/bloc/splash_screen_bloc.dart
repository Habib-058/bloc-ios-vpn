import 'package:bloc/bloc.dart';
import 'package:bloc_vpn_ios/core/cache_repositories/user_preferences_repository.dart';
import 'package:bloc_vpn_ios/screens/splash/domain/usecases/check_accepted_policy_usecase.dart';
import 'package:bloc_vpn_ios/screens/splash/presentation/bloc/splash_screen_event.dart';
import 'package:bloc_vpn_ios/screens/splash/presentation/bloc/splash_screen_state.dart';

import '../../../../core/cache_repositories/server_cache_repositories/server_cache_repository.dart';
import '../../domain/usecases/subscription_status_usecase.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  final CheckAcceptedPolicyUseCase checkAcceptedPolicyUseCase;
  final SubscriptionStatusUseCase subscriptionStatusUseCase;

  SplashScreenBloc({
    required this.checkAcceptedPolicyUseCase,
    required this.subscriptionStatusUseCase,
  }) : super(const SplashScreenState()) {
    on<InitializeSplashScreen>(_onInitializeSplashScreen);
    // on<CheckAcceptedTCStatus>(_onCheckAcceptedTCStatus);
  }

  /// Main initialization handler - handles all async operations
  Future<void> _onInitializeSplashScreen(
    InitializeSplashScreen event,
    Emitter<SplashScreenState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Run both operations (can be parallel if independent)
      final isAccepted = await checkAcceptedPolicyUseCase();
      final subscriptionStatusResponse = await subscriptionStatusUseCase();

      // Handle subscription status based on response
      // You can perform different actions based on subscription status here
      if (subscriptionStatusResponse.isSuccess && subscriptionStatusResponse.user != null) {
        // Success case - user has valid subscription
        UserPreferencesRepository.setUserSubscriptionStatus(subscriptionStatusResponse.user?.isSubscriptionStatus ?? false);
        UserPreferencesRepository.setCurrentTimeStampToCheckSubscription();

      } else {
        // Failed case - handle subscription error
        // subscriptionStatusResponse.errorMessage contains error details
      }

      // Emit state with all the data
      emit(
        state.copyWith(
          isLoading: false,
          isInitialized: true,
          isTCAccepted: isAccepted,
          subscriptionStatus: subscriptionStatusResponse,
          isSubscribed: subscriptionStatusResponse.user?.isSubscriptionStatus,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isInitialized: true,
          isTCAccepted: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

}

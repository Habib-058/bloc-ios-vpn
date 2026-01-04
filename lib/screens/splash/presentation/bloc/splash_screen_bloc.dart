import 'package:bloc/bloc.dart';
import 'package:bloc_vpn_ios/screens/splash/domain/usecases/check_accepted_policy_usecase.dart';
import 'package:bloc_vpn_ios/screens/splash/presentation/bloc/splash_screen_event.dart';
import 'package:bloc_vpn_ios/screens/splash/presentation/bloc/splash_screen_state.dart';

import '../../domain/usecases/get_subscription_status_with_cache_usecase.dart';
import '../../domain/usecases/fetch_data_based_on_subscription_usecase.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  final CheckAcceptedPolicyUseCase checkAcceptedPolicyUseCase;
  final GetSubscriptionStatusWithCacheUseCase getSubscriptionStatusWithCacheUseCase;
  final FetchDataBasedOnSubscriptionUseCase fetchDataBasedOnSubscriptionUseCase;

  SplashScreenBloc({
    required this.checkAcceptedPolicyUseCase,
    required this.getSubscriptionStatusWithCacheUseCase,
    required this.fetchDataBasedOnSubscriptionUseCase,
  }) : super(const SplashScreenState()) {
    on<InitializeSplashScreen>(_onInitializeSplashScreen);
  }

  /// Main initialization handler - handles presentation logic only
  Future<void> _onInitializeSplashScreen(
    InitializeSplashScreen event,
    Emitter<SplashScreenState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Presentation Logic: Check accepted policy
      final isAccepted = await checkAcceptedPolicyUseCase();

      // Presentation Logic: Get subscription status (business logic handled in use case)
      final subscriptionResult = await getSubscriptionStatusWithCacheUseCase();

      /// Presentation Logic: Fetch data based on subscription (business logic handled in use case)
      // await fetchDataBasedOnSubscriptionUseCase(subscriptionResult.isSubscribed);

      // Presentation Logic: Emit state for UI
      emit(
        state.copyWith(
          isLoading: false,
          isInitialized: true,
          isTCAccepted: isAccepted,
        ),
      );
    } catch (e) {
      // Presentation Logic: Handle error state
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

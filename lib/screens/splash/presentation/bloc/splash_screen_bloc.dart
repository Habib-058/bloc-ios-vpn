import 'package:bloc/bloc.dart';
import 'package:bloc_vpn_ios/screens/splash/domain/usecases/check_accepted_policy_usecase.dart';
import 'package:bloc_vpn_ios/screens/splash/presentation/bloc/splash_screen_event.dart';
import 'package:bloc_vpn_ios/screens/splash/presentation/bloc/splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  final CheckAcceptedPolicyUseCase checkAcceptedPolicyUseCase;
  // Add more use cases here as needed
  // final FetchUserDataUseCase fetchUserDataUseCase;
  // final CheckAppVersionUseCase checkAppVersionUseCase;

  SplashScreenBloc({required this.checkAcceptedPolicyUseCase})
      : super(const SplashScreenState()) {
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

      final isAccepted = await checkAcceptedPolicyUseCase();
      // await fetchUserDataUseCase();
      // await checkAppVersionUseCase();

      // Option B: Parallel (all at once) - faster
      // final results = await Future.wait([
      //   checkAcceptedPolicyUseCase(),
      //   fetchUserDataUseCase(),
      //   checkAppVersionUseCase(),
      // ]);
      // final isAccepted = results[0] as bool;

      emit(state.copyWith(
        isLoading: false,
        isInitialized: true,
        isTCAccepted: isAccepted,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isInitialized: true,
        isTCAccepted: false,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Legacy handler - kept for backward compatibility
  Future<void> _onCheckAcceptedTCStatus(
    CheckAcceptedTCStatus event,
    Emitter<SplashScreenState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final isAccepted = await checkAcceptedPolicyUseCase();
      emit(state.copyWith(
        isLoading: false,
        isInitialized: true,
        isTCAccepted: isAccepted,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isInitialized: true,
        isTCAccepted: false,
        errorMessage: e.toString(),
      ));
    }
  }
}
